using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class Donation
{
    public int DonationId { get; set; }

    public int DonorId { get; set; }

    public int? DisasterEventId { get; set; }

    public decimal Amount { get; set; }

    public DateTime DonationDate { get; set; }

    public string PaymentMethod { get; set; } = null!;

    public virtual DisasterEvent? DisasterEvent { get; set; }

    public virtual Donor Donor { get; set; } = null!;
}
