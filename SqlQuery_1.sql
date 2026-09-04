-- Create the database
CREATE DATABASE RaceDay;
GO

USE RaceDay;
GO

-- ============================================================
-- TABLE: User
-- Stores all user information for both Organisers and Participants
-- ============================================================
CREATE TABLE [User] (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(500) NOT NULL,
    FullName NVARCHAR(200) NOT NULL,
    DateOfBirth DATE NOT NULL,
    [Role] NVARCHAR(50) NOT NULL CHECK ([Role] IN ('Organiser', 'Participant')),
    ProfileImageId INT NULL, 
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
GO

-- ============================================================
-- TABLE: Event
-- Stores event details for road running, walking, and cycling events
-- ============================================================
CREATE TABLE [Event] (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserId INT NOT NULL,
    [Name] NVARCHAR(200) NOT NULL,
    [Description] NVARCHAR(MAX) NULL,
    EventDate DATETIME2 NOT NULL,
    [Location] NVARCHAR(300) NOT NULL,
    [Distance] DECIMAL(10,2) NOT NULL, 
    EventType NVARCHAR(20) NOT NULL CHECK (EventType IN ('run', 'walk', 'cycle')),
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    
    CONSTRAINT FK_Event_Organiser FOREIGN KEY (OrganiserId) REFERENCES [User](Id)
);
GO

-- ============================================================
-- TABLE: EventCategory
-- Defines categories for events (e.g., Under 20, Senior, 10km, 21km)
-- ============================================================
CREATE TABLE EventCategory (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(200) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    
    CONSTRAINT FK_EventCategory_Event FOREIGN KEY (EventId) REFERENCES [Event](Id) ON DELETE CASCADE,
    CONSTRAINT UQ_EventCategory_EventName UNIQUE (EventId, CategoryName)
);
GO

-- ============================================================
-- TABLE: Enrolment
-- Links Participants to Events with their selected category and status
-- ============================================================
CREATE TABLE Enrolment (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantId INT NOT NULL,
    EventId INT NOT NULL,
    CategoryId INT NOT NULL,
    EnrolmentDate DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [Status] NVARCHAR(50) NOT NULL DEFAULT 'Pending' CHECK ([Status] IN ('Pending', 'Confirmed', 'Withdrawn')),
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    
    CONSTRAINT FK_Enrolment_Participant FOREIGN KEY (ParticipantId) REFERENCES [User](Id),
    CONSTRAINT FK_Enrolment_Event FOREIGN KEY (EventId) REFERENCES [Event](Id),
    CONSTRAINT FK_Enrolment_Category FOREIGN KEY (CategoryId) REFERENCES EventCategory(Id),
    CONSTRAINT UQ_Enrolment_ParticipantEvent UNIQUE (ParticipantId, EventId)
);
GO

-- ============================================================
-- TABLE: Result
-- Stores finish times and positions for Participants in Events
-- ============================================================
CREATE TABLE [Result] (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId INT NOT NULL,
    EventId INT NOT NULL,
    FinishTime TIME(0) NOT NULL,
    FinishingPosition INT NOT NULL,
    TotalFinishers INT NOT NULL,
    [Status] NVARCHAR(20) NOT NULL DEFAULT 'Completed' CHECK ([Status] IN ('Completed', 'Disqualified', 'DNS', 'DNF')),
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    
    CONSTRAINT FK_Result_Enrolment FOREIGN KEY (EnrolmentId) REFERENCES Enrolment(Id),
    CONSTRAINT FK_Result_Event FOREIGN KEY (EventId) REFERENCES [Event](Id),
    CONSTRAINT UQ_Result_Enrolment UNIQUE (EnrolmentId),
    CONSTRAINT CHK_FinishingPosition CHECK (FinishingPosition >= 1),
    CONSTRAINT CHK_TotalFinishers CHECK (TotalFinishers >= 1)
);
GO

-- ============================================================
-- TABLE: EventImage
-- Stores references to images uploaded to Azure Blob Storage for Events
-- ============================================================
CREATE TABLE EventImage (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL UNIQUE, 
    ImageUrl NVARCHAR(500) NOT NULL,
    BlobName NVARCHAR(255) NOT NULL,
    UploadedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    
    CONSTRAINT FK_EventImage_Event FOREIGN KEY (EventId) REFERENCES [Event](Id) ON DELETE CASCADE
);
GO

-- ============================================================
-- TABLE: UserProfileImage
-- Stores references to profile images uploaded to Azure Blob Storage for Users
-- ============================================================
CREATE TABLE UserProfileImage (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL UNIQUE, 
    ImageUrl NVARCHAR(500) NOT NULL,
    BlobName NVARCHAR(255) NOT NULL,
    UploadedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    
    CONSTRAINT FK_UserProfileImage_User FOREIGN KEY (UserId) REFERENCES [User](Id) ON DELETE CASCADE
);
GO

-- ============================================================
-- Add foreign key from User to UserProfileImage (after both tables exist)
-- ============================================================
ALTER TABLE [User]
ADD CONSTRAINT FK_User_ProfileImage
FOREIGN KEY (ProfileImageId) REFERENCES UserProfileImage(Id);
GO

-- ============================================================
-- CREATE INDEXES for performance optimization
-- ============================================================
CREATE INDEX IX_Event_OrganiserId ON [Event](OrganiserId);
CREATE INDEX IX_Event_EventDate ON [Event](EventDate);
CREATE INDEX IX_Event_EventType ON [Event](EventType);
CREATE INDEX IX_Enrolment_ParticipantId ON Enrolment(ParticipantId);
CREATE INDEX IX_Enrolment_EventId ON Enrolment(EventId);
CREATE INDEX IX_Enrolment_CategoryId ON Enrolment(CategoryId);
CREATE INDEX IX_Enrolment_Status ON Enrolment([Status]);
CREATE INDEX IX_Result_EventId ON [Result](EventId);
CREATE INDEX IX_Result_EnrolmentId ON [Result](EnrolmentId);
CREATE INDEX IX_EventCategory_EventId ON EventCategory(EventId);
GO

-- ============================================================
-- SAMPLE DATA: Seed the database with realistic test data
-- ============================================================


INSERT INTO [User] (Email, PasswordHash, FullName, DateOfBirth, [Role], CreatedAt, UpdatedAt)
VALUES 
    -- Organisers
    ('thabo.mokoena@racehub.co.za', 'HASHED_PASSWORD_1', 'Thabo Mokoena', '1985-03-15', 'Organiser', GETUTCDATE(), GETUTCDATE()),
    ('sarah.johnson@capetownrunning.co.za', 'HASHED_PASSWORD_2', 'Sarah Johnson', '1990-07-22', 'Organiser', GETUTCDATE(), GETUTCDATE()),
    
    -- Participants
    ('sipho.ndlovu@gmail.com', 'HASHED_PASSWORD_3', 'Sipho Ndlovu', '1992-11-05', 'Participant', GETUTCDATE(), GETUTCDATE()),
    ('lisa.vandermerwe@outlook.com', 'HASHED_PASSWORD_4', 'Lisa van der Merwe', '1988-09-12', 'Participant', GETUTCDATE(), GETUTCDATE());
GO

-- Insert sample Events
INSERT INTO [Event] (OrganiserId, [Name], [Description], EventDate, [Location], [Distance], EventType, CreatedAt, UpdatedAt)
VALUES
    -- Event 1: Comrades Marathon (organised by Thabo)
    (1, 'Comrades Marathon 2026', 'The ultimate human race - 90km ultra-marathon between Pietermaritzburg and Durban.', '2026-08-29 05:30:00', 'Pietermaritzburg to Durban', 90.00, 'run', GETUTCDATE(), GETUTCDATE()),
    
    -- Event 2: Cape Town Cycle Tour (organised by Sarah)
    (2, 'Cape Town Cycle Tour 2026', 'The world''s largest timed cycling event around the Cape Peninsula.', '2026-03-14 06:00:00', 'Cape Town, Western Cape', 109.00, 'cycle', GETUTCDATE(), GETUTCDATE()),
    
    -- Event 3: Soweto Marathon (organised by Thabo)
    (1, 'Soweto Marathon 2026', 'A vibrant 42.2km marathon through the streets of Soweto.', '2026-11-07 06:00:00', 'Soweto, Gauteng', 42.20, 'run', GETUTCDATE(), GETUTCDATE());
GO

-- Insert Event Categories
INSERT INTO EventCategory (EventId, CategoryName, [Description], CreatedAt, UpdatedAt)
VALUES
    -- Comrades Marathon Categories
    (1, 'Open Men', 'Men aged 20-39', GETUTCDATE(), GETUTCDATE()),
    (1, 'Open Women', 'Women aged 20-39', GETUTCDATE(), GETUTCDATE()),
    (1, 'Veteran Men (40+)', 'Men aged 40 and over', GETUTCDATE(), GETUTCDATE()),
    (1, 'Veteran Women (40+)', 'Women aged 40 and over', GETUTCDATE(), GETUTCDATE()),
    
    -- Cape Town Cycle Tour Categories
    (2, 'Elite Men', 'Licensed elite men', GETUTCDATE(), GETUTCDATE()),
    (2, 'Elite Women', 'Licensed elite women', GETUTCDATE(), GETUTCDATE()),
    (2, 'Amateur Men', 'Recreational men', GETUTCDATE(), GETUTCDATE()),
    (2, 'Amateur Women', 'Recreational women', GETUTCDATE(), GETUTCDATE()),
    
    -- Soweto Marathon Categories
    (3, 'Open Men', 'Men aged 20-39', GETUTCDATE(), GETUTCDATE()),
    (3, 'Open Women', 'Women aged 20-39', GETUTCDATE(), GETUTCDATE()),
    (3, 'Veteran Men (40+)', 'Men aged 40 and over', GETUTCDATE(), GETUTCDATE()),
    (3, 'Veteran Women (40+)', 'Women aged 40 and over', GETUTCDATE(), GETUTCDATE());
GO

-- Insert sample Enrolments
INSERT INTO Enrolment (ParticipantId, EventId, CategoryId, [Status], EnrolmentDate, CreatedAt, UpdatedAt)
VALUES
    -- Sipho enrols in Comrades
    (3, 1, 1, 'Confirmed', '2026-01-15 10:00:00', GETUTCDATE(), GETUTCDATE()),
    -- Sipho enrols in Soweto Marathon
    (3, 3, 9, 'Confirmed', '2026-02-01 14:30:00', GETUTCDATE(), GETUTCDATE()),
    -- Lisa enrols in Cape Town Cycle Tour
    (4, 2, 8, 'Confirmed', '2026-01-20 09:15:00', GETUTCDATE(), GETUTCDATE()),
    -- Lisa enrols in Comrades
    (4, 1, 4, 'Pending', '2026-02-10 11:00:00', GETUTCDATE(), GETUTCDATE());
GO

-- Insert sample Results (after events have concluded)
INSERT INTO [Result] (EnrolmentId, EventId, FinishTime, FinishingPosition, TotalFinishers, [Status], CreatedAt, UpdatedAt)
VALUES
    -- Sipho's Comrades result
    (1, 1, '07:45:30', 152, 1200, 'Completed', GETUTCDATE(), GETUTCDATE()),
    -- Lisa's Cape Town Cycle Tour result
    (3, 2, '03:12:45', 87, 850, 'Completed', GETUTCDATE(), GETUTCDATE());
GO


GO

