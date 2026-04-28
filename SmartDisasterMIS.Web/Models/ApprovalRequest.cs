using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class ApprovalRequest
{
    public int ApprovalId { get; set; }

    public int SubmittedBy { get; set; }

    public int? ApprovedBy { get; set; }

    public string RequestType { get; set; } = null!;

    public int ReferenceId { get; set; }

    public string Status { get; set; } = null!;

    public string? Remarks { get; set; }

    public DateTime SubmittedAt { get; set; }

    public DateTime? DecisionAt { get; set; }

    public virtual User? ApprovedByNavigation { get; set; }

    public virtual User SubmittedByNavigation { get; set; } = null!;
}
