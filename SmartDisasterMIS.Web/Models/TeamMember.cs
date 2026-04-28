using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class TeamMember
{
    public int MemberId { get; set; }

    public int TeamId { get; set; }

    public int? UserId { get; set; }

    public string FullName { get; set; } = null!;

    public string Designation { get; set; } = null!;

    public string? Phone { get; set; }

    public virtual RescueTeam Team { get; set; } = null!;

    public virtual User? User { get; set; }
}
