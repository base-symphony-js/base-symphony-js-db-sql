BEGIN TRY
    BEGIN TRANSACTION;

    -- DROP PROCEDURES
    DROP PROCEDURE [dbo].[sp_users]
    DROP PROCEDURE [dbo].[sp_roles]

    -- COMMIT
    COMMIT TRANSACTION;
    PRINT '> The store procedures have been deleted';
    END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH