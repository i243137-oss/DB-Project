using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class Location
{
    public int LocationId { get; set; }

    public string City { get; set; } = null!;

    public string? Area { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public virtual ICollection<EmergencyReport> EmergencyReports { get; set; } = new List<EmergencyReport>();

    public virtual ICollection<Hospital> Hospitals { get; set; } = new List<Hospital>();

    public virtual ICollection<RescueTeam> RescueTeams { get; set; } = new List<RescueTeam>();

    public virtual ICollection<Warehouse> Warehouses { get; set; } = new List<Warehouse>();
}
