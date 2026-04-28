using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class Donor
{
    public int DonorId { get; set; }

    public string DonorName { get; set; } = null!;

    public string DonorType { get; set; } = null!;

    public string? Phone { get; set; }

    public string? Email { get; set; }

    public virtual ICollection<Donation> Donations { get; set; } = new List<Donation>();
}
