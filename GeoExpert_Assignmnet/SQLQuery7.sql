UPDATE Countries
SET FlagImage = '/Assets/Flags/' + FlagImage
WHERE FlagImage IS NOT NULL AND FlagImage NOT LIKE '/Assets/Flags/%';
