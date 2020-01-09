USE Sample;

GO

CREATE PROCEDURE GetCurrentUserPermissions AS
BEGIN
	SELECT * FROM fn_my_permissions ((SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG='Sample'), 'OBJECT')
END
