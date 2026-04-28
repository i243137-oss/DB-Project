using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartDisasterMIS.Web.Models;

namespace SmartDisasterMIS.Web.Controllers
{
    [Authorize]
    public class HospitalController : Controller
    {
        private readonly SmartDisasterMisContext _context;
        public HospitalController(SmartDisasterMisContext context) => _context = context;

        public async Task<IActionResult> Index()
        {
            var hospitals = await _context.Hospitals.Include(h => h.Location).ToListAsync();

            var admissions = await _context.Admissions
                .Include(a => a.Patient)
                .Include(a => a.Hospital)
                .OrderByDescending(a => a.AdmitTime)
                .Take(20)
                .ToListAsync();

            ViewBag.Admissions = admissions;
            ViewBag.Patients = await _context.Patients.Where(p => !_context.Admissions.Any(a => a.PatientId == p.PatientId && a.Status == "Admitted")).ToListAsync();
            return View(hospitals);
        }

        [HttpPost]
        public async Task<IActionResult> AdmitPatient(int hospitalId, int patientId)
        {
            var hospital = await _context.Hospitals.FindAsync(hospitalId);
            if (hospital != null && hospital.AvailableBeds > 0)
            {
                var admission = new Admission
                {
                    HospitalId = hospitalId,
                    PatientId = patientId,
                    AdmitTime = DateTime.Now,
                    Status = "Admitted"
                };
                _context.Admissions.Add(admission);
                hospital.AvailableBeds--;
                await _context.SaveChangesAsync();
                TempData["Success"] = "Patient admitted successfully!";
            }
            else
            {
                TempData["Error"] = "No available beds!";
            }
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> DischargePatient(int admissionId)
        {
            var admission = await _context.Admissions.Include(a => a.Hospital).FirstOrDefaultAsync(a => a.AdmissionId == admissionId);
            if (admission != null)
            {
                admission.Status = "Discharged";
                admission.DischargeTime = DateTime.Now;
                if (admission.Hospital != null) admission.Hospital.AvailableBeds++;
                await _context.SaveChangesAsync();
                TempData["Success"] = "Patient discharged!";
            }
            return RedirectToAction(nameof(Index));
        }
    }
}
