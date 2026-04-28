using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class EmergencyReport
{
    public int ReportId { get; set; }

    public int DisasterTypeId { get; set; }

    public int LocationId { get; set; }

    public int DisasterEventId { get; set; }

    public int? ReportedBy { get; set; }

    public string? CitizenName { get; set; }

    public string? CitizenPhone { get; set; }

    public string SeverityLevel { get; set; } = null!;

    public string? Description { get; set; }

    public DateTime ReportTime { get; set; }

    public string Status { get; set; } = null!;

    public virtual DisasterEvent DisasterEvent { get; set; } = null!;

    public virtual DisasterType DisasterType { get; set; } = null!;

    public virtual Location Location { get; set; } = null!;

    public virtual ICollection<Patient> Patients { get; set; } = new List<Patient>();

    public virtual User? ReportedByNavigation { get; set; }

    public virtual ICollection<RescueAssignment> RescueAssignments { get; set; } = new List<RescueAssignment>();

    public virtual ICollection<ResourceRequest> ResourceRequests { get; set; } = new List<ResourceRequest>();
}
