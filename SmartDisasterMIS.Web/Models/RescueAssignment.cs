using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class RescueAssignment
{
    public int AssignmentId { get; set; }

    public int ReportId { get; set; }

    public int TeamId { get; set; }

    public int AssignedBy { get; set; }

    public DateTime AssignedTime { get; set; }

    public DateTime? CompletionTime { get; set; }

    public string AssignmentStatus { get; set; } = null!;

    public virtual User AssignedByNavigation { get; set; } = null!;

    public virtual EmergencyReport Report { get; set; } = null!;

    public virtual ICollection<ResourceDispatch> ResourceDispatches { get; set; } = new List<ResourceDispatch>();

    public virtual RescueTeam Team { get; set; } = null!;
}
