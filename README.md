# Column-Profiling-SQL-Script
This SQL script dynamically inspects all columns in a specified table to help in profiling the columns data characteristics.

It extracts useful column information like:
- Maximum values for numeric columns
- Maximum length for 'VARCHAR' columns
- Maximum date for date/time columns

This is useful for:
- Data type validation
- Schema refinement
- Data auditing

## 🔧  How It Works
The script:
- Accepts a table name and schema name as input.
- Queries 'information_schema.columns' to generate column profiles.
- Executes the final SQL block using 'sp_executesql'.

It returns a unified result sorted by data type and column name.

## 🎁 Output Columns
| Column Name | Data Type | Max Number | Max Length | Max Date |
|-------------|-----------|------------|------------|----------|

With each row representing a column from the target table and it's most relevamt maximum metric.


## 🛠️ Usage
Replace the following variables in the script with the desired table and schema:

'''SQL
DECLARE @TableName NVARCHAR(128) = 'YourTableName'
DECLARE @SchemaName NVARCHAR(128) = 'YourSchemaName'