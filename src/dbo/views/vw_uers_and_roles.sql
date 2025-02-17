CREATE OR ALTER VIEW [dbo].[vw_uers_and_roles]
AS
SELECT
    T1.userId AS userId,
    T1.firstName AS firstName,
    T1.lastName AS lastName,
    T1.email AS email,
    T2.name AS roleName,
    T1.status AS status
FROM [dbo].[Users] T1
INNER JOIN [dbo].[Roles] T2 ON T1.roleId = T2.roleId
