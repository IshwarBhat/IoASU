-- Stored Procedure:
-- Return list of Organizations (Name, Email, Weblink) given a UserID
USE IoASU;
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
-- EXEC sp_OrgListForUser 1

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
-- sp_MyProfileForUser 1

-------------------------------------------------------------------------------------------------
-- Procedure to Validate User.
-- Three cases or output possibilities:
-- 1. 'NA' = User Does Not Exist
-- 2. 'Success' = Login Successful
-- 3. 'Failure' = Password Incorrect
GO
CREATE PROC sp_ValidateUser
@ASUID VARCHAR(20),
@Password VARCHAR(20)
AS

DECLARE @PasswordSalt VARCHAR(128);
DECLARE @Result VARCHAR(20);

IF (SELECT Password from Users WHERE ASUID = @ASUID) IS NULL
SET @Result = 'NA'
ELSE
BEGIN
  IF (SELECT HASHBYTES('SHA2_512', @Password + PasswordSalt) FROM Users WHERE ASUID = @ASUID) =
    (SELECT Password FROM Users WHERE ASUID = @ASUID)
  SET @Result = 'Success'
  ELSE SET @Result = 'Failure'
;END
SELECT @Result;
-------------------------------------------------------------------------------------------------
/* Testing:
-- USE as Dynamic SQL
DECLARE @ASUID VARCHAR(20);
DECLARE @Password VARCHAR(20);
DECLARE @SQLquery NVARCHAR(50);
SET @ASUID = 'tcruise'
SET @Password = 'topgun&&'

-- Implement below in login() function of Python in Django
SET @SQLQUERY = N'sp_ValidateUser ' + '''' + @ASUID + ''', ' + '''' + @Password + ''''
EXEC sp_executesql @SQLQUERY
*/