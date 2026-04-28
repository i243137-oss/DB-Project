using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class VwWarehouseLowStock
{
    public int WarehouseId { get; set; }

    public string WarehouseName { get; set; } = null!;

    public string City { get; set; } = null!;

    public int ResourceTypeId { get; set; }

    public string ResourceName { get; set; } = null!;

    public int QuantityAvailable { get; set; }

    public int ReorderLevel { get; set; }

    public int? Shortage { get; set; }
}
