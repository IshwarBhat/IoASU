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

-- Test:
EXEC sp_OrgListForUser 1

-- Stored Procedure:
-- Return stuff for User's My Profile Page
SELECT * FROM UserPhones
GO
CREATE PROC sp_MyProfileForUser
@UserID INT
AS
BEGIN
  SELECT Fname, Lname, ASUID, d.Department, Bio, Email, Phone
  FROM Users u
  JOIN UserDepartment ud ON u.UserID = ud.UserID
  JOIN Departments d ON d.DepID = ud.DepID
  JOIN UserEmails ue ON u.UserID = ue.UserID
  JOIN UserPhones up ON u.UserID = up.UserID
  WHERE u.UserID = @UserID
END;

-- Test:
sp_MyProfileForUser 1