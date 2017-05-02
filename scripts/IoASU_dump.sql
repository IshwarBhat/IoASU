
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




-- Insert data into the tables

SET IDENTITY_INSERT Campuses ON;

INSERT INTO Campuses (CampusID, CampusName, Location) VALUES
(1, 'Tempe', 'Tempe'), 
(2, 'Downtown', 'Phoenix'),
(3, 'Polytechnic','Mesa'),
(4, 'West', 'Glendale'),
(5, 'Lake Havasu City', 'Lake Havasu'),
(6, 'Thunderbird', 'Thunderbird');

SET IDENTITY_INSERT Campuses OFF;


SET IDENTITY_INSERT Organizations ON;

INSERT INTO Organizations (OrgID, Name, Email, Phone, MeetingVenue, WeeklyMeetDay, WeeklyMeetTime, WebLink, DateOfCreation) VALUES
(1, 'Action for America', 'aofa@asu.edu', '4806567865', 'COWDN', 'Monday', '17:00', 'aofa.org', '2012-04-01'),
(2, 'Active Minds at Arizona State University', 'aminds@asu.edu', '4805782052', 'Art', 'Friday', '16:00', 'aminds.com', '2013-05-23'),
(3, 'Adworks', 'adworks@asu.edu', '4801234357', 'ECE', 'Tuesday', '17:00', 'adworks.com', '2011-01-21'),
(4, 'Aerospace Innovation Club', 'aeroinnoclub@asu.edu', '4806723451', 'Physical Sciences', 'Monday', '19:00', 'aeroinnoclub.org', '2015-03-20'),
(5, 'Alpha Chi Omega Sorority', 'alphachiomega@asu.edu', '4803481228', 'BAC', 'Thursday', '17:00', 'alphachiomega.com', '2014-02-28'),
(6, 'Barrett Leadership and Service Team', 'barrettLST@asu.edu', '4805987937', 'Barrett Honors College', 'Wednesday', '18:00', 'barrettlst.org', '2010-07-11'),
(7, 'Bhakti Yoga Club', 'bhaktiyoga@asu.edu', '4802651298', 'CPCOM', 'Monday', '17:00', 'bhaktiyoga.com', '2010-08-12'),
(8, 'bioSyntagma', 'biosyntagma@asu.edu', '4805640099', 'Hassayampa Academic Village', 'Wednesday', '19:00', 'biosyntagma.org', '2012-11-23'),
(9, 'Global Business Association', 'gba@asu.edu', '4807763452', 'W P Carey', 'Friday', '16:00', 'gba.org', '2013-09-27'),
(10,'JOYS', 'joys@asu.edu', '4807867654', 'Discovery', 'Thursday', '16:00', 'joys.com', '2014-10-10'),
(11,'Alpha Chi Omega Sorority', 'alchios@asu.edu', '4532549872', 'Peralta', 'Thursday', '17:00', 'alchios.com', '2015-03-10'),
(12,'ASU Club Golf Team', 'golf@asu.edu', '2094567845', 'CPCOM', 'Monday', '17:50', 'asugolf.com', '2014-01-19'),
(13,'Bakers at ASU', 'bakers@asu.edu', '6024549234', 'BAC', 'Friday', '16:00', 'asubakers.com', '2013-04-05'),
(14,'Sustaninable Engergy Solutions', 'energy@asu.edu', '4328766123', 'SanTan Hall', 'Thursday', '16:00', 'joys.com', '2014-10-10'),
(15,'TECH Devils', 'techdevils@asu.edu', '3349877823', 'Fulton Center', 'Wednesday', '16:50', 'techdevils.com', '2013-11-01');


SET IDENTITY_INSERT Organizations OFF;

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
(2, 10),
(5,11),
(4, 12),
(6, 13),
(5, 14),
(6, 15);


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

INSERT INTO Users (UserID, ASUID, Password, PasswordSalt, LName, FName, Bio) VALUES
(1, 'pbuffet',        HASHBYTES('SHA2_512', 'January01@' + '1pbuffet'),      '1pbuffet', 'Buffet', 'Pheobe', 'Information Technology Student'),
(2, 'kclarkson',      HASHBYTES('SHA2_512', 'February8' + '2kclarkson'),     '2kclarkson', 'Clarkson', 'Kelly', 'Civil Engineering Student'),
(3, 'bpitt',          HASHBYTES('SHA2_512', 'March123@' + '3bpitt'),         '3bpitt', 'Pitt', 'Brad', 'Biomedical Student'),
(4, 'jlawrence',      HASHBYTES('SHA2_512', 'April09%' + '4jlawrence'),      '4jlawrence', 'Lawrence', 'Jennifer', 'Biodesign Student'),
(5, 'jtribianni',     HASHBYTES('SHA2_512', 'June123@' + '5jtribianni'),     '5jtribianni', 'Tribianni', 'Joey', 'Computer Science Student'),
(6, 'cbing',          HASHBYTES('SHA2_512', 'Flower##' + '6cbing'),          '6cbing', 'Bing', 'Chandler', 'Graphic Information technology Student'),
(7, 'rgeller',        HASHBYTES('SHA2_512', 'September9@' + '7rgeller'),     '7rgeller', 'Geller', 'Ross', 'Law Student'),
(8, 'rgreen',         HASHBYTES('SHA2_512', 'August!120' + '8rgreen'),       '8rgreen', 'Green', 'Rachel', 'Accounting Student'),
(9, 'mgeller',        HASHBYTES('SHA2_512', 'December%2' + '9mgeller'),      '9mgeller', 'Geller', 'Monica', 'Software Engineering Student'),
(10,'omunn',          HASHBYTES('SHA2_512', 'october003!' + '10omunn'),       '10omunn', 'Munn', 'Olivia', 'Real Estate Student'),
(11,'mkohl',          HASHBYTES('SHA2_512', 'purple365@' + '11mkohl'),        '11mkohl', 'Kohl', 'Melissa', ' Dance Student'),
(12,'arigby',         HASHBYTES('SHA2_512', 'tesla07!&' + '12arigby'),        '12arigby', 'Rigby', 'Adam', 'Digital Culture Student'),
(13,'ajolie',         HASHBYTES('SHA2_512', 'pitt760!&&' + '13ajolie'),       '13ajolie', 'Jolie', 'Angelina', 'Industrial Design Student'),
(14,'cphelps',        HASHBYTES('SHA2_512', 'summer2654' + '14cphelps'),      '14cphelps', 'Phelps', 'Chase', 'Music Student'),
(15,'kperry',         HASHBYTES('SHA2_512', 'paris085!' + '15kperry'),        '15kperry', 'Perry', 'katy', 'Theatre Student'),
(16,'jtimberlake',    HASHBYTES('SHA2_512', 'tennesse653' + '16jtimberlake'), '16jtimberlake', 'Timberlake', 'Justin', 'Visual Communication Student'),
(17,'jparsons',       HASHBYTES('SHA2_512', 'winter34!&' + '17jparsons'),     '17jparsons', 'Parsons', 'Jim', 'Construction Management Student'),
(18,'tcruise',        HASHBYTES('SHA2_512', 'topgun&&' + '18tcruise'),        '18tcruise', 'Cruise', 'Tom', 'Environmental Technology Management Student'),
(19,'ldicaprio',      HASHBYTES('SHA2_512', 'titanic58!' + '19ldicaprio'),    '19ldicaprio', 'DiCaprio', 'Leonardo', 'Software Engineering Student'),
(20,'hjackman',       HASHBYTES('SHA2_512', 'wolverine34!&' + '20hjackman'),  '20hjackman', 'Jackman', 'Hugh', 'Information Technology Student'), 
(21,'sjohansson',     HASHBYTES('SHA2_512', 'lucy986@!' + '21sjohansson'),    '21sjohansson', 'Johansson', 'Scarlett', 'Information Technology Student'),
(22,'mstreep',        HASHBYTES('SHA2_512', 'mamamia978!' + '22mstreep'),     '22mstreep', 'Streep', 'Meryl', 'Civil Engineering Student'),
(23,'nportman',       HASHBYTES('SHA2_512', 'blackswan234!' + '23nportman'),  '23nportman', 'Portman', 'Natalie', 'Biomedical Student'),
(24,'mmccarthy',      HASHBYTES('SHA2_512', 'spy000!' + '24mmccarthy'),       '24mmccarthy', 'McCarthy', 'Melissa', 'Biodesign Student'),
(25,'mfox',           HASHBYTES('SHA2_512', 'jonahhex6567!' + '25mfox'),      '25mfox', 'Fox', 'Megan', 'Computer Science Student'),
(26,'khudson',        HASHBYTES('SHA2_512', 'Bridewars111!' + '26khudson'),   '26khudson', 'Hudson', 'kate', 'Graphic Information technology Student'),
(27,'mdamon',         HASHBYTES('SHA2_512', 'departed986!' + '27mdamon'),     '27mdamon', 'Damon', 'Matt', 'Law Student'),
(28,'thanks',         HASHBYTES('SHA2_512', 'Sully*@@12!' + '28thanks'),      '28thanks', 'Hanks', 'Tom', 'Accounting Student'),
(29,'cbale',          HASHBYTES('SHA2_512', 'americanhustle5&&' + '29cbale'), '29cbale', 'Bale', 'Christian', 'Dance Student'),
(30,'jdepp',          HASHBYTES('SHA2_512', 'pirates876!' + '30jdepp'),       '30jdepp', 'Depp', 'Johnny', 'Theatre Student');

-- Ideally, PasswordSalt should be a true random string for each entry.
-- For our Proof-Of-Concept purposes, a concatenation of UserID and ASUID (Both of which are unique) will work.

-- UPDATE Users SET PasswordSalt = CONVERT(VARCHAR, UserID) + ASUID;

-- Use SHA2_512 with a concatenation of Password and PasswordSalt to generate a 20-byte Encrypted Password
-- UPDATE Users SET Password =  HASHBYTES('SHA2_512',Password + PasswordSalt)

SET IDENTITY_INSERT Users OFF;

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
(10, '5203228767'),
(11, '4800734576'),
(12, '6024768769'),
(13, '5202343222'),
(14, '6022343424'),
(15, '5202333234'),
(16, '4800999221'),
(17, '4809800094'),
(18, '6024200975'),
(19, '4804522334'),
(20, '5208676668'), 
(21, '4803342344'),
(22, '4562345524'),
(23, '5264563454'),
(24, '7865443322'),
(25, '4524565652'),
(26, '2454623444'),
(27, '6556322097'),
(28, '3452409424'),
(29, '2234875009'),
(30, '2230975234');


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
(10, 'omunn@asu.edu'),
(11, 'mkohl@asu.edu'),
(12, 'arigby@asu.edu'),
(13, 'ajolie@asu.edu'),
(14, 'cphelps@asu.edu'),
(15, 'kperry@asu.edu'),
(16, 'jtimberlake@asu.edu'),
(17, 'jparsons@asu.edu'),
(18, 'tcruise@asu.edu'),
(19, 'ldicaprio@asu.edu'),
(20, 'hjackman@asu.edu'),
(21, 'sjohansson@asu.edu'), 
(22, 'mstreep@asu.edu'),
(23, 'nportman@asu.edu'),
(24, 'mmccarthy@asu.edu'),
(25, 'mfox@asu.edu'),
(26, 'khudson@asu.edu'),
(27, 'mdamon@asu.edu'),
(28, 'thanks@asu.edu'),
(29, 'cbale@asu.edu'),
(30, 'jdepp@asu.edu');


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
(10, '1000'),
(11, '100'),
(12, '200'),
(13, '300'),
(14, '400'),
(15, '500'),
(16, '600'),
(17, '700'),
(18, '800'),
(19, '900'),
(20, '1000'),
(21, '100'),
(22, '200'),
(23, '300'),
(24, '400'),
(25, '500'),
(26, '600'),
(27, '700'),
(28, '800'),
(29, '900'),
(30, '1000');


INSERT INTO UserOrganization ( UserID, OrgID, Status) VALUES
(1, 3, 'Active'),
(1, 7, 'Active'),
(1, 10, 'Active'),
(2, 9, 'Active'),
(2, 15, 'Active'),
(2, 4, 'Active'),
(2, 2, 'Active'),
(3, 8, 'Active'),
(3, 1, 'Active'),
(3, 10, 'Active'),
(3, 7, 'Active'),
(4, 7, 'Active'),
(4, 9, 'Active'),
(4, 5, 'Active'),
(4, 12, 'Active'),
(5, 14, 'Active'),
(5, 4, 'Active'),
(5, 10, 'Active'),
(5, 8, 'Active'),
(6, 5, 'Active'),
(6, 2, 'Active'),
(6, 4, 'Active'),
(6, 13, 'Active'),
(6, 8, 'Active'),
(7, 4, 'Active'),
(7, 7, 'Active'),
(7, 9, 'Active'),
(7, 13, 'Active'),
(7, 15, 'Active'),
(8, 1, 'Active'),
(8, 4, 'Active'),
(8, 8, 'Active'),
(8, 10, 'Active'),
(8, 5, 'Active'),
(9, 2, 'Active'),
(9, 6, 'Active'),
(9, 10, 'Active'),
(9, 9, 'Active'),
(9, 4, 'Active'),
(10, 12, 'Active'),
(10, 11, 'Active'),
(10, 6, 'Active'),
(10, 3, 'Active'),
(10, 7,'Active'),
(11, 15, 'Active'),
(11, 5, 'Active'),
(11, 7, 'Active'),
(11, 9, 'Active'),
(12, 15, 'Active'),
(12, 3, 'Active'),
(12, 8, 'Active'),
(12, 6, 'Active'),
(12, 10, 'Active'),
(13, 14, 'Active'),
(13, 3, 'Active'),
(13, 8, 'Active'),
(13, 2, 'Active'),
(14, 3, 'Active'),
(14, 13, 'Active'),
(14, 8, 'Active'),
(14, 2, 'Active'),
(14, 10, 'Active'),
(15, 2, 'Active'),
(15, 1, 'Active'),
(15, 8, 'Active'),
(15, 10, 'Active'),
(15, 13, 'Active'),
(16, 1, 'Active'),
(16, 4, 'Active'),
(16, 3, 'Active'),
(16, 8, 'Active'),
(16, 9, 'Active'),
(17, 15, 'Active'),
(17, 12, 'Active'),
(17, 6, 'Active'),
(17, 8, 'Active'),
(17, 4, 'Active'),
(18, 2, 'Active'),
(18, 4, 'Active'),
(18, 7, 'Active'),
(18, 10,'Active'),
(18, 5, 'Active'),
(18, 12, 'Active'),
(19, 8, 'Active'),
(19, 4, 'Active'),
(19, 10, 'Active'),
(19, 1, 'Active'),
(19, 7, 'Active'),
(19, 12, 'Active'),
(19, 11, 'Active'),
(19, 2, 'Active'),
(20, 7, 'Active'),
(20, 9, 'Active'),
(20, 14, 'Active'),
(20, 12, 'Active'),
(20, 1, 'Active'),
(21, 6, 'Active'),
(21, 3, 'Active'),
(21, 8, 'Active'),
(21, 10, 'Active'),
(21, 11, 'Active'),
(21, 4, 'Active'),
(22, 13, 'Active'),
(22, 3, 'Active'),
(22, 7, 'Active'),
(22, 9, 'Active'),
(22, 2, 'Active'),
(23, 10, 'Active'),
(23, 5, 'Active'),
(23, 2, 'Active'),
(23, 6, 'Active'),
(23, 9, 'Active'),
(24, 5, 'Active'),
(24, 10, 'Active'),
(24, 13, 'Active'),
(24, 14, 'Active'),
(24, 2, 'Active'),
(24, 1, 'Active'),
(25, 3, 'Active'),
(25, 8, 'Active'),
(25, 11, 'Active'),
(25, 10, 'Active'),
(25, 2, 'Active'),
(25, 7, 'Active'),
(25, 5, 'Active'),
(25, 9, 'Active'),
(26, 11, 'Active'),
(26, 15, 'Active'),
(26, 2, 'Active'),
(26, 8, 'Active'),
(27, 12, 'Active'),
(27, 3, 'Active'),
(27, 5, 'Active'),
(27, 9, 'Active'),
(27, 10, 'Active'),
(28, 13, 'Active'),
(28, 3, 'Active'),
(28, 1, 'Active'),
(28, 2, 'Active'),
(29, 14, 'Active'),
(29, 5, 'Active'),
(29, 7, 'Active'),
(29, 4, 'Active'),
(30, 15, 'Active'),
(30, 2, 'Active'),
(30, 9, 'Active'),
(30, 7, 'Active'),
(30, 1, 'Active');

Update Events
Set Time= getdate();

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
(11, 'Passion in Action Summit', 'Topics include immigration and sustainability ', '15:00', 'Discovery', ''),
(12, 'Cisco Innovation Challenge', 'live pitch competition where students can win seed funding to start their ventures ', '16:30', 'Mercado C', ''),
(13, 'Cutural Festival', 'Come enjoy live performances, activities and food that is representative of the variety of cultures our students bring to the ASU community.', '10:00', 'WellsFargo Arena', ''),
(14, 'Ditch the Dumpster', 'donate and recycle unwanted items as they are moving out of their residence hall ', '9:00', 'Palo Verde Residence Hall', ''),
(15, 'Vault Gallery Photo Exhibit', 'The Downtown Phoenix campus library is pleased to exhibit the work of Ryan Carey', '16:00', 'Mercado E', '');

SET IDENTITY_INSERT Events OFF;


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
(10, 3),
(11, 11),
(12, 12),
(13,13),
(14,14),
(15,15);

SET IDENTITY_INSERT Categories ON;

INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1, 'Academic'),
(2, 'Biotechnology'),
(3, 'Community and Lifestyle'), 
(4, 'Data and Analytics'),
(5, 'Entrepreneurship/Innovation'),
(6, 'Financial Services'),
(7, 'International'),
(8, 'Political'),
(9, 'Science and Engineering'),
(10,'Sports'),
(11,'Sustainability');


SET IDENTITY_INSERT Categories OFF;

INSERT INTO CategoryOrganization (CategoryID , OrgID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 1);


SET IDENTITY_INSERT Documents ON;
INSERT INTO Documents (DocID, DocName, DocDesc, DocLink) VALUES
(1,  'Action for America_Doc',                       'Document for Action for America', ''),
(2,  'Active Minds at Arizona State University_Doc', 'Document for Active Minds at Arizona State University', ''),
(3,  'Adworks_Doc',                                  'Document for Adworks', ''),
(4,  'Aerospace Innovation Club_Doc',                'Document for Aerospace Innovation Club', ''),
(5,  'Alpha Chi Omega Sorority_Doc',                 'Document for Alpha Chi Omega Sorority', ''),
(6,  'Barrett Leadership and Service Team_Doc',      'Document for Barrett Leadership and Service Team', ''),
(7,  'Bhakti Yoga Club_Doc',                         'Document for Bhakti Yoga Club', ''),
(8,  'bioSyntagma_Doc',                              'Document for bioSyntagma', ''),
(9,  'Global Business Association_Doc',              'Document for Global Business Association', ''),
(10, 'JOYS_Doc',                                     'Document for JOYS', ''),
(11, 'Alpha Chi Omega Sorority_Doc',                 'Document for Alpha Chi Omega Sorority', ''),
(12, 'ASU Club Golf Team_Doc',                       'Document for ASU Club Golf Team', ''),
(13, 'Bakers at ASU_Doc',                            'Document for Bakers at ASU', ''),
(14, 'Sustaninable Engergy Solutions_Doc',           'Document for Sustaninable Engergy Solutions', ''),
(15, 'TECH Devils_Doc',                              'Document for TECH Devils', '');

SET IDENTITY_INSERT Documents OFF;


INSERT INTO DocumentOrganization (DocID, OrgID) VALUES
(1,  1),
(2,  2),
(3,  3),
(4,  4),
(5,  5),
(6,  6),
(7,  7),
(8,  8),
(9,  9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15);

INSERT INTO Roles (RoleID, Description) VALUES

(1, 'SuperAdmin'),
(2, 'OrgAdmin'),
(3, 'User');

INSERT INTO UserRoles (RoleID, UserID) VALUES
('1', '1'),
('2', '5'),
('2', '7'),
('3', '2'),
('3', '3'),
('3', '4'),
('3', '6'),
('3', '8'),
('3', '9'),
('3', '10'),
('3', '11'),
('3', '12'),
('3', '13'),
('3', '14'),
('3', '15'),
('3', '16'),
('3', '17'),
('3', '18'),
('3', '19'),
('3', '20'),
('3', '21'),
('3', '22'),
('3', '23'),
('3', '24'),
('3', '25'),
('3', '26'),
('3', '27'),
('3', '28'),
('3', '29'),
('3', '30');

----------------------------------------------
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
group by Categories.CategoryID,CategoryName;
GO

-------------------------------------------------
-- Create Stored Procedures:
-- Stored Procedure:
-- Return list of Organizations, their Categories and campus Name

EXEC sp_OrganizationCategoryCampus
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
end;
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
DECLARE @UserID INT;
DECLARE @RoleID INT;
SET @UserID = 0;
SET @RoleID = 0;
IF (SELECT Password from Users WHERE ASUID = @ASUID) IS NULL
SET @Result = 'NA'
ELSE
BEGIN
  IF (SELECT HASHBYTES('SHA2_512', @Password + PasswordSalt) FROM Users WHERE ASUID = @ASUID) =
    (SELECT Password FROM Users WHERE ASUID = @ASUID)
  BEGIN
    SET @Result = 'Success';
    SET @UserID = (SELECT UserID FROM Users WHERE ASUID = @ASUID);
	SET @RoleID = (SELECT r.RoleID FROM Users u JOIN UserRoles ur ON u.UserID = ur.UserID
                     JOIN Roles r ON r.RoleID = ur.RoleID WHERE u.UserID = @UserID)
  END
  ELSE SET @Result = 'Failure'
;END
SELECT @Result AS status, @UserID AS UserID, @RoleID AS RoleID;
-------------------------------------------------------------------------------------------------
/* Testing:
EXEC sp_ValidateUser 'pbuffet', 'January01@'
-- USING as Dynamic SQL:
DECLARE @ASUID VARCHAR(20);
DECLARE @Password VARCHAR(20);
DECLARE @SQLquery NVARCHAR(50);
SET @ASUID = 'tcruise'
SET @Password = 'topgun&&'

-- Implement below in login() function of Python in Django
SET @SQLQUERY = N'sp_ValidateUser ' + '''' + @ASUID + ''', ' + '''' + @Password + ''''
EXEC sp_executesql @SQLQUERY
*/

-----------------
-- This procedure returns list of events
-- for a given OrgID
GO
CREATE PROC sp_EventsForOrg
@OrgID INT
AS
BEGIN
  SELECT EventName, EventDesc FROM Events e
  JOIN EventOrganization eo ON e.EventID = eo.EventID
  JOIN Organizations o ON o.OrgID = eo.OrgID
  WHERE o.OrgID=@OrgID
END;
GO
-- Test:
-- EXEC sp_EventsForOrg 2