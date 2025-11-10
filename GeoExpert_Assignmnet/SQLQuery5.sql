CREATE TABLE [dbo].[Users] (
    [UserID] INT IDENTITY (1, 1) NOT NULL,
    [Username] NVARCHAR(50) NOT NULL,
    [Password] NVARCHAR(255) NOT NULL,
    [Email] NVARCHAR(100) NOT NULL,
    [Role] NVARCHAR(20) DEFAULT ('User') NULL,
    [CurrentStreak] INT DEFAULT ((0)) NULL,
    [LastLoginDate] DATE NULL,
    [CreatedDate] DATETIME DEFAULT (GETDATE()) NULL,
    
    -- 🔹 Added for login enhancement
    [FailedLoginAttempts] INT DEFAULT (0) NULL,
    [LockoutEnd] DATETIME NULL,

    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserID] ASC),
    CONSTRAINT [UQ_Users_Username] UNIQUE NONCLUSTERED ([Username] ASC)
);