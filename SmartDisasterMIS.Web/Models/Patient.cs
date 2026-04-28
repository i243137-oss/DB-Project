using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class Patient
{
    public int PatientId { get; set; }

    public int? ReportId { get; set; }

    public string FullName { get; set; } = null!;

    public int? Age { get; set; }

    public string Gender { get; set; } = null!;

    public string ConditionStatus { get; set; } = null!;

    public virtual ICollection<Admission> Admissions { get; set; } = new List<Admission>();

    public virtual EmergencyReport? Report { get; set; }
}
