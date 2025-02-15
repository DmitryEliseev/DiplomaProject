CREATE FUNCTION guest.org_num_of_contracts_lvl (@OrgID INT, @Lvl INT)

/*
Количество завершенных контрактов по определенному уровню (федеральному, муниципальному, региональному)
для конкретного заказчика
*/

RETURNS INT
AS
BEGIN
  DECLARE @num_of_contracts_lvl INT = (
    SELECT COUNT(cntr.ID)
    FROM DV.f_OOS_Value AS val
    INNER JOIN DV.d_OOS_Org AS org ON org.ID = val.RefOrg
    INNER JOIN DV.d_OOS_Contracts AS cntr ON cntr.ID = val.RefContract
    INNER JOIN DV.fx_OOS_ContractStage AS cntrStg ON cntrStg.ID = cntr.RefStage
    WHERE 
  		org.ID = @OrgID AND 
  		cntrStg.ID IN (3, 4) AND 
      val.RefLevelOrder = @Lvl 
  )
  RETURN @num_of_contracts_lvl
END