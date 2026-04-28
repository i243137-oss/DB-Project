using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class DisasterEvent
{
    public int DisasterEventId { get; set; }

    public int DisasterTypeId { get; set; }

    public string EventName { get; set; } = null!;

    public DateOnly StartDate { get; set; }

    public DateOnly? EndDate { get; set; }

    public string Status { get; set; } = null!;

    public virtual DisasterType DisasterType { get; set; } = null!;

    public virtual ICollection<Donation> Donations { get; set; } = new List<Donation>();

    public virtual ICollection<EmergencyReport> EmergencyReports { get; set; } = new List<EmergencyReport>();

    public virtual ICollection<Expense> Expenses { get; set; } = new List<Expense>();

    public virtual ICollection<Hospital> Hospitals { get; set; } = new List<Hospital>();
}
