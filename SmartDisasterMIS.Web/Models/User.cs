using System;
using System.Collections.Generic;

namespace SmartDisasterMIS.Web.Models;

public partial class User
{
    public int UserId { get; set; }

    public string FullName { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string? Phone { get; set; }

    public string PasswordHash { get; set; } = null!;

    public string Status { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    public DateTime? LastLogin { get; set; }

    public virtual ICollection<ApprovalRequest> ApprovalRequestApprovedByNavigations { get; set; } = new List<ApprovalRequest>();

    public virtual ICollection<ApprovalRequest> ApprovalRequestSubmittedByNavigations { get; set; } = new List<ApprovalRequest>();

    public virtual ICollection<AuditLog> AuditLogs { get; set; } = new List<AuditLog>();

    public virtual ICollection<EmergencyReport> EmergencyReports { get; set; } = new List<EmergencyReport>();

    public virtual ICollection<Expense> Expenses { get; set; } = new List<Expense>();

    public virtual ICollection<RescueAssignment> RescueAssignments { get; set; } = new List<RescueAssignment>();

    public virtual ICollection<ResourceDispatch> ResourceDispatches { get; set; } = new List<ResourceDispatch>();

    public virtual ICollection<ResourceRequest> ResourceRequests { get; set; } = new List<ResourceRequest>();

    public virtual ICollection<TeamMember> TeamMembers { get; set; } = new List<TeamMember>();

    public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();

    public virtual ICollection<Warehouse> Warehouses { get; set; } = new List<Warehouse>();
}
