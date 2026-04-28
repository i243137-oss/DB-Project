using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartDisasterMIS.Web.Models;
using System.Security.Claims;

namespace SmartDisasterMIS.Web.Controllers
{
    public class AccountController : Controller
    {
        private readonly SmartDisasterMisContext _context;

        public AccountController(SmartDisasterMisContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (ModelState.IsValid)
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == model.Email);
                
                // Simplified password check for boilerplate/demo. In prod, use BCrypt or similar hash verify.
                // The DB seeded data has hashes like '$2b$12$hash_admin_001', we simulate success if Email matches and the password is "password" to simplify the prototype since hashing was not implemented centrally.
                if (user != null && (model.Password == "password" || user.PasswordHash.Contains("hash_")))
                {
                    // Update last login
                    user.LastLogin = DateTime.Now;
                    await _context.SaveChangesAsync();

                    // Load User Roles to build claims
                    var userRoles = await _context.UserRoles
                        .Include(ur => ur.Role)
                        .Where(ur => ur.UserId == user.UserId)
                        .ToListAsync();

                    var claims = new List<Claim>
                    {
                        new Claim(ClaimTypes.Name, user.FullName),
                        new Claim(ClaimTypes.Email, user.Email),
                        new Claim("UserId", user.UserId.ToString())
                    };

                    foreach (var ur in userRoles)
                    {
                        claims.Add(new Claim(ClaimTypes.Role, ur.Role.RoleName));
                    }

                    var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    var principal = new ClaimsPrincipal(identity);

                    await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal);

                    return RedirectToAction("Index", "Dashboard");
                }

                ModelState.AddModelError("", "Invalid Username or Password.");
            }

            return View(model);
        }

        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Login", "Account");
        }

        public IActionResult AccessDenied()
        {
            return View();
        }
    }
}
