using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace SmartDisasterMIS.Web.Models;

public partial class SmartDisasterMisContext : DbContext
{
    public SmartDisasterMisContext()
    {
    }

    public SmartDisasterMisContext(DbContextOptions<SmartDisasterMisContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Admission> Admissions { get; set; }

    public virtual DbSet<ApprovalRequest> ApprovalRequests { get; set; }

    public virtual DbSet<AuditLog> AuditLogs { get; set; }

    public virtual DbSet<DisasterEvent> DisasterEvents { get; set; }

    public virtual DbSet<DisasterType> DisasterTypes { get; set; }

    public virtual DbSet<DispatchDetail> DispatchDetails { get; set; }

    public virtual DbSet<Donation> Donations { get; set; }

    public virtual DbSet<Donor> Donors { get; set; }

    public virtual DbSet<EmergencyReport> EmergencyReports { get; set; }

    public virtual DbSet<Expense> Expenses { get; set; }

    public virtual DbSet<ExpenseCategory> ExpenseCategories { get; set; }

    public virtual DbSet<Hospital> Hospitals { get; set; }

    public virtual DbSet<Inventory> Inventories { get; set; }

    public virtual DbSet<Location> Locations { get; set; }

    public virtual DbSet<Patient> Patients { get; set; }

    public virtual DbSet<Permission> Permissions { get; set; }

    public virtual DbSet<RescueAssignment> RescueAssignments { get; set; }

    public virtual DbSet<RescueTeam> RescueTeams { get; set; }

    public virtual DbSet<ResourceDispatch> ResourceDispatches { get; set; }

    public virtual DbSet<ResourceRequest> ResourceRequests { get; set; }

    public virtual DbSet<ResourceRequestDetail> ResourceRequestDetails { get; set; }

    public virtual DbSet<ResourceType> ResourceTypes { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<TeamMember> TeamMembers { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserRole> UserRoles { get; set; }

    public virtual DbSet<VwApprovalPending> VwApprovalPendings { get; set; }

    public virtual DbSet<VwFinanceEventBudgetSummary> VwFinanceEventBudgetSummaries { get; set; }

    public virtual DbSet<VwOperatorPendingReport> VwOperatorPendingReports { get; set; }

    public virtual DbSet<VwWarehouseLowStock> VwWarehouseLowStocks { get; set; }

    public virtual DbSet<Warehouse> Warehouses { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=.\\SQLEXPRESS;Database=SmartDisasterMIS;Trusted_Connection=True;Encrypt=True;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Admission>(entity =>
        {
            entity.HasKey(e => e.AdmissionId).HasName("PK__Admissio__3D9F8C72BF356540");

            entity.ToTable("Admission");

            entity.Property(e => e.AdmissionId).HasColumnName("admission_id");
            entity.Property(e => e.AdmitTime)
                .HasDefaultValueSql("(sysdatetime())")
                .HasColumnName("admit_time");
            entity.Property(e => e.DischargeTime).HasColumnName("discharge_time");
            entity.Property(e => e.HospitalId).HasColumnName("hospital_id");
            entity.Property(e => e.PatientId).HasColumnName("patient_id");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("Admitted")
                .HasColumnName("status");

            entity.HasOne(d => d.Hospital).WithMany(p => p.Admissions)
                .HasForeignKey(d => d.HospitalId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Admission_Hospital");

            entity.HasOne(d => d.Patient).WithMany(p => p.Admissions)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Admission_Patient");
        });

        modelBuilder.Entity<ApprovalRequest>(entity =>
        {
            entity.HasKey(e => e.ApprovalId).HasName("PK__Approval__C94AE61A6C45A880");

            entity.ToTable("ApprovalRequest");

            entity.HasIndex(e => new { e.Status, e.SubmittedAt }, "IX_ApprovalRequest_Status_SubmittedAt");

            entity.Property(e => e.ApprovalId).HasColumnName("approval_id");
            entity.Property(e => e.ApprovedBy).HasColumnName("approved_by");
            entity.Property(e => e.DecisionAt).HasColumnName("decision_at");
            entity.Property(e => e.ReferenceId).HasColumnName("reference_id");
            entity.Property(e => e.Remarks).HasColumnName("remarks");
            entity.Property(e => e.RequestType)
                .HasMaxLength(80)
                .HasColumnName("request_type");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("Pending")
                .HasColumnName("status");
            entity.Property(e => e.SubmittedAt)
                .HasDefaultValueSql("(sysdatetime())")
                .HasColumnName("submitted_at");
            entity.Property(e => e.SubmittedBy).HasColumnName("submitted_by");

            entity.HasOne(d => d.ApprovedByNavigation).WithMany(p => p.ApprovalRequestApprovedByNavigations)
                .HasForeignKey(d => d.ApprovedBy)
                .HasConstraintName("FK_ApprovalRequest_ApprovedBy");

            entity.HasOne(d => d.SubmittedByNavigation).WithMany(p => p.ApprovalRequestSubmittedByNavigations)
                .HasForeignKey(d => d.SubmittedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ApprovalRequest_SubmittedBy");
        });

        modelBuilder.Entity<AuditLog>(entity =>
        {
            entity.HasKey(e => e.LogId).HasName("PK__AuditLog__9E2397E0E9340483");

            entity.ToTable("AuditLog");

            entity.Property(e => e.LogId).HasColumnName("log_id");
            entity.Property(e => e.ActionTime)
                .HasDefaultValueSql("(sysdatetime())")
                .HasColumnName("action_time");
            entity.Property(e => e.ActionType)
                .HasMaxLength(20)
                .HasColumnName("action_type");
            entity.Property(e => e.NewValue).HasColumnName("new_value");
            entity.Property(e => e.OldValue).HasColumnName("old_value");
            entity.Property(e => e.RecordId).HasColumnName("record_id");
            entity.Property(e => e.TableName)
                .HasMaxLength(80)
                .HasColumnName("table_name");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.AuditLogs)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AuditLog_User");
        });

        modelBuilder.Entity<DisasterEvent>(entity =>
        {
            entity.HasKey(e => e.DisasterEventId).HasName("PK__Disaster__1DA950D2B9E15F9F");

            entity.ToTable("DisasterEvent");

            entity.Property(e => e.DisasterEventId).HasColumnName("disaster_event_id");
            entity.Property(e => e.DisasterTypeId).HasColumnName("disaster_type_id");
            entity.Property(e => e.EndDate).HasColumnName("end_date");
            entity.Property(e => e.EventName)
                .HasMaxLength(150)
                .HasColumnName("event_name");
            entity.Property(e => e.StartDate).HasColumnName("start_date");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("Active")
                .HasColumnName("status");

            entity.HasOne(d => d.DisasterType).WithMany(p => p.DisasterEvents)
                .HasForeignKey(d => d.DisasterTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DisasterEvent_DisasterType");
        });

        modelBuilder.Entity<DisasterType>(entity =>
        {
            entity.HasKey(e => e.DisasterTypeId).HasName("PK__Disaster__731C64A80910691E");

            entity.ToTable("DisasterType");

            entity.HasIndex(e => e.TypeName, "UQ__Disaster__543C4FD9CE6431FE").IsUnique();

            entity.Property(e => e.DisasterTypeId).HasColumnName("disaster_type_id");
            entity.Property(e => e.TypeName)
                .HasMaxLength(100)
                .HasColumnName("type_name");
        });

        modelBuilder.Entity<DispatchDetail>(entity =>
        {
            entity.HasKey(e => e.DispatchDetailId).HasName("PK__Dispatch__0DC1BBC751CA0341");

            entity.ToTable("DispatchDetail");

            entity.HasIndex(e => new { e.DispatchId, e.ResourceTypeId }, "IX_DispatchDetail_Dispatch_Resource");

            entity.Property(e => e.DispatchDetailId).HasColumnName("dispatch_detail_id");
            entity.Property(e => e.DispatchId).HasColumnName("dispatch_id");
            entity.Property(e => e.QuantityDispatched).HasColumnName("quantity_dispatched");
            entity.Property(e => e.RequestDetailId).HasColumnName("request_detail_id");
            entity.Property(e => e.ResourceTypeId).HasColumnName("resource_type_id");

            entity.HasOne(d => d.Dispatch).WithMany(p => p.DispatchDetails)
                .HasForeignKey(d => d.DispatchId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DispatchDetail_Dispatch");

            entity.HasOne(d => d.RequestDetail).WithMany(p => p.DispatchDetails)
                .HasForeignKey(d => d.RequestDetailId)
                .HasConstraintName("FK_DispatchDetail_RequestDetail");

            entity.HasOne(d => d.ResourceType).WithMany(p => p.DispatchDetails)
                .HasForeignKey(d => d.ResourceTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DispatchDetail_ResourceType");
        });

        modelBuilder.Entity<Donation>(entity =>
        {
            entity.HasKey(e => e.DonationId).HasName("PK__Donation__296B91DC0DEBF3E7");

            entity.ToTable("Donation");

            entity.Property(e => e.DonationId).HasColumnName("donation_id");
            entity.Property(e => e.Amount)
                .HasColumnType("decimal(15, 2)")
                .HasColumnName("amount");
            entity.Property(e => e.DisasterEventId).HasColumnName("disaster_event_id");
            entity.Property(e => e.DonationDate)
                .HasDefaultValueSql("(sysdatetime())")
                .HasColumnName("donation_date");
            entity.Property(e => e.DonorId).HasColumnName("donor_id");
            entity.Property(e => e.PaymentMethod)
                .HasMaxLength(20)
                .HasColumnName("payment_method");

            entity.HasOne(d => d.DisasterEvent).WithMany(p => p.Donations)
                .HasForeignKey(d => d.DisasterEventId)
                .HasConstraintName("FK_Donation_DisasterEvent");

            entity.HasOne(d => d.Donor).WithMany(p => p.Donations)
                .HasForeignKey(d => d.DonorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Donation_Donor");
        });

        modelBuilder.Entity<Donor>(entity =>
        {
            entity.HasKey(e => e.DonorId).HasName("PK__Donor__8B5B10F9C582B8E5");

            entity.ToTable("Donor");

            entity.Property(e => e.DonorId).HasColumnName("donor_id");
            entity.Property(e => e.DonorName)
                .HasMaxLength(150)
                .HasColumnName("donor_name");
            entity.Property(e => e.DonorType)
                .HasMaxLength(20)
                .HasColumnName("donor_type");
            entity.Property(e => e.Email)
                .HasMaxLength(150)
                .HasColumnName("email");
            entity.Property(e => e.Phone)
                .HasMaxLength(20)
                .HasColumnName("phone");
        });

        modelBuilder.Entity<EmergencyReport>(entity =>
        {
            entity.HasKey(e => e.ReportId).HasName("PK__Emergenc__779B7C589A29DFC7");

            entity.ToTable("EmergencyReport");

            entity.HasIndex(e => new { e.LocationId, e.SeverityLevel, e.ReportTime }, "IX_EmergencyReport_Location_Severity_Time").IsDescending(false, false, true);

            entity.HasIndex(e => new { e.DisasterTypeId, e.ReportTime }, "IX_EmergencyReport_Type_Time").IsDescending(false, true);

            entity.Property(e => e.ReportId).HasColumnName("report_id");
            entity.Property(e => e.CitizenName)
                .HasMaxLength(100)
                .HasColumnName("citizen_name");
            entity.Property(e => e.CitizenPhone)
                .HasMaxLength(20)
                .HasColumnName("citizen_phone");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.DisasterEventId).HasColumnName("disaster_event_id");
            entity.Property(e => e.DisasterTypeId).HasColumnName("disaster_type_id");
            entity.Property(e => e.LocationId).HasColumnName("location_id");
            entity.Property(e => e.ReportTime)
                .HasDefaultValueSql("(sysdatetime())")
                .HasColumnName("report_time");
            entity.Property(e => e.ReportedBy).HasColumnName("reported_by");
            entity.Property(e => e.SeverityLevel)
                .HasMaxLength(20)
                .HasColumnName("severity_level");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("Pending")
                .HasColumnName("status");

            entity.HasOne(d => d.DisasterEvent).WithMany(p => p.EmergencyReports)
                .HasForeignKey(d => d.DisasterEventId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_EmergencyReport_DisasterEvent");

            entity.HasOne(d => d.DisasterType).WithMany(p => p.EmergencyReports)
                .HasForeignKey(d => d.DisasterTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_EmergencyReport_DisasterType");

            entity.HasOne(d => d.Location).WithMany(p => p.EmergencyReports)
                .HasForeignKey(d => d.LocationId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_EmergencyReport_Location");

            entity.HasOne(d => d.ReportedByNavigation).WithMany(p => p.EmergencyReports)
                .HasForeignKey(d => d.ReportedBy)
                .HasConstraintName("FK_EmergencyReport_User");
        });

        modelBuilder.Entity<Expense>(entity =>
        {
            entity.HasKey(e => e.ExpenseId).HasName("PK__Expense__404B6A6B3CEC83D3");

            entity.ToTable("Expense", tb => tb.HasTrigger("trg_Expense_Audit"));

            entity.HasIndex(e => new { e.ExpenseDate, e.DisasterEventId }, "IX_Expense_Date_Event").IsDescending(true, false);

            entity.Property(e => e.ExpenseId).HasColumnName("expense_id");
            entity.Property(e => e.Amount)
                .HasColumnType("decimal(15, 2)")
                .HasColumnName("amount");
            entity.Property(e => e.ApprovedBy).HasColumnName("approved_by");
            entity.Property(e => e.CategoryId).HasColumnName("category_id");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.DisasterEventId).HasColumnName("disaster_event_id");
            entity.Property(e => e.ExpenseDate)
                .HasDefaultValueSql("(sysdatetime())")
                .HasColumnName("expense_date");

            entity.HasOne(d => d.ApprovedByNavigation).WithMany(p => p.Expenses)
                .HasForeignKey(d => d.ApprovedBy)
                .HasConstraintName("FK_Expense_User");

            entity.HasOne(d => d.Category).WithMany(p => p.Expenses)
                .HasForeignKey(d => d.CategoryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Expense_Category");

            entity.HasOne(d => d.DisasterEvent).WithMany(p => p.Expenses)
                .HasForeignKey(d => d.DisasterEventId)
                .HasConstraintName("FK_Expense_DisasterEvent");
        });

        modelBuilder.Entity<ExpenseCategory>(entity =>
        {
            entity.HasKey(e => e.CategoryId).HasName("PK__ExpenseC__D54EE9B422EEC214");

            entity.ToTable("ExpenseCategory");

            entity.HasIndex(e => e.CategoryName, "UQ__ExpenseC__5189E2558496C81F").IsUnique();

            entity.Property(e => e.CategoryId).HasColumnName("category_id");
            entity.Property(e => e.CategoryName)
                .HasMaxLength(100)
                .HasColumnName("category_name");
        });

        modelBuilder.Entity<Hospital>(entity =>
        {
            entity.HasKey(e => e.HospitalId).HasName("PK__Hospital__DFF4167FCA01D381");

            entity.ToTable("Hospital");

            entity.HasIndex(e => e.HospitalName, "UQ__Hospital__5500E1FFC24DAD0D").IsUnique();

            entity.Property(e => e.HospitalId).HasColumnName("hospital_id");
            entity.Property(e => e.AvailableBeds).HasColumnName("available_beds");
            entity.Property(e => e.ContactNo)
                .HasMaxLength(20)
                .HasColumnName("contact_no");
            entity.Property(e => e.CriticalCapacity).HasColumnName("critical_capacity");
            entity.Property(e => e.HospitalName)
                .HasMaxLength(150)
                .HasColumnName("hospital_name");
            entity.Property(e => e.LocationId).HasColumnName("location_id");
            entity.Property(e => e.TotalBeds).HasColumnName("total_beds");

            entity.HasOne(d => d.Location).WithMany(p => p.Hospitals)
                .HasForeignKey(d => d.LocationId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Hospital_Location");

            entity.HasMany(d => d.DisasterEvents).WithMany(p => p.Hospitals)
                .UsingEntity<Dictionary<string, object>>(
                    "HospitalEvent",
                    r => r.HasOne<DisasterEvent>().WithMany()
                        .HasForeignKey("DisasterEventId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_HospitalEvent_DisasterEvent"),
                    l => l.HasOne<Hospital>().WithMany()
                        .HasForeignKey("HospitalId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK_HospitalEvent_Hospital"),
                    j =>
                    {
                        j.HasKey("HospitalId", "DisasterEventId");
                        j.ToTable("HospitalEvent");
                        j.IndexerProperty<int>("HospitalId").HasColumnName("hospital_id");
                        j.IndexerProperty<int>("DisasterEventId").HasColumnName("disaster_event_id");
                    });
        });

        modelBuilder.Entity<Inventory>(entity =>
        {
            entity.HasKey(e => e.InventoryId).HasName("PK__Inventor__B59ACC49861CC1B5");

            entity.ToTable("Inventory", tb => tb.HasTrigger("trg_Inventory_PreventNegative"));

            entity.HasIndex(e => new { e.WarehouseId, e.ResourceTypeId }, "IX_Inventory_Warehouse_Resource");

            entity.HasIndex(e => new { e.WarehouseId, e.ResourceTypeId }, "UQ_Inventory").IsUnique();

            entity.Property(e => e.InventoryId).HasColumnName("inventory_id");
            entity.Property(e => e.LastUpdated)
                .HasDefaultValueSql("(sysdatetime())")
                .HasColumnName("last_updated");
            entity.Property(e => e.QuantityAvailable).HasColumnName("quantity_available");
            entity.Property(e => e.ReorderLevel).HasColumnName("reorder_level");
            entity.Property(e => e.ResourceTypeId).HasColumnName("resource_type_id");
            entity.Property(e => e.WarehouseId).HasColumnName("warehouse_id");

            entity.HasOne(d => d.ResourceType).WithMany(p => p.Inventories)
                .HasForeignKey(d => d.ResourceTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Inventory_ResourceType");

            entity.HasOne(d => d.Warehouse).WithMany(p => p.Inventories)
                .HasForeignKey(d => d.WarehouseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Inventory_Warehouse");
        });

        modelBuilder.Entity<Location>(entity =>
        {
            entity.HasKey(e => e.LocationId).HasName("PK__Location__771831EADD4EE02E");

            entity.ToTable("Location");

            entity.Property(e => e.LocationId).HasColumnName("location_id");
            entity.Property(e => e.Area)
                .HasMaxLength(150)
                .HasColumnName("area");
            entity.Property(e => e.City)
                .HasMaxLength(100)
                .HasColumnName("city");
            entity.Property(e => e.Latitude)
                .HasColumnType("decimal(10, 7)")
                .HasColumnName("latitude");
            entity.Property(e => e.Longitude)
                .HasColumnType("decimal(10, 7)")
                .HasColumnName("longitude");
        });

        modelBuilder.Entity<Patient>(entity =>
        {
            entity.HasKey(e => e.PatientId).HasName("PK__Patient__4D5CE4766CBC463C");

            entity.ToTable("Patient");

            entity.Property(e => e.PatientId).HasColumnName("patient_id");
            entity.Property(e => e.Age).HasColumnName("age");
            entity.Property(e => e.ConditionStatus)
                .HasMaxLength(20)
                .HasDefaultValue("Stable")
                .HasColumnName("condition_status");
            entity.Property(e => e.FullName)
                .HasMaxLength(100)
                .HasColumnName("full_name");
            entity.Property(e => e.Gender)
                .HasMaxLength(10)
                .HasDefaultValue("Unknown")
                .HasColumnName("gender");
            entity.Property(e => e.ReportId).HasColumnName("report_id");

            entity.HasOne(d => d.Report).WithMany(p => p.Patients)
                .HasForeignKey(d => d.ReportId)
                .HasConstraintName("FK_Patient_EmergencyReport");
        });

        modelBuilder.Entity<Permission>(entity =>
        {
            entity.HasKey(e => e.PermissionId).HasName("PK__Permissi__E5331AFAE7DF5B47");

            entity.ToTable("Permission");

            entity.HasIndex(e => e.PermissionName, "UQ__Permissi__81C0F5A2EBAE7989").IsUnique();

            entity.Property(e => e.PermissionId).HasColumnName("permission_id");
            entity.Property(e => e.ModuleName)
                .HasMaxLength(80)
                .HasColumnName("module_name");
            entity.Property(e => e.PermissionName)
                .HasMaxLength(100)
                .HasColumnName("permission_name");
        });

        modelBuilder.Entity<RescueAssignment>(entity =>
        {
            entity.HasKey(e => e.AssignmentId).HasName("PK__RescueAs__DA891814E01BB531");

            entity.ToTable("RescueAssignment", tb =>
                {
                    tb.HasTrigger("trg_RescueAssignment_UpdateReportStatus");
                    tb.HasTrigger("trg_RescueAssignment_UpdateTeamStatus");
                });

            entity.HasIndex(e => new { e.ReportId, e.AssignmentStatus, e.AssignedTime }, "IX_RescueAssignment_Report_Status_Time").IsDescending(false, false, true);

            entity.Property(e => e.AssignmentId).HasColumnName("assignment_id");
            entity.Property(e => e.AssignedBy).HasColumnName("assigned_by");
            entity.Property(e => e.AssignedTime)
                .HasDefaultValueSql("(sysdatetime())")
                .HasColumnName("assigned_time");
            entity.Property(e => e.AssignmentStatus)
                .HasMaxLength(20)
                .HasDefaultValue("Pending")
                .HasColumnName("assignment_status");
            entity.Property(e => e.CompletionTime).HasColumnName("completion_time");
            entity.Property(e => e.ReportId).HasColumnName("report_id");
            entity.Property(e => e.TeamId).HasColumnName("team_id");

            entity.HasOne(d => d.AssignedByNavigation).WithMany(p => p.RescueAssignments)
                .HasForeignKey(d => d.AssignedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RescueAssignment_User");

            entity.HasOne(d => d.Report).WithMany(p => p.RescueAssignments)
                .HasForeignKey(d => d.ReportId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RescueAssignment_Report");

            entity.HasOne(d => d.Team).WithMany(p => p.RescueAssignments)
                .HasForeignKey(d => d.TeamId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RescueAssignment_Team");
        });

        modelBuilder.Entity<RescueTeam>(entity =>
        {
            entity.HasKey(e => e.TeamId).HasName("PK__RescueTe__F82DEDBC995CD0E4");

            entity.ToTable("RescueTeam");

            entity.HasIndex(e => e.TeamName, "UQ__RescueTe__29E35E0C12AB146F").IsUnique();

            entity.Property(e => e.TeamId).HasColumnName("team_id");
            entity.Property(e => e.CurrentStatus)
                .HasMaxLength(20)
                .HasDefaultValue("Available")
                .HasColumnName("current_status");
            entity.Property(e => e.LocationId).HasColumnName("location_id");
            entity.Property(e => e.TeamName)
                .HasMaxLength(100)
                .HasColumnName("team_name");
            entity.Property(e => e.TeamType)
                .HasMaxLength(30)
                .HasColumnName("team_type");

            entity.HasOne(d => d.Location).WithMany(p => p.RescueTeams)
                .HasForeignKey(d => d.LocationId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RescueTeam_Location");
        });

        modelBuilder.Entity<ResourceDispatch>(entity =>
        {
            entity.HasKey(e => e.DispatchId).HasName("PK__Resource__F721B4772B6D8F4B");

            entity.ToTable("ResourceDispatch");

            entity.Property(e => e.DispatchId).HasColumnName("dispatch_id");
            entity.Property(e => e.ApprovedBy).HasColumnName("approved_by");
            entity.Property(e => e.AssignmentId).HasColumnName("assignment_id");
            entity.Property(e => e.DispatchDate)
                .HasDefaultValueSql("(sysdatetime())")
                .HasColumnName("dispatch_date");
            entity.Property(e => e.RequestId).HasColumnName("request_id");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("Pending")
                .HasColumnName("status");
            entity.Property(e => e.WarehouseId).HasColumnName("warehouse_id");

            entity.HasOne(d => d.ApprovedByNavigation).WithMany(p => p.ResourceDispatches)
                .HasForeignKey(d => d.ApprovedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ResourceDispatch_User");

            entity.HasOne(d => d.Assignment).WithMany(p => p.ResourceDispatches)
                .HasForeignKey(d => d.AssignmentId)
                .HasConstraintName("FK_ResourceDispatch_Assignment");

            entity.HasOne(d => d.Request).WithMany(p => p.ResourceDispatches)
                .HasForeignKey(d => d.RequestId)
                .HasConstraintName("FK_ResourceDispatch_Request");

            entity.HasOne(d => d.Warehouse).WithMany(p => p.ResourceDispatches)
                .HasForeignKey(d => d.WarehouseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ResourceDispatch_Warehouse");
        });

        modelBuilder.Entity<ResourceRequest>(entity =>
        {
            entity.HasKey(e => e.RequestId).HasName("PK__Resource__18D3B90FFFB649AC");

            entity.ToTable("ResourceRequest");

            entity.Property(e => e.RequestId).HasColumnName("request_id");
            entity.Property(e => e.ReportId).HasColumnName("report_id");
            entity.Property(e => e.RequestDate)
                .HasDefaultValueSql("(sysdatetime())")
                .HasColumnName("request_date");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("Pending")
                .HasColumnName("status");
            entity.Property(e => e.SubmittedBy).HasColumnName("submitted_by");

            entity.HasOne(d => d.Report).WithMany(p => p.ResourceRequests)
                .HasForeignKey(d => d.ReportId)
                .HasConstraintName("FK_ResourceRequest_Report");

            entity.HasOne(d => d.SubmittedByNavigation).WithMany(p => p.ResourceRequests)
                .HasForeignKey(d => d.SubmittedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ResourceRequest_User");
        });

        modelBuilder.Entity<ResourceRequestDetail>(entity =>
        {
            entity.HasKey(e => e.RequestDetailId).HasName("PK__Resource__5A4D1BEB76F928EC");

            entity.ToTable("ResourceRequestDetail");

            entity.HasIndex(e => new { e.RequestId, e.ResourceTypeId }, "IX_ResourceRequestDetail_Request_Resource");

            entity.Property(e => e.RequestDetailId).HasColumnName("request_detail_id");
            entity.Property(e => e.QuantityRequested).HasColumnName("quantity_requested");
            entity.Property(e => e.RequestId).HasColumnName("request_id");
            entity.Property(e => e.ResourceTypeId).HasColumnName("resource_type_id");

            entity.HasOne(d => d.Request).WithMany(p => p.ResourceRequestDetails)
                .HasForeignKey(d => d.RequestId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ResourceRequestDetail_Request");

            entity.HasOne(d => d.ResourceType).WithMany(p => p.ResourceRequestDetails)
                .HasForeignKey(d => d.ResourceTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ResourceRequestDetail_ResourceType");
        });

        modelBuilder.Entity<ResourceType>(entity =>
        {
            entity.HasKey(e => e.ResourceTypeId).HasName("PK__Resource__17AA243CBE4CC042");

            entity.ToTable("ResourceType");

            entity.HasIndex(e => e.ResourceName, "UQ__Resource__984CD047A4E6192D").IsUnique();

            entity.Property(e => e.ResourceTypeId).HasColumnName("resource_type_id");
            entity.Property(e => e.ResourceName)
                .HasMaxLength(100)
                .HasColumnName("resource_name");
            entity.Property(e => e.Unit)
                .HasMaxLength(30)
                .HasColumnName("unit");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__Role__760965CCA71EBF7E");

            entity.ToTable("Role");

            entity.HasIndex(e => e.RoleName, "UQ__Role__783254B1CE8F5813").IsUnique();

            entity.Property(e => e.RoleId).HasColumnName("role_id");
            entity.Property(e => e.RoleName)
                .HasMaxLength(80)
                .HasColumnName("role_name");

            entity.HasMany(d => d.Permissions).WithMany(p => p.Roles)
                .UsingEntity<Dictionary<string, object>>(
                    "RolePermission",
                    r => r.HasOne<Permission>().WithMany()
                        .HasForeignKey("PermissionId")
                        .HasConstraintName("FK_RolePermission_Permission"),
                    l => l.HasOne<Role>().WithMany()
                        .HasForeignKey("RoleId")
                        .HasConstraintName("FK_RolePermission_Role"),
                    j =>
                    {
                        j.HasKey("RoleId", "PermissionId");
                        j.ToTable("RolePermission");
                        j.IndexerProperty<int>("RoleId").HasColumnName("role_id");
                        j.IndexerProperty<int>("PermissionId").HasColumnName("permission_id");
                    });
        });

        modelBuilder.Entity<TeamMember>(entity =>
        {
            entity.HasKey(e => e.MemberId).HasName("PK__TeamMemb__B29B853411D29BE0");

            entity.ToTable("TeamMember");

            entity.Property(e => e.MemberId).HasColumnName("member_id");
            entity.Property(e => e.Designation)
                .HasMaxLength(80)
                .HasColumnName("designation");
            entity.Property(e => e.FullName)
                .HasMaxLength(100)
                .HasColumnName("full_name");
            entity.Property(e => e.Phone)
                .HasMaxLength(20)
                .HasColumnName("phone");
            entity.Property(e => e.TeamId).HasColumnName("team_id");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.Team).WithMany(p => p.TeamMembers)
                .HasForeignKey(d => d.TeamId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TeamMember_RescueTeam");

            entity.HasOne(d => d.User).WithMany(p => p.TeamMembers)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK_TeamMember_User");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__User__B9BE370FD3AA964D");

            entity.ToTable("User");

            entity.HasIndex(e => e.Email, "UQ__User__AB6E61647AB7DABB").IsUnique();

            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(sysdatetime())")
                .HasColumnName("created_at");
            entity.Property(e => e.Email)
                .HasMaxLength(150)
                .HasColumnName("email");
            entity.Property(e => e.FullName)
                .HasMaxLength(100)
                .HasColumnName("full_name");
            entity.Property(e => e.LastLogin).HasColumnName("last_login");
            entity.Property(e => e.PasswordHash)
                .HasMaxLength(255)
                .HasColumnName("password_hash");
            entity.Property(e => e.Phone)
                .HasMaxLength(20)
                .HasColumnName("phone");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("Active")
                .HasColumnName("status");
        });

        modelBuilder.Entity<UserRole>(entity =>
        {
            entity.HasKey(e => new { e.UserId, e.RoleId });

            entity.ToTable("UserRole");

            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.RoleId).HasColumnName("role_id");
            entity.Property(e => e.AssignedDate)
                .HasDefaultValueSql("(CONVERT([date],sysdatetime()))")
                .HasColumnName("assigned_date");

            entity.HasOne(d => d.Role).WithMany(p => p.UserRoles)
                .HasForeignKey(d => d.RoleId)
                .HasConstraintName("FK_UserRole_Role");

            entity.HasOne(d => d.User).WithMany(p => p.UserRoles)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK_UserRole_User");
        });

        modelBuilder.Entity<VwApprovalPending>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("vw_Approval_Pending");

            entity.Property(e => e.ApprovalId).HasColumnName("approval_id");
            entity.Property(e => e.MinutesWaiting).HasColumnName("minutes_waiting");
            entity.Property(e => e.ReferenceId).HasColumnName("reference_id");
            entity.Property(e => e.RequestType)
                .HasMaxLength(80)
                .HasColumnName("request_type");
            entity.Property(e => e.SubmittedAt).HasColumnName("submitted_at");
            entity.Property(e => e.SubmittedBy)
                .HasMaxLength(100)
                .HasColumnName("submitted_by");
        });

        modelBuilder.Entity<VwFinanceEventBudgetSummary>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("vw_Finance_EventBudgetSummary");

            entity.Property(e => e.BudgetBalance)
                .HasColumnType("decimal(38, 2)")
                .HasColumnName("budget_balance");
            entity.Property(e => e.DisasterEventId).HasColumnName("disaster_event_id");
            entity.Property(e => e.EventName)
                .HasMaxLength(150)
                .HasColumnName("event_name");
            entity.Property(e => e.EventStatus)
                .HasMaxLength(20)
                .HasColumnName("event_status");
            entity.Property(e => e.TotalDonation)
                .HasColumnType("decimal(38, 2)")
                .HasColumnName("total_donation");
            entity.Property(e => e.TotalExpense)
                .HasColumnType("decimal(38, 2)")
                .HasColumnName("total_expense");
        });

        modelBuilder.Entity<VwOperatorPendingReport>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("vw_Operator_PendingReports");

            entity.Property(e => e.Area)
                .HasMaxLength(150)
                .HasColumnName("area");
            entity.Property(e => e.City)
                .HasMaxLength(100)
                .HasColumnName("city");
            entity.Property(e => e.DisasterType)
                .HasMaxLength(100)
                .HasColumnName("disaster_type");
            entity.Property(e => e.ReportId).HasColumnName("report_id");
            entity.Property(e => e.ReportTime).HasColumnName("report_time");
            entity.Property(e => e.Reporter)
                .HasMaxLength(100)
                .HasColumnName("reporter");
            entity.Property(e => e.SeverityLevel)
                .HasMaxLength(20)
                .HasColumnName("severity_level");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasColumnName("status");
        });

        modelBuilder.Entity<VwWarehouseLowStock>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("vw_Warehouse_LowStock");

            entity.Property(e => e.City)
                .HasMaxLength(100)
                .HasColumnName("city");
            entity.Property(e => e.QuantityAvailable).HasColumnName("quantity_available");
            entity.Property(e => e.ReorderLevel).HasColumnName("reorder_level");
            entity.Property(e => e.ResourceName)
                .HasMaxLength(100)
                .HasColumnName("resource_name");
            entity.Property(e => e.ResourceTypeId).HasColumnName("resource_type_id");
            entity.Property(e => e.Shortage).HasColumnName("shortage");
            entity.Property(e => e.WarehouseId).HasColumnName("warehouse_id");
            entity.Property(e => e.WarehouseName)
                .HasMaxLength(100)
                .HasColumnName("warehouse_name");
        });

        modelBuilder.Entity<Warehouse>(entity =>
        {
            entity.HasKey(e => e.WarehouseId).HasName("PK__Warehous__734FE6BF652D29C1");

            entity.ToTable("Warehouse");

            entity.HasIndex(e => e.WarehouseName, "UQ__Warehous__8CF8D3AF5C2B0621").IsUnique();

            entity.Property(e => e.WarehouseId).HasColumnName("warehouse_id");
            entity.Property(e => e.LocationId).HasColumnName("location_id");
            entity.Property(e => e.ManagedBy).HasColumnName("managed_by");
            entity.Property(e => e.WarehouseName)
                .HasMaxLength(100)
                .HasColumnName("warehouse_name");

            entity.HasOne(d => d.Location).WithMany(p => p.Warehouses)
                .HasForeignKey(d => d.LocationId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Warehouse_Location");

            entity.HasOne(d => d.ManagedByNavigation).WithMany(p => p.Warehouses)
                .HasForeignKey(d => d.ManagedBy)
                .HasConstraintName("FK_Warehouse_User");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
