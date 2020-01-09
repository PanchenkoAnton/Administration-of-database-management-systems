USE master;
GO
DROP PROCEDURE IF EXISTS RestoreBackup
GO
CREATE PROCEDURE RestoreBackup
(@dbName NVARCHAR(50), @Date NVARCHAR(100))
AS
BEGIN
	DECLARE @BackupPath NVARCHAR(100)
	SET @BackupPath = 'D:\tmp_backups\' + @dbName + '_full_' + @Date + '.bak'
	RESTORE DATABASE @dbName
	FROM
	DISK = @BackupPath
	WITH
	NORECOVERY;
END