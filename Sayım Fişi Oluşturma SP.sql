DECLARE @ItemCode1 NVARCHAR(30)
DECLARE @ItemCode2 NVARCHAR(30)
DECLARE @ItemCode3 NVARCHAR(30)
DECLARE @ItemCode4 NVARCHAR(30)
DECLARE @ItemCode5 NVARCHAR(30)
DECLARE @date NVARCHAR(30)

SET @ItemCode1 ='0900100010K1'
SET @ItemCode2 ='89005Y1581Y1'
SET @ItemCode3 ='89005Y1581Y2'
SET @ItemCode4 =''
SET @ItemCode5 =''
SET @date ='20191108'

SELECT 'exec SayimFisi @Office=''' + cdWarehouse.OfficeCode + '''' + ',@date='''+@date+''''+',@ItemCode1 ='''+@ItemCode1+''''+',@ItemCode2 ='''+@ItemCode2+''''+',@ItemCode3 ='''+@ItemCode3+''''+',@ItemCode4 ='''+@ItemCode4+''''+',@ItemCode5 ='''+@ItemCode5+''''
FROM dbo.trStock WITH (NOLOCK)
    JOIN
    (
        SELECT cdItem.ItemCode
        FROM dbo.cdItem
            JOIN ProductHierarchy(N'TR')
                ON cdItem.ProductHierarchyID = ProductHierarchy.ProductHierarchyID
            JOIN ProductAttributesFilter
                ON ProductAttributesFilter.ItemTypeCode = cdItem.ItemTypeCode
                   AND ProductAttributesFilter.ItemCode = cdItem.ItemCode
        WHERE ProductHierarchyLevelCode03 = 47 AND ProductAtt01 in ('59','65','88')
              AND IsBlocked = 0
    ) q
        ON q.ItemCode = trStock.ItemCode
    JOIN dbo.cdWarehouse WITH (NOLOCK)
        ON cdWarehouse.WarehouseCode = trStock.WarehouseCode
           AND WarehouseTypeCode = 1
WHERE OperationDate <= '20191111'
      --AND trStock.OfficeCode ='259'
  --  AND trStock.ItemCode='593620428SS1'
GROUP BY cdWarehouse.OfficeCode

HAVING SUM(In_Qty1-Out_Qty1)<>0

