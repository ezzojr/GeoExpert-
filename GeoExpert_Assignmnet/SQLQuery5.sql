-- ============================================
-- GEOEXPERT DATABASE SETUP - FIX ALL ERRORS
-- ============================================

-- Run this entire script in SQL Server Management Studio

USE GeoExpertDB;  -- Change to your database name
GO

-- ============================================
-- 1. FIX USERS TABLE
-- ============================================

-- Add ProfilePicture column if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'ProfilePicture')
BEGIN
    ALTER TABLE Users ADD ProfilePicture NVARCHAR(255) NULL;
    PRINT '✓ Added ProfilePicture column to Users table';
END
ELSE
BEGIN
    PRINT '✓ ProfilePicture column already exists';
END

-- Add CurrentStreak column if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'CurrentStreak')
BEGIN
    ALTER TABLE Users ADD CurrentStreak INT DEFAULT 0;
    PRINT '✓ Added CurrentStreak column to Users table';
END
ELSE
BEGIN
    PRINT '✓ CurrentStreak column already exists';
END

-- ============================================
-- 2. CREATE UserQuizResults TABLE
-- ============================================

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_NAME = 'UserQuizResults')
BEGIN
    CREATE TABLE UserQuizResults (
        ResultID INT PRIMARY KEY IDENTITY(1,1),
        UserID INT NOT NULL,
        QuizID INT NOT NULL,
        Score INT NOT NULL,
        TotalQuestions INT DEFAULT 10,
        CompletedDate DATETIME DEFAULT GETDATE(),
        TimeTaken INT NULL, -- in seconds
        FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
    );
    PRINT '✓ Created UserQuizResults table';
END
ELSE
BEGIN
    PRINT '✓ UserQuizResults table already exists';
END

-- ============================================
-- 3. CREATE UserBadges TABLE
-- ============================================

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_NAME = 'UserBadges')
BEGIN
    CREATE TABLE UserBadges (
        BadgeID INT PRIMARY KEY IDENTITY(1,1),
        UserID INT NOT NULL,
        BadgeName NVARCHAR(100) NOT NULL,
        BadgeDescription NVARCHAR(500) NULL,
        EarnedDate DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
    );
    PRINT '✓ Created UserBadges table';
END
ELSE
BEGIN
    PRINT '✓ UserBadges table already exists';
END

-- ============================================
-- 4. FIX UserProgress TABLE
-- ============================================

-- Check if UserProgress table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_NAME = 'UserProgress')
BEGIN
    -- Add Completed column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_NAME = 'UserProgress' AND COLUMN_NAME = 'Completed')
    BEGIN
        ALTER TABLE UserProgress ADD Completed BIT DEFAULT 0;
        PRINT '✓ Added Completed column to UserProgress table';
    END
    ELSE
    BEGIN
        PRINT '✓ Completed column already exists in UserProgress';
    END

    -- Check if CountryID column exists
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_NAME = 'UserProgress' AND COLUMN_NAME = 'CountryID')
    BEGIN
        -- Try to add CountryID column
        -- Note: You may need to adjust this based on your Countries table
        ALTER TABLE UserProgress ADD CountryID INT NULL;
        PRINT '✓ Added CountryID column to UserProgress table';
        PRINT '⚠ Please add foreign key constraint manually if needed';
    END
    ELSE
    BEGIN
        PRINT '✓ CountryID column already exists in UserProgress';
    END

    -- Add LastAccessDate if it doesn't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_NAME = 'UserProgress' AND COLUMN_NAME = 'LastAccessDate')
    BEGIN
        ALTER TABLE UserProgress ADD LastAccessDate DATETIME DEFAULT GETDATE();
        PRINT '✓ Added LastAccessDate column to UserProgress table';
    END
    ELSE
    BEGIN
        PRINT '✓ LastAccessDate column already exists in UserProgress';
    END
END
ELSE
BEGIN
    -- Create UserProgress table from scratch
    CREATE TABLE UserProgress (
        ProgressID INT PRIMARY KEY IDENTITY(1,1),
        UserID INT NOT NULL,
        CountryID INT NOT NULL,
        Completed BIT DEFAULT 0,
        LastAccessDate DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
    );
    PRINT '✓ Created UserProgress table';
END

-- ============================================
-- 5. VERIFY ALL TABLES
-- ============================================

PRINT '';
PRINT '=== TABLE VERIFICATION ===';

-- Check Users table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
    PRINT '✓ Users table exists';
ELSE
    PRINT '✗ Users table MISSING!';

-- Check UserQuizResults table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'UserQuizResults')
    PRINT '✓ UserQuizResults table exists';
ELSE
    PRINT '✗ UserQuizResults table MISSING!';

-- Check UserBadges table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'UserBadges')
    PRINT '✓ UserBadges table exists';
ELSE
    PRINT '✗ UserBadges table MISSING!';

-- Check UserProgress table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'UserProgress')
    PRINT '✓ UserProgress table exists';
ELSE
    PRINT '✗ UserProgress table MISSING!';

-- Check Countries table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Countries')
    PRINT '✓ Countries table exists';
ELSE
    PRINT '✗ Countries table MISSING!';

PRINT '';
PRINT '=== COLUMN VERIFICATION ===';

-- Check Users columns
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'ProfilePicture')
    PRINT '✓ Users.ProfilePicture exists';
ELSE
    PRINT '✗ Users.ProfilePicture MISSING!';

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'CurrentStreak')
    PRINT '✓ Users.CurrentStreak exists';
ELSE
    PRINT '✗ Users.CurrentStreak MISSING!';

-- Check UserProgress columns
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'UserProgress' AND COLUMN_NAME = 'CountryID')
    PRINT '✓ UserProgress.CountryID exists';
ELSE
    PRINT '✗ UserProgress.CountryID MISSING!';

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'UserProgress' AND COLUMN_NAME = 'Completed')
    PRINT '✓ UserProgress.Completed exists';
ELSE
    PRINT '✗ UserProgress.Completed MISSING!';

-- ============================================
-- 6. INSERT SAMPLE DATA (OPTIONAL)
-- ============================================

PRINT '';
PRINT '=== INSERTING SAMPLE DATA ===';

-- Add sample quiz results for testing (UserID = 1)
IF EXISTS (SELECT * FROM Users WHERE UserID = 1)
BEGIN
    -- Add 2 sample quiz results
    IF NOT EXISTS (SELECT * FROM UserQuizResults WHERE UserID = 1)
    BEGIN
        INSERT INTO UserQuizResults (UserID, QuizID, Score, TotalQuestions, CompletedDate)
        VALUES 
            (1, 1, 80, 10, GETDATE()),
            (1, 2, 90, 10, DATEADD(DAY, -1, GETDATE()));
        PRINT '✓ Added 2 sample quiz results for User 1';
    END
    ELSE
    BEGIN
        PRINT '✓ Quiz results already exist for User 1';
    END

    -- Add sample badge
    IF NOT EXISTS (SELECT * FROM UserBadges WHERE UserID = 1)
    BEGIN
        INSERT INTO UserBadges (UserID, BadgeName, BadgeDescription, EarnedDate)
        VALUES (1, 'First Steps', 'Complete your first quiz', GETDATE());
        PRINT '✓ Added sample badge for User 1';
    END
    ELSE
    BEGIN
        PRINT '✓ Badges already exist for User 1';
    END

    -- Update streak
    UPDATE Users SET CurrentStreak = 2 WHERE UserID = 1;
    PRINT '✓ Set CurrentStreak to 2 for User 1';
END
ELSE
BEGIN
    PRINT '⚠ User 1 not found - skipping sample data';
END

-- ============================================
-- 7. VERIFICATION QUERIES
-- ============================================

PRINT '';
PRINT '=== VERIFICATION QUERIES ===';
PRINT 'Run these queries to verify everything works:';
PRINT '';
PRINT '-- Check user 1 data:';
PRINT 'SELECT * FROM Users WHERE UserID = 1;';
PRINT 'SELECT * FROM UserQuizResults WHERE UserID = 1;';
PRINT 'SELECT * FROM UserBadges WHERE UserID = 1;';
PRINT 'SELECT * FROM UserProgress WHERE UserID = 1;';
PRINT '';
PRINT '-- Check counts:';
PRINT 'SELECT COUNT(*) as QuizCount FROM UserQuizResults WHERE UserID = 1;';
PRINT 'SELECT COUNT(*) as BadgeCount FROM UserBadges WHERE UserID = 1;';
PRINT 'SELECT COUNT(*) as ProgressCount FROM UserProgress WHERE UserID = 1;';
PRINT '';

PRINT '=== SETUP COMPLETE ===';
PRINT '✓ All tables and columns are ready!';
PRINT '✓ Now rebuild your project and test the profile page';

GO