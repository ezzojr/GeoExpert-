ALTER TABLE Users
ADD FailedLoginAttempts INT DEFAULT 0,
    LockoutEnd DATETIME NULL;