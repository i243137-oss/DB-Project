using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class DisasterType
{
    public int DisasterTypeId { get; set; }

    public string TypeName { get; set; } = null!;

    public virtual ICollection<DisasterEvent> DisasterEvents { get; set; } = new List<DisasterEvent>();

    public virtual ICollection<EmergencyReport> EmergencyReports { get; set; } = new List<EmergencyReport>();
}
