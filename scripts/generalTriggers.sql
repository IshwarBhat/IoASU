/*
Trigger to drop document from Documents table when
the record is deleted from DocumentOrganization table.
*/
GO
CREATE TRIGGER DocumentDrop_Trigger
ON DocumentOrganization
FOR DELETE AS
   BEGIN
   DELETE FROM Documents WHERE DocID=(SELECT DocID FROM deleted)
   END;

-- Test:
-- DELETE FROM DocumentOrganization WHERE DocID = 17
-- SELECT * FROM Documents

/*
INSTEAD OF Trigger to encrypt passwords whenever a
new entry happens to the Users table.
*/

/*
CREATE TRIGGER PasswordEncrypt_Trigger
ON Users

*/