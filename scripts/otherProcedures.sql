-- Stored Procedure: Uploading Documents
-- Given OrgID, DocName, DocDesc
-- Insert into Documents and DocumentOrganization tables
GO
CREATE PROC sp_DocumentUpload
@OrgID INT,
@DocName varchar(255),
@DocDesc varchar(255)
AS
BEGIN
DECLARE @ScopeIdentity INT;
INSERT INTO Documents (DocName, DocDesc, DocLink) VALUES (@DocName,@DocDesc, '');
SELECT @ScopeIdentity=SCOPE_IDENTITY();
INSERT INTO DocumentOrganization (DocID, OrgID) VALUES (@ScopeIdentity, @OrgID);
END

EXEC sp_DocumentUpload 1, 'TestName1','Test Desc 1';