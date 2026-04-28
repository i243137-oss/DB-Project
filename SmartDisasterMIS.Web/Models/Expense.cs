using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class Expense
{
    public int ExpenseId { get; set; }

    public int CategoryId { get; set; }

    public int? DisasterEventId { get; set; }

    public int? ApprovedBy { get; set; }

    public decimal Amount { get; set; }

    public DateTime ExpenseDate { get; set; }

    public string? Description { get; set; }

    public virtual User? ApprovedByNavigation { get; set; }

    public virtual ExpenseCategory Category { get; set; } = null!;

    public virtual DisasterEvent? DisasterEvent { get; set; }
}
