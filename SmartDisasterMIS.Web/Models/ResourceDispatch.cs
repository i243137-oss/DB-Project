using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class ResourceDispatch
{
    public int DispatchId { get; set; }

    public int? RequestId { get; set; }

    public int WarehouseId { get; set; }

    public int? AssignmentId { get; set; }

    public int ApprovedBy { get; set; }

    public DateTime DispatchDate { get; set; }

    public string Status { get; set; } = null!;

    public virtual User ApprovedByNavigation { get; set; } = null!;

    public virtual RescueAssignment? Assignment { get; set; }

    public virtual ICollection<DispatchDetail> DispatchDetails { get; set; } = new List<DispatchDetail>();

    public virtual ResourceRequest? Request { get; set; }

    public virtual Warehouse Warehouse { get; set; } = null!;
}
