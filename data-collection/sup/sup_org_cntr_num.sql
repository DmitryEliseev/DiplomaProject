CREATE FUNCTION guest.sup_org_cntr_num (@SupID INT, @OrgID INT)

/*
Количество контрактов между определенным поставщиком и заказчиком
*/

RETURNS INT
AS
BEGIN
  DECLARE @contracts_num INT = (
    SELECT COUNT(cntr.ID)
	FROM DV.f_OOS_Value AS val
    INNER JOIN DV.d_OOS_Suppliers AS sup ON sup.ID = val.RefSupplier
    INNER JOIN DV.d_OOS_Org AS org ON org.ID = val.RefOrg
  	INNER JOIN DV.d_OOS_Contracts AS cntr ON cntr.ID = val.RefContract
  	INNER JOIN DV.d_OOS_ClosContracts As cntrCls ON cntrCls.RefContract = cntr.ID
  	INNER JOIN DV.fx_OOS_ContractStage AS cntrSt ON cntrSt.ID = cntr.RefStage
		WHERE
			sup.ID = @SupID AND 
			org.ID = @OrgID AND
			cntrSt.ID IN (3, 4)
	)
  RETURN @contracts_num
END