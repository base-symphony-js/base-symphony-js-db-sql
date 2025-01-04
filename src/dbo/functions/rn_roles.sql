CREATE OR ALTER FUNCTION [dbo].[rn_roles] (
    -- Operation parameters
    @pnOperationType VARCHAR(50), -- [GET-ALL, GET-SINGLE, CREATE, UPDATE, INACTIVATE, DELETE]
    @pcUser VARCHAR(50) = NULL,

    -- Parameters that indicate the value of a column in a record
    @pnRoleId INT = NULL,
    @pcName VARCHAR(100) = NULL,
    @pcDescription VARCHAR(100) = NULL,
    @pnStatus INT = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    -- Output message
    DECLARE @vcMessage                      VARCHAR(MAX) = '';
    DECLARE @vnCount		                INT = 0;

    -- Result codes
    DECLARE @cnSuccessfulResult             INT = 0;
    DECLARE @cnControlledErrorResult        INT = 1;
    DECLARE @cnUncontrolledErrorResult      INT = 2;

    -- Record status codes
    DECLARE @cnInactiveRecord               INT = 0;
    DECLARE @cnActiveRecord                 INT = 1;

    -- Validation of main parameters
    IF(@pnOperationType IS NULL) BEGIN
        SET @vcMessage = @vcMessage + '@pnOperationType, ';
    END;
    IF(@pcUser IS NULL) BEGIN
        SET @vcMessage = @vcMessage + '@pcUser, ';
    END;
    IF @vcMessage <> '' BEGIN
        RETURN 'BD_WARNING_EMPTY_PRINCIPAL_PARAMETERS';
    END;

    -- Validate the operation type
    IF
        @pnOperationType NOT IN ('GET-ALL', 'GET-SINGLE', 'CREATE', 'UPDATE', 'INACTIVATE', 'DELETE')
    BEGIN
        RETURN 'BD_WARNING_INVALID_OPERATION';
    END;

    SELECT @vnCount = COUNT(*) FROM Roles R
    WHERE R.roleId = @pnRoleId;

    -- GET-SINGLE
    IF @pnOperationType = 'GET-SINGLE' BEGIN
        IF @pnRoleId IS NULL BEGIN
            SET @vcMessage = @vcMessage + '@pnRoleId, ';
        END;
        IF @vcMessage <> '' BEGIN
            RETURN 'BD_WARNING_EMPTY_PARAMETERS';
        END;
        IF @vnCount = 0 BEGIN
            RETURN 'BD_ROLES_INVALID_ID';
        END;
    END;

    -- CREATE
    IF @pnOperationType = 'CREATE' BEGIN
        IF @pcName IS NULL BEGIN
            SET @vcMessage = @vcMessage + '@pcName, ';
        END;
        IF @pcDescription IS NULL BEGIN
            SET @vcMessage = @vcMessage + '@pcDescription, ';
        END;
        IF @pnStatus IS NULL BEGIN
            SET @vcMessage = @vcMessage + '@pnStatus, ';
        END;
        IF @vcMessage <> '' BEGIN
            RETURN 'BD_WARNING_EMPTY_PARAMETERS';
        END;
    END;

    -- UPDATE
    IF @pnOperationType = 'UPDATE' BEGIN
        IF @pnRoleId IS NULL BEGIN
            SET @vcMessage = @vcMessage + '@pnRoleId, ';
        END;
        IF @pcName IS NULL BEGIN
            SET @vcMessage = @vcMessage + '@pcName, ';
        END;
        IF @pcDescription IS NULL BEGIN
            SET @vcMessage = @vcMessage + '@pcDescription, ';
        END;
        IF @pnStatus IS NULL BEGIN
            SET @vcMessage = @vcMessage + '@pnStatus, ';
        END;
        IF @vcMessage <> '' BEGIN
            RETURN 'BD_WARNING_EMPTY_PARAMETERS';
        END;
        IF @vnCount = 0 BEGIN
            RETURN 'BD_ROLES_INVALID_ID';
        END;
    END;

    -- INACTIVATE
    IF @pnOperationType = 'INACTIVATE' BEGIN
        IF @pnRoleId IS NULL BEGIN
            SET @vcMessage = @vcMessage + '@pnRoleId, ';
        END;
        IF @vcMessage <> '' BEGIN
            RETURN 'BD_WARNING_EMPTY_PARAMETERS';
        END;
        IF @vnCount = 0 BEGIN
            RETURN 'BD_ROLES_INVALID_ID';
        END;
    END;

    -- DELETE
    IF @pnOperationType = 'DELETE' BEGIN
        IF @pnRoleId IS NULL BEGIN
            SET @vcMessage = @vcMessage + '@pnRoleId, ';
        END;
        IF @vcMessage <> '' BEGIN
            RETURN 'BD_WARNING_EMPTY_PARAMETERS';
        END;
        IF @vnCount = 0 BEGIN
            RETURN 'BD_ROLES_INVALID_ID';
        END;
    END;

    RETURN '';
END;
