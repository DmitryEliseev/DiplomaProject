CREATE FUNCTION guest.ter_num_of_contracts (@TerrCode INT)

/*
Количество завершенных контрактов в рамках определенной территории
*/

RETURNS INT
AS
BEGIN
  DECLARE @num_of_contracts INT = (
    SELECT COUNT(*)
    FROM
    (
      SELECT DISTINCT cntr.ID
  		FROM DV.f_OOS_Value AS val
      INNER JOIN DV.d_Territory_RF AS ter ON ter.ID = val.RefTerritory
  		INNER JOIN DV.d_OOS_Contracts AS cntr ON cntr.ID = val.RefContract
  		INNER JOIN DV.d_OOS_ClosContracts As cntrCls ON cntrCls.RefContract = cntr.ID
  		INNER JOIN DV.fx_OOS_ContractStage AS cntrSt ON cntrSt.ID = cntr.RefStage
      WHERE
        ter.Code1 = @TerrCode AND
    	  cntrSt.ID IN (3, 4) 
    )t 
  )
  RETURN @num_of_contracts
END