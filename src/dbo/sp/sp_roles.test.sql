DECLARE
    @pnTypeResult           INT,
    @pcResult               VARCHAR(MAX),
    @pcMessage              VARCHAR(MAX)
;

EXEC sp_roles
    'GET-ALL', -- @pnTipoOperacion
    'admin@example.com', -- @pcUser

    NULL, -- @pnRoleId
    NULL, -- @pcName
    NULL, -- @pcDescription
    NULL, -- @pnStatus

    @pnTypeResult OUTPUT,
    @pcResult OUTPUT,
    @pcMessage OUTPUT
;

SELECT @pnTypeResult AS pnTypeResult;
SELECT @pcResult AS pcResult;
SELECT @pcMessage AS pcMessage;
