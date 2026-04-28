using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class ExpenseCategory
{
    public int CategoryId { get; set; }

    public string CategoryName { get; set; } = null!;

    public virtual ICollection<Expense> Expenses { get; set; } = new List<Expense>();
}
