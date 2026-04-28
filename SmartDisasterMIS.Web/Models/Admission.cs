using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class Admission
{
    public int AdmissionId { get; set; }

    public int PatientId { get; set; }

    public int HospitalId { get; set; }

    public DateTime AdmitTime { get; set; }

    public DateTime? DischargeTime { get; set; }

    public string Status { get; set; } = null!;

    public virtual Hospital Hospital { get; set; } = null!;

    public virtual Patient Patient { get; set; } = null!;
}
