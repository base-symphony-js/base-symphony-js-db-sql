BEGIN TRY
    BEGIN TRANSACTION;

    -- DROP TABLES
    DROP TABLE [security].[Otps];
    DROP TABLE [security].[CustomPermissions];
    DROP TABLE [security].[Actions];
    DROP TABLE [security].[Permissions];
    DROP TABLE [security].[UsersOnRoles];
    DROP TABLE [security].[Roles];
    DROP TABLE [security].[Users];

    -- DROP SCHEMAS
    EXEC sp_executesql N'DROP SCHEMA [security]';;

    -- COMMIT
    COMMIT TRANSACTION;
    PRINT '> The tables have been deleted';
    END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH