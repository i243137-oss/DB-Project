using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class ResourceType
{
    public int ResourceTypeId { get; set; }

    public string ResourceName { get; set; } = null!;

    public string Unit { get; set; } = null!;

    public virtual ICollection<DispatchDetail> DispatchDetails { get; set; } = new List<DispatchDetail>();

    public virtual ICollection<Inventory> Inventories { get; set; } = new List<Inventory>();

    public virtual ICollection<ResourceRequestDetail> ResourceRequestDetails { get; set; } = new List<ResourceRequestDetail>();
}
