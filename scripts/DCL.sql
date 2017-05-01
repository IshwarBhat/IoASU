USE IoASU;

CREATE LOGIN SuperAdmin WITH PASSWORD = '8SuNy<76G,', 
DEFAULT_DATABASE = IoASU,
CHECK_EXPIRATION =ON,
CHECK_POLICY =ON;

CREATE USER SuperAdmin;

-- SuperAdmin can perform any activity on IoASU Database
GRANT ALTER ON DATABASE::IoASU
TO SuperAdmin;
 
 ---------------------------------------------------------------------------
-- General User, who uses the mobile application.
-- This user has permissions to view, insert and update tables in dbo schema.
CREATE LOGIN JustAnotherUser WITH PASSWORD = '<AK31r-B8C',
DEFAULT_DATABASE = IoASU,
CHECK_EXPIRATION =ON,
CHECK_POLICY =ON;

CREATE USER JustAnotherUser;

GRANT SELECT, UPDATE, INSERT
ON SCHEMA::dbo
TO JustAnotherUser;
