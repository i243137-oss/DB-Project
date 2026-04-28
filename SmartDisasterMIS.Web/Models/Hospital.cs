using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class Hospital
{
    public int HospitalId { get; set; }

    public string HospitalName { get; set; } = null!;

    public int LocationId { get; set; }

    public string ContactNo { get; set; } = null!;

    public int TotalBeds { get; set; }

    public int AvailableBeds { get; set; }

    public int CriticalCapacity { get; set; }

    public virtual ICollection<Admission> Admissions { get; set; } = new List<Admission>();

    public virtual Location Location { get; set; } = null!;

    public virtual ICollection<DisasterEvent> DisasterEvents { get; set; } = new List<DisasterEvent>();
}
