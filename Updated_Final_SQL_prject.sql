-- ============================================================
--  Smart Disaster Response MIS
-- ============================================================

-- ============================================================
-- DDL : CREATE TABLES
-- ============================================================
CREATE DATABASE SmartDisasterMIS;
GO
USE SmartDisasterMIS;
GO
-- Drop tables in reverse dependency order
IF OBJECT_ID('AuditLog',              'U') IS NOT NULL DROP TABLE AuditLog;
IF OBJECT_ID('ApprovalRequest',       'U') IS NOT NULL DROP TABLE ApprovalRequest;
IF OBJECT_ID('Expense',               'U') IS NOT NULL DROP TABLE Expense;
IF OBJECT_ID('ExpenseCategory',       'U') IS NOT NULL DROP TABLE ExpenseCategory;
IF OBJECT_ID('Donation',              'U') IS NOT NULL DROP TABLE Donation;
IF OBJECT_ID('Donor',                 'U') IS NOT NULL DROP TABLE Donor;
IF OBJECT_ID('Admission',             'U') IS NOT NULL DROP TABLE Admission;
IF OBJECT_ID('Patient',               'U') IS NOT NULL DROP TABLE Patient;
IF OBJECT_ID('HospitalEvent',         'U') IS NOT NULL DROP TABLE HospitalEvent;
IF OBJECT_ID('Hospital',              'U') IS NOT NULL DROP TABLE Hospital;
IF OBJECT_ID('DispatchDetail',        'U') IS NOT NULL DROP TABLE DispatchDetail;
IF OBJECT_ID('ResourceDispatch',      'U') IS NOT NULL DROP TABLE ResourceDispatch;
IF OBJECT_ID('ResourceRequestDetail', 'U') IS NOT NULL DROP TABLE ResourceRequestDetail;
IF OBJECT_ID('ResourceRequest',       'U') IS NOT NULL DROP TABLE ResourceRequest;
IF OBJECT_ID('Inventory',             'U') IS NOT NULL DROP TABLE Inventory;
IF OBJECT_ID('ResourceType',          'U') IS NOT NULL DROP TABLE ResourceType;
IF OBJECT_ID('Warehouse',             'U') IS NOT NULL DROP TABLE Warehouse;
IF OBJECT_ID('RescueAssignment',      'U') IS NOT NULL DROP TABLE RescueAssignment;
IF OBJECT_ID('TeamMember',            'U') IS NOT NULL DROP TABLE TeamMember;
IF OBJECT_ID('RescueTeam',            'U') IS NOT NULL DROP TABLE RescueTeam;
IF OBJECT_ID('EmergencyReport',       'U') IS NOT NULL DROP TABLE EmergencyReport;
IF OBJECT_ID('DisasterEvent',         'U') IS NOT NULL DROP TABLE DisasterEvent;
IF OBJECT_ID('Location',              'U') IS NOT NULL DROP TABLE Location;
IF OBJECT_ID('DisasterType',          'U') IS NOT NULL DROP TABLE DisasterType;
IF OBJECT_ID('RolePermission',        'U') IS NOT NULL DROP TABLE RolePermission;
IF OBJECT_ID('UserRole',              'U') IS NOT NULL DROP TABLE UserRole;
IF OBJECT_ID('Permission',            'U') IS NOT NULL DROP TABLE Permission;
IF OBJECT_ID('Role',                  'U') IS NOT NULL DROP TABLE Role;
IF OBJECT_ID('[User]',                'U') IS NOT NULL DROP TABLE [User];

-- ─────────────────────────────────────────────────────────────
-- DisasterType
-- ─────────────────────────────────────────────────────────────
CREATE TABLE DisasterType (
    disaster_type_id INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    type_name        NVARCHAR(100) NOT NULL UNIQUE
);

-- ─────────────────────────────────────────────────────────────
-- Location
-- ─────────────────────────────────────────────────────────────
CREATE TABLE Location (
    location_id INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    city        NVARCHAR(100)  NOT NULL,
    area        NVARCHAR(150)  NULL,
    latitude    DECIMAL(10,7)  NULL,
    longitude   DECIMAL(10,7)  NULL
);

-- ─────────────────────────────────────────────────────────────
-- Role
-- ─────────────────────────────────────────────────────────────
CREATE TABLE Role (
    role_id   INT          NOT NULL IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(80) NOT NULL UNIQUE
);

-- ─────────────────────────────────────────────────────────────
-- Permission
-- ─────────────────────────────────────────────────────────────
CREATE TABLE Permission (
    permission_id   INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    permission_name NVARCHAR(100) NOT NULL UNIQUE,
    module_name     NVARCHAR(80)  NOT NULL
);

-- ─────────────────────────────────────────────────────────────
-- User
-- ─────────────────────────────────────────────────────────────
CREATE TABLE [User] (
    user_id       INT                          NOT NULL IDENTITY(1,1) PRIMARY KEY,
    full_name     NVARCHAR(100)                NOT NULL,
    email         NVARCHAR(150)                NOT NULL UNIQUE,
    phone         NVARCHAR(20)                 NULL,
    password_hash NVARCHAR(255)                NOT NULL,
    status        NVARCHAR(20)                 NOT NULL DEFAULT 'Active',
    created_at    DATETIME2                    NOT NULL DEFAULT SYSDATETIME(),
    last_login    DATETIME2                    NULL,
    CONSTRAINT CK_User_status CHECK (status IN ('Active','Inactive','Suspended'))
);

-- ─────────────────────────────────────────────────────────────
-- UserRole
-- ─────────────────────────────────────────────────────────────
CREATE TABLE UserRole (
    user_id       INT  NOT NULL,
    role_id       INT  NOT NULL,
    assigned_date DATE NOT NULL DEFAULT CAST(SYSDATETIME() AS DATE),
    CONSTRAINT PK_UserRole PRIMARY KEY (user_id, role_id),
    CONSTRAINT FK_UserRole_User FOREIGN KEY (user_id) REFERENCES [User](user_id) ON DELETE CASCADE,
    CONSTRAINT FK_UserRole_Role FOREIGN KEY (role_id) REFERENCES Role(role_id)   ON DELETE CASCADE
);

-- ─────────────────────────────────────────────────────────────
-- RolePermission
-- ─────────────────────────────────────────────────────────────
CREATE TABLE RolePermission (
    role_id       INT NOT NULL,
    permission_id INT NOT NULL,
    CONSTRAINT PK_RolePermission PRIMARY KEY (role_id, permission_id),
    CONSTRAINT FK_RolePermission_Role       FOREIGN KEY (role_id)       REFERENCES Role(role_id)             ON DELETE CASCADE,
    CONSTRAINT FK_RolePermission_Permission FOREIGN KEY (permission_id) REFERENCES Permission(permission_id) ON DELETE CASCADE
);

-- ─────────────────────────────────────────────────────────────
-- DisasterEvent
-- ─────────────────────────────────────────────────────────────
CREATE TABLE DisasterEvent (
    disaster_event_id INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    disaster_type_id  INT           NOT NULL,
    event_name        NVARCHAR(150) NOT NULL,
    start_date        DATE          NOT NULL,
    end_date          DATE          NULL,
    status            NVARCHAR(20)  NOT NULL DEFAULT 'Active',
    CONSTRAINT CK_DisasterEvent_status CHECK (status IN ('Active','Monitoring','Closed')),
    CONSTRAINT FK_DisasterEvent_DisasterType FOREIGN KEY (disaster_type_id) REFERENCES DisasterType(disaster_type_id)
);

-- ─────────────────────────────────────────────────────────────
-- EmergencyReport
-- ─────────────────────────────────────────────────────────────
CREATE TABLE EmergencyReport (
    report_id         INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    disaster_type_id  INT           NOT NULL,
    location_id       INT           NOT NULL,
    disaster_event_id INT           NOT NULL,
    reported_by       INT           NULL,
    citizen_name      NVARCHAR(100) NULL,
    citizen_phone     NVARCHAR(20)  NULL,
    severity_level    NVARCHAR(20)  NOT NULL,
    description       NVARCHAR(MAX) NULL,
    report_time       DATETIME2     NOT NULL DEFAULT SYSDATETIME(),
    status            NVARCHAR(20)  NOT NULL DEFAULT 'Pending',
    CONSTRAINT CK_EmergencyReport_severity CHECK (severity_level IN ('Low','Medium','High','Critical')),
    CONSTRAINT CK_EmergencyReport_status   CHECK (status         IN ('Pending','Assigned','Resolved','Closed')),
    CONSTRAINT FK_EmergencyReport_DisasterType  FOREIGN KEY (disaster_type_id)  REFERENCES DisasterType(disaster_type_id),
    CONSTRAINT FK_EmergencyReport_Location      FOREIGN KEY (location_id)       REFERENCES Location(location_id),
    CONSTRAINT FK_EmergencyReport_DisasterEvent FOREIGN KEY (disaster_event_id) REFERENCES DisasterEvent(disaster_event_id),
    CONSTRAINT FK_EmergencyReport_User          FOREIGN KEY (reported_by)       REFERENCES [User](user_id)
);

-- ─────────────────────────────────────────────────────────────
-- RescueTeam
-- ─────────────────────────────────────────────────────────────
CREATE TABLE RescueTeam (
    team_id        INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    team_name      NVARCHAR(100) NOT NULL UNIQUE,
    team_type      NVARCHAR(30)  NOT NULL,
    location_id    INT           NOT NULL,
    current_status NVARCHAR(20)  NOT NULL DEFAULT 'Available',
    CONSTRAINT CK_RescueTeam_type   CHECK (team_type      IN ('Medical','Fire','Search & Rescue','Hazmat')),
    CONSTRAINT CK_RescueTeam_status CHECK (current_status IN ('Available','Assigned','Busy','Completed')),
    CONSTRAINT FK_RescueTeam_Location FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

-- ─────────────────────────────────────────────────────────────
-- TeamMember
-- ─────────────────────────────────────────────────────────────
CREATE TABLE TeamMember (
    member_id   INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    team_id     INT           NOT NULL,
    user_id     INT           NULL,
    full_name   NVARCHAR(100) NOT NULL,
    designation NVARCHAR(80)  NOT NULL,
    phone       NVARCHAR(20)  NULL,
    CONSTRAINT FK_TeamMember_RescueTeam FOREIGN KEY (team_id) REFERENCES RescueTeam(team_id),
    CONSTRAINT FK_TeamMember_User       FOREIGN KEY (user_id) REFERENCES [User](user_id)
);

-- ─────────────────────────────────────────────────────────────
-- RescueAssignment
-- ─────────────────────────────────────────────────────────────
CREATE TABLE RescueAssignment (
    assignment_id     INT          NOT NULL IDENTITY(1,1) PRIMARY KEY,
    report_id         INT          NOT NULL,
    team_id           INT          NOT NULL,
    assigned_by       INT          NOT NULL,
    assigned_time     DATETIME2    NOT NULL DEFAULT SYSDATETIME(),
    completion_time   DATETIME2    NULL,
    assignment_status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    CONSTRAINT CK_RescueAssignment_status CHECK (assignment_status IN ('Pending','En Route','On Scene','Completed','Cancelled')),
    CONSTRAINT FK_RescueAssignment_Report   FOREIGN KEY (report_id)   REFERENCES EmergencyReport(report_id),
    CONSTRAINT FK_RescueAssignment_Team     FOREIGN KEY (team_id)     REFERENCES RescueTeam(team_id),
    CONSTRAINT FK_RescueAssignment_User     FOREIGN KEY (assigned_by) REFERENCES [User](user_id)
);

-- ─────────────────────────────────────────────────────────────
-- Warehouse
-- ─────────────────────────────────────────────────────────────
CREATE TABLE Warehouse (
    warehouse_id   INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    warehouse_name NVARCHAR(100) NOT NULL UNIQUE,
    location_id    INT           NOT NULL,
    managed_by     INT           NULL,
    CONSTRAINT FK_Warehouse_Location FOREIGN KEY (location_id) REFERENCES Location(location_id),
    CONSTRAINT FK_Warehouse_User     FOREIGN KEY (managed_by)  REFERENCES [User](user_id)
);

-- ─────────────────────────────────────────────────────────────
-- ResourceType
-- ─────────────────────────────────────────────────────────────
CREATE TABLE ResourceType (
    resource_type_id INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    resource_name    NVARCHAR(100) NOT NULL UNIQUE,
    unit             NVARCHAR(30)  NOT NULL
);

-- ─────────────────────────────────────────────────────────────
-- Inventory
-- ─────────────────────────────────────────────────────────────
CREATE TABLE Inventory (
    inventory_id       INT      NOT NULL IDENTITY(1,1) PRIMARY KEY,
    warehouse_id       INT      NOT NULL,
    resource_type_id   INT      NOT NULL,
    quantity_available INT      NOT NULL DEFAULT 0,
    reorder_level      INT      NOT NULL DEFAULT 0,
    last_updated       DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT CK_Inventory_qty    CHECK (quantity_available >= 0),
    CONSTRAINT UQ_Inventory        UNIQUE (warehouse_id, resource_type_id),
    CONSTRAINT FK_Inventory_Warehouse     FOREIGN KEY (warehouse_id)     REFERENCES Warehouse(warehouse_id),
    CONSTRAINT FK_Inventory_ResourceType  FOREIGN KEY (resource_type_id) REFERENCES ResourceType(resource_type_id)
);

-- ─────────────────────────────────────────────────────────────
-- ResourceRequest
-- ─────────────────────────────────────────────────────────────
CREATE TABLE ResourceRequest (
    request_id   INT          NOT NULL IDENTITY(1,1) PRIMARY KEY,
    report_id    INT          NULL,
    submitted_by INT          NOT NULL,
    request_date DATETIME2    NOT NULL DEFAULT SYSDATETIME(),
    status       NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    CONSTRAINT CK_ResourceRequest_status CHECK (status IN ('Pending','Approved','Rejected','Fulfilled')),
    CONSTRAINT FK_ResourceRequest_Report FOREIGN KEY (report_id)    REFERENCES EmergencyReport(report_id),
    CONSTRAINT FK_ResourceRequest_User   FOREIGN KEY (submitted_by) REFERENCES [User](user_id)
);

-- ─────────────────────────────────────────────────────────────
-- ResourceRequestDetail
-- ─────────────────────────────────────────────────────────────
CREATE TABLE ResourceRequestDetail (
    request_detail_id  INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    request_id         INT NOT NULL,
    resource_type_id   INT NOT NULL,
    quantity_requested INT NOT NULL,
    CONSTRAINT CK_ResourceRequestDetail_qty CHECK (quantity_requested > 0),
    CONSTRAINT FK_ResourceRequestDetail_Request      FOREIGN KEY (request_id)       REFERENCES ResourceRequest(request_id),
    CONSTRAINT FK_ResourceRequestDetail_ResourceType FOREIGN KEY (resource_type_id) REFERENCES ResourceType(resource_type_id)
);
-- ─────────────────────────────────────────────────────────────
-- ResourceDispatch
-- ─────────────────────────────────────────────────────────────
CREATE TABLE ResourceDispatch (
    dispatch_id   INT          NOT NULL IDENTITY(1,1) PRIMARY KEY,
    request_id    INT          NULL,
    warehouse_id  INT          NOT NULL,
    assignment_id INT          NULL,
    approved_by   INT          NOT NULL,
    dispatch_date DATETIME2    NOT NULL DEFAULT SYSDATETIME(),
    status        NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    CONSTRAINT CK_ResourceDispatch_status CHECK (status IN ('Pending','Dispatched','Delivered','Cancelled')),
    CONSTRAINT FK_ResourceDispatch_Request    FOREIGN KEY (request_id)    REFERENCES ResourceRequest(request_id),
    CONSTRAINT FK_ResourceDispatch_Warehouse  FOREIGN KEY (warehouse_id)  REFERENCES Warehouse(warehouse_id),
    CONSTRAINT FK_ResourceDispatch_Assignment FOREIGN KEY (assignment_id) REFERENCES RescueAssignment(assignment_id),
    CONSTRAINT FK_ResourceDispatch_User       FOREIGN KEY (approved_by)   REFERENCES [User](user_id)
);

-- ─────────────────────────────────────────────────────────────
-- DispatchDetail
-- ─────────────────────────────────────────────────────────────
CREATE TABLE DispatchDetail (
    dispatch_detail_id  INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    dispatch_id         INT NOT NULL,
    resource_type_id    INT NOT NULL,
    request_detail_id   INT NULL,
    quantity_dispatched INT NOT NULL,
    CONSTRAINT CK_DispatchDetail_qty CHECK (quantity_dispatched > 0),
    CONSTRAINT FK_DispatchDetail_Dispatch      FOREIGN KEY (dispatch_id)       REFERENCES ResourceDispatch(dispatch_id),
    CONSTRAINT FK_DispatchDetail_ResourceType  FOREIGN KEY (resource_type_id)  REFERENCES ResourceType(resource_type_id),
    CONSTRAINT FK_DispatchDetail_RequestDetail FOREIGN KEY (request_detail_id) REFERENCES ResourceRequestDetail(request_detail_id)
);

-- ─────────────────────────────────────────────────────────────
-- Hospital
-- ─────────────────────────────────────────────────────────────
CREATE TABLE Hospital (
    hospital_id       INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    hospital_name     NVARCHAR(150) NOT NULL UNIQUE,
    location_id       INT           NOT NULL,
    contact_no        NVARCHAR(20)  NOT NULL,
    total_beds        INT           NOT NULL DEFAULT 0,
    available_beds    INT           NOT NULL DEFAULT 0,
    critical_capacity INT           NOT NULL DEFAULT 0,
    CONSTRAINT CK_Hospital_available_beds CHECK (available_beds >= 0),
    CONSTRAINT FK_Hospital_Location FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

-- ─────────────────────────────────────────────────────────────
-- HospitalEvent
-- ─────────────────────────────────────────────────────────────
CREATE TABLE HospitalEvent (
    hospital_id       INT NOT NULL,
    disaster_event_id INT NOT NULL,
    CONSTRAINT PK_HospitalEvent PRIMARY KEY (hospital_id, disaster_event_id),
    CONSTRAINT FK_HospitalEvent_Hospital      FOREIGN KEY (hospital_id)       REFERENCES Hospital(hospital_id),
    CONSTRAINT FK_HospitalEvent_DisasterEvent FOREIGN KEY (disaster_event_id) REFERENCES DisasterEvent(disaster_event_id)
);

-- ─────────────────────────────────────────────────────────────
-- Patient
-- ─────────────────────────────────────────────────────────────
CREATE TABLE Patient (
    patient_id       INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    report_id        INT           NULL,
    full_name        NVARCHAR(100) NOT NULL,
    age              INT           NULL,
    gender           NVARCHAR(10)  NOT NULL DEFAULT 'Unknown',
    condition_status NVARCHAR(20)  NOT NULL DEFAULT 'Stable',
    CONSTRAINT CK_Patient_age             CHECK (age >= 0),
    CONSTRAINT CK_Patient_gender          CHECK (gender           IN ('Male','Female','Other','Unknown')),
    CONSTRAINT CK_Patient_condition       CHECK (condition_status IN ('Stable','Critical','Deceased','Recovered')),
    CONSTRAINT FK_Patient_EmergencyReport FOREIGN KEY (report_id) REFERENCES EmergencyReport(report_id)
);

-- ─────────────────────────────────────────────────────────────
-- Admission
-- ─────────────────────────────────────────────────────────────
CREATE TABLE Admission (
    admission_id   INT          NOT NULL IDENTITY(1,1) PRIMARY KEY,
    patient_id     INT          NOT NULL,
    hospital_id    INT          NOT NULL,
    admit_time     DATETIME2    NOT NULL DEFAULT SYSDATETIME(),
    discharge_time DATETIME2    NULL,
    status         NVARCHAR(20) NOT NULL DEFAULT 'Admitted',
    CONSTRAINT CK_Admission_status CHECK (status IN ('Admitted','Discharged','Transferred','Deceased')),
    CONSTRAINT FK_Admission_Patient  FOREIGN KEY (patient_id)  REFERENCES Patient(patient_id),
    CONSTRAINT FK_Admission_Hospital FOREIGN KEY (hospital_id) REFERENCES Hospital(hospital_id)
);

-- ─────────────────────────────────────────────────────────────
-- Donor
-- ─────────────────────────────────────────────────────────────
CREATE TABLE Donor (
    donor_id   INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    donor_name NVARCHAR(150) NOT NULL,
    donor_type NVARCHAR(20)  NOT NULL,
    phone      NVARCHAR(20)  NULL,
    email      NVARCHAR(150) NULL,
    CONSTRAINT CK_Donor_type CHECK (donor_type IN ('Individual','Corporate','NGO','Government'))
);

-- ─────────────────────────────────────────────────────────────
-- Donation
-- ─────────────────────────────────────────────────────────────
CREATE TABLE Donation (
    donation_id       INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    donor_id          INT            NOT NULL,
    disaster_event_id INT            NULL,
    amount            DECIMAL(15,2)  NOT NULL,
    donation_date     DATETIME2      NOT NULL DEFAULT SYSDATETIME(),
    payment_method    NVARCHAR(20)   NOT NULL,
    CONSTRAINT CK_Donation_amount         CHECK (amount > 0),
    CONSTRAINT CK_Donation_payment_method CHECK (payment_method IN ('Cash','Bank Transfer','Online','Cheque')),
    CONSTRAINT FK_Donation_Donor        FOREIGN KEY (donor_id)          REFERENCES Donor(donor_id),
    CONSTRAINT FK_Donation_DisasterEvent FOREIGN KEY (disaster_event_id) REFERENCES DisasterEvent(disaster_event_id)
);

-- ─────────────────────────────────────────────────────────────
-- ExpenseCategory
-- ─────────────────────────────────────────────────────────────
CREATE TABLE ExpenseCategory (
    category_id   INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL UNIQUE
);

-- ─────────────────────────────────────────────────────────────
-- Expense
-- ─────────────────────────────────────────────────────────────
CREATE TABLE Expense (
    expense_id        INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    category_id       INT           NOT NULL,
    disaster_event_id INT           NULL,
    approved_by       INT           NULL,
    amount            DECIMAL(15,2) NOT NULL,
    expense_date      DATETIME2     NOT NULL DEFAULT SYSDATETIME(),
    description       NVARCHAR(MAX) NULL,
    CONSTRAINT CK_Expense_amount CHECK (amount > 0),
    CONSTRAINT FK_Expense_Category      FOREIGN KEY (category_id)       REFERENCES ExpenseCategory(category_id),
    CONSTRAINT FK_Expense_DisasterEvent FOREIGN KEY (disaster_event_id) REFERENCES DisasterEvent(disaster_event_id),
    CONSTRAINT FK_Expense_User          FOREIGN KEY (approved_by)       REFERENCES [User](user_id)
);

-- ─────────────────────────────────────────────────────────────
-- ApprovalRequest
-- ─────────────────────────────────────────────────────────────
CREATE TABLE ApprovalRequest (
    approval_id  INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    submitted_by INT           NOT NULL,
    approved_by  INT           NULL,
    request_type NVARCHAR(80)  NOT NULL,
    reference_id INT           NOT NULL,
    status       NVARCHAR(20)  NOT NULL DEFAULT 'Pending',
    remarks      NVARCHAR(MAX) NULL,
    submitted_at DATETIME2     NOT NULL DEFAULT SYSDATETIME(),
    decision_at  DATETIME2     NULL,
    CONSTRAINT CK_ApprovalRequest_status CHECK (status IN ('Pending','Approved','Rejected')),
    CONSTRAINT FK_ApprovalRequest_SubmittedBy FOREIGN KEY (submitted_by) REFERENCES [User](user_id),
    CONSTRAINT FK_ApprovalRequest_ApprovedBy  FOREIGN KEY (approved_by)  REFERENCES [User](user_id)
);

-- ─────────────────────────────────────────────────────────────
-- AuditLog
-- ─────────────────────────────────────────────────────────────
CREATE TABLE AuditLog (
    log_id      INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    user_id     INT           NOT NULL,
    action_type NVARCHAR(20)  NOT NULL,
    table_name  NVARCHAR(80)  NOT NULL,
    record_id   INT           NULL,
    old_value   NVARCHAR(MAX) NULL,
    new_value   NVARCHAR(MAX) NULL,
    action_time DATETIME2     NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT CK_AuditLog_action_type CHECK (action_type IN ('INSERT','UPDATE','DELETE','LOGIN','LOGOUT','APPROVE','REJECT')),
    CONSTRAINT FK_AuditLog_User FOREIGN KEY (user_id) REFERENCES [User](user_id)
);


-- ============================================================
-- PART 2 — DML : SAMPLE DATA
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- DisasterType
-- ─────────────────────────────────────────────────────────────
INSERT INTO DisasterType (type_name) VALUES
('Flood'), ('Earthquake'), ('Fire'), ('Landslide'), ('Cyclone');

-- ─────────────────────────────────────────────────────────────
-- Location
-- ─────────────────────────────────────────────────────────────
INSERT INTO Location (city, area, latitude, longitude) VALUES
('Karachi',     'Korangi',         24.8400,  67.1200),
('Lahore',      'Model Town',      31.4800,  74.3200),
('Islamabad',   'G-10',            33.6844,  73.0479),
('Peshawar',    'Hayatabad',       34.0151,  71.4450),
('Quetta',      'Satellite Town',  30.1798,  66.9750),
('Rawalpindi',  'Saddar',          33.5651,  73.0169),
('Multan',      'Gulgasht',        30.1575,  71.5249),
('Faisalabad',  'Peoples Colony',  31.4180,  73.0790);

-- ─────────────────────────────────────────────────────────────
-- Role
-- ─────────────────────────────────────────────────────────────
INSERT INTO Role (role_name) VALUES
('Administrator'),
('Emergency Operator'),
('Field Officer'),
('Warehouse Manager'),
('Finance Officer');

-- ─────────────────────────────────────────────────────────────
-- Permission
-- ─────────────────────────────────────────────────────────────
INSERT INTO Permission (permission_name, module_name) VALUES
('VIEW_REPORTS',      'Disaster Incident'),
('CREATE_REPORT',     'Disaster Incident'),
('ASSIGN_TEAM',       'Rescue Team Management'),
('VIEW_INVENTORY',    'Resource Management'),
('APPROVE_DISPATCH',  'Resource Management'),
('MANAGE_WAREHOUSE',  'Resource Management'),
('VIEW_FINANCE',      'Finance'),
('APPROVE_EXPENSE',   'Finance'),
('MANAGE_USERS',      'User Management'),
('VIEW_AUDIT',        'Audit & Logging'),
('APPROVE_REQUEST',   'Approval Workflow'),
('VIEW_HOSPITALS',    'Hospital Coordination');

-- ─────────────────────────────────────────────────────────────
-- User
-- ─────────────────────────────────────────────────────────────
INSERT INTO [User] (full_name, email, phone, password_hash, status) VALUES
('Admin User',    'admin@disaster.gov.pk',         '03001234567', '$2b$12$hash_admin_001', 'Active'),
('Ali Hassan',    'ali.operator@disaster.gov.pk',  '03011234567', '$2b$12$hash_op_002',    'Active'),
('Sara Khan',     'sara.officer@disaster.gov.pk',  '03021234567', '$2b$12$hash_fo_003',    'Active'),
('Bilal Ahmed',   'bilal.wm@disaster.gov.pk',      '03031234567', '$2b$12$hash_wm_004',    'Active'),
('Nida Farooq',   'nida.finance@disaster.gov.pk',  '03041234567', '$2b$12$hash_fin_005',   'Active'),
('Omar Malik',    'omar.operator@disaster.gov.pk', '03051234567', '$2b$12$hash_op_006',    'Active'),
('Fatima Zahra',  'fatima.officer@disaster.gov.pk','03061234567', '$2b$12$hash_fo_007',    'Active'),
('Usman Raza',    'usman.admin@disaster.gov.pk',   '03071234567', '$2b$12$hash_adm_008',   'Active');

-- ─────────────────────────────────────────────────────────────
-- UserRole
-- ─────────────────────────────────────────────────────────────
INSERT INTO UserRole (user_id, role_id, assigned_date) VALUES
(1, 1, '2024-01-01'),
(2, 2, '2024-01-02'),
(3, 3, '2024-01-02'),
(4, 4, '2024-01-03'),
(5, 5, '2024-01-03'),
(6, 2, '2024-01-04'),
(7, 3, '2024-01-04'),
(8, 1, '2024-01-05');

-- ─────────────────────────────────────────────────────────────
-- RolePermission
-- ─────────────────────────────────────────────────────────────
INSERT INTO RolePermission (role_id, permission_id) VALUES
-- Administrator: all permissions
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),
-- Emergency Operator
(2,1),(2,2),(2,3),(2,12),
-- Field Officer
(3,1),(3,12),
-- Warehouse Manager
(4,4),(4,5),(4,6),
-- Finance Officer
(5,7),(5,8),(5,11);

-- ─────────────────────────────────────────────────────────────
-- DisasterEvent
-- ─────────────────────────────────────────────────────────────
INSERT INTO DisasterEvent (disaster_type_id, event_name, start_date, end_date, status) VALUES
(1, 'Karachi Monsoon Flood 2024',    '2024-07-15', NULL,         'Active'),
(2, 'Quetta Earthquake 2024',        '2024-08-22', '2024-09-10', 'Closed'),
(3, 'Lahore Industrial Fire 2024',   '2024-09-05', '2024-09-06', 'Closed'),
(1, 'Peshawar Flash Flood 2024',     '2024-10-01', NULL,         'Monitoring');

-- ─────────────────────────────────────────────────────────────
-- EmergencyReport
-- ─────────────────────────────────────────────────────────────
INSERT INTO EmergencyReport
    (disaster_type_id, location_id, disaster_event_id, reported_by,
     citizen_name, citizen_phone, severity_level, description, report_time, status)
VALUES
(1, 1, 1, 2,    NULL,          NULL,            'Critical', 'Major flooding in Korangi — residential areas submerged',  '2024-07-15 08:30:00', 'Assigned'),
(1, 1, 1, NULL, 'Rashid Ali',  '03009876543',   'High',     'Water levels rising near school',                          '2024-07-15 09:15:00', 'Assigned'),
(2, 5, 2, 6,    NULL,          NULL,            'Critical', 'Building collapse in Satellite Town',                       '2024-08-22 14:00:00', 'Resolved'),
(3, 2, 3, 2,    NULL,          NULL,            'High',     'Fire spreading in industrial zone',                         '2024-09-05 22:00:00', 'Resolved'),
(1, 4, 4, NULL, 'Zara Bibi',   '03119876543',   'Medium',   'Flash flood warning — need evacuation support',            '2024-10-01 06:00:00', 'Pending'),
(1, 1, 1, 6,    NULL,          NULL,            'High',     'Relief camps needed in sector 5',                          '2024-07-16 10:00:00', 'Pending'),
(2, 5, 2, NULL, 'Ahmad Shah',  '03219876543',   'Critical', 'People trapped under debris',                              '2024-08-22 15:30:00', 'Resolved'),
(1, 4, 4, 2,    NULL,          NULL,            'Low',      'Minor flooding near market area',                          '2024-10-02 08:00:00', 'Pending');

-- ─────────────────────────────────────────────────────────────
-- RescueTeam
-- ─────────────────────────────────────────────────────────────
INSERT INTO RescueTeam (team_name, team_type, location_id, current_status) VALUES
('Alpha Medical Unit',       'Medical',          1, 'Assigned'),
('Bravo Fire Squad',         'Fire',             2, 'Available'),
('Charlie Search & Rescue',  'Search & Rescue',  5, 'Available'),
('Delta Hazmat Team',        'Hazmat',           3, 'Available'),
('Echo Medical Unit',        'Medical',          4, 'Busy'),
('Foxtrot Fire Squad',       'Fire',             1, 'Available'),
('Golf Search & Rescue',     'Search & Rescue',  1, 'Assigned'),
('Hotel Medical Unit',       'Medical',          5, 'Completed');

-- ─────────────────────────────────────────────────────────────
-- TeamMember
-- ─────────────────────────────────────────────────────────────
INSERT INTO TeamMember (team_id, user_id, full_name, designation, phone) VALUES
(1, 3,    'Sara Khan',         'Team Lead',            '03021234567'),
(1, NULL, 'Dr. Imran Qureshi', 'Paramedic',            '03099887766'),
(1, NULL, 'Hira Baig',         'Nurse',                '03088776655'),
(2, 7,    'Fatima Zahra',      'Team Lead',            '03061234567'),
(2, NULL, 'Tariq Mehmood',     'Fire Fighter',         '03077665544'),
(3, NULL, 'Kamran Iqbal',      'Search Specialist',    '03066554433'),
(3, NULL, 'Ayesha Noor',       'Rescue Diver',         '03055443322'),
(5, NULL, 'Dr. Zafar Hussain', 'Chief Medical Officer','03044332211');

-- ─────────────────────────────────────────────────────────────
-- RescueAssignment
-- ─────────────────────────────────────────────────────────────
INSERT INTO RescueAssignment
    (report_id, team_id, assigned_by, assigned_time, completion_time, assignment_status)
VALUES
(1, 1, 2, '2024-07-15 09:00:00', NULL,                  'On Scene'),
(1, 7, 2, '2024-07-15 09:30:00', NULL,                  'On Scene'),
(3, 3, 6, '2024-08-22 14:30:00', '2024-08-22 20:00:00', 'Completed'),
(4, 2, 2, '2024-09-05 22:30:00', '2024-09-06 04:00:00', 'Completed'),
(7, 8, 6, '2024-08-22 16:00:00', '2024-08-22 22:00:00', 'Completed'),
(2, 1, 2, '2024-07-15 10:00:00', NULL,                  'En Route');

-- ─────────────────────────────────────────────────────────────
-- Warehouse
-- ─────────────────────────────────────────────────────────────
INSERT INTO Warehouse (warehouse_name, location_id, managed_by) VALUES
('Karachi Central Warehouse',  1, 4),
('Lahore Relief Hub',          2, 4),
('Islamabad Storage Facility', 3, 4),
('Quetta Emergency Depot',     5, 4),
('Peshawar Supply Center',     4, 4);

-- ─────────────────────────────────────────────────────────────
-- ResourceType
-- ─────────────────────────────────────────────────────────────
INSERT INTO ResourceType (resource_name, unit) VALUES
('Food Pack',            'piece'),
('Water Bottle (1.5L)',  'piece'),
('First Aid Kit',        'piece'),
('Tent (4-person)',      'piece'),
('Blanket',              'piece'),
('Medicine Bundle',      'piece'),
('Rope (50m)',           'roll'),
('Generator (5kW)',      'piece');

-- ─────────────────────────────────────────────────────────────
-- Inventory
-- ─────────────────────────────────────────────────────────────
INSERT INTO Inventory (warehouse_id, resource_type_id, quantity_available, reorder_level) VALUES
(1, 1, 5000, 500),
(1, 2,10000,1000),
(1, 3,  300,  50),
(1, 4,  150,  20),
(1, 5,  800, 100),
(2, 1, 3000, 300),
(2, 2, 6000, 600),
(2, 3,  200,  30),
(3, 1, 2000, 200),
(3, 6,  400,  50),
(4, 1, 1500, 150),
(4, 2, 3000, 300),
(4, 3,  100,  20),
(5, 1,   80, 200),   -- BELOW REORDER (low-stock demo)
(5, 2,   50, 300),   -- BELOW REORDER (low-stock demo)
(5, 7,   20,  10),
(1, 8,    5,   2);

-- ─────────────────────────────────────────────────────────────
-- ResourceRequest
-- ─────────────────────────────────────────────────────────────
INSERT INTO ResourceRequest (report_id, submitted_by, request_date, status) VALUES
(1, 2, '2024-07-15 10:00:00', 'Fulfilled'),
(2, 2, '2024-07-15 11:00:00', 'Approved'),
(3, 6, '2024-08-22 15:00:00', 'Fulfilled'),
(4, 2, '2024-09-05 23:00:00', 'Fulfilled'),
(5, 6, '2024-10-01 07:00:00', 'Pending'),
(6, 6, '2024-07-16 11:00:00', 'Pending');

-- ─────────────────────────────────────────────────────────────
-- ResourceRequestDetail
-- ─────────────────────────────────────────────────────────────
INSERT INTO ResourceRequestDetail (request_id, resource_type_id, quantity_requested) VALUES
(1, 1,  500),
(1, 2, 1000),
(1, 4,   30),
(2, 5,  200),
(3, 3,   50),
(3, 6,  100),
(4, 3,   20),
(5, 1,  200),
(5, 2,  400),
(6, 4,   50);

-- ─────────────────────────────────────────────────────────────
-- ResourceDispatch
-- ─────────────────────────────────────────────────────────────
INSERT INTO ResourceDispatch (request_id, warehouse_id, assignment_id, approved_by, dispatch_date, status) VALUES
(1, 1, 1, 1, '2024-07-15 12:00:00', 'Delivered'),
(2, 1, 6, 1, '2024-07-15 13:00:00', 'Dispatched'),
(3, 4, 3, 1, '2024-08-22 16:00:00', 'Delivered'),
(4, 2, 4, 1, '2024-09-05 23:30:00', 'Delivered');

-- ─────────────────────────────────────────────────────────────
-- DispatchDetail
-- ─────────────────────────────────────────────────────────────
INSERT INTO DispatchDetail (dispatch_id, resource_type_id, request_detail_id, quantity_dispatched) VALUES
(1, 1, 1,  500),
(1, 2, 2, 1000),
(1, 4, 3,   30),
(2, 5, 4,  200),
(3, 3, 5,   50),
(3, 6, 6,  100),
(4, 3, 7,   20);

-- ─────────────────────────────────────────────────────────────
-- Hospital
-- ─────────────────────────────────────────────────────────────
INSERT INTO Hospital (hospital_name, location_id, contact_no, total_beds, available_beds, critical_capacity) VALUES
('Karachi Civil Hospital',     1, '021-99215740', 500, 120, 30),
('Jinnah Hospital Lahore',     2, '042-99231111', 600, 200, 50),
('PIMS Islamabad',             3, '051-9261170',  400, 150, 40),
('Quetta Civil Hospital',      5, '081-9201211',  250,  50, 15),
('Hayatabad Medical Complex',  4, '091-9217991',  350, 100, 25);

-- ─────────────────────────────────────────────────────────────
-- HospitalEvent
-- ─────────────────────────────────────────────────────────────
INSERT INTO HospitalEvent (hospital_id, disaster_event_id) VALUES
(1, 1), (5, 4), (4, 2), (2, 3), (3, 1);

-- ─────────────────────────────────────────────────────────────
-- Patient
-- ─────────────────────────────────────────────────────────────
INSERT INTO Patient (report_id, full_name, age, gender, condition_status) VALUES
(1,    'Mohammed Iqbal',    45, 'Male',    'Stable'),
(1,    'Amina Bibi',        32, 'Female',  'Critical'),
(3,    'Abdul Rehman',      60, 'Male',    'Stable'),
(3,    'Sana Shah',         25, 'Female',  'Recovered'),
(7,    'Tariq Hussain',     38, 'Male',    'Critical'),
(7,    'Rukhsana Begum',    55, 'Female',  'Deceased'),
(4,    'Faisal Mirza',      29, 'Male',    'Stable'),
(NULL, 'Unknown Patient 1', NULL,'Unknown','Stable');

-- ─────────────────────────────────────────────────────────────
-- Admission
-- ─────────────────────────────────────────────────────────────
INSERT INTO Admission (patient_id, hospital_id, admit_time, discharge_time, status) VALUES
(1, 1, '2024-07-15 10:30:00', NULL,                  'Admitted'),
(2, 1, '2024-07-15 10:45:00', NULL,                  'Admitted'),
(3, 4, '2024-08-22 15:00:00', '2024-08-30 09:00:00', 'Discharged'),
(4, 4, '2024-08-22 15:30:00', '2024-09-01 11:00:00', 'Discharged'),
(5, 4, '2024-08-22 17:00:00', NULL,                  'Admitted'),
(6, 4, '2024-08-22 17:30:00', '2024-08-23 00:30:00', 'Deceased'),
(7, 2, '2024-09-05 23:00:00', '2024-09-07 12:00:00', 'Discharged'),
(8, 3, '2024-10-01 09:00:00', NULL,                  'Admitted');

-- ─────────────────────────────────────────────────────────────
-- Donor
-- ─────────────────────────────────────────────────────────────
INSERT INTO Donor (donor_name, donor_type, phone, email) VALUES
('Habib Bank Limited',     'Corporate',   '021-111-111-425', 'csr@hbl.com'),
('Edhi Foundation',        'NGO',         '021-32413232',    'info@edhi.org'),
('Ahmed Raza',             'Individual',  '03001112233',     'ahmed.raza@gmail.com'),
('NDMA Pakistan',          'Government',  '051-9205210',     'ndma@gov.pk'),
('Fatima Welfare Trust',   'NGO',         '042-35761234',    'info@fatimawelfare.org'),
('Zainab Malik',           'Individual',  '03119876543',     'zainab.malik@yahoo.com');

-- ─────────────────────────────────────────────────────────────
-- Donation
-- ─────────────────────────────────────────────────────────────
INSERT INTO Donation (donor_id, disaster_event_id, amount, donation_date, payment_method) VALUES
(1, 1,  5000000.00, '2024-07-16 10:00:00', 'Bank Transfer'),
(2, 1,  2000000.00, '2024-07-17 11:00:00', 'Cash'),
(3, 2,    50000.00, '2024-08-23 09:00:00', 'Online'),
(4, 1, 10000000.00, '2024-07-18 14:00:00', 'Bank Transfer'),
(4, 2,  8000000.00, '2024-08-25 14:00:00', 'Bank Transfer'),
(5, NULL,1000000.00,'2024-09-01 10:00:00', 'Cheque'),
(6, 4,    75000.00, '2024-10-02 12:00:00', 'Online'),
(1, 3,   500000.00, '2024-09-06 09:00:00', 'Bank Transfer');

-- ─────────────────────────────────────────────────────────────
-- ExpenseCategory
-- ─────────────────────────────────────────────────────────────
INSERT INTO ExpenseCategory (category_name) VALUES
('Procurement'), ('Logistics'), ('Medical Supplies'),
('Food & Water'), ('Shelter'), ('Personnel'), ('Equipment Maintenance');

-- ─────────────────────────────────────────────────────────────
-- Expense
-- ─────────────────────────────────────────────────────────────
INSERT INTO Expense (category_id, disaster_event_id, approved_by, amount, expense_date, description) VALUES
(4, 1, 5, 1200000.00, '2024-07-16 14:00:00', 'Food packs procurement for Karachi flood'),
(2, 1, 5,  300000.00, '2024-07-17 09:00:00', 'Truck transportation to relief camps'),
(3, 2, 5,  800000.00, '2024-08-23 10:00:00', 'Medical supplies for earthquake victims'),
(5, 2, 5,  600000.00, '2024-08-24 11:00:00', 'Emergency tents for displaced families'),
(6, 1, 5,  450000.00, '2024-07-20 08:00:00', 'Field officer allowances and overtime'),
(1, 3, 5,  150000.00, '2024-09-06 13:00:00', 'Fire suppression equipment'),
(4, 4, 5,  250000.00, '2024-10-02 10:00:00', 'Water and food for Peshawar flood response'),
(7, NULL,5,  80000.00, '2024-10-05 09:00:00', 'Generator maintenance — general overhead');

-- ─────────────────────────────────────────────────────────────
-- ApprovalRequest
-- ─────────────────────────────────────────────────────────────
INSERT INTO ApprovalRequest
    (submitted_by, approved_by, request_type, reference_id, status, remarks, submitted_at, decision_at)
VALUES
(2, 1, 'Resource Dispatch',  1, 'Approved', 'Urgent — flood victims',              '2024-07-15 10:30:00', '2024-07-15 11:00:00'),
(6, 1, 'Resource Dispatch',  3, 'Approved', 'Approved for earthquake response',    '2024-08-22 15:30:00', '2024-08-22 16:00:00'),
(2, 1, 'Rescue Deployment',  3, 'Approved', 'Deploy Charlie team to Quetta',       '2024-08-22 14:15:00', '2024-08-22 14:30:00'),
(5, 1, 'Expense',            3, 'Approved', 'Medical supplies authorized',         '2024-08-23 09:30:00', '2024-08-23 10:00:00'),
(6, NULL,'Resource Dispatch',5, 'Pending',  NULL,                                  '2024-10-01 07:30:00', NULL),
(2, NULL,'Rescue Deployment',5, 'Pending',  NULL,                                  '2024-10-01 06:30:00', NULL);

-- ─────────────────────────────────────────────────────────────
-- AuditLog
-- ─────────────────────────────────────────────────────────────
INSERT INTO AuditLog (user_id, action_type, table_name, record_id, old_value, new_value, action_time) VALUES
(1, 'LOGIN',  'User',            1, NULL,                        NULL,                       '2024-07-15 08:00:00'),
(2, 'INSERT', 'EmergencyReport', 1, NULL,                        '{"status":"Pending"}',     '2024-07-15 08:30:00'),
(2, 'UPDATE', 'EmergencyReport', 1, '{"status":"Pending"}',      '{"status":"Assigned"}',    '2024-07-15 09:00:00'),
(1, 'APPROVE','ApprovalRequest', 1, '{"status":"Pending"}',      '{"status":"Approved"}',    '2024-07-15 11:00:00'),
(4, 'UPDATE', 'Inventory',       1, '{"quantity_available":5500}','{"quantity_available":5000}','2024-07-15 12:00:00'),
(5, 'INSERT', 'Expense',         1, NULL,                        '{"amount":1200000}',       '2024-07-16 14:00:00'),
(2, 'LOGIN',  'User',            2, NULL,                        NULL,                       '2024-07-15 08:25:00'),
(6, 'INSERT', 'EmergencyReport', 3, NULL,                        '{"status":"Pending"}',     '2024-08-22 14:00:00');



-- ============================================================
-- PART 3 — QUERIES
-- ============================================================

-- ════════════════════════════════════════════════════════════
-- SECTION A — EMERGENCY REPORTING
-- ════════════════════════════════════════════════════════════

-- Q-A1: Real-time status board — ALL reports with reporter, location, priority
SELECT
    er.report_id,
    dt.type_name                                               AS disaster_type,
    l.city,
    l.area,
    er.severity_level,
    er.status,
    er.report_time,
    COALESCE(u.full_name, er.citizen_name, 'Anonymous')        AS reported_by,
    de.event_name                                              AS disaster_event
FROM EmergencyReport er
JOIN DisasterType  dt ON er.disaster_type_id  = dt.disaster_type_id
JOIN Location       l ON er.location_id       = l.location_id
JOIN DisasterEvent de ON er.disaster_event_id = de.disaster_event_id
LEFT JOIN [User]    u ON er.reported_by       = u.user_id
ORDER BY
    CASE er.severity_level
        WHEN 'Critical' THEN 1
        WHEN 'High'     THEN 2
        WHEN 'Medium'   THEN 3
        WHEN 'Low'      THEN 4
    END,
    er.report_time DESC;


-- Q-A2: Prioritised PENDING reports (operator action queue)
SELECT
    er.report_id,
    dt.type_name,
    l.city, l.area,
    er.severity_level,
    er.report_time,
    COALESCE(u.full_name, er.citizen_name, 'Anonymous') AS reporter,
    er.description
FROM EmergencyReport er
JOIN DisasterType dt ON er.disaster_type_id = dt.disaster_type_id
JOIN Location      l ON er.location_id      = l.location_id
LEFT JOIN [User]   u ON er.reported_by      = u.user_id
WHERE er.status = 'Pending'
ORDER BY
    CASE er.severity_level
        WHEN 'Critical' THEN 1
        WHEN 'High'     THEN 2
        WHEN 'Medium'   THEN 3
        WHEN 'Low'      THEN 4
    END,
    er.report_time ASC;

-- Q-A3: Filter reports by disaster type
SELECT
    er.report_id, l.city, l.area,
    er.severity_level, er.status, er.report_time
FROM EmergencyReport er
JOIN DisasterType dt ON er.disaster_type_id = dt.disaster_type_id
JOIN Location      l ON er.location_id      = l.location_id
WHERE dt.type_name = 'Flood'
ORDER BY er.report_time DESC;

-- Q-A4: Filter reports by severity level
SELECT
    er.report_id, dt.type_name,
    l.city, er.status, er.report_time, er.description
FROM EmergencyReport er
JOIN DisasterType dt ON er.disaster_type_id = dt.disaster_type_id
JOIN Location      l ON er.location_id      = l.location_id
WHERE er.severity_level = 'Critical'
ORDER BY er.report_time DESC;

-- Q-A5: All reports under a specific disaster event
SELECT
    er.report_id, dt.type_name,
    l.city, l.area,
    er.severity_level, er.status, er.report_time
FROM EmergencyReport er
JOIN DisasterType dt ON er.disaster_type_id = dt.disaster_type_id
JOIN Location      l ON er.location_id      = l.location_id
WHERE er.disaster_event_id = 1
ORDER BY er.report_time;

-- Q-A6: Reports not yet assigned to any rescue team
SELECT
    er.report_id, dt.type_name, l.city,
    er.severity_level, er.report_time
FROM EmergencyReport er
JOIN DisasterType dt ON er.disaster_type_id = dt.disaster_type_id
JOIN Location      l ON er.location_id      = l.location_id
WHERE er.status = 'Pending'
  AND er.report_id NOT IN (SELECT DISTINCT report_id FROM RescueAssignment)
ORDER BY
    CASE er.severity_level
        WHEN 'Critical' THEN 1
        WHEN 'High'     THEN 2
        WHEN 'Medium'   THEN 3
        WHEN 'Low'      THEN 4
    END;

-- ════════════════════════════════════════════════════════════
-- SECTION B — RESCUE TEAM MANAGEMENT
-- ════════════════════════════════════════════════════════════

-- Q-B1: All available rescue teams
SELECT
    rt.team_id, rt.team_name, rt.team_type,
    l.city, l.area,
    rt.current_status
FROM RescueTeam rt
JOIN Location l ON rt.location_id = l.location_id
WHERE rt.current_status = 'Available'
ORDER BY rt.team_type;

-- Q-B2: Available teams in a given city
SELECT
    rt.team_id, rt.team_name, rt.team_type, rt.current_status
FROM RescueTeam rt
JOIN Location l ON rt.location_id = l.location_id
WHERE rt.current_status = 'Available'
  AND l.city = 'Karachi'
ORDER BY rt.team_type;

-- Q-B3: Historical assignments for a specific team
SELECT
    ra.assignment_id,
    er.report_id,
    dt.type_name            AS disaster_type,
    l.city,
    er.severity_level,
    ra.assigned_time,
    ra.completion_time,
    ra.assignment_status,
    DATEDIFF(MINUTE, ra.assigned_time,
        COALESCE(ra.completion_time, GETDATE()))  AS duration_minutes
FROM RescueAssignment ra
JOIN EmergencyReport er ON ra.report_id         = er.report_id
JOIN DisasterType    dt ON er.disaster_type_id  = dt.disaster_type_id
JOIN Location         l ON er.location_id       = l.location_id
WHERE ra.team_id = 1
ORDER BY ra.assigned_time DESC;

-- Q-B4: Teams currently active (En Route or On Scene)
SELECT
    rt.team_name, rt.team_type,
    lb.city                  AS team_base_city,
    er.report_id,
    er.severity_level,
    li.city                  AS incident_city,
    ra.assignment_status,
    ra.assigned_time
FROM RescueAssignment ra
JOIN RescueTeam       rt ON ra.team_id    = rt.team_id
JOIN Location         lb ON rt.location_id= lb.location_id
JOIN EmergencyReport  er ON ra.report_id  = er.report_id
JOIN Location         li ON er.location_id= li.location_id
WHERE ra.assignment_status IN ('En Route','On Scene')
ORDER BY ra.assigned_time;

-- Q-B5: Team performance — assignment count + average completion time
SELECT
    rt.team_name,
    rt.team_type,
    COUNT(ra.assignment_id)                                                      AS total_assignments,
    SUM(CASE WHEN ra.assignment_status = 'Completed' THEN 1 ELSE 0 END)         AS completed,
    ROUND(AVG(CAST(DATEDIFF(MINUTE, ra.assigned_time, ra.completion_time) AS FLOAT)), 1) AS avg_completion_mins
FROM RescueTeam rt
LEFT JOIN RescueAssignment ra ON rt.team_id = ra.team_id
GROUP BY rt.team_id, rt.team_name, rt.team_type
ORDER BY total_assignments DESC;

-- Q-B6: Full member roster for a team
SELECT
    tm.member_id, tm.full_name, tm.designation, tm.phone,
    u.email AS system_account
FROM TeamMember tm
LEFT JOIN [User] u ON tm.user_id = u.user_id
WHERE tm.team_id = 1;

-- ════════════════════════════════════════════════════════════
-- SECTION C — RESOURCE MANAGEMENT
-- ════════════════════════════════════════════════════════════

-- Q-C1: Warehouse-wise inventory levels
SELECT
    w.warehouse_name,
    l.city,
    rt.resource_name,
    rt.unit,
    inv.quantity_available,
    inv.reorder_level,
    CASE
        WHEN inv.quantity_available = 0                        THEN 'OUT OF STOCK'
        WHEN inv.quantity_available < inv.reorder_level        THEN 'LOW STOCK'
        ELSE 'OK'
    END                                                        AS stock_status,
    inv.last_updated
FROM Inventory inv
JOIN Warehouse    w ON inv.warehouse_id      = w.warehouse_id
JOIN Location     l ON w.location_id         = l.location_id
JOIN ResourceType rt ON inv.resource_type_id = rt.resource_type_id
ORDER BY w.warehouse_name, rt.resource_name;

-- Q-C2: Low-stock alert
SELECT
    w.warehouse_name,
    l.city,
    rt.resource_name,
    inv.quantity_available,
    inv.reorder_level,
    (inv.reorder_level - inv.quantity_available) AS shortage_quantity
FROM Inventory inv
JOIN Warehouse    w  ON inv.warehouse_id     = w.warehouse_id
JOIN Location     l  ON w.location_id        = l.location_id
JOIN ResourceType rt ON inv.resource_type_id = rt.resource_type_id
WHERE inv.quantity_available < inv.reorder_level
ORDER BY shortage_quantity DESC;

-- Q-C3: Dispatched vs requested quantities — variance report
SELECT
    rrd.request_detail_id,
    rr.request_id,
    rt.resource_name,
    rrd.quantity_requested,
    COALESCE(SUM(dd.quantity_dispatched), 0)                                    AS quantity_dispatched,
    (rrd.quantity_requested - COALESCE(SUM(dd.quantity_dispatched), 0))         AS variance
FROM ResourceRequestDetail rrd
JOIN ResourceRequest rr ON rrd.request_id        = rr.request_id
JOIN ResourceType   rt  ON rrd.resource_type_id  = rt.resource_type_id
LEFT JOIN DispatchDetail dd ON rrd.request_detail_id = dd.request_detail_id
GROUP BY rrd.request_detail_id, rr.request_id, rt.resource_name, rrd.quantity_requested
ORDER BY rr.request_id, rt.resource_name;

-- Q-C4: Total resources dispatched per disaster event
SELECT
    de.event_name,
    rt.resource_name,
    rt.unit,
    SUM(dd.quantity_dispatched) AS total_dispatched
FROM DispatchDetail dd
JOIN ResourceDispatch  rd ON dd.dispatch_id       = rd.dispatch_id
JOIN RescueAssignment  ra ON rd.assignment_id     = ra.assignment_id
JOIN EmergencyReport   er ON ra.report_id         = er.report_id
JOIN DisasterEvent     de ON er.disaster_event_id = de.disaster_event_id
JOIN ResourceType      rt ON dd.resource_type_id  = rt.resource_type_id
GROUP BY de.event_name, rt.resource_name, rt.unit
ORDER BY de.event_name, total_dispatched DESC;

-- Q-C5: All resource requests with line-item summary
-- GROUP_CONCAT(...) → STRING_AGG(...)
SELECT
    rr.request_id,
    l.city                                                              AS incident_city,
    u.full_name                                                         AS submitted_by,
    rr.request_date,
    rr.status,
    STRING_AGG(rt.resource_name + ' x' + CAST(rrd.quantity_requested AS NVARCHAR(20)), ' | ')
        WITHIN GROUP (ORDER BY rt.resource_name)                        AS items_requested
FROM ResourceRequest rr
LEFT JOIN EmergencyReport       er  ON rr.report_id      = er.report_id
LEFT JOIN Location               l  ON er.location_id    = l.location_id
JOIN [User]                      u  ON rr.submitted_by   = u.user_id
JOIN ResourceRequestDetail      rrd ON rr.request_id     = rrd.request_id
JOIN ResourceType                rt ON rrd.resource_type_id = rt.resource_type_id
GROUP BY rr.request_id, l.city, u.full_name, rr.request_date, rr.status
ORDER BY rr.request_date DESC;

-- ════════════════════════════════════════════════════════════
-- SECTION D — HOSPITAL COORDINATION
-- ════════════════════════════════════════════════════════════

-- Q-D1: Hospitals sorted by available capacity
SELECT
    h.hospital_id,
    h.hospital_name,
    l.city,
    h.contact_no,
    h.total_beds,
    h.available_beds,
    h.critical_capacity,
    ROUND(CAST(h.available_beds AS FLOAT) * 100.0 / h.total_beds, 1) AS pct_available
FROM Hospital h
JOIN Location l ON h.location_id = l.location_id
WHERE h.available_beds > 0
ORDER BY h.available_beds DESC;

-- Q-D2: Best hospital for a CRITICAL patient
SELECT TOP 1
    h.hospital_id,
    h.hospital_name,
    l.city,
    h.available_beds,
    h.critical_capacity,
    h.contact_no
FROM Hospital h
JOIN Location l ON h.location_id = l.location_id
WHERE h.critical_capacity > 0
  AND h.available_beds    > 0
ORDER BY h.critical_capacity DESC;

-- Q-D3: Hospital load balancing — admissions per hospital per event
SELECT
    h.hospital_name,
    l.city,
    de.event_name,
    COUNT(a.admission_id)                                                       AS total_admissions,
    SUM(CASE WHEN a.status = 'Admitted'           THEN 1 ELSE 0 END)            AS currently_admitted,
    SUM(CASE WHEN p.condition_status = 'Critical' THEN 1 ELSE 0 END)            AS critical_cases
FROM Admission a
JOIN Patient       p  ON a.patient_id       = p.patient_id
JOIN Hospital      h  ON a.hospital_id      = h.hospital_id
JOIN Location      l  ON h.location_id      = l.location_id
LEFT JOIN EmergencyReport er ON p.report_id = er.report_id
LEFT JOIN DisasterEvent   de ON er.disaster_event_id = de.disaster_event_id
GROUP BY h.hospital_id, h.hospital_name, l.city, de.event_name
ORDER BY total_admissions DESC;

-- Q-D4: Live patient condition dashboard per hospital
SELECT
    h.hospital_name,
    l.city,
    COUNT(a.admission_id)                                                         AS total_admitted,
    SUM(CASE WHEN p.condition_status = 'Stable'    THEN 1 ELSE 0 END)            AS stable,
    SUM(CASE WHEN p.condition_status = 'Critical'  THEN 1 ELSE 0 END)            AS critical,
    SUM(CASE WHEN p.condition_status = 'Recovered' THEN 1 ELSE 0 END)            AS recovered,
    SUM(CASE WHEN p.condition_status = 'Deceased'  THEN 1 ELSE 0 END)            AS deceased
FROM Admission a
JOIN Patient   p ON a.patient_id  = p.patient_id
JOIN Hospital  h ON a.hospital_id = h.hospital_id
JOIN Location  l ON h.location_id = l.location_id
WHERE a.status = 'Admitted'
GROUP BY h.hospital_id, h.hospital_name, l.city
ORDER BY total_admitted DESC;

-- ════════════════════════════════════════════════════════════
-- SECTION E — FINANCIAL MANAGEMENT
-- ════════════════════════════════════════════════════════════

-- Q-E1: Total donations per disaster event
SELECT
    COALESCE(de.event_name, 'General Fund') AS disaster_event,
    COUNT(don.donation_id) AS donation_count,
    SUM(don.amount) AS total_donated,
    STRING_AGG(don.payment_method, ', ') AS payment_methods_used
FROM Donation don
LEFT JOIN DisasterEvent de
    ON don.disaster_event_id = de.disaster_event_id
GROUP BY don.disaster_event_id, de.event_name
ORDER BY total_donated DESC;

-- Q-E2: Total expenses per disaster event by category
SELECT
    COALESCE(de.event_name, 'General/Operational') AS disaster_event,
    ec.category_name,
    COUNT(e.expense_id)                            AS expense_count,
    SUM(e.amount)                                  AS total_amount
FROM Expense e
JOIN ExpenseCategory ec ON e.category_id        = ec.category_id
LEFT JOIN DisasterEvent de ON e.disaster_event_id = de.disaster_event_id
GROUP BY e.disaster_event_id, de.event_name, e.category_id, ec.category_name
ORDER BY de.event_name, total_amount DESC;

-- Q-E3: Budget balance per event (donations minus expenses)
SELECT
    de.event_name,
    de.status                                                  AS event_status,
    COALESCE(d.total_donated,  0)                              AS total_donated,
    COALESCE(x.total_spent,    0)                              AS total_spent,
    (COALESCE(d.total_donated, 0) - COALESCE(x.total_spent,0)) AS budget_balance
FROM DisasterEvent de
LEFT JOIN (
    SELECT disaster_event_id, SUM(amount) AS total_donated
    FROM Donation GROUP BY disaster_event_id
) d ON de.disaster_event_id = d.disaster_event_id
LEFT JOIN (
    SELECT disaster_event_id, SUM(amount) AS total_spent
    FROM Expense GROUP BY disaster_event_id
) x ON de.disaster_event_id = x.disaster_event_id
ORDER BY budget_balance DESC;

-- Q-E4: Top donors ranked by total contribution
SELECT
    d.donor_name,
    d.donor_type,
    COUNT(don.donation_id)  AS total_transactions,
    SUM(don.amount)         AS total_contributed
FROM Donor    d
JOIN Donation don ON d.donor_id = don.donor_id
GROUP BY d.donor_id, d.donor_name, d.donor_type
ORDER BY total_contributed DESC;

-- Q-E5: Financial audit trail — expenses with approver details
SELECT
    e.expense_id,
    ec.category_name,
    COALESCE(de.event_name, 'General') AS charged_to,
    e.amount,
    e.expense_date,
    u.full_name                        AS approved_by,
    e.description
FROM Expense e
JOIN ExpenseCategory ec ON e.category_id        = ec.category_id
LEFT JOIN DisasterEvent de ON e.disaster_event_id = de.disaster_event_id
LEFT JOIN [User]        u  ON e.approved_by       = u.user_id
ORDER BY e.expense_date DESC;

-- Q-E6: Donation breakdown by payment method
-- SUM(...) OVER () window function — supported in SQL Server
SELECT
    payment_method,
    COUNT(donation_id)                                            AS transaction_count,
    SUM(amount)                                                   AS total_amount,
    ROUND(SUM(amount) * 100.0
          / SUM(SUM(amount)) OVER (), 2)                          AS pct_of_total
FROM Donation
GROUP BY payment_method
ORDER BY total_amount DESC;

-- ════════════════════════════════════════════════════════════
-- SECTION F — MIS REPORTING & ANALYTICS
-- ════════════════════════════════════════════════════════════

-- Q-F1: Incident heatmap — count by city and severity
SELECT
    l.city,
    COUNT(er.report_id)                                               AS total_incidents,
    SUM(CASE WHEN er.severity_level = 'Critical' THEN 1 ELSE 0 END)  AS critical,
    SUM(CASE WHEN er.severity_level = 'High'     THEN 1 ELSE 0 END)  AS high,
    SUM(CASE WHEN er.severity_level = 'Medium'   THEN 1 ELSE 0 END)  AS medium,
    SUM(CASE WHEN er.severity_level = 'Low'      THEN 1 ELSE 0 END)  AS low
FROM EmergencyReport er
JOIN Location l ON er.location_id = l.location_id
GROUP BY l.city
ORDER BY total_incidents DESC;

-- Q-F2: Incident distribution by severity (pie chart data)
SELECT
    severity_level,
    COUNT(*)                                                          AS report_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)               AS pct
FROM EmergencyReport
GROUP BY severity_level
ORDER BY
    CASE severity_level
        WHEN 'Critical' THEN 1
        WHEN 'High'     THEN 2
        WHEN 'Medium'   THEN 3
        WHEN 'Low'      THEN 4
    END;

-- Q-F3: Incident count by disaster type with resolution rate
SELECT
    dt.type_name           AS disaster_type,
    COUNT(er.report_id)    AS total_reports,
    SUM(CASE WHEN er.status IN ('Resolved','Closed') THEN 1 ELSE 0 END) AS resolved,
    SUM(CASE WHEN er.status = 'Pending'              THEN 1 ELSE 0 END) AS pending,
    ROUND(
        CAST(SUM(CASE WHEN er.status IN ('Resolved','Closed') THEN 1 ELSE 0 END) AS FLOAT)
        * 100.0 / COUNT(er.report_id)
    , 1)                                                                AS resolution_pct
FROM EmergencyReport er
JOIN DisasterType dt ON er.disaster_type_id = dt.disaster_type_id
GROUP BY dt.disaster_type_id, dt.type_name
ORDER BY total_reports DESC;

-- Q-F4: Response time analytics
SELECT
    er.report_id,
    dt.type_name          AS disaster_type,
    l.city,
    er.severity_level,
    er.report_time,
    MIN(ra.assigned_time) AS first_assignment_time,
    DATEDIFF(MINUTE, er.report_time, MIN(ra.assigned_time)) AS response_time_minutes
FROM EmergencyReport er
JOIN DisasterType    dt ON er.disaster_type_id = dt.disaster_type_id
JOIN Location         l ON er.location_id      = l.location_id
JOIN RescueAssignment ra ON er.report_id       = ra.report_id
GROUP BY er.report_id, dt.type_name, l.city, er.severity_level, er.report_time
ORDER BY response_time_minutes;

-- Q-F5: Average response time by severity (SLA analysis)
SELECT
    er.severity_level,
    COUNT(DISTINCT er.report_id)                                                          AS report_count,
    ROUND(AVG(CAST(DATEDIFF(MINUTE, er.report_time, ra.assigned_time) AS FLOAT)), 1)     AS avg_response_mins,
    MIN(DATEDIFF(MINUTE, er.report_time, ra.assigned_time))                               AS min_response_mins,
    MAX(DATEDIFF(MINUTE, er.report_time, ra.assigned_time))                               AS max_response_mins
FROM EmergencyReport er
JOIN RescueAssignment ra ON er.report_id = ra.report_id
GROUP BY er.severity_level
ORDER BY
    CASE er.severity_level
        WHEN 'Critical' THEN 1
        WHEN 'High'     THEN 2
        WHEN 'Medium'   THEN 3
        WHEN 'Low'      THEN 4
    END;

-- Q-F6: Resource utilisation report (stock vs dispatched)
SELECT
    rt.resource_name,
    rt.unit,
    SUM(inv.quantity_available)                                           AS current_stock,
    COALESCE(SUM(dd.quantity_dispatched), 0)                              AS total_dispatched,
    ROUND(
        CAST(COALESCE(SUM(dd.quantity_dispatched), 0) AS FLOAT) * 100.0
        / NULLIF(SUM(inv.quantity_available) + COALESCE(SUM(dd.quantity_dispatched), 0), 0)
    , 1)                                                                  AS utilisation_pct
FROM Inventory inv
JOIN ResourceType rt ON inv.resource_type_id = rt.resource_type_id
LEFT JOIN DispatchDetail dd ON rt.resource_type_id = dd.resource_type_id
GROUP BY rt.resource_type_id, rt.resource_name, rt.unit
ORDER BY utilisation_pct DESC;

-- Q-F7: Approval workflow summary
SELECT
    request_type,
    COUNT(*)                                                               AS total_requests,
    SUM(CASE WHEN status = 'Pending'  THEN 1 ELSE 0 END)                  AS pending,
    SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END)                  AS approved,
    SUM(CASE WHEN status = 'Rejected' THEN 1 ELSE 0 END)                  AS rejected,
    ROUND(AVG(
        CASE WHEN decision_at IS NOT NULL
             THEN CAST(DATEDIFF(MINUTE, submitted_at, decision_at) AS FLOAT)
        END
    ), 1)                                                                  AS avg_decision_mins
FROM ApprovalRequest
GROUP BY request_type
ORDER BY total_requests DESC;

-- Q-F8: Pending approvals with wait time
SELECT
    ar.approval_id,
    ar.request_type,
    ar.reference_id,
    u.full_name                                              AS submitted_by,
    ar.submitted_at,
    DATEDIFF(HOUR, ar.submitted_at, GETDATE())               AS hours_waiting
FROM ApprovalRequest ar
JOIN [User] u ON ar.submitted_by = u.user_id
WHERE ar.status = 'Pending'
ORDER BY ar.submitted_at ASC;

-- Q-F9: User activity summary from audit log
SELECT
    u.full_name,
    u.email,
    r.role_name,
    COUNT(al.log_id)                                                           AS total_actions,
    MAX(al.action_time)                                                        AS last_action,
    SUM(CASE WHEN al.action_type = 'LOGIN'   THEN 1 ELSE 0 END)               AS logins,
    SUM(CASE WHEN al.action_type = 'INSERT'  THEN 1 ELSE 0 END)               AS inserts,
    SUM(CASE WHEN al.action_type = 'UPDATE'  THEN 1 ELSE 0 END)               AS updates,
    SUM(CASE WHEN al.action_type = 'APPROVE' THEN 1 ELSE 0 END)               AS approvals
FROM [User] u
JOIN UserRole ur ON u.user_id  = ur.user_id
JOIN Role      r ON ur.role_id = r.role_id
LEFT JOIN AuditLog al ON u.user_id = al.user_id
GROUP BY u.user_id, u.full_name, u.email, r.role_name
ORDER BY total_actions DESC;

-- Q-F10: Comprehensive disaster event dashboard (executive summary)
SELECT
    de.event_name,
    dt.type_name          AS disaster_type,
    de.start_date,
    de.end_date,
    de.status,
    COUNT(DISTINCT er.report_id)                                          AS total_reports,
    SUM(CASE WHEN er.severity_level = 'Critical' THEN 1 ELSE 0 END)      AS critical_reports,
    COUNT(DISTINCT ra.assignment_id)                                      AS rescue_deployments,
    COUNT(DISTINCT p.patient_id)                                          AS patients,
    COUNT(DISTINCT a.admission_id)                                        AS hospital_admissions,
    COALESCE((
        SELECT SUM(don2.amount)
        FROM Donation don2
        WHERE don2.disaster_event_id = de.disaster_event_id
    ), 0)                                                                 AS total_donations,
    COALESCE((
        SELECT SUM(ex2.amount)
        FROM Expense ex2
        WHERE ex2.disaster_event_id = de.disaster_event_id
    ), 0)                                                                 AS total_expenses
FROM DisasterEvent de
JOIN DisasterType      dt  ON de.disaster_event_id  = dt.disaster_type_id
LEFT JOIN EmergencyReport er ON de.disaster_event_id = er.disaster_event_id
LEFT JOIN RescueAssignment ra ON er.report_id        = ra.report_id
LEFT JOIN Patient          p  ON er.report_id        = p.report_id
LEFT JOIN Admission         a  ON p.patient_id        = a.patient_id
GROUP BY de.disaster_event_id, de.event_name, dt.type_name,
         de.start_date, de.end_date, de.status
ORDER BY de.start_date DESC;

-- ============================================================
-- END OF FILE
-- ============================================================

-- PART 5

-- ============================================================
-- PART 5: TRANSACTION HANDLING DEMONSTRATION
-- Smart Disaster Response MIS (SQL Server)
-- ============================================================

USE SmartDisasterMIS;
GO

-- ------------------------------------------------------------
-- T5-A: Approve request + create dispatch + deduct inventory
-- ACID + rollback-safe + race-condition protected
-- ------------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_ApproveAndDispatchResourceRequest
    @request_id     INT,
    @warehouse_id   INT,
    @assignment_id  INT = NULL,
    @approved_by    INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; -- auto rollback on runtime error

    BEGIN TRY
        BEGIN TRAN;

        -- Lock request row for update to avoid concurrent approval conflicts
        DECLARE @request_status NVARCHAR(20);
        SELECT @request_status = status
        FROM ResourceRequest WITH (UPDLOCK, HOLDLOCK)
        WHERE request_id = @request_id;

        IF @request_status IS NULL
            THROW 51001, 'Resource request not found.', 1;

        IF @request_status NOT IN ('Pending','Approved')
            THROW 51002, 'Only Pending/Approved requests can be dispatched.', 1;

        -- Validate inventory sufficiency (locked rows to prevent race condition)
        IF EXISTS (
            SELECT 1
            FROM ResourceRequestDetail rrd
            JOIN Inventory inv WITH (UPDLOCK, HOLDLOCK)
                 ON inv.resource_type_id = rrd.resource_type_id
                AND inv.warehouse_id = @warehouse_id
            WHERE rrd.request_id = @request_id
              AND inv.quantity_available < rrd.quantity_requested
        )
        BEGIN
            THROW 51003, 'Insufficient inventory for one or more requested resources.', 1;
        END

        -- Create dispatch
        INSERT INTO ResourceDispatch
            (request_id, warehouse_id, assignment_id, approved_by, dispatch_date, status)
        VALUES
            (@request_id, @warehouse_id, @assignment_id, @approved_by, SYSDATETIME(), 'Dispatched');

        DECLARE @dispatch_id INT = SCOPE_IDENTITY();

        -- Insert dispatch details from request details
        INSERT INTO DispatchDetail (dispatch_id, resource_type_id, request_detail_id, quantity_dispatched)
        SELECT
            @dispatch_id,
            rrd.resource_type_id,
            rrd.request_detail_id,
            rrd.quantity_requested
        FROM ResourceRequestDetail rrd
        WHERE rrd.request_id = @request_id;

        -- Deduct inventory
        UPDATE inv
        SET inv.quantity_available = inv.quantity_available - rrd.quantity_requested,
            inv.last_updated = SYSDATETIME()
        FROM Inventory inv
        JOIN ResourceRequestDetail rrd
          ON inv.resource_type_id = rrd.resource_type_id
        WHERE inv.warehouse_id = @warehouse_id
          AND rrd.request_id = @request_id;

        -- Update request status
        UPDATE ResourceRequest
        SET status = 'Fulfilled'
        WHERE request_id = @request_id;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;

        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrNo  INT = ERROR_NUMBER();
        DECLARE @ErrState INT = ERROR_STATE();

        THROW @ErrNo, @ErrMsg, @ErrState;
    END CATCH
END;
GO



-- DEMO

--EXEC sp_AssignRescueTeam @report_id = 5, @team_id = 2, @assigned_by = 2;

-- Check results
SELECT * FROM RescueAssignment WHERE report_id = 5 ORDER BY assignment_id DESC;
SELECT team_id, team_name, current_status FROM RescueTeam WHERE team_id = 2;
SELECT report_id, status FROM EmergencyReport WHERE report_id = 5;

-- Failure/rollback case example:
-- Try assigning same team again while it is no longer available
BEGIN TRY
    EXEC sp_AssignRescueTeam @report_id = 8, @team_id = 2, @assigned_by = 2;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS expected_error_message;
END CATCH;

-- Verify no partial insert happened for failed attempt
SELECT * FROM RescueAssignment WHERE report_id = 8 AND team_id = 2;






-- PART 6
USE SmartDisasterMIS;
GO

-- ============================================================
-- PART 6: TRIGGERS
-- ============================================================

-- ------------------------------------------------------------
-- TR-1: Prevent negative inventory on INSERT/UPDATE
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_Inventory_PreventNegative
ON Inventory
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE quantity_available < 0 OR reorder_level < 0
    )
    BEGIN
        RAISERROR('Inventory or reorder level cannot be negative.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- ------------------------------------------------------------
-- TR-2: Auto-update RescueTeam current_status from assignment updates
-- Logic:
--   Pending/En Route/On Scene -> Assigned
--   Completed/Cancelled -> Available (if no other active assignment)
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_RescueAssignment_UpdateTeamStatus
ON RescueAssignment
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Set assigned for active assignments
    UPDATE rt
    SET rt.current_status = 'Assigned'
    FROM RescueTeam rt
    JOIN inserted i ON rt.team_id = i.team_id
    WHERE i.assignment_status IN ('Pending','En Route','On Scene');

    -- For completed/cancelled assignments, set available only if no active assignment exists
    UPDATE rt
    SET rt.current_status = 'Available'
    FROM RescueTeam rt
    JOIN inserted i ON rt.team_id = i.team_id
    WHERE i.assignment_status IN ('Completed','Cancelled')
      AND NOT EXISTS (
            SELECT 1
            FROM RescueAssignment ra
            WHERE ra.team_id = rt.team_id
              AND ra.assignment_status IN ('Pending','En Route','On Scene')
      );
END;
GO

-- ------------------------------------------------------------
-- TR-3: Auto-update EmergencyReport status on rescue assignment changes
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_RescueAssignment_UpdateReportStatus
ON RescueAssignment
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- If any active assignment exists, mark report Assigned
    UPDATE er
    SET er.status = 'Assigned'
    FROM EmergencyReport er
    JOIN (
        SELECT DISTINCT report_id
        FROM inserted
    ) x ON er.report_id = x.report_id
    WHERE EXISTS (
        SELECT 1
        FROM RescueAssignment ra
        WHERE ra.report_id = er.report_id
          AND ra.assignment_status IN ('Pending','En Route','On Scene')
    );

    -- If all assignments for a report are completed/cancelled, mark report Resolved
    UPDATE er
    SET er.status = 'Resolved'
    FROM EmergencyReport er
    JOIN (
        SELECT DISTINCT report_id
        FROM inserted
    ) x ON er.report_id = x.report_id
    WHERE NOT EXISTS (
        SELECT 1
        FROM RescueAssignment ra
        WHERE ra.report_id = er.report_id
          AND ra.assignment_status IN ('Pending','En Route','On Scene')
    )
      AND EXISTS (
        SELECT 1
        FROM RescueAssignment ra
        WHERE ra.report_id = er.report_id
      );
END;
GO

-- ------------------------------------------------------------
-- TR-4: Audit Expense INSERT/UPDATE/DELETE automatically
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_Expense_Audit
ON Expense
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- INSERT
    INSERT INTO AuditLog (user_id, action_type, table_name, record_id, old_value, new_value, action_time)
    SELECT
        COALESCE(i.approved_by, 1), -- fallback admin user
        'INSERT',
        'Expense',
        i.expense_id,
        NULL,
        CONCAT('{"amount":', CAST(i.amount AS NVARCHAR(40)),
               ',"category_id":', CAST(i.category_id AS NVARCHAR(20)), '}'),
        SYSDATETIME()
    FROM inserted i
    LEFT JOIN deleted d ON i.expense_id = d.expense_id
    WHERE d.expense_id IS NULL;

    -- UPDATE
    INSERT INTO AuditLog (user_id, action_type, table_name, record_id, old_value, new_value, action_time)
    SELECT
        COALESCE(i.approved_by, 1),
        'UPDATE',
        'Expense',
        i.expense_id,
        CONCAT('{"old_amount":', CAST(d.amount AS NVARCHAR(40)),
               ',"old_category_id":', CAST(d.category_id AS NVARCHAR(20)), '}'),
        CONCAT('{"new_amount":', CAST(i.amount AS NVARCHAR(40)),
               ',"new_category_id":', CAST(i.category_id AS NVARCHAR(20)), '}'),
        SYSDATETIME()
    FROM inserted i
    JOIN deleted  d ON i.expense_id = d.expense_id;

    -- DELETE
    INSERT INTO AuditLog (user_id, action_type, table_name, record_id, old_value, new_value, action_time)
    SELECT
        COALESCE(d.approved_by, 1),
        'DELETE',
        'Expense',
        d.expense_id,
        CONCAT('{"amount":', CAST(d.amount AS NVARCHAR(40)),
               ',"category_id":', CAST(d.category_id AS NVARCHAR(20)), '}'),
        NULL,
        SYSDATETIME()
    FROM deleted d
    LEFT JOIN inserted i ON i.expense_id = d.expense_id
    WHERE i.expense_id IS NULL;
END;
GO






-- PART 7


USE SmartDisasterMIS;
GO

-- ============================================================
-- PART 7: VIEWS + PERFORMANCE COMPARISON
-- ============================================================

-- ------------------------------------------------------------
-- V1: Emergency Operator queue view
-- ------------------------------------------------------------
CREATE OR ALTER VIEW vw_Operator_PendingReports
AS
SELECT
    er.report_id,
    dt.type_name AS disaster_type,
    l.city,
    l.area,
    er.severity_level,
    er.report_time,
    er.status,
    COALESCE(u.full_name, er.citizen_name, 'Anonymous') AS reporter
FROM EmergencyReport er
JOIN DisasterType dt ON er.disaster_type_id = dt.disaster_type_id
JOIN Location l      ON er.location_id = l.location_id
LEFT JOIN [User] u   ON er.reported_by = u.user_id
WHERE er.status = 'Pending';
GO

-- ------------------------------------------------------------
-- V2: Warehouse low-stock monitoring view
-- ------------------------------------------------------------
CREATE OR ALTER VIEW vw_Warehouse_LowStock
AS
SELECT
    w.warehouse_id,
    w.warehouse_name,
    l.city,
    rt.resource_type_id,
    rt.resource_name,
    inv.quantity_available,
    inv.reorder_level,
    (inv.reorder_level - inv.quantity_available) AS shortage
FROM Inventory inv
JOIN Warehouse w    ON inv.warehouse_id = w.warehouse_id
JOIN Location l     ON w.location_id = l.location_id
JOIN ResourceType rt ON inv.resource_type_id = rt.resource_type_id
WHERE inv.quantity_available < inv.reorder_level;
GO

-- ------------------------------------------------------------
-- V3: Finance summary view (hides donor contact info)
-- ------------------------------------------------------------
CREATE OR ALTER VIEW vw_Finance_EventBudgetSummary
AS
SELECT
    de.disaster_event_id,
    de.event_name,
    de.status AS event_status,
    COALESCE(d.total_donation, 0) AS total_donation,
    COALESCE(e.total_expense, 0)  AS total_expense,
    COALESCE(d.total_donation, 0) - COALESCE(e.total_expense, 0) AS budget_balance
FROM DisasterEvent de
LEFT JOIN (
    SELECT disaster_event_id, SUM(amount) AS total_donation
    FROM Donation
    GROUP BY disaster_event_id
) d ON de.disaster_event_id = d.disaster_event_id
LEFT JOIN (
    SELECT disaster_event_id, SUM(amount) AS total_expense
    FROM Expense
    GROUP BY disaster_event_id
) e ON de.disaster_event_id = e.disaster_event_id;
GO

-- ------------------------------------------------------------
-- V4: Approval workflow pending queue view
-- ------------------------------------------------------------
CREATE OR ALTER VIEW vw_Approval_Pending
AS
SELECT
    ar.approval_id,
    ar.request_type,
    ar.reference_id,
    submitter.full_name AS submitted_by,
    ar.submitted_at,
    DATEDIFF(MINUTE, ar.submitted_at, SYSDATETIME()) AS minutes_waiting
FROM ApprovalRequest ar
JOIN [User] submitter ON ar.submitted_by = submitter.user_id
WHERE ar.status = 'Pending';
GO

-- ------------------------------------------------------------
-- Optional role-based permission grants on views
-- (Run only after creating DB roles/users in your environment)
-- ------------------------------------------------------------
-- GRANT SELECT ON vw_Operator_PendingReports   TO [EmergencyOperatorRole];
-- GRANT SELECT ON vw_Warehouse_LowStock        TO [WarehouseManagerRole];
-- GRANT SELECT ON vw_Finance_EventBudgetSummary TO [FinanceOfficerRole];
-- GRANT SELECT ON vw_Approval_Pending          TO [AdministratorRole];
GO





-- PART 7 TEST
USE SmartDisasterMIS;
GO
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

-- Test A: Direct table query
SELECT
    er.report_id, dt.type_name, l.city, er.severity_level, er.report_time
FROM EmergencyReport er
JOIN DisasterType dt ON er.disaster_type_id = dt.disaster_type_id
JOIN Location l      ON er.location_id = l.location_id
WHERE er.status = 'Pending'
ORDER BY er.report_time;

-- Test B: Same logic via view
SELECT
    report_id, disaster_type, city, severity_level, report_time
FROM vw_Operator_PendingReports
ORDER BY report_time;
GO

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO











-- ============================================================
-- PART 8: INDEXING STRATEGY & PERFORMANCE ANALYSIS
-- Smart Disaster Response MIS (SQL Server)
-- ============================================================

USE SmartDisasterMIS;
GO

/* ------------------------------------------------------------
   A) BASELINE: PERFORMANCE TEST WITHOUT CUSTOM INDEXES
   ------------------------------------------------------------ */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- P1: Incident filtering by location + severity + time
SELECT er.report_id, er.location_id, er.severity_level, er.report_time, er.status
FROM EmergencyReport er
WHERE er.location_id = 1
  AND er.severity_level IN ('High','Critical')
ORDER BY er.report_time DESC;

-- P2: Disaster-type analytics with date range
SELECT er.report_id, er.disaster_type_id, er.report_time, er.status
FROM EmergencyReport er
WHERE er.disaster_type_id = 1
  AND er.report_time >= '2024-07-01'
  AND er.report_time <  '2024-11-01';

-- P3: Low stock scan by warehouse/resource
SELECT inv.warehouse_id, inv.resource_type_id, inv.quantity_available, inv.reorder_level
FROM Inventory inv
WHERE inv.warehouse_id = 5
  AND inv.quantity_available < inv.reorder_level;

-- P4: Financial timeline query
SELECT e.expense_id, e.disaster_event_id, e.expense_date, e.amount, e.category_id
FROM Expense e
WHERE e.expense_date >= '2024-07-01'
  AND e.expense_date <  '2024-11-01'
ORDER BY e.expense_date DESC;

-- P5: Approval pending queue by time
SELECT ar.approval_id, ar.status, ar.submitted_at, ar.request_type
FROM ApprovalRequest ar
WHERE ar.status = 'Pending'
ORDER BY ar.submitted_at ASC;

GO
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


/* ------------------------------------------------------------
   B) CREATE INDEXES (single-column + composite)
   ------------------------------------------------------------ */

-- 1) Emergency reporting: location/severity/time
CREATE NONCLUSTERED INDEX IX_EmergencyReport_Location_Severity_Time
ON EmergencyReport (location_id, severity_level, report_time DESC)
INCLUDE (status, disaster_type_id, disaster_event_id, reported_by);

-- 2) Emergency reporting by type/time
CREATE NONCLUSTERED INDEX IX_EmergencyReport_Type_Time
ON EmergencyReport (disaster_type_id, report_time DESC)
INCLUDE (severity_level, status, location_id);

-- 3) Inventory threshold/lookup
CREATE NONCLUSTERED INDEX IX_Inventory_Warehouse_Resource
ON Inventory (warehouse_id, resource_type_id)
INCLUDE (quantity_available, reorder_level, last_updated);

-- 4) Finance timeline optimization
CREATE NONCLUSTERED INDEX IX_Expense_Date_Event
ON Expense (expense_date DESC, disaster_event_id)
INCLUDE (amount, category_id, approved_by);

-- 5) Approval workflow queue
CREATE NONCLUSTERED INDEX IX_ApprovalRequest_Status_SubmittedAt
ON ApprovalRequest (status, submitted_at ASC)
INCLUDE (request_type, submitted_by, approved_by, reference_id);

-- 6) Resource request detail joins
CREATE NONCLUSTERED INDEX IX_ResourceRequestDetail_Request_Resource
ON ResourceRequestDetail (request_id, resource_type_id)
INCLUDE (quantity_requested);

-- 7) Dispatch detail joins
CREATE NONCLUSTERED INDEX IX_DispatchDetail_Dispatch_Resource
ON DispatchDetail (dispatch_id, resource_type_id)
INCLUDE (quantity_dispatched, request_detail_id);

-- 8) Rescue assignment operational queries
CREATE NONCLUSTERED INDEX IX_RescueAssignment_Report_Status_Time
ON RescueAssignment (report_id, assignment_status, assigned_time DESC)
INCLUDE (team_id, completion_time, assigned_by);

GO


/* ------------------------------------------------------------
   C) RE-RUN SAME QUERIES AFTER INDEXING
   ------------------------------------------------------------ */

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- P1
SELECT er.report_id, er.location_id, er.severity_level, er.report_time, er.status
FROM EmergencyReport er
WHERE er.location_id = 1
  AND er.severity_level IN ('High','Critical')
ORDER BY er.report_time DESC;

-- P2
SELECT er.report_id, er.disaster_type_id, er.report_time, er.status
FROM EmergencyReport er
WHERE er.disaster_type_id = 1
  AND er.report_time >= '2024-07-01'
  AND er.report_time <  '2024-11-01';

-- P3
SELECT inv.warehouse_id, inv.resource_type_id, inv.quantity_available, inv.reorder_level
FROM Inventory inv
WHERE inv.warehouse_id = 5
  AND inv.quantity_available < inv.reorder_level;

-- P4
SELECT e.expense_id, e.disaster_event_id, e.expense_date, e.amount, e.category_id
FROM Expense e
WHERE e.expense_date >= '2024-07-01'
  AND e.expense_date <  '2024-11-01'
ORDER BY e.expense_date DESC;

-- P5
SELECT ar.approval_id, ar.status, ar.submitted_at, ar.request_type
FROM ApprovalRequest ar
WHERE ar.status = 'Pending'
ORDER BY ar.submitted_at ASC;

GO
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


/* ------------------------------------------------------------
   D) WRITE-OVERHEAD DEMO (index trade-off)
   ------------------------------------------------------------ */
SET STATISTICS TIME ON;
GO

-- Bulk insert simulation (shows write overhead due to indexes)
INSERT INTO AuditLog (user_id, action_type, table_name, record_id, old_value, new_value, action_time)
SELECT TOP 2000
    1, 'INSERT', 'PerfTest', ROW_NUMBER() OVER(ORDER BY (SELECT NULL)),
    NULL, '{"demo":"bulk"}', SYSDATETIME()
FROM sys.all_objects a
CROSS JOIN sys.all_objects b;

SET STATISTICS TIME OFF;
GO
















