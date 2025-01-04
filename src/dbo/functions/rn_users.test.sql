PRINT dbo.rn_users(
    'GET-ALL', -- @pnOperationType (Crear un usuario)
    'admin@example.com', -- @pcUser

    NULL, -- @pnUserId
    NULL, -- @pcFirstName
    NULL, -- @pcLastName
    NULL, -- @pcEmail
    NULL, -- @pdBirthdate
    NULL, -- @pnRoleId (ID de un rol existente)
    NULL -- @pnStatus (Activo)
);
