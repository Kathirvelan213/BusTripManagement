using BusTripManagement.API.Models.Auth;
using Google.Apis.Auth;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace BusTripManagement.API.Controllers
{
    [ApiController]
    [Route("auth/google")]
    public class AuthController : ControllerBase
    {
        private readonly IConfiguration _config;

        public AuthController(IConfiguration configuration)
        {
            _config = configuration;
        }
        [HttpPost("mobile")]
        public async Task<IActionResult> MobileLogin([FromBody] GoogleTokenRequest request)
        {
            if (string.IsNullOrEmpty(request.IdToken))
                return BadRequest("Missing id token");

            var payload = await GoogleJsonWebSignature.ValidateAsync(request.IdToken);

            // UNIVERSITY CHECK
            if (payload.HostedDomain != "ssn.edu.in")
                return StatusCode(403, "University members only");

            // TODO: Issue your JWT token
            var jwt = CreateJwt(payload.Email);

            return Ok(new { token = jwt, email = payload.Email });
        }

        private string CreateJwt(string email)
        {
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(ClaimTypes.Email, email)
            };

            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddDays(30),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }


        //private readonly GoogleAuthService _googleAuth;

        //public AuthController(GoogleAuthService googleAuth)
        //{
        //    _googleAuth = googleAuth;
        //}

        //[HttpGet("login")]
        //public IActionResult Login()
        //{
        //    return Challenge(new AuthenticationProperties
        //    {
        //        RedirectUri = "/auth/google/callback"
        //    }, GoogleDefaults.AuthenticationScheme);
        //}

        //[HttpGet("callback")]
        //public async Task<IActionResult> Callback()
        //{
        //    var result = await HttpContext.AuthenticateAsync(GoogleDefaults.AuthenticationScheme);

        //    if (!result.Succeeded)
        //        return BadRequest("Google authentication failed");

        //    var idToken = result.Properties.GetTokenValue("id_token");

        //    var payload = await _googleAuth.VerifyIdTokenAsync(idToken);

        //    if (!_googleAuth.IsValidUniversityUser(payload))
        //        return StatusCode(403, "University members only");

        //    return Ok($"Welcome {payload.Email}! Login successful.");
        //}
    }
}
