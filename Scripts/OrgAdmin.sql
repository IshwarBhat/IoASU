drop proc spUserList
create proc sp_UserList
@OrgID int
as
begin
with UsersCTE as
(
	select UserID,ASUID,Lname,Fname from Users
),
EmailsCTE as
(
	select * from UserEmails where right(Email,7) = 'asu.edu' 
),
UserEmailOrganizationCTE as
(
	select u.UserID,u.ASUID,u.Lname,u.Fname,e.Email from UsersCTE as u 
	inner join
	EmailsCTE as e
	on
	u.UserID=e.UserID
	inner join UserOrganization as uo
	on 
	uo.UserID=e.UserID and uo.OrgID = @OrgID
)
select * from UserEmailOrganizationCTE;
end

Exec sp_UserList 5

create proc sp_DocList
@OrgID int
as
begin
select DocName,DocLink from Documents where DocID in 
(select DocID from DocumentOrganization where OrgID=@OrgID)
end

exec sp_DocList 6

create proc sp_EventList
@OrgID int
as
begin
select * from Events where EventID in 
(select EventID from EventOrganization where OrgID=@OrgID)
end

exec sp_EventList 6

create proc sp_DocumentUpload
@DocName varchar(255),
@DocDesc varchar(255),
@LastIdentity int output
as
begin
insert into Documents (DocName,DocDesc) values(@DocName,@DocDesc);
select @LastIdentity=@@IDENTITY
end

declare @l int;
exec sp_DocumentUpload 'Hello','Hello World',@l output;
print @l


