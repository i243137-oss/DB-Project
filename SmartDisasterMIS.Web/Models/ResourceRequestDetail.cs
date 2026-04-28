using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class ResourceRequestDetail
{
    public int RequestDetailId { get; set; }

    public int RequestId { get; set; }

    public int ResourceTypeId { get; set; }

    public int QuantityRequested { get; set; }

    public virtual ICollection<DispatchDetail> DispatchDetails { get; set; } = new List<DispatchDetail>();

    public virtual ResourceRequest Request { get; set; } = null!;

    public virtual ResourceType ResourceType { get; set; } = null!;
}
