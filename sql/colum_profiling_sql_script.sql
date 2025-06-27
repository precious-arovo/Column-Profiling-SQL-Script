/* SQL script to dynamically inspect all columns in a specified table in profiling the columns data characteristics. */
DECLARE @SQL NVARCHAR(MAX) = ''
DECLARE @TableName NVARCHAR(128) = ''  -- table name 
DECLARE @SchemaName NVARCHAR(128) = ''  -- schema name

-- Maximum value for all int data type for each column
SELECT @SQL = @SQL + 
    'SELECT ''' + COLUMN_NAME + ''' AS COLUMN_NAME, ''' + DATA_TYPE + ''' AS DATA_TYPE, ' +
    'MAX(CAST([' + COLUMN_NAME + '] AS BIGINT)) AS MAX_NUMBER, NULL AS MAX_LENGTH, NULL AS MAX_DATE ' +
    'FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) +
    ' UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName
  AND TABLE_SCHEMA = @SchemaName
  AND DATA_TYPE IN ('tinyint', 'smallint', 'int', 'bigint')

-- Maximum length for Varchar data type for each column
SELECT @SQL = @SQL + 
    'SELECT ''' + COLUMN_NAME + ''' AS COLUMN_NAME, ''' + DATA_TYPE + ''' AS DATA_TYPE, ' +
    'NULL AS MAX_NUMBER, MAX(LEN([' + COLUMN_NAME + '])) AS MAX_LENGTH, NULL AS MAX_DATE ' +
    'FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) +
    ' WHERE [' + COLUMN_NAME + '] IS NOT NULL ' + 
    ' UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName
  AND TABLE_SCHEMA = @SchemaName
  AND DATA_TYPE IN ('varchar')

-- Maximum Date for all date data type for each column
SELECT @SQL = @SQL + 
    'SELECT ''' + COLUMN_NAME + ''' AS COLUMN_NAME, ''' + DATA_TYPE + ''' AS DATA_TYPE, ' +
    'NULL AS MAX_NUMBER, NULL AS MAX_LENGTH, MAX([' + COLUMN_NAME + ']) AS MAX_DATE ' +
    'FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) +
    ' UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName
  AND TABLE_SCHEMA = @SchemaName
  AND DATA_TYPE IN ('date', 'datetime', 'smalldatetime', 'datetime2', 'datetimeoffset', 'time')

-- Remove the last UNION ALL
SET @SQL = LEFT(@SQL, LEN(@SQL) - 10)

-- Sorting by DataType first and then ColumnName
SET @SQL = 'SELECT COLUMN_NAME, DATA_TYPE, MAX_NUMBER, MAX_LENGTH, MAX_DATE ' +
           'FROM (' + @SQL + ') AS FinalResult ' +
           'ORDER BY DATA_TYPE, COLUMN_NAME'

-- Execute SQL
EXEC sp_executesql @SQL 