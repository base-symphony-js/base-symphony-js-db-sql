BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE [dbo].[Roles] (
        [roleId]                          INTEGER IDENTITY(1,1) NOT NULL,
        [name]                            VARCHAR(100) NULL,
        [description]                     VARCHAR(500) NULL,
        [createdBy]                       VARCHAR(50) NULL,
        [createdAt]                       DATETIME NULL,
        [modifiedBy]                      VARCHAR(50) NULL,
        [modifiedAt]                      DATETIME NULL,
        [status]                          INTEGER NULL,
        CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED ([roleId])
    );

    CREATE TABLE [dbo].[Users] (
        [userId]                          INTEGER IDENTITY(1,1) NOT NULL,
        [firstName]                       VARCHAR(100) NULL,
        [lastName]                        VARCHAR(100) NULL,
        [email]                           VARCHAR(50) NULL,
        [birthdate]                       DATETIME NULL,
        [roleId]                          INTEGER NULL,
        [createdBy]                       VARCHAR(50) NULL,
        [createdAt]                       DATETIME NULL,
        [modifiedBy]                      VARCHAR(50) NULL,
        [modifiedAt]                      DATETIME NULL,
        [status]                          INTEGER NULL,
        CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([userId]),
        CONSTRAINT [FK_Users_Roles] FOREIGN KEY ([roleId])
            REFERENCES [dbo].[Roles]([roleId])
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
    );

    -- COMMIT
    COMMIT TRANSACTION;
    PRINT '> The tables have been created.';
    END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH