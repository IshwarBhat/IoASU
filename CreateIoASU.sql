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
  OrganizationCount   INT                          DEFAULT 0
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
  Password          VARCHAR(128) NOT NULL,
  PasswordSalt      VARCHAR(128) NOT NULL,
  LName             VARCHAR(255) NOT NULL,
  FName             VARCHAR(255) NOT NULL,
  Bio               VARCHAR(255),
  Email             VARCHAR(255) NOT NULL,
  Phone             VARCHAR(10)
);

CREATE TABLE Phones (
  Phone             VARCHAR(10)    PRIMARY KEY
);

CREATE TABLE UserPhones (
  UserID            INT             REFERENCES Users (UserID)      NOT NULL,
  Phone             VARCHAR(10)     REFERENCES Phones (Phone)      NOT NULL
  PRIMARY KEY (UserID, Phone)
);

CREATE TABLE Emails (
  Email             VARCHAR(255)   PRIMARY KEY
);

CREATE TABLE UserEmails (
  UserID            INT             REFERENCES Users (UserID)      NOT NULL,
  Email             VARCHAR(255)     REFERENCES Emails (Email)      NOT NULL,
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
  CountOfOrgs       INT                          DEFAULT 0
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

-- Insert data into the tables
-- Later