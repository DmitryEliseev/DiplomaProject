CREATE FUNCTION guest.org_num_of_good_contracts (@OrgID INT)

/*
Количество хороших завершенных контрактов у заказчика
*/

RETURNS INT
AS
BEGIN
  DECLARE @num_of_good_contracts INT = (
   SELECT COUNT(cntr.ID)
    FROM DV.f_OOS_Value AS val
    INNER JOIN DV.d_OOS_Org AS org ON org.ID = val.RefOrg
    INNER JOIN DV.d_OOS_Contracts AS cntr ON cntr.ID = val.RefContract
    INNER JOIN DV.fx_OOS_ContractStage AS cntrStg ON cntrStg.ID = cntr.RefStage
    WHERE 
  		org.ID = @OrgID AND 
  		cntrStg.ID IN (3, 4) AND
      guest.pred_variable(cntr.ID) = 1
  )
  RETURN @num_of_good_contracts
END