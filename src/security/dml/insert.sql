BEGIN TRY
    BEGIN TRANSACTION;

    -- Insert records into [security].[Actions] table
    INSERT INTO [security].[Actions] ([name], [title_en], [title_es], [description_en], [description_es]) VALUES
    ('read', 'Read', 'Leer', 'Permission to view or consult information', 'Permiso para ver o consultar información'),
    ('add', 'Add', 'Agregar', 'Permission to create new records or entities', 'Permiso para crear nuevos registros o entidades'),
    ('edit', 'Edit', 'Editar', 'Permission to modify existing records or entities', 'Permiso para modificar registros o entidades existentes'),
    ('delete', 'Delete', 'Eliminar', 'Permission to remove records or entities', 'Permiso para eliminar registros o entidades');


    -- Insert records into [security].[Permissions] table
    -- Security
    INSERT INTO [security].[Permissions] ([parentId], [name], [title_en], [title_es], [description_en], [description_es]) VALUES
    (NULL, 'security', 'Security', 'Seguridad', 'Permission to manage security module', 'Permiso para gestionar el módulo de seguridad');

    DECLARE @SecurityModuleId INT = (SELECT [id] FROM [security].[Permissions] WHERE [name] = 'security');
    INSERT INTO [security].[Permissions] ([parentId], [name], [title_en], [title_es], [description_en], [description_es]) VALUES
    (@SecurityModuleId, 'users', 'Users', 'Usuarios', 'Permission to manage users in the security module', 'Permiso para gestionar usuarios en el módulo de seguridad'),
    (@SecurityModuleId, 'roles', 'Roles', 'Roles', 'Permission to manage roles in the security module', 'Permiso para gestionar roles en el módulo de seguridad'),
    (@SecurityModuleId, 'permissions', 'Permissions', 'Permisos', 'Permission to manage permissions in the security module', 'Permiso para gestionar permisos en el módulo de seguridad');

    -- Logistics
    INSERT INTO [security].[Permissions] ([parentId], [name], [title_en], [title_es], [description_en], [description_es]) VALUES
    (NULL, 'logistics', 'Logistics', 'Logística', 'Permission to manage logistics module', 'Permiso para gestionar el módulo de logística');

    DECLARE @LogisticsModuleId INT = (SELECT [id] FROM [security].[Permissions] WHERE [name] = 'logistics');
    INSERT INTO [security].[Permissions] ([parentId], [name], [title_en], [title_es], [description_en], [description_es]) VALUES
    (@LogisticsModuleId, 'inventory', 'Inventory', 'Inventario', 'Permission to manage inventory in the logistics module', 'Permiso para gestionar el inventario en el módulo de logística'),
    (@LogisticsModuleId, 'work-orders', 'Work Orders', 'Órdenes de trabajo', 'Permission to manage work orders in the logistics module', 'Permiso para gestionar órdenes de trabajo en el módulo de logística');

    -- Billing
    INSERT INTO [security].[Permissions] ([parentId], [name], [title_en], [title_es], [description_en], [description_es]) VALUES
    (NULL, 'billing', 'Billing', 'Facturación', 'Module for managing billing and payments', 'Módulo para gestionar facturación y pagos');

    -- Insert records into [security].[Roles] table
    INSERT INTO [security].[Roles] ([type], [title_en], [title_es], [description_en], [description_es], [state]) VALUES
    ('owner', 'Super Administrator', 'Super Administrador', 'Role that has full control over the entire system.', 'Rol que tiene control total sobre todo el sistema.', 1), -- '1' represents active state in BIT
    ('admin', 'User and Roles Administrator', 'Administrador de Usuarios y Roles', 'Role responsible for managing users and roles in the system.', 'Rol encargado de gestionar los usuarios y roles del sistema.', 1);

    -- Insert records into [security].[CustomPermissions] table
    DECLARE @AdminRoleId INT = 2;
    DECLARE @SecurityPermissionId INT = (SELECT [id] FROM [security].[Permissions] WHERE [name] = 'security');
    DECLARE @UsersPermissionId INT = (SELECT [id] FROM [security].[Permissions] WHERE [name] = 'users');
    DECLARE @RolesPermissionId INT = (SELECT [id] FROM [security].[Permissions] WHERE [name] = 'roles');

    -- Assigning actions to the "Administrador de Usuarios y Roles" role for each permission
    DECLARE @ReadActionId INT = (SELECT [id] FROM [security].[Actions] WHERE [name] = 'read');
    DECLARE @AddActionId INT = (SELECT [id] FROM [security].[Actions] WHERE [name] = 'add');
    DECLARE @EditActionId INT = (SELECT [id] FROM [security].[Actions] WHERE [name] = 'edit');
    DECLARE @DeleteActionId INT = (SELECT [id] FROM [security].[Actions] WHERE [name] = 'delete');

    -- Insert the custom permissions for the "Administrador de Usuarios y Roles" role
    INSERT INTO [security].[CustomPermissions] ([roleId], [permissionId], [actionId])
    VALUES
    (@AdminRoleId, @SecurityPermissionId, @ReadActionId),
    (@AdminRoleId, @UsersPermissionId, @ReadActionId),
    (@AdminRoleId, @UsersPermissionId, @AddActionId),
    (@AdminRoleId, @UsersPermissionId, @EditActionId),
    (@AdminRoleId, @UsersPermissionId, @DeleteActionId),
    (@AdminRoleId, @RolesPermissionId, @ReadActionId),
    (@AdminRoleId, @RolesPermissionId, @AddActionId),
    (@AdminRoleId, @RolesPermissionId, @EditActionId),
    (@AdminRoleId, @RolesPermissionId, @DeleteActionId);

    -- Insert into [security].[Users] table
    INSERT INTO [security].[Users] ([firstName], [lastName], [email], [password], [passwordVersion], [incorrectPassword], [state]) VALUES
    ('Luis Fernando', 'Solano Martínez', 'luisfer.sm15@gmail.com', '$2b$12$GSfRFX6DncyPEHsIvUBI7.u2NxlY4KD8dEM0/r42NTf0Qet7b/hCK', 1, 0, 1);

    -- Insert into [security].[UsersOnRoles] table
    DECLARE @UserId INT = (SELECT [id] FROM [security].[Users] WHERE [email] = 'luisfer.sm15@gmail.com');
    DECLARE @SuperAdminRoleId INT = (SELECT [id] FROM [security].[Roles] WHERE [type] = 'owner');
    INSERT INTO [security].[UsersOnRoles] ([userId], [roleId]) VALUES (@UserId, @SuperAdminRoleId);

    COMMIT TRANSACTION;
    PRINT '> The tables have been populated.';
    END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH