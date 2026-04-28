using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class Warehouse
{
    public int WarehouseId { get; set; }

    public string WarehouseName { get; set; } = null!;

    public int LocationId { get; set; }

    public int? ManagedBy { get; set; }

    public virtual ICollection<Inventory> Inventories { get; set; } = new List<Inventory>();

    public virtual Location Location { get; set; } = null!;

    public virtual User? ManagedByNavigation { get; set; }

    public virtual ICollection<ResourceDispatch> ResourceDispatches { get; set; } = new List<ResourceDispatch>();
}
