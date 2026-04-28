using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartDisasterMIS.Web.Models;

namespace SmartDisasterMIS.Web.Controllers
{
    [Authorize]
    public class DashboardController : Controller
    {
        private readonly SmartDisasterMisContext _context;

        public DashboardController(SmartDisasterMisContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            // Gather multiple items from DB views to render into dynamic dashboard
            
            // 1. Pending Reports
            var pendingReports = await _context.VwOperatorPendingReports.ToListAsync();
            
            // 2. Low Stock Alerts
            var lowStocks = await _context.VwWarehouseLowStocks.ToListAsync();
            
            // 3. Budgets
            var budgets = await _context.VwFinanceEventBudgetSummaries.ToListAsync();

            // 4. Pending Approvals
            var approvals = await _context.VwApprovalPendings.ToListAsync();

            ViewBag.PendingReports = pendingReports;
            ViewBag.LowStocks = lowStocks;
            ViewBag.Budgets = budgets;
            ViewBag.Approvals = approvals;

            // Simple chart data for Incident by City (grouped)
            var incidentsByCity = await _context.EmergencyReports
                .Include(r => r.Location)
                .GroupBy(r => r.Location.City)
                .Select(g => new { City = g.Key, Count = g.Count() })
                .ToListAsync();

            ViewBag.IncidentsLabels = incidentsByCity.Select(x => x.City).ToArray();
            ViewBag.IncidentsCounts = incidentsByCity.Select(x => x.Count).ToArray();

            return View();
        }
    }
}
