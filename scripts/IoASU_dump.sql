/********************************************************
* This script creates the database named IoASU
*********************************************************/
USE master;
GO

IF  DB_ID('IoASU') IS NOT NULL
DROP DATABASE IoASU;
GO

CREATE DATABASE IoASU;
GO

USE IoASU;

-- create the tables for the database
CREATE TABLE Campuses (
  CampusID            INT            PRIMARY KEY   IDENTITY,
  CampusName          VARCHAR(255)   NOT NULL,
  Location            VARCHAR(255)   NOT NULL,
 );

CREATE TABLE Organizations (
  OrgID             INT            PRIMARY KEY   IDENTITY,
  Name              VARCHAR(255)   NOT NULL,
  Email             VARCHAR(255)   NOT NULL,
  Phone             VARCHAR(10),
  MeetingVenue      VARCHAR(255),
  WeeklyMeetDay     VARCHAR(10),
  WeeklyMeetTime    TIME,
  WebLink           VARCHAR(255),
  DateOfCreation    DATETIME                     DEFAULT GETDATE()
);

CREATE TABLE CampusOrganization (
  CampusID          INT            REFERENCES Campuses (CampusID)    NOT NULL, 
  OrgID             INT            REFERENCES Organizations (OrgID)  NOT NULL,
  PRIMARY KEY (CampusID, OrgID)
);

CREATE TABLE Departments (
  DepID             INT            PRIMARY KEY   IDENTITY,
  Department        VARCHAR(255)
);

CREATE TABLE Users (
  UserID            INT            PRIMARY KEY   IDENTITY,
  ASUID             VARCHAR(20),
  Password          VARBINARY(128) NOT NULL,
  PasswordSalt      VARCHAR(128),
  LName             VARCHAR(255) NOT NULL,
  FName             VARCHAR(255) NOT NULL,
  Bio               VARCHAR(255)
    );


CREATE TABLE UserPhones (
  UserID            INT             REFERENCES Users (UserID)      NOT NULL,
  Phone             VARCHAR(10)     NOT NULL,
  PRIMARY KEY (UserID, Phone)
);


CREATE TABLE UserEmails (
  UserID            INT             REFERENCES Users (UserID)      NOT NULL,
  Email             VARCHAR(255)    NOT NULL,
  PRIMARY KEY (UserID, Email)
);

CREATE TABLE UserDepartment (
  UserID            INT           REFERENCES Users (UserID)      NOT NULL, 
  DepID             INT           REFERENCES Departments (DepID) NOT NULL,
  PRIMARY KEY (UserID, DepID)
);


CREATE TABLE UserOrganization (
  UserID          INT            REFERENCES Users (UserID)         NOT NULL, 
  OrgID           INT            REFERENCES Organizations (OrgID)  NOT NULL,
  Status		  VARCHAR(25)	 NOT NULL,
  PRIMARY KEY (UserID, OrgID)
);

CREATE TABLE Events (
  EventID           INT            PRIMARY KEY   IDENTITY,
  EventName         VARCHAR(255)   NOT NULL,
  EventDesc         VARCHAR(255),
  Time              DATETIME,
  Venue             VARCHAR(255),
  LinkToJoin        VARCHAR(255)
);

CREATE TABLE EventOrganization (
  EventID          INT           REFERENCES Events (EventID)       NOT NULL, 
  OrgID           INT            REFERENCES Organizations (OrgID)  NOT NULL,
  PRIMARY KEY (EventID, OrgID)
);

CREATE TABLE Categories (
  CategoryID        INT            PRIMARY KEY   IDENTITY,
  CategoryName      VARCHAR(255)   NOT NULL,
);

CREATE TABLE CategoryOrganization (
  CategoryID      INT            REFERENCES Categories (CategoryID)    NOT NULL, 
  OrgID           INT            REFERENCES Organizations (OrgID)      NOT NULL,
  PRIMARY KEY (CategoryID, OrgID)
);

CREATE TABLE Documents (
  DocID             INT            PRIMARY KEY   IDENTITY,
  DocName           VARCHAR(255),
  DocDesc           VARCHAR(255),
  DocLink           VARCHAR(255)   NOT NULL
);

CREATE TABLE DocumentOrganization (
  DocID           INT            REFERENCES Documents (DocID)      NOT NULL, 
  OrgID           INT            REFERENCES Organizations (OrgID)  NOT NULL,
  PRIMARY KEY (DocID, OrgID)
);

CREATE TABLE Roles (

  RoleID   INT    NOT NULL,
  Description	 VARCHAR(255) NOT NULL, 
  PRIMARY KEY (RoleID)
);

CREATE TABLE UserRoles (

  RoleID   INT      REFERENCES Roles (RoleID)     NOT NULL,
  UserID   INT      REFERENCES Users (UserID)	   NOT NULL
  PRIMARY KEY (RoleID, UserID)
);


----------------------------------------------
-- Create Stored Procedures:
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

-----------------------------------------------------------------------------------------
-- Views:
--View for campuses and number of organizations on each campus 
GO
create view CampusOrganizationCountView as
select Campuses.CampusID,CampusName,count(*) as 'Number of organizations'
from Campuses inner join CampusOrganization
on
Campuses.CampusID=CampusOrganization.CampusID
group by Campuses.CampusID,CampusName

--View for categories and number of organizations
GO
create view CategoryOrganizationCountView as
select Categories.CategoryID,CategoryName,count(*) as 'Number of organizations'
from Categories inner join CategoryOrganization
on
Categories.CategoryID=CategoryOrganization.CategoryID
group by Categories.CategoryID,CategoryName

--Stored procedure with CTE for organizations with respective campus and category
GO
create proc sp_OrganizationCategoryCampus
as
begin
with OrganizationCampusCTE
as
(
select Organizations.OrgID,CampusID,Name from
Organizations inner join CampusOrganization
on Organizations.OrgID=CampusOrganization.OrgID
),
CampusOrganizationCTE 
as
(
select OrganizationCampusCTE.OrgID,OrganizationCampusCTE.Name,CampusName from
Campuses inner join OrganizationCampusCTE
on Campuses.CampusID=OrganizationCampusCTE.CampusID
),
OrganizationCategoryCTE
as
(
select CategoryID,Name,CampusName from
CampusOrganizationCTE inner join CategoryOrganization
on CampusOrganizationCTE.OrgID=CategoryOrganization.OrgID
),
CategoryOrganizationCTE 
as
(
select Name as 'OrganizationName',CategoryName,CampusName from
Categories inner join OrganizationCategoryCTE
on Categories.CategoryID=OrganizationCategoryCTE.CategoryID
)
select * from CategoryOrganizationCTE
end

exec sp_OrganizationCategoryCampus

