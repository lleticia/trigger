-- SELECT ORIGINAL --
PRODUTO -> case when REGEXP_MATCH(pdt, "FIA") and lead_creation_day < '2019-06-19' then "FIA"
when REGEXP_MATCH(pdt, "FIA") and REGEXP_MATCH(canal_atendimento, "PORTO_ALUGUEL_EMISSAO") and lead_creation_day >= '2019-06-19' then "FIA Emissao"
when REGEXP_MATCH(pdt, "FIA") and REGEXP_MATCH(canal_atendimento, "PORTO_ALUGUEL") and lead_creation_day >= '2019-06-19' then "FIA Produto"
when REGEXP_MATCH(pdt, "CAP") then "CAP"
when REGEXP_MATCH(pdt, "GAR") then "GAR"
when REGEXP_MATCH(pdt, "FIAcanal.*") then "FIA"
when REGEXP_MATCH(chat_fianca, "sim") then "FIA"
when REGEXP_MATCH(chat_portocap, "sim") then "CAP"
when REGEXP_MATCH(chat_garantia, "sim") then "GAR"
else "" end

-- TABLE -- 
  CREATE TABLE `smarkio_portoseguroriscosfinanceiros`.`acessos_count` (
  `idacessos` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL, 
  `dispositivo` VARCHAR(255) NOT NULL,
  `produto` VARCHAR(255) NOT NULL,
  `pais` VARCHAR(255) NOT NULL,
  `regiao` VARCHAR(255) NOT NULL,
  `navegador` VARCHAR(255) NOT NULL,
  `total` INT(11) NULL DEFAULT 0,
  PRIMARY KEY (`idacessos`));

-- TRIGGER INSERT --
USE smarkio_portoseguroriscosfinanceiros;
DELIMITER |
CREATE TRIGGER tg_acessos_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.susep != 'COL10J') 
        AND (SELECT EXISTS (
          SELECT * FROM smarkio_portoseguroriscosfinanceiros.acessos_count 
          WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00")
          AND produto = CASE 
            WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END 
          AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END 
          AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
          AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
          AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END)=0))
          
    THEN INSERT INTO smarkio_portoseguroriscosfinanceiros.acessos_count
    (date, produto, dispositivo, pais, regiao, navegador)
    VALUES (DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00"),
        CASE WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END, 
        CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END,
        CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,
        CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,
        CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END);
    END IF;

    IF (NEW.susep != 'COL10J') THEN 
        UPDATE smarkio_portoseguroriscosfinanceiros.acessos_count
        SET total = total + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00")
        AND produto = CASE 
            WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END 
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
        AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
        AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
        AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END;
    END IF;	
END;

-- TRIGGER UPDATE--
USE smarkio_portoseguroriscosfinanceiros;
DELIMITER |
CREATE TRIGGER tg_acessos_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.susep != 'COL10J') 
        AND (SELECT EXISTS (
          SELECT * FROM smarkio_portoseguroriscosfinanceiros.acessos_count 
          WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00")
          AND produto = CASE 
            WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END 
          AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END 
          AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
          AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
          AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END)=0))
          
    THEN INSERT INTO smarkio_portoseguroriscosfinanceiros.acessos_count
    (date, produto, dispositivo, pais, regiao, navegador)
    VALUES (DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00"),
        CASE WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END,
        CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END,
        CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,
        CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,
        CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END);
    END IF;

    IF (NEW.susep != 'COL10J') THEN 
        UPDATE smarkio_portoseguroriscosfinanceiros.acessos_count
        SET total = total + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00")
        AND produto = CASE 
            WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END 
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
        AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
        AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
        AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END;
    END IF;	

    IF (OLD.susep != 'COL10J') THEN 
        UPDATE smarkio_portoseguroriscosfinanceiros.acessos_count
        SET total = total - 1
        WHERE date = DATE_FORMAT(OLD.created_at,"%Y-%m-%d %H:00")
        AND produto = CASE 
            WHEN ((OLD.pdt = 'FIA') AND (OLD.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((OLD.pdt = 'FIA') AND (OLD.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (OLD.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((OLD.pdt = 'FIA') AND (OLD.canal_atendimento = 'PORTO_ALUGUEL') AND (OLD.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (OLD.pdt = 'CAP') THEN 'CAP'
            WHEN (OLD.pdt = 'GAR') THEN 'GAR'
            WHEN (OLD.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (OLD.chat_fianca = 'sim') THEN 'FIA'
            WHEN (OLD.chat_portocap = 'sim') THEN 'CAP'
            WHEN (OLD.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END 
        AND dispositivo = CASE WHEN (OLD.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
        AND pais = CASE WHEN (OLD.geo_country IS NOT NULL) THEN OLD.geo_country  ELSE '-' END
        AND regiao = CASE WHEN (OLD.geo_region IS NOT NULL) THEN OLD.geo_region  ELSE '-' END 
        AND navegador = CASE WHEN (OLD.browser IS NOT NULL) THEN OLD.browser  ELSE '-' END;
    END IF;	
END;

-- SELECT -- 
INSERT INTO smarkio_portoseguroriscosfinanceiros.acessos_count (`date`, `produto`, `dispositivo`, `pais`, `regiao`, `navegador`, `total`)
SELECT c.date, c.produto, c.dispositivo, c.pais, c.regiao, c.navegador, c.total
FROM 
(
SELECT 
	DATE_FORMAT(created_at,"%Y-%m-%d %H:00") AS date,
    (CASE WHEN ((pdt = 'FIA') AND (lead_creation_day < '2019-06-19')) THEN 'FIA'
        WHEN ((pdt = 'FIA') AND (canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
        WHEN ((pdt = 'FIA') AND (canal_atendimento = 'PORTO_ALUGUEL') AND (lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
        WHEN (pdt = 'CAP') THEN 'CAP'
        WHEN (pdt = 'GAR') THEN 'GAR'
        WHEN (pdt LIKE 'FIAcanal%') THEN 'FIA'
        WHEN (chat_fianca = 'sim') THEN 'FIA'
        WHEN (chat_portocap = 'sim') THEN 'CAP'
        WHEN (chat_garantia = 'sim') THEN 'GAR'
        ELSE '-' END) AS produto,
    (CASE WHEN (is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END) AS dispositivo,
    (CASE WHEN (geo_country IS NOT NULL) THEN geo_country  ELSE '-' END) AS pais,
    (CASE WHEN (geo_region IS NOT NULL) THEN geo_region  ELSE '-' END) AS regiao,
    (CASE WHEN (browser IS NOT NULL) THEN browser  ELSE '-' END) AS navegador,
    SUM(CASE WHEN (id IS NOT NULL)  THEN 1 ELSE 0 END) AS total
	FROM smarkio_portoseguroriscosfinanceiros.leads 
    WHERE lead_creation_day between '2021-06-01' and '2021-06-07'
    AND susep != 'COL10J'
	GROUP BY date, produto, dispositivo, pais, regiao, navegador) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `produto` = c.produto,
        `dispositivo` = c.dispositivo,
        `pais` = c.pais,
        `regiao` = c.regiao,
        `navegador` = c.navegador,
        `total` = c.total;