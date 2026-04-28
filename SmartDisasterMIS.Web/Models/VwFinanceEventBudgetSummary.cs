using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class VwFinanceEventBudgetSummary
{
    public int DisasterEventId { get; set; }

    public string EventName { get; set; } = null!;

    public string EventStatus { get; set; } = null!;

    public decimal? TotalDonation { get; set; }

    public decimal? TotalExpense { get; set; }

    public decimal? BudgetBalance { get; set; }
}
