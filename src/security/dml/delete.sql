BEGIN TRY
    BEGIN TRANSACTION;

    DELETE FROM [security].[Otps]
    DBCC CHECKIDENT('security.Otps', RESEED, 0);
    DELETE FROM [security].[CustomPermissions]
    DBCC CHECKIDENT('security.CustomPermissions', RESEED, 0);
    DELETE FROM [security].[Actions]
    DBCC CHECKIDENT('security.Actions', RESEED, 0);
    DELETE FROM [security].[Permissions]
    DBCC CHECKIDENT('security.Permissions', RESEED, 0);
    DELETE FROM [security].[UsersOnRoles]
    DELETE FROM [security].[Roles]
    DBCC CHECKIDENT('security.Roles', RESEED, 0);
    DELETE FROM [security].[Users]
    DBCC CHECKIDENT('security.Users', RESEED, 0);

    COMMIT TRANSACTION;
    PRINT '> The tables have been emptied.';
    END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH