using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class DispatchDetail
{
    public int DispatchDetailId { get; set; }

    public int DispatchId { get; set; }

    public int ResourceTypeId { get; set; }

    public int? RequestDetailId { get; set; }

    public int QuantityDispatched { get; set; }

    public virtual ResourceDispatch Dispatch { get; set; } = null!;

    public virtual ResourceRequestDetail? RequestDetail { get; set; }

    public virtual ResourceType ResourceType { get; set; } = null!;
}
