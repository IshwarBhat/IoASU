/********************************************************
* This script creates the database named IoASU
*********************************************************/
USE master;
GO

-- alter database IoASU set single_user with rollback immediate;

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
  PasswordSalt      VARCHAR(128),
  LName             VARCHAR(255) NOT NULL,
  FName             VARCHAR(255) NOT NULL,
  Bio               VARCHAR(255)
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

SET IDENTITY_INSERT Campuses ON;

INSERT INTO Campuses (CampusID, CampusName, Location, OrganizationCount) VALUES
(1, 'Tempe', 'Tempe', '80'), 
(2, 'Downtown', 'Phoenix', '20'),
(3, 'Polytechnic','Mesa', '30'),
(4, 'West', 'Glendale', '15');

SET IDENTITY_INSERT Campuses OFF;


SET IDENTITY_INSERT Organizations ON;

INSERT INTO Organizations (OrgID, Name, Email, Phone, MeetingVenue, WeeklyMeetDay, WeeklyMeetTime, WebLink, DateOfCreation) VALUES
(1, 'Action for America', 'aofa@asu.edu', '4806567865', 'COWDN', 'Monday', '17:00', 'aofa.org', '2012-04-01'),
(2, 'Active Minds at Arizona State University', 'aminds@asu.edu', '4805782052', 'Art', 'Friday', '16:00', 'aminds.com', '2013-05-23'),
(3, 'Adworks', 'adworks@asu.edu', '4801234357', 'ECE', 'Tuesday', '17:00', 'adworks.com', '2011-01-21'),
(4, 'Aerospace Innovation Club', 'aeroinnoclub@asu.edu', '4806723451', 'Physical Sciences', 'Monday', '19:00', 'aeroinnoclub.org', '2015-03-20'),
(5, 'Alpha Chi Omega Sorority', 'alphachiomega@asu.edu', '4803481228', 'Alpha Chi Omega', 'Thursday', '17:00', 'alphachiomega.com', '2014-02-28'),
(6, 'Barrett Leadership and Service Team', 'barrettLST@asu.edu', '4805987937', 'Barrett Honors College', 'Wednesday', '18:00', 'barrettlst.org', '2010-07-11'),
(7, 'Bhakti Yoga Club', 'bhaktiyoga@asu.edu', '4802651298', 'CPCOM', 'Monday', '17:00', 'bhaktiyoga.com', '2010-08-12'),
(8, 'bioSyntagma', 'biosyntagma@asu.edu', '4805640099', 'Hassayampa Academic Village', 'Wednesday', '19:00', 'biosyntagma.org', '2012-11-23'),
(9, 'Global Business Association', 'gba@asu.edu', '4807763452', 'W P Carey', 'Friday', '16:00', 'gba.org', '2013-09-27'),
(10,'JOYS', 'joys@asu.edu', '4807867654', 'Discovery', 'Thursday', '16:00', 'joys.com', '2014-10-10');
 

SET IDENTITY_INSERT Organizations OFF;


--SET IDENTITY_INSERT CampusOrganization ON;

INSERT INTO CampusOrganization (CampusID, OrgID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(1, 5),
(2, 6),
(3, 7),
(4, 8),
(1, 9),
(2, 10);

--SET IDENTITY_INSERT CampusOrganization OFF;



SET IDENTITY_INSERT Departments ON;

INSERT INTO Departments (DepID, Department) VALUES
(100, 'Information Technology'),
(200, 'Civil Engineering'),
(300, 'Biomedical Engineering'),
(400, 'Biodesign Engineering'),
(500, 'Computer Science'),
(600, 'Graphic Information Technology'),
(700, 'Accounting'),
(800, 'Law'),
(900, 'Software Engineering'),
(1000, 'Business Administration');


SET IDENTITY_INSERT Departments OFF;

SET IDENTITY_INSERT Users ON;


<<<<<<< HEAD
INSERT INTO Users (UserID, ASUID, Password, PasswordSalt, LName, FName, Bio, Email) VALUES
(1, 'pbuffet', 'January01@', NULL, 'Buffet', 'Pheobe', 'Student of Information Technology', 'pbuffet@asu.edu'),
(2, 'kclarkson', 'February8', NULL, 'Clarkson', 'Kelly', 'Civil Engineering Student', 'kclarkson@asu,edu'),
(3, 'bpitt', 'March123@', NULL, 'Pitt', 'Brad', 'Biomedical Student', 'bpitt@asu.edu'),
(4, 'jlawrence', 'April09%', NULL, 'Lawarence', 'Jennifer', 'Biodesign Student', 'jlawrence@asu.edu'),
(5, 'jtribianni', 'June123@', NULL, 'Tribianni', 'Joseph', 'Computer Science Student', 'jtribianni@asu.edu'),
(6, 'cbing', 'Flower##', NULL, 'Bing', 'Chandler', 'Graphic Information technology Student', 'cbing@asu.edu'),
(7, 'rgeller', 'September9@', NULL, 'Geller', 'Ross', 'Law Student', 'rgeller@asu.edu'),
(8, 'rgreen', 'August!120', NULL, 'Green', 'Rachel', 'Accounting Student', 'rgreen@asu.edu'),
(9, 'mgeller', 'December%2', NULL, 'Geller', 'Monica', 'Software Engineering Student', 'mgeller@asu.edu'),
(10,'omunn', 'october763@', NULL, 'Olivia', 'Munn', 'Real Estate Student', 'omunn@asu.edu');
=======
INSERT INTO Users (UserID, ASUID, Password, PasswordSalt, LName, FName, Bio) VALUES
(1, 'pbuffet', 'January01@', NULL, 'Buffet', 'Pheobe', 'Student of Information Technology'),
(2, 'kclarkson', 'February8', NULL, 'Clarkson', 'Kelly', 'Civil Engineering Student'),
(3, 'bpitt', 'March123@', NULL, 'Pitt', 'Brad', 'Biomedical Student'),
(4, 'jlawrence', 'April09%', NULL, 'Tribianni', 'Joseph', 'Biodesign Student'),
(5, 'jtribianni', 'June123@', NULL, 'Buffet', 'Pheobe', 'Computer Science Student'),
(6, 'cbing', 'Flower##', NULL, 'Bing', 'Chandler', 'Graphic Information technology Student'),
(7, 'rgeller', 'September9@', NULL, 'Geller', 'Ross', 'Law Student'),
(8, 'rgreen', 'August!120', NULL, 'Green', 'Rachel', 'Accounting Student'),
(9, 'mgeller', 'December%2', NULL, 'Geller', 'Monica', 'Software Engineering Student'),
(10,'omunn', 'october763@', NULL, 'Olivia', 'Munn', 'Real Estate Student');
>>>>>>> draja/master

SET IDENTITY_INSERT Users OFF;


--SET IDENTITY_INSERT Phones ON;

INSERT INTO Phones (Phone) VALUES
('4806742876'),
('6027321879'),
('5204372595'),
('6020981235'),
('5201256822'),
('4803346543'),
('4805572397'),
('6022347654'),
('4809124531'),
('5203228767');


--SET IDENTITY_INSERT Phones OFF;

--SET IDENTITY_INSERT UserPhones ON;

INSERT INTO UserPhones (UserID, Phone) VALUES
(1, '4806742876'),
(2, '6027321879'),
(3, '5204372595'),
(4, '6020981235'),
(5, '5201256822'),
(6, '4803346543'),
(7, '4805572397'),
(8, '6022347654'),
(9, '4809124531'),
(10, '5203228767');


--SET IDENTITY_INSERT UserPhones OFF;

--SET IDENTITY_INSERT Emails ON;

INSERT INTO Emails (Email) VALUES
('pbuffet@asu.edu'),
('kclarkson@asu.edu'),
('bpitt@asu.edu'),
('jlawrence@asu.edu'),
('jtribianni@asu.edu'),
('cbing@asu.edu'),
('rgeller@asu.edu'),
('rgreen@asu.edu'),
('mgeller@asu.edu'),
('omunn@asu.edu');

--SET IDENTITY_INSERT Emails OFF;

--SET IDENTITY_INSERT UserEmails ON;

INSERT INTO UserEmails(UserID, Email) VALUES
(1, 'pbuffet@asu.edu'),
(2, 'kclarkson@asu.edu'),
(3,	'bpitt@asu.edu'),
(4, 'jlawrence@asu.edu'),
(5, 'jtribianni@asu.edu'),
(6, 'cbing@asu.edu'),
(7, 'rgeller@asu.edu'),
(8, 'rgreen@asu.edu'),
(9, 'mgeller@asu.edu'),
(10, 'omunn@asu.edu');

--SET IDENTITY_INSERT UserEmails OFF;

--SET IDENTITY_INSERT UserDepartment ON;
INSERT INTO UserDepartment (UserID, DepID) VALUES
(1, '100'),
(2, '200'),
(3, '300'),
(4, '400'),
(5, '500'),
(6, '600'),
(7, '700'),
(8, '800'),
(9, '900'),
(10, '1000');


--SET IDENTITY_INSERT UserDepartment OFF;

--SET IDENTITY_INSERT UserOrganization ON;
INSERT INTO UserOrganization ( UserID, OrgID) VALUES
(1, 10),
(2, 9),
(3, 8),
(4, 7),
(5, 6),
(6, 5),
(7, 4),
(8, 3),
(9, 2),
(10, 1);

--SET IDENTITY_INSERT UserOrganization OFF;

SET IDENTITY_INSERT Events ON;
INSERT INTO Events (EventID , EventName, EventDesc, Time, Venue, LinkToJoin) VALUES
(1, 'Doctoral Recital Series', 'Alpha Chi Omega presents collaborative piano recital', '17:30', 'COWDN', ''),
(2, 'Latin Sol Dance Festival', 'The event is all-day latin dance extravaganza and free for both ASU students and members of the local dance community', '18:00', 'Art', ''),
(3, '"A" Mountain Restoration', '"Celebrate Earth Day 2017 by helping to restore walking and hiking trails on ""A"" Mountain', '9:00', '"A" Mountain', ''),
(4, 'Barrett Marketing Association Case Competition', 'Competition for all the students of Barrett Honors College', '17:00', 'Barrett Honors College', ''),
(5, 'Aero Innovation Club Garden Party', 'Get together party', '15:00', 'Hayden Lawn', ''),
(6, 'Topic : Your global mindset growing', 'Discussion about global business association', '10:00', 'BAC', ''),
(7, 'Ignite @ ASU', 'Public event for individuals to share the ideas, passions and stories', '13:00', 'CPCOM', ''),
(8, 'Greater Arizona : Mapping Place, history and transformations', 'Exhibit, Environment and Humanity', '17:30', 'COWDN', ''),
(9, 'Doctoral Recital Series', 'Alpha Chi Omega presents collaborative piano recital', '16:00', 'Hassayampa Academic Village', ''),
(10, 'Legal Issues in Design and Construction', 'Join us for lunch as we try to stump our panel of experts by asking them difficult, if not impossible, construction law questions.', '14:00', 'BAC', ''),
(11, 'Passion in Action Summit', 'Topics include immigration and sustainability ', '16:00', 'Discovery', '');

SET IDENTITY_INSERT Events OFF;

--SET IDENTITY_INSERT EventOrganization ON;
INSERT INTO EventOrganization(EventID, OrgID) VALUES
(1, 5),
(2, 10),
(3, 2),
(4, 6),
(5, 4),
(6, 9),
(7, 1),
(8, 7),
(9, 8),
(10, 3);

--SET IDENTITY_INSERT EventOrganization OFF;

SET IDENTITY_INSERT Categories ON;

INSERT INTO Categories (CategoryID, CategoryName, CountOfOrgs) VALUES
(1, 'Academic', 158),
(2, 'Biotechnology', 1),
(3, 'Community and Lifestyle', 4), 
(4, 'Data and Analytics', 4),
(5, 'Entrepreneurship/Innovation', 18),
(6, 'Financial Services', 2),
(7, 'International', 15),
(8, 'Political', 29),
(9, 'Science and Engineering', 6),
(10,'Sports', 3),
(11,'Sustainability', 35);


SET IDENTITY_INSERT Categories OFF;


SET IDENTITY_INSERT Documents ON;

INSERT INTO Documents (DocID, DocName, DocDesc, DocLink) VALUES
(1, 'Member List', 'List of all members of the organization', 'aminds.com/memberlist'),
(2, 'Student Event Planner', 'Event Planning Manual', 'adworks.com/studenteventplanner'),
(3, 'Registration info', 'Information of  all the students who register for each events', 'barrettlst.org/reginfo'),
(4, 'Membership requirements', 'All members must be students in good academic standing and registered at Arizona State University.', 'gba.com/membershipreq'),
(5, 'Officer Requirements', 'All officers must be students registered at Arizona State University.', 'joys.com/officerreq'),
(6, 'Constitution', 'All organizations required to submit their constitution when registering their student organization.', 'bhaktiyoga.com/constitution'),
(7, 'Faculty/Staff Advisor', 'All organizations need to choose a faculty/staff advisor. The faculty/staff advisor must be a full-time faculty or staff member who works on the ASU campus.', 'gba.com/staffadvisor'),
(8, 'Student Organization Handbook', 'Manual for student organizations', 'barrettlst.org/studentorghandbook'),
(9, 'Advisor Commitment Form', 'Forms for faculty advisors', 'aeroinnoclub.org/advisorcommittmentform'),
(10, 'Meeting Presentation', 'Presentations for events ', 'biosyntagma.org/presentation1');


SET IDENTITY_INSERT Documents OFF;


--SET IDENTITY_INSERT DocumentOrganization ON; 

INSERT INTO DocumentOrganization (DocID, OrgID) VALUES
(1,2),
(2,3),
(3,6),
(4,9),
(5,10),
(6,7),
(7,9),
(8,6),
(9,4),
(10,8);

--SET IDENTITY_INSERT Documents OFF

-- Create a user named MGSUser

/*
GRANT SELECT, INSERT, UPDATE, DELETE
ON *
TO MGSUser@localhost
IDENTIFIED BY 'pa55word';
*/
