-- Emails Cursor
-- Description: Given a particular organization, this cursor 
--              sends an email to all the users one-by-one
--              about the latest event in the organization.

DECLARE @OrgID INT,
  @currentEmail VARCHAR(255),
  @FirstName VARCHAR(255),
  @LastName VARCHAR(255),
  @EventName VARCHAR(255),
  @EventDesc VARCHAR(255),
  @EventTime VARCHAR(255),
  @EventVenue VARCHAR(255),
  @hello VARCHAR(100),
  @subject VARCHAR(255),
  @message VARCHAR(1000);
PRINT '-------- User Emails --------';

-- Pass OrgID dynamically here.
SET @OrgID = 1;
SELECT @EventName = EventName, @EventDesc = EventDesc,
  @EventTime = Time, @EventVenue = Venue
  FROM Events WHERE EventID IN
 (SELECT TOP 1 EventID FROM EventOrganization WHERE OrgID = @OrgID);
DECLARE emails_cursor CURSOR FOR   
SELECT Email, u.FName, LName FROM UserEmails ue 
JOIN Users u ON ue.UserID = u.UserID
WHERE ue.UserID IN
  (SELECT UserID FROM UserOrganization WHERE OrgID = @OrgID);

OPEN emails_cursor

FETCH NEXT FROM emails_cursor
INTO @currentEmail, @FirstName, @LastName

WHILE @@FETCH_STATUS = 0  
BEGIN  
    PRINT ' '
	SELECT @hello   = 'Hi ' + @FirstName + ' ' + @LastName + ',' + CHAR(13)+CHAR(10)
	SELECT @subject   = 'Subject: ' + @EventName + CHAR(13)+CHAR(10)
    SELECT @message = 'You are invited to this event! Details: ' + @EventDesc + CHAR(13)+CHAR(10)
	                     + 'Time: ' + @EventTime + CHAR(13)+CHAR(10)
						 + 'Venue: ' + @EventVenue + CHAR(13)+CHAR(10)
						 + 'Hope to see you there!' + CHAR(13)+CHAR(10)
						 + 'Bye.'
     
    PRINT '<'+@currentEmail+'>' + CHAR(13)+CHAR(10)+ @hello + @subject + @message

        -- Get the next user.  
    FETCH NEXT FROM emails_cursor
    INTO @currentEmail, @FirstName, @LastName
END   
CLOSE emails_cursor;  
DEALLOCATE emails_cursor;
