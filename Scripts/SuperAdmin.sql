--View for campuses and number of organizations on each campus 

create view CampusOrganizationCountView as
select Campuses.CampusID,CampusName,count(*) as 'Number of organizations'
from Campuses inner join CampusOrganization
on
Campuses.CampusID=CampusOrganization.CampusID
group by Campuses.CampusID,CampusName

--View for categories and number of organizations

create view CategoryOrganizationCountView as
select Categories.CategoryID,CategoryName,count(*) as 'Number of organizations'
from Categories inner join CategoryOrganization
on
Categories.CategoryID=CategoryOrganization.CategoryID
group by Categories.CategoryID,CategoryName

--Stored procedure with CTE for organizations with respective campus and category

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
end

exec sp_OrganizationCategoryCampus


