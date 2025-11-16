CREATE TABLE CountryComments (
    CommentID     INT IDENTITY(1,1) PRIMARY KEY,
    CountryID     INT NOT NULL,
    UserID        INT NULL,
    UserName      NVARCHAR(100) NOT NULL,
    CommentText   NVARCHAR(500) NOT NULL,
    CreatedAt     DATETIME NOT NULL DEFAULT GETDATE()
);
