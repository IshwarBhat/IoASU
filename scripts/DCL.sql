USE IoASU;

CREATE LOGIN SuperAdmin WITH PASSWORD = '8SuNy<76G,', 
DEFAULT_DATABASE = IoASU,
CHECK_EXPIRATION =ON,
CHECK_POLICY =ON;

CREATE USER SuperAdmin;

-- SuperAdmin can perform any activity on IoASU Database
GRANT ALTER ON DATABASE::IoASU
TO SuperAdmin;
 
