using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartDisasterMIS.Web.Models;

namespace SmartDisasterMIS.Web.Controllers
{
    [Authorize(Roles = "Administrator")]
    public class AuditController : Controller
    {
        private readonly SmartDisasterMisContext _context;
        public AuditController(SmartDisasterMisContext context) => _context = context;

        public async Task<IActionResult> Index()
        {
            var logs = await _context.AuditLogs
                .Include(l => l.User)
                .OrderByDescending(l => l.ActionTime)
                .Take(100)
                .ToListAsync();
            return View(logs);
        }
    }
}
