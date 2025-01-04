BEGIN TRY
    BEGIN TRANSACTION;

    -- CREATE SCHEMAS
    EXEC sp_executesql N'CREATE SCHEMA [security]';

    -- CREATE TABLES
    -- [security].[Users]
    CREATE TABLE [security].[Users] (
        [id]                    INT NOT NULL IDENTITY(1, 1),
        [firstName]             VARCHAR(100) NOT NULL,
        [lastName]              VARCHAR(100),
        [email]                 VARCHAR(50) UNIQUE NOT NULL,
        [phoneNumber]           VARCHAR(30),
        [password]              VARCHAR(100),
        [passwordVersion]       INT NOT NULL DEFAULT 0,
        [incorrectPassword]     INT DEFAULT 0,
        [photo]                 VARCHAR(255),
        [refreshToken]          VARCHAR(4000),
        [state]                 BIT NOT NULL,
        [createdAt]             DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
        [createdById]           INT,
        [updatedAt]             DATETIME2,
        [updatedById]           INT,
        CONSTRAINT [Users_pkey] PRIMARY KEY CLUSTERED ([id]),
        CONSTRAINT [Users_createdById_fkey] FOREIGN KEY ([createdById]) REFERENCES [security].[Users]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION,
        CONSTRAINT [Users_updatedById_fkey] FOREIGN KEY ([updatedById]) REFERENCES [security].[Users]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
    );

    -- [security].[Roles]
    CREATE TABLE [security].[Roles] (
        [id]                    INT NOT NULL IDENTITY(1, 1),
        [type]                  VARCHAR(25) NOT NULL,
        [title_en]              VARCHAR(50) NOT NULL,
        [title_es]              VARCHAR(50) NOT NULL,
        [description_en]        VARCHAR(255),
        [description_es]        VARCHAR(255),
        [state]                 BIT NOT NULL,
        [createdAt]             DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
        [createdById]           INT,
        [updatedAt]             DATETIME2,
        [updatedById]           INT,
        CONSTRAINT [Roles_pkey] PRIMARY KEY CLUSTERED ([id]),
        CONSTRAINT [Roles_createdById_fkey] FOREIGN KEY ([createdById]) REFERENCES [security].[Users]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION,
        CONSTRAINT [Roles_updatedById_fkey] FOREIGN KEY ([updatedById]) REFERENCES [security].[Users]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
    );

    -- [security].[UsersOnRoles]
    CREATE TABLE [security].[UsersOnRoles] (
        [userId]                INT NOT NULL,
        [roleId]                INT NOT NULL,
        CONSTRAINT [UsersOnRoles_pkey] PRIMARY KEY CLUSTERED ([userId], [roleId]),
        CONSTRAINT [UsersOnRoles_userId_fkey] FOREIGN KEY ([userId]) REFERENCES [security].[Users]([id]) ON DELETE CASCADE,
        CONSTRAINT [UsersOnRoles_roleId_fkey] FOREIGN KEY ([roleId]) REFERENCES [security].[Roles]([id]) ON DELETE CASCADE
    );;
    CREATE INDEX IX_UsersOnRoles_userId ON [security].[UsersOnRoles]([userId]);
    CREATE INDEX IX_UsersOnRoles_roleId ON [security].[UsersOnRoles]([roleId]);

    -- [security].[Permissions]: Permissions Table (unified for modules, sections, and subsections)
    CREATE TABLE [security].[Permissions] (
        [id]                    INT NOT NULL IDENTITY(1,1),
        [parentId]              INT NULL,
        [name]                  VARCHAR(100) NOT NULL,
        [title_en]              VARCHAR(100) NOT NULL,
        [title_es]              VARCHAR(100) NOT NULL,
        [description_en]        VARCHAR(255),
        [description_es]        VARCHAR(255),
        CONSTRAINT [Permissions_pkey] PRIMARY KEY CLUSTERED ([id]),
        CONSTRAINT [Permissions_parent_fkey] FOREIGN KEY ([parentId]) REFERENCES [security].[Permissions]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION,
        CONSTRAINT [Permissions_unique_name] UNIQUE ([name])
    );

    -- [security].[Actions]: Actions Table (to define possible actions on permissions)
    CREATE TABLE [security].[Actions] (
        [id]                    INT NOT NULL IDENTITY(1,1),
        [name]                  VARCHAR(50) NOT NULL,
        [title_en]              VARCHAR(50) NOT NULL,
        [title_es]              VARCHAR(50) NOT NULL,
        [description_en]        VARCHAR(255),
        [description_es]        VARCHAR(255),
        CONSTRAINT [Actions_pkey] PRIMARY KEY CLUSTERED ([id]),
        CONSTRAINT [Actions_unique_name] UNIQUE ([name])
    );

    -- [security].[CustomPermissions]: CustomPermissions Table (to associate custom permissions with roles and actions on them)
    CREATE TABLE [security].[CustomPermissions] (
        [roleId]                INT NOT NULL,
        [permissionId]          INT NOT NULL,
        [actionId]              INT NOT NULL,
        CONSTRAINT [CustomPermissions_pkey] PRIMARY KEY CLUSTERED ([roleId], [permissionId], [actionId]),
        CONSTRAINT [CustomPermissions_role_fkey] FOREIGN KEY ([roleId]) REFERENCES [security].[Roles]([id]) ON DELETE CASCADE,
        CONSTRAINT [CustomPermissions_permission_fkey] FOREIGN KEY ([permissionId]) REFERENCES [security].[Permissions]([id]) ON DELETE CASCADE,
        CONSTRAINT [CustomPermissions_action_fkey] FOREIGN KEY ([actionId]) REFERENCES [security].[Actions]([id]) ON DELETE CASCADE
    );

    -- [security].[Otps]
    CREATE TABLE [security].[Otps] (
        [id]                    INT NOT NULL IDENTITY(1, 1),
        [email]                 VARCHAR(255) NOT NULL,
        [otp]                   VARCHAR(6) NOT NULL,
        [createdAt]             DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
        [expiresAt]             DATETIME2 NOT NULL,
        CONSTRAINT [Otps_pkey] PRIMARY KEY CLUSTERED ([id])
    );

    COMMIT TRANSACTION;
    PRINT '> The tables have been created.';
    END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH