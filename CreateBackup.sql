USE Sample;
GO
DROP PROCEDURE IF EXISTS CreateBackup 
GO
CREATE PROCEDURE CreateBackup
(@dbName NVARCHAR(50), @isFull BIT)
AS
BEGIN
	DECLARE @BackupPath NVARCHAR(100), @CurrentDate NVARCHAR(20)
	SET @CurrentDate = (
		SELECT
		CONCAT_WS(
			'T',
			CONCAT_WS(
				'-',
				RIGHT(DATEPART(YEAR  , GETDATE()), 4),
				RIGHT(DATEPART(MONTH, GETDATE()), 2),
				RIGHT(DATEPART(DAY, GETDATE()), 2)
			),
			CONCAT_WS(
				'.',
				RIGHT(DATEPART(HOUR  , GETDATE()), 2),
				RIGHT(DATEPART(MINUTE, GETDATE()), 2),
				RIGHT(DATEPART(SECOND, GETDATE()), 2)
			)
		)
	)
-- (SELECT CONVERT(VARCHAR(20), GETDATE(), 126))
	SET @BackupPath = 'D:\tmp_backups\' + @dbName + '_full_' + @CurrentDate + '.bak'
	BACKUP DATABASE @dbName
	TO
	DISK = @BackupPath
	WITH INIT;
END