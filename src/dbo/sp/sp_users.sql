CREATE OR ALTER PROCEDURE [dbo].[sp_users] (
    -- Operation parameters
    @pnOperationType VARCHAR(50), -- [GET-ALL, GET-SINGLE, CREATE, UPDATE, INACTIVATE, DELETE]
    @pcUser VARCHAR(50) = NULL, -- User performing the operation

    -- Parameters indicating the value of a column in a record
    @pnIdUser INT = NULL,
    @pcFirstName VARCHAR(100) = NULL,
    @pcLastName VARCHAR(100) = NULL,
    @pcEmail VARCHAR(100) = NULL,
    @pdBirthdate DATETIME = NULL,
    @pnIdRole INT = NULL,
    @pnStatus INT = NULL,

    -- Output parameters
    @pnResultType INT OUT, -- Parameter returning the execution status of the SP [0: Success | 1: Controlled Error | 2: Uncontrolled Error]
    @pcResult VARCHAR(MAX) OUT, -- Parameter returning the result of the Stored Procedure
    @pcMessage VARCHAR(MAX) OUT -- Parameter returning an informational, error, or success message
)
AS 
    -- Utility variables
    DECLARE @cctkProcedureName        VARCHAR(200) = 'dbo.sp_users';
    DECLARE @vcTempError              VARCHAR(4000);

    -- Result codes
    DECLARE @cnSuccessfulResult       INT = 0;
    DECLARE @cnControlledErrorResult INT = 1;
    DECLARE @cnUncontrolledErrorResult INT = 2;

    -- Record status codes
    DECLARE @cnInactiveRecord        INT = 0;
    DECLARE @cnActiveRecord          INT = 1;

BEGIN
    BEGIN TRY
        -- Parameter validation
        SET @vcTempError = 'Error validating the parameters';
        SET @pcMessage = '';

        SET @pcResult = dbo.rn_users(
            @pnOperationType,
            @pcUser,
            @pnIdUser,
            @pcFirstName,
            @pcLastName,
            @pcEmail,
            @pdBirthdate,
            @pnIdRole,
            @pnStatus
        );
        IF @pcResult <> '' AND @pcResult IS NOT NULL BEGIN
            SET @pnResultType = @cnControlledErrorResult;
            RETURN;
        END;

        BEGIN TRANSACTION;

        -- GET-ALL
        IF @pnOperationType = 'GET-ALL' BEGIN
            SET @vcTempError = 'Error retrieving information from the table';
            SELECT
                U.userId,
                U.firstName,
                U.lastName,
                U.email,
                (
                    SELECT name FROM Roles R
                    WHERE R.roleId = U.roleId
                ) AS Role,
                U.status
            FROM Users U;
            SET @pnResultType = @cnSuccessfulResult;
            SET @pcResult = 'BD_SUCCESS_GET';
        END;

        -- GET-SINGLE
        IF @pnOperationType = 'GET-SINGLE' BEGIN
            SET @vcTempError = 'Error retrieving the record information';
            SELECT
                U.userId,
                U.firstName,
                U.lastName,
                U.birthdate,
                U.email,
                U.roleId,
                U.createdBy,
                U.createdAt,
                U.modifiedBy,
                U.modifiedAt,
                U.status
            FROM Users U
            WHERE U.userId = @pnIdUser;
            SELECT
                R.roleId,
                R.name,
                R.description
            FROM Roles R;
            SET @pnResultType = @cnSuccessfulResult;
            SET @pcResult = 'BD_SUCCESS_GET';
        END;
        
        -- CREATE
        IF @pnOperationType = 'CREATE' BEGIN
            SET @vcTempError = 'Error creating a new record';
            INSERT INTO Users (
                firstName,
                lastName,
                email,
                birthdate,
                roleId,
                createdBy,
                createdAt,
                status
            ) VALUES (
                @pcFirstName,
                @pcLastName,
                @pcEmail,
                @pdBirthdate,
                @pnIdRole,
                @pcUser,
                GETDATE(),
                @pnStatus
            );
            SET @pnResultType = @cnSuccessfulResult;
            SET @pcResult = 'BD_SUCCESS_CREATE';
        END;
        
        -- UPDATE
        IF @pnOperationType = 'UPDATE' BEGIN
            SET @vcTempError = 'Error modifying the record data';
            UPDATE Users SET
                firstName = @pcFirstName,
                lastName = @pcLastName,
                email = @pcEmail,
                birthdate = @pdBirthdate,
                roleId = @pnIdRole,
                modifiedBy = @pcUser,
                modifiedAt = GETDATE(),
                status = @pnStatus
            WHERE userId = @pnIdUser;
            SET @pnResultType = @cnSuccessfulResult;
            SET @pcResult = 'BD_SUCCESS_UPDATE';
        END;

        -- INACTIVATE
        IF @pnOperationType = 'INACTIVATE' BEGIN 
            SET @vcTempError = 'Error inactivating the record';
            UPDATE Users SET
                modifiedBy = @pcUser,
                modifiedAt = GETDATE(),
                status = @cnInactiveRecord
            WHERE userId = @pnIdUser;
            SET @pnResultType = @cnSuccessfulResult;
            SET @pcResult = 'BD_SUCCESS_DISABLE';
        END;

        -- DELETE
        IF @pnOperationType = 'DELETE' BEGIN 
            SET @vcTempError = 'Error deleting the record';
            DELETE Users WHERE userId = @pnIdUser;
            SET @pnResultType = @cnSuccessfulResult;
            SET @pcResult = 'BD_SUCCESS_DELETE';
        END;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @pnResultType = @cnUncontrolledErrorResult;
        SET @pcResult = 'BD_SUCCESS_ERROR'
        SET @pcMessage = CONCAT(@pcMessage, ' - ', @vcTempError, ' - ErrorMessage:', ERROR_MESSAGE(),' - ErrorLine:', ERROR_LINE());
    END CATCH
END
