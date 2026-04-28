using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class Inventory
{
    public int InventoryId { get; set; }

    public int WarehouseId { get; set; }

    public int ResourceTypeId { get; set; }

    public int QuantityAvailable { get; set; }

    public int ReorderLevel { get; set; }

    public DateTime LastUpdated { get; set; }

    public virtual ResourceType ResourceType { get; set; } = null!;

    public virtual Warehouse Warehouse { get; set; } = null!;
}
