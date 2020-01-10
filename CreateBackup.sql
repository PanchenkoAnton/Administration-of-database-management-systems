USE master;
GO
DROP PROCEDURE IF EXISTS CreateBackup 
GO
CREATE PROCEDURE CreateBackup
(@dbName NVARCHAR(50), @isFull BIT)
AS
BEGIN
	DECLARE @BackupPath NVARCHAR(100), @CurrentDate NVARCHAR(20), @Date DATETIME
	SET @Date = GETDATE()
	SET @CurrentDate = (
		SELECT
		CONCAT_WS(
			'T',
			CONCAT_WS(
				'-',
				RIGHT(DATEPART(YEAR  , @Date), 4),
				RIGHT(DATEPART(MONTH, @Date), 2),
				RIGHT(DATEPART(DAY, @Date), 2)
			),
			CONCAT_WS(
				'.',
				RIGHT(DATEPART(HOUR  , @Date), 2),
				RIGHT(DATEPART(MINUTE, @Date), 2),
				RIGHT(DATEPART(SECOND, @Date), 2)
			)
		)
	)
-- (SELECT CONVERT(VARCHAR(20), GETDATE(), 126))
	IF @isFull = 1
	BEGIN
		SET @BackupPath = 'D:\tmp_backups\' + @dbName + '_full_' + @CurrentDate + '.bak'
		BACKUP DATABASE @dbName
		TO DISK = @BackupPath
		WITH INIT;
	END
	ELSE
	BEGIN
		SET @BackupPath = 'D:\tmp_backups\' + @dbName + '_diff_' + @CurrentDate + '.bak'
		BACKUP DATABASE @dbName
		TO DISK = @BackupPath
		WITH DIFFERENTIAL, INIT;
	END
	INSERT INTO [dbo].[backup_logs] VALUES (@isFull, @Date, @dbName)
END