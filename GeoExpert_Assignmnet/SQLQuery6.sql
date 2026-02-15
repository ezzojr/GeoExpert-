-- ============================================
-- ADD TEST DATA FOR USER: ezzo
-- ============================================

-- Get ezzo's UserID
DECLARE @UserID INT = (SELECT UserID FROM Users WHERE Username = 'ezzo');

PRINT '=== Adding data for user: ezzo ===';
PRINT 'UserID: ' + CAST(@UserID AS VARCHAR);
PRINT '';

-- ============================================
-- ADD 3 QUIZ RESULTS
-- ============================================

PRINT '--- Adding Quiz Results ---';

INSERT INTO UserQuizResults (UserID, QuizID, Score, TotalQuestions, CompletedDate)
VALUES 
    (@UserID, 1, 80, 10, GETDATE()),
    (@UserID, 2, 90, 10, DATEADD(DAY, -1, GETDATE())),
    (@UserID, 3, 100, 10, DATEADD(DAY, -2, GETDATE()));

PRINT '✓ Added 3 quiz results:';
PRINT '  - Quiz 1: 80% (8/10)';
PRINT '  - Quiz 2: 90% (9/10)';
PRINT '  - Quiz 3: 100% (10/10) - Perfect!';

-- ============================================
-- ADD 2 BADGES
-- ============================================

PRINT '';
PRINT '--- Adding Badges ---';

INSERT INTO UserBadges (UserID, BadgeName, BadgeDescription, EarnedDate)
VALUES 
    (@UserID, 'First Steps', 'Complete your first quiz', GETDATE()),
    (@UserID, 'Perfect Score', 'Get 100% on a quiz', GETDATE());

PRINT '✓ Added 2 badges:';
PRINT '  - 🌟 First Steps (Complete your first quiz)';
PRINT '  - ⭐ Perfect Score (Get 100% on a quiz)';

-- ============================================
-- ADD 5 COUNTRY VISITS
-- ============================================

PRINT '';
PRINT '--- Adding Country Progress ---';

-- Check if countries exist
IF EXISTS (SELECT * FROM Countries)
BEGIN
    INSERT INTO UserProgress (UserID, CountryID, Completed, LastAccessDate)
    SELECT TOP 5 
        @UserID, 
        CountryID, 
        1, 
        DATEADD(DAY, -ROW_NUMBER() OVER (ORDER BY CountryID), GETDATE())
    FROM Countries
    ORDER BY CountryID;
    
    PRINT '✓ Added 5 country visits (marked as completed)';
    
    -- Show which countries
    SELECT TOP 5 
        c.CountryID,
        c.Name as CountryName
    FROM Countries c
    ORDER BY c.CountryID;
END
ELSE
BEGIN
    PRINT '⚠ No countries found in database';
END

-- ============================================
-- VERIFY DATA
-- ============================================

PRINT '';
PRINT '=== VERIFICATION ===';

DECLARE @Quizzes INT = (SELECT COUNT(*) FROM UserQuizResults WHERE UserID = @UserID);
DECLARE @Badges INT = (SELECT COUNT(*) FROM UserBadges WHERE UserID = @UserID);
DECLARE @Countries INT = (SELECT COUNT(*) FROM UserProgress WHERE UserID = @UserID AND Completed = 1);
DECLARE @Streak INT = (SELECT ISNULL(CurrentStreak, 0) FROM Users WHERE UserID = @UserID);

SELECT 
    @Quizzes as Quizzes,
    @Badges as Badges,
    @Countries as Countries,
    @Streak as Streak,
    (@Quizzes + @Badges + @Countries + @Streak) as TotalProgress;

PRINT '';
PRINT '=== YOUR PROFILE WILL SHOW ===';
PRINT '';
PRINT 'Overall Progress: ' + CAST((@Quizzes + @Badges + @Countries + @Streak) AS VARCHAR) + '/138 (' + 
      CAST(CAST((@Quizzes + @Badges + @Countries + @Streak) * 100.0 / 138 AS INT) AS VARCHAR) + '%)';
PRINT '';
PRINT '🌍 Countries Explored:  ' + CAST(@Countries AS VARCHAR) + '/50 (' + 
      CAST(CAST(@Countries * 100.0 / 50 AS INT) AS VARCHAR) + '%)';
PRINT '🎯 Quizzes Completed:   ' + CAST(@Quizzes AS VARCHAR) + '/50 (' + 
      CAST(CAST(@Quizzes * 100.0 / 50 AS INT) AS VARCHAR) + '%)';
PRINT '🏆 Badges Earned:       ' + CAST(@Badges AS VARCHAR) + '/8 (' + 
      CAST(CAST(@Badges * 100.0 / 8 AS INT) AS VARCHAR) + '%)';
PRINT '🔥 Current Streak:      ' + CAST(@Streak AS VARCHAR) + '/30 days (' + 
      CAST(CAST(@Streak * 100.0 / 30 AS INT) AS VARCHAR) + '%)';

PRINT '';
PRINT '✓ DONE! Data added successfully for ezzo!';
PRINT '';
PRINT '=== NEXT STEPS ===';
PRINT '1. Rebuild your Visual Studio project (Ctrl+Shift+B)';
PRINT '2. Run the project (F5)';
PRINT '3. Login as ezzo';
PRINT '4. Go to Profile page';
PRINT '5. See all progress bars working! 🎉';

GO