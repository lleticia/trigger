-- TABLE -- 
  CREATE TABLE `smarkio_portocorretores`.`dadosconfirmados_count` (
  `iddadosconfirmados` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `menu` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
   PRIMARY KEY (`iddadosconfirmados`));

-- TRIGGER --
USE smarkio_portocorretores;
DELIMITER |
CREATE TRIGGER tg_dadosconfirmados_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.dados_confirmados IS NOT NULL) 
        AND (NEW.gostaria LIKE 'Corrig%') 
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portocorretores.dadosconfirmados_count 
        WHERE date = NEW.lead_creation_day
        AND menu = CASE WHEN (NEW.dados_confirmados IS NOT NULL) THEN NEW.dados_confirmados ELSE '-' END)=0))

    THEN INSERT INTO smarkio_portocorretores.dadosconfirmados_count
    (date,menu)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.dados_confirmados IS NOT NULL) THEN NEW.dados_confirmados ELSE '-' END);
    END IF;

	IF ((NEW.dados_confirmados IS NOT NULL) AND (NEW.gostaria LIKE 'Corrig%')) THEN 
    UPDATE smarkio_portocorretores.dadosconfirmados_count
		SET total = total + 1
    WHERE date = NEW.lead_creation_day
		AND menu = CASE WHEN (NEW.dados_confirmados IS NOT NULL) THEN NEW.dados_confirmados ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portocorretores;
DELIMITER |
CREATE TRIGGER tg_dadosconfirmados_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN	
  IF ((NEW.dados_confirmados IS NOT NULL) 
        AND (NEW.gostaria LIKE 'Corrig%')
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portocorretores.dadosconfirmados_count 
        WHERE date = NEW.lead_creation_day
        AND menu = CASE WHEN (NEW.dados_confirmados IS NOT NULL) THEN NEW.dados_confirmados ELSE '-' END)=0))

  THEN INSERT INTO smarkio_portocorretores.dadosconfirmados_count
  (date,menu)
  VALUES (NEW.lead_creation_day,CASE WHEN (NEW.dados_confirmados IS NOT NULL) THEN NEW.dados_confirmados ELSE '-' END);
  END IF;

	IF ((NEW.dados_confirmados IS NOT NULL) AND (NEW.gostaria LIKE 'Corrig%')) THEN 
    UPDATE smarkio_portocorretores.dadosconfirmados_count
		SET total = total + 1
    WHERE date = NEW.lead_creation_day
		AND menu = CASE WHEN (NEW.dados_confirmados IS NOT NULL) THEN NEW.dados_confirmados ELSE '-' END;
    END IF;

  IF ((OLD.dados_confirmados IS NOT NULL) AND (OLD.gostaria LIKE 'Corrig%')) THEN 
    UPDATE smarkio_portocorretores.dadosconfirmados_count
		SET total = total - 1
    WHERE date = OLD.lead_creation_day
		AND menu = CASE WHEN (OLD.dados_confirmados IS NOT NULL) THEN OLD.dados_confirmados ELSE '-' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portocorretores.dadosconfirmados_count (`date`, `menu`, `total`)
SELECT c.date, c.menu, c.total
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (dados_confirmados IS NOT NULL) THEN dados_confirmados ELSE '-' END) as menu,
    SUM(CASE WHEN (dados_confirmados IS NOT NULL) THEN 1 ELSE 0 END) AS total
	FROM smarkio_portocorretores.leads 
    WHERE lead_creation_day >= '2021-02-01'
    and gostaria LIKE 'Corrig%'
    AND dados_confirmados IS NOT NULL
		GROUP BY date, menu) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `menu` = c.menu,
        `total` = c.total;
