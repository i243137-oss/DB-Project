using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class AuditLog
{
    public int LogId { get; set; }

    public int UserId { get; set; }

    public string ActionType { get; set; } = null!;

    public string TableName { get; set; } = null!;

    public int? RecordId { get; set; }

    public string? OldValue { get; set; }

    public string? NewValue { get; set; }

    public DateTime ActionTime { get; set; }

    public virtual User User { get; set; } = null!;
}
