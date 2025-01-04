DECLARE
    @pnTypeResult           INT,
    @pcResult               VARCHAR(MAX),
    @pcMessage              VARCHAR(MAX)
;

EXEC sp_users
    'GET-ALL', -- @pnTipoOperacion
    'admin@example.com', -- @pcUser

    NULL, -- @pnUserId
    NULL, -- @pcFirstName
    NULL, -- @pcLastName
    NULL, -- @pcEmail
    NULL, -- @pdBirthdate
    NULL, -- @pnRoleId
    NULL, -- @pnStatus

    @pnTypeResult OUTPUT,
    @pcResult OUTPUT,
    @pcMessage OUTPUT
;

SELECT @pnTypeResult AS pnTypeResult;
SELECT @pcResult AS pcResult;
SELECT @pcMessage AS pcMessage;
