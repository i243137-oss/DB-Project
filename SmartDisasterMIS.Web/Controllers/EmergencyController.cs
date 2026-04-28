using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartDisasterMIS.Web.Models;

namespace SmartDisasterMIS.Web.Controllers
{
    [Authorize]
    public class EmergencyController : Controller
    {
        private readonly SmartDisasterMisContext _context;
        public EmergencyController(SmartDisasterMisContext context) => _context = context;

        public async Task<IActionResult> Index()
        {
            var reports = await _context.EmergencyReports
                .Include(e => e.DisasterEvent)
                .Include(e => e.DisasterType)
                .Include(e => e.Location)
                .OrderByDescending(e => e.ReportTime)
                .ToListAsync();

            ViewBag.RescueTeams = await _context.RescueTeams.Where(t => t.CurrentStatus == "Available").ToListAsync();
            return View(reports);
        }

        [HttpGet]
        public async Task<IActionResult> Create()
        {
            ViewBag.DisasterTypes = await _context.DisasterTypes.ToListAsync();
            ViewBag.Locations = await _context.Locations.ToListAsync();
            ViewBag.Events = await _context.DisasterEvents.ToListAsync();
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Create(EmergencyReport report)
        {
            report.ReportTime = DateTime.Now;
            report.Status = "Pending";
            if (User.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value is string uid && int.TryParse(uid, out int userId))
                report.ReportedBy = userId;

            _context.EmergencyReports.Add(report);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> AssignTeam(int reportId, int teamId)
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

            TempData["Success"] = $"Team assigned to report #{reportId} successfully!";
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> UpdateStatus(int reportId, string status)
        {
            var report = await _context.EmergencyReports.FindAsync(reportId);
            if (report != null)
            {
                report.Status = status;
                await _context.SaveChangesAsync();
                TempData["Success"] = $"Report #{reportId} status updated to {status}.";
            }
            return RedirectToAction(nameof(Index));
        }
    }
}
