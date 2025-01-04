BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO [dbo].[Roles] (
        name,
        description,
        createdBy,
        createdAt,
        status
    ) VALUES
    ('Super User', 'User who by default has all privileges to access the system.', 'system', GETDATE(), 1),
    ('User Administrator', 'User who has access to view and manage all users in the system.', 'system', GETDATE(), 1);

    INSERT INTO [dbo].[Users] (
        firstName,
        lastName,
        email,
        birthdate,
        roleId,
        createdBy,
        createdAt,
        status
    ) VALUES
    ('John', 'Doe', 'jdoe@example.com', '2000-01-01', 1, 'system', GETDATE(), 1);

    COMMIT TRANSACTION;
    PRINT '> The tables have been populated.';
    END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH