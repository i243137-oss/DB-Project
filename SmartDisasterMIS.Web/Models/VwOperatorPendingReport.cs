using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class VwOperatorPendingReport
{
    public int ReportId { get; set; }

    public string DisasterType { get; set; } = null!;

    public string City { get; set; } = null!;

    public string? Area { get; set; }

    public string SeverityLevel { get; set; } = null!;

    public DateTime ReportTime { get; set; }

    public string Status { get; set; } = null!;

    public string? Reporter { get; set; }
}
