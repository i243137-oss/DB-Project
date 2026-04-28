using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartDisasterMIS.Web.Models;

namespace SmartDisasterMIS.Web.Controllers
{
    [Authorize]
    public class RescueTeamController : Controller
    {
        private readonly SmartDisasterMisContext _context;
        public RescueTeamController(SmartDisasterMisContext context) => _context = context;

        public async Task<IActionResult> Index()
        {
            var teams = await _context.RescueTeams
                .Include(t => t.Location)
                .Include(t => t.TeamMembers)
                .ToListAsync();

            var assignments = await _context.RescueAssignments
                .Include(a => a.Report)
                .Include(a => a.Team)
                .Include(a => a.AssignedByNavigation)
                .OrderByDescending(a => a.AssignedTime)
                .Take(20)
                .ToListAsync();

            ViewBag.Assignments = assignments;
            ViewBag.PendingReports = await _context.EmergencyReports
                .Where(r => r.Status == "Pending")
                .Include(r => r.Location)
                .ToListAsync();
            return View(teams);
        }

        [HttpPost]
        public async Task<IActionResult> AssignToReport(int teamId, int reportId)
        {
            int userId = 1;
            if (User.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value is string uid && int.TryParse(uid, out int parsed))
                userId = parsed;

            var assignment = new RescueAssignment
            {
                ReportId = reportId,
                TeamId = teamId,
                AssignedBy = userId,
                AssignedTime = DateTime.Now,
                AssignmentStatus = "En Route"
            };
            _context.RescueAssignments.Add(assignment);
            await _context.SaveChangesAsync();

            TempData["Success"] = "Team assigned successfully!";
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> UpdateAssignmentStatus(int assignmentId, string status)
        {
            var assignment = await _context.RescueAssignments.FindAsync(assignmentId);
            if (assignment != null)
            {
                assignment.AssignmentStatus = status;
                if (status == "Completed") assignment.CompletionTime = DateTime.Now;
                await _context.SaveChangesAsync();
                TempData["Success"] = $"Assignment #{assignmentId} marked as {status}.";
            }
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> UpdateTeamStatus(int teamId, string status)
        {
            var team = await _context.RescueTeams.FindAsync(teamId);
            if (team != null)
            {
                team.CurrentStatus = status;
                await _context.SaveChangesAsync();
                TempData["Success"] = $"Team status updated to {status}.";
            }
            return RedirectToAction(nameof(Index));
        }
    }
}
