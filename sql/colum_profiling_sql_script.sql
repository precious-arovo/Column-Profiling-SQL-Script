/* SQL script to dynamically inspect all columns in a specified table in profiling the columns data characteristics. */
DECLARE @SQL NVARCHAR(MAX) = ''
DECLARE @TableName NVARCHAR(128) = '' -- table name
DECLARE @SchemaName NVARCHAR(128) = '' -- table schema name