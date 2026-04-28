using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class VwApprovalPending
{
    public int ApprovalId { get; set; }

    public string RequestType { get; set; } = null!;

    public int ReferenceId { get; set; }

    public string SubmittedBy { get; set; } = null!;

    public DateTime SubmittedAt { get; set; }

    public int? MinutesWaiting { get; set; }
}
