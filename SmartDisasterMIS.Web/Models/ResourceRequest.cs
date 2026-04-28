using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class ResourceRequest
{
    public int RequestId { get; set; }

    public int? ReportId { get; set; }

    public int SubmittedBy { get; set; }

    public DateTime RequestDate { get; set; }

    public string Status { get; set; } = null!;

    public virtual EmergencyReport? Report { get; set; }

    public virtual ICollection<ResourceDispatch> ResourceDispatches { get; set; } = new List<ResourceDispatch>();

    public virtual ICollection<ResourceRequestDetail> ResourceRequestDetails { get; set; } = new List<ResourceRequestDetail>();

    public virtual User SubmittedByNavigation { get; set; } = null!;
}
