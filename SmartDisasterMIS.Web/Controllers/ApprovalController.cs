using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartDisasterMIS.Web.Models;

namespace SmartDisasterMIS.Web.Controllers
{
    [Authorize(Roles = "Administrator")]
    public class ApprovalController : Controller
    {
        private readonly SmartDisasterMisContext _context;
        public ApprovalController(SmartDisasterMisContext context) => _context = context;

        public async Task<IActionResult> Index()
        {
            var approvals = await _context.ApprovalRequests
                .Include(a => a.SubmittedByNavigation)
                .Include(a => a.ApprovedByNavigation)
                .OrderByDescending(a => a.SubmittedAt)
                .ToListAsync();
            return View(approvals);
        }

        [HttpPost]
        public async Task<IActionResult> Decide(int id, string decision, string remarks)
        {
            var approval = await _context.ApprovalRequests.FindAsync(id);
            if (approval != null)
            {
                approval.Status = decision;
                approval.Remarks = remarks;
                approval.DecisionAt = DateTime.Now;

                if (User.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value is string uid && int.TryParse(uid, out int userId))
                    approval.ApprovedBy = userId;

                await _context.SaveChangesAsync();
            }
            return RedirectToAction(nameof(Index));
        }
    }
}
