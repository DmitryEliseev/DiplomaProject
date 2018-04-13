/*
Предподсчет необходимых для построения таблицы метрик заранее
и сохранение результатов в таблицы
*/

USE YaroblMZ;
GO

DROP TABLE sup_stats
DROP TABLE org_stats
DROP TABLE okpd_stats

GO
--Создание таблицы для хранения статистики по поставщикам
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sup_stats' AND xtype='U')
  CREATE TABLE sup_stats (
    SupID INT NOT NULL,
    sup_cntr_num INT,
    sup_cntr_avg_price BIGINT,
    sup_cntr_avg_penalty FLOAT,
    sup_no_pnl_share FLOAT,
    sup_1s_sev FLOAT,
    sup_1s_org_sev FLOAT,
    PRIMARY KEY(SupID)
  )

--Создание таблицы для хранения статистики по заказчикам
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='org_stats' AND xtype='U')
  CREATE TABLE org_stats (
    OrgID INT NOT NULL,
    org_cntr_num INT,
    org_cntr_avg_price BIGINT,
    org_1s_sev INT,
    org_1s_sup_sev FLOAT,
    PRIMARY KEY(OrgID)
  )

--Создание таблицы для хранения статистики по ОКПД
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='okpd_stats' AND xtype='U')
  CREATE TABLE okpd_stats (
    OkpdID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(9),
    cntr_num INT,
    good_cntr_num INT
  )

  
GO
--Заполнение таблицы со статистикой по поставщикам
INSERT INTO sup_stats 
SELECT
sup.ID,
guest.sup_num_of_contracts(sup.ID),
guest.sup_avg_contract_price(sup.ID),
guest.sup_avg_penalty_share(sup.ID),
guest.sup_no_penalty_cntr_share(sup.ID),
guest.sup_one_side_severance_share(sup.ID),
guest.sup_one_side_org_severance_share(sup.ID)
FROM DV.d_OOS_Suppliers AS sup

GO
--Заполнение таблицы со статистикой по заказчикам
INSERT INTO org_stats 
SELECT
org.ID,
guest.org_num_of_contracts(org.ID),
guest.org_avg_contract_price(org.ID),
guest.org_one_side_severance_share(org.ID),
guest.org_one_side_supplier_severance_share(org.ID)
FROM DV.d_OOS_Org AS org

GO
--Заполнение таблицы со статистикой по ОКПД: количество завершенных контрактов по ОКПД
INSERT INTO okpd_stats (okpd_stats.code, okpd_stats.cntr_num)
SELECT okpd.Code, COUNT(cntr.ID)
FROM 
DV.d_OOS_OKPD2 AS okpd 
INNER JOIN DV.d_OOS_Products AS prods ON prods.RefOKPD2 = okpd.ID
INNER JOIN DV.f_OOS_Product AS prod ON prod.RefProduct = prods.ID
INNER JOIN DV.d_OOS_Contracts AS cntr ON cntr.ID = prod.RefContract
INNER JOIN DV.fx_OOS_ContractStage AS cntrSt ON cntrSt.ID = cntr.RefStage
WHERE cntrSt.ID IN (3, 4)
GROUP BY okpd.Code

--Заполнение таблицы со статистикой по ОКПД: количество хороших контрактов по ОКПД
UPDATE okpd_stats
SET okpd_stats.good_cntr_num = t.good_cntr_num
FROM
(
  SELECT okpd.code, COUNT(cntr.ID) AS 'good_cntr_num'
  FROM 
  DV.d_OOS_OKPD2 AS okpd 
  INNER JOIN DV.d_OOS_Products AS prods ON prods.RefOKPD2 = okpd.ID
  INNER JOIN DV.f_OOS_Product AS prod ON prod.RefProduct = prods.ID
  INNER JOIN DV.d_OOS_Contracts AS cntr ON cntr.ID = prod.RefContract
  INNER JOIN DV.fx_OOS_ContractStage AS cntrSt ON cntrSt.ID = cntr.RefStage
  WHERE 
    guest.pred_variable(cntr.ID) = 1 AND
    cntrSt.ID IN (3, 4)
  GROUP BY okpd.Code
)t
WHERE t.code = okpd_stats.code

USE TulaMZ;
GO

DROP TABLE sup_stats
DROP TABLE org_stats
DROP TABLE okpd_stats

GO
--Создание таблицы для хранения статистики по поставщикам
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sup_stats' AND xtype='U')
  CREATE TABLE sup_stats (
    SupID INT NOT NULL,
    sup_cntr_num INT,
    sup_cntr_avg_price BIGINT,
    sup_cntr_avg_penalty FLOAT,
    sup_no_pnl_share FLOAT,
    sup_1s_sev FLOAT,
    sup_1s_org_sev FLOAT,
    PRIMARY KEY(SupID)
  )

--Создание таблицы для хранения статистики по заказчикам
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='org_stats' AND xtype='U')
  CREATE TABLE org_stats (
    OrgID INT NOT NULL,
    org_cntr_num INT,
    org_cntr_avg_price BIGINT,
    org_1s_sev INT,
    org_1s_sup_sev FLOAT,
    PRIMARY KEY(OrgID)
  )

--Создание таблицы для хранения статистики по ОКПД
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='okpd_stats' AND xtype='U')
  CREATE TABLE okpd_stats (
    OkpdID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(9),
    cntr_num INT,
    good_cntr_num INT
  )

  
GO
--Заполнение таблицы со статистикой по поставщикам
INSERT INTO sup_stats 
SELECT
sup.ID,
guest.sup_num_of_contracts(sup.ID),
guest.sup_avg_contract_price(sup.ID),
guest.sup_avg_penalty_share(sup.ID),
guest.sup_no_penalty_cntr_share(sup.ID),
guest.sup_one_side_severance_share(sup.ID),
guest.sup_one_side_org_severance_share(sup.ID)
FROM DV.d_OOS_Suppliers AS sup

GO
--Заполнение таблицы со статистикой по заказчикам
INSERT INTO org_stats 
SELECT
org.ID,
guest.org_num_of_contracts(org.ID),
guest.org_avg_contract_price(org.ID),
guest.org_one_side_severance_share(org.ID),
guest.org_one_side_supplier_severance_share(org.ID)
FROM DV.d_OOS_Org AS org

GO
--Заполнение таблицы со статистикой по ОКПД: количество завершенных контрактов по ОКПД
INSERT INTO okpd_stats (okpd_stats.code, okpd_stats.cntr_num)
SELECT okpd.Code, COUNT(cntr.ID)
FROM 
DV.d_OOS_OKPD2 AS okpd 
INNER JOIN DV.d_OOS_Products AS prods ON prods.RefOKPD2 = okpd.ID
INNER JOIN DV.f_OOS_Product AS prod ON prod.RefProduct = prods.ID
INNER JOIN DV.d_OOS_Contracts AS cntr ON cntr.ID = prod.RefContract
INNER JOIN DV.fx_OOS_ContractStage AS cntrSt ON cntrSt.ID = cntr.RefStage
WHERE cntrSt.ID IN (3, 4)
GROUP BY okpd.Code

--Заполнение таблицы со статистикой по ОКПД: количество хороших контрактов по ОКПД
UPDATE okpd_stats
SET okpd_stats.good_cntr_num = t.good_cntr_num
FROM
(
  SELECT okpd.code, COUNT(cntr.ID) AS 'good_cntr_num'
  FROM 
  DV.d_OOS_OKPD2 AS okpd 
  INNER JOIN DV.d_OOS_Products AS prods ON prods.RefOKPD2 = okpd.ID
  INNER JOIN DV.f_OOS_Product AS prod ON prod.RefProduct = prods.ID
  INNER JOIN DV.d_OOS_Contracts AS cntr ON cntr.ID = prod.RefContract
  INNER JOIN DV.fx_OOS_ContractStage AS cntrSt ON cntrSt.ID = cntr.RefStage
  WHERE 
    guest.pred_variable(cntr.ID) = 1 AND
    cntrSt.ID IN (3, 4)
  GROUP BY okpd.Code
)t
WHERE t.code = okpd_stats.code