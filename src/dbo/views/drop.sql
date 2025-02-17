BEGIN TRY
    BEGIN TRANSACTION;

    -- DROP PROCEDURES
    DROP VIEW [dbo].[vw_uers_and_roles]

    -- COMMIT
    COMMIT TRANSACTION;
    PRINT '> The store views have been deleted';
    END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH