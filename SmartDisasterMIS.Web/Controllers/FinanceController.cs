using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartDisasterMIS.Web.Models;

namespace SmartDisasterMIS.Web.Controllers
{
    [Authorize]
    public class FinanceController : Controller
    {
        private readonly SmartDisasterMisContext _context;
        public FinanceController(SmartDisasterMisContext context) => _context = context;

        public async Task<IActionResult> Index()
        {
            var donations = await _context.Donations
                .Include(d => d.Donor)
                .Include(d => d.DisasterEvent)
                .OrderByDescending(d => d.DonationDate)
                .ToListAsync();

            var expenses = await _context.Expenses
                .Include(e => e.Category)
                .Include(e => e.DisasterEvent)
                .Include(e => e.ApprovedByNavigation)
                .OrderByDescending(e => e.ExpenseDate)
                .ToListAsync();

            var budgetSummary = await _context.VwFinanceEventBudgetSummaries.ToListAsync();

            ViewBag.Expenses = expenses;
            ViewBag.BudgetSummary = budgetSummary;
            ViewBag.Donors = await _context.Donors.ToListAsync();
            ViewBag.Events = await _context.DisasterEvents.ToListAsync();
            ViewBag.Categories = await _context.ExpenseCategories.ToListAsync();
            return View(donations);
        }

        [HttpPost]
        public async Task<IActionResult> RecordDonation(int donorId, int? disasterEventId, decimal amount, string paymentMethod)
        {
            var donation = new Donation
            {
                DonorId = donorId,
                DisasterEventId = disasterEventId,
                Amount = amount,
                PaymentMethod = paymentMethod,
                DonationDate = DateTime.Now
            };
            _context.Donations.Add(donation);
            await _context.SaveChangesAsync();
            TempData["Success"] = $"Donation of PKR {amount:N0} recorded!";
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> RecordExpense(int categoryId, int? disasterEventId, decimal amount, string description)
        {
            int userId = 1;
            if (User.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value is string uid && int.TryParse(uid, out int parsed))
                userId = parsed;

            var expense = new Expense
            {
                CategoryId = categoryId,
                DisasterEventId = disasterEventId,
                Amount = amount,
                Description = description,
                ApprovedBy = userId,
                ExpenseDate = DateTime.Now
            };
            _context.Expenses.Add(expense);
            await _context.SaveChangesAsync();
            TempData["Success"] = $"Expense of PKR {amount:N0} recorded!";
            return RedirectToAction(nameof(Index));
        }
    }
}
