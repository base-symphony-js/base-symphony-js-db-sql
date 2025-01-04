CREATE TRIGGER AuditUsers
ON Users
FOR INSERT, UPDATE
AS
DECLARE @UserId INT
DECLARE @FirstName VARCHAR(100)
DECLARE @LastName VARCHAR(100)
DECLARE @Email VARCHAR(50)
DECLARE @Birthdate DATETIME
DECLARE @RoleId INT
DECLARE @CreatedBy VARCHAR(50)
DECLARE @CreatedAt DATETIME
DECLARE @ModifiedBy VARCHAR(50)
DECLARE @ModifiedAt DATETIME
DECLARE @Status INT
DECLARE @RoleName VARCHAR(100)
DECLARE @RoleDescription VARCHAR(500)
DECLARE @CreatorUsername VARCHAR(50)
DECLARE @Action VARCHAR(10)
DECLARE @Date DATETIME

-- Capture the type of action (INSERT or UPDATE)
IF EXISTS (SELECT * FROM Inserted) AND NOT EXISTS (SELECT * FROM Deleted)
BEGIN
    SET @Action = 'INSERT'
END
ELSE IF EXISTS (SELECT * FROM Inserted) AND EXISTS (SELECT * FROM Deleted)
BEGIN
    SET @Action = 'UPDATE'
END

-- Assign variables from the Inserted table (for INSERT or UPDATE actions)
SET @UserId = (SELECT userId FROM Inserted)
SET @FirstName = (SELECT firstName FROM Inserted)
SET @LastName = (SELECT lastName FROM Inserted)
SET @Email = (SELECT email FROM Inserted)
SET @Birthdate = (SELECT birthdate FROM Inserted)
SET @RoleId = (SELECT roleId FROM Inserted)
SET @CreatedBy = (SELECT createdBy FROM Inserted)
SET @CreatedAt = (SELECT createdAt FROM Inserted)
SET @ModifiedBy = (SELECT modifiedBy FROM Inserted)
SET @ModifiedAt = (SELECT modifiedAt FROM Inserted)
SET @Status = (SELECT status FROM Inserted)

-- Get Role Information for logging if needed (for both INSERT and UPDATE)
SET @RoleName = (SELECT name FROM Roles WHERE roleId = @RoleId)
SET @RoleDescription = (SELECT description FROM Roles WHERE roleId = @RoleId)

-- Capture the current system user (who is performing the action)
SET @CreatorUsername = (SELECT system_user)
SET @Date = (SELECT GETDATE())

-- Insert into the Audit table
-- This table should have columns for action type, user info, role info, and who performed the action.
INSERT INTO AuditTblUsers
(
    UserId, FirstName, LastName, Email, Birthdate, RoleId, RoleName, RoleDescription,
    CreatedBy, CreatedAt, ModifiedBy, ModifiedAt, Status, Action, CreatorUsername, Date
)
VALUES
(
    @UserId, @FirstName, @LastName, @Email, @Birthdate, @RoleId, @RoleName, @RoleDescription,
    @CreatedBy, @CreatedAt, @ModifiedBy, @ModifiedAt, @Status, @Action, @CreatorUsername, @Date
)
