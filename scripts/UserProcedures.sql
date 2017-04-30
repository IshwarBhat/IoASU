-- Stored Procedure:
-- Return list of Organizations (Name, Email, Weblink) given a UserID
GO
CREATE PROC sp_OrgListForUser
@UserID INT
AS
BEGIN
  SELECT Name, Email, WebLink
  FROM Organizations WHERE OrgID IN
  (SELECT OrgID
   FROM UserOrganization WHERE UserID = @UserID)
END;

EXEC sp_OrgListForUser 1