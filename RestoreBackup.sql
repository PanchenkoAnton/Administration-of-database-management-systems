USE master;
GO
DROP PROCEDURE IF EXISTS RestoreBackup
GO
/*ALTER DATABASE SampleDB
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE
GO*/
CREATE PROCEDURE RestoreBackup
(@dbName NVARCHAR(50), @fullDate NVARCHAR(100), @diffDate NVARCHAR(100), @isFull BIT)
AS
BEGIN
	DECLARE @fullBackupPath NVARCHAR(100), @diffBackupPath NVARCHAR(100)
	SET @fullBackupPath = 'D:\tmp_backups\' + @dbName + '_full_' + @fullDate + '.bak'
	SET @diffBackupPath = 'D:\tmp_backups\' + @dbName + '_diff_' + @diffDate + '.bak'
	--SET @logBackupPath = 'D:\tmp_backups\' + @dbName + '.TRN'
	/*BACKUP LOG @dbName 
	TO DISK = 'D:\tmp_backups\mylog'
	WITH NORECOVERY;
	RESTORE DATABASE @dbName
	FROM
	DISK = @fullBackupPath
	WITH
	RECOVERY;*/
	IF @isFull = 1
	BEGIN
		BACKUP LOG @dbName 
		TO DISK = 'D:\tmp_backups\mylog'
		WITH NORECOVERY;
		RESTORE DATABASE @dbName
		FROM DISK = @fullBackupPath
		WITH RECOVERY;
	END
	ELSE
	BEGIN
		BACKUP LOG @dbName 
		TO DISK = 'D:\tmp_backups\mylog'
		WITH NORECOVERY;
		RESTORE DATABASE @dbName
		FROM DISK = @fullBackupPath
		WITH NORECOVERY;
		RESTORE DATABASE @dbName
		FROM DISK = @diffBackupPath
		WITH RECOVERY;
	END
END
GO
/*ALTER DATABASE SampleDB
SET MULTI_USER
WITH NO_WAIT
GO*/