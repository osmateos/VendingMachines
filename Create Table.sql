CREATE TABLE [Transactions] (
	-- TODO: 1. Transaction ID should be a Primary Key, fields with a b-tree index
	

TransactionId int IDENTITY NOT NULL PRIMARY KEY NONCLUSTERED,
VendingMachineId char(36),
	ItemName varchar(255),
	ItemId int,
	PurchasePrice smallmoney,
	TransactionStatus int,
	TransactionDate datetime, 
	-- TODO: 2. This table should have a columnar index

INDEX Transactions_CCI CLUSTERED COLUMNSTORE
) WITH (
MEMORY_OPTIMIZED = ON
);

-- TODO: 4. In-memory tables should auto-elevate their transaction level to Snapshot



ALTER DATABASE CURRENT SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT=ON;