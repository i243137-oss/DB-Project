using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartDisasterMIS.Web.Models;

namespace SmartDisasterMIS.Web.Controllers
{
    [Authorize]
    public class ResourceController : Controller
    {
        private readonly SmartDisasterMisContext _context;
        public ResourceController(SmartDisasterMisContext context) => _context = context;

        public async Task<IActionResult> Index()
        {
            var inventory = await _context.Inventories
                .Include(i => i.Warehouse)
                .Include(i => i.ResourceType)
                .OrderBy(i => i.Warehouse.WarehouseName)
                .ToListAsync();

            var requests = await _context.ResourceRequests
                .Include(r => r.Report)
                .Include(r => r.SubmittedByNavigation)
                .Include(r => r.ResourceRequestDetails).ThenInclude(d => d.ResourceType)
                .OrderByDescending(r => r.RequestDate)
                .Take(15)
                .ToListAsync();

            var dispatches = await _context.ResourceDispatches
                .Include(d => d.Warehouse)
                .Include(d => d.ApprovedByNavigation)
                .OrderByDescending(d => d.DispatchDate)
                .Take(15)
                .ToListAsync();

            ViewBag.Requests = requests;
            ViewBag.Dispatches = dispatches;
            ViewBag.Warehouses = await _context.Warehouses.ToListAsync();
            ViewBag.ResourceTypes = await _context.ResourceTypes.ToListAsync();
            ViewBag.PendingReports = await _context.EmergencyReports.Where(r => r.Status != "Resolved").ToListAsync();
            return View(inventory);
        }

        [HttpPost]
        public async Task<IActionResult> CreateRequest(int reportId, int resourceTypeId, int quantity)
        {
            int userId = 1;
            if (User.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value is string uid && int.TryParse(uid, out int parsed))
                userId = parsed;

            var request = new ResourceRequest
            {
                ReportId = reportId,
                SubmittedBy = userId,
                RequestDate = DateTime.Now,
                Status = "Pending"
            };
            _context.ResourceRequests.Add(request);
            await _context.SaveChangesAsync();

            var detail = new ResourceRequestDetail
            {
                RequestId = request.RequestId,
                ResourceTypeId = resourceTypeId,
                QuantityRequested = quantity
            };
            _context.ResourceRequestDetails.Add(detail);
            await _context.SaveChangesAsync();

            TempData["Success"] = $"Resource request #{request.RequestId} created!";
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> DispatchResource(int requestId, int warehouseId)
        {
            int userId = 1;
            if (User.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value is string uid && int.TryParse(uid, out int parsed))
                userId = parsed;

            var dispatch = new ResourceDispatch
            {
                RequestId = requestId,
                WarehouseId = warehouseId,
                ApprovedBy = userId,
                DispatchDate = DateTime.Now,
                Status = "Dispatched"
            };
            _context.ResourceDispatches.Add(dispatch);

            var request = await _context.ResourceRequests.FindAsync(requestId);
            if (request != null) request.Status = "Fulfilled";

            await _context.SaveChangesAsync();
            TempData["Success"] = "Resource dispatched successfully!";
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> UpdateStock(int inventoryId, int newQuantity)
        {
            var inv = await _context.Inventories.FindAsync(inventoryId);
            if (inv != null)
            {
                inv.QuantityAvailable = newQuantity;
                inv.LastUpdated = DateTime.Now;
                await _context.SaveChangesAsync();
                TempData["Success"] = "Stock updated!";
            }
            return RedirectToAction(nameof(Index));
        }
    }
}
