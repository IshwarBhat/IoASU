/*
Trigger to drop document from Documents table when
the record is deleted from DocumentOrganization table.
*/
GO
CREATE TRIGGER DocumentDropTrigger
ON DocumentOrganization
FOR DELETE AS
   BEGIN
   DELETE FROM Documents WHERE DocID=(SELECT DocID FROM deleted)
   END;

-- Test:
DELETE FROM DocumentOrganization WHERE DocID = 17
SELECT * FROM Documents