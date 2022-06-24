-- TABLE -- 
  CREATE TABLE `smarkio_posvendafinanceiraportoseguro`.`acessos_count` (
  `idacessos` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL, 
  `dispositivo` VARCHAR(255) NOT NULL,
  `pais` VARCHAR(255) NOT NULL,
  `regiao` VARCHAR(255) NOT NULL,
  `navegador` VARCHAR(255) NOT NULL,
  `total` INT(11) NULL DEFAULT 0,
  PRIMARY KEY (`idacessos`));

-- TRIGGER --
USE smarkio_posvendafinanceiraportoseguro;
DELIMITER |
CREATE TRIGGER tg_acessos_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.id IS NOT NULL) 
        AND (SELECT EXISTS (
          SELECT * FROM smarkio_posvendafinanceiraportoseguro.acessos_count 
          WHERE date = NEW.lead_creation_day
          AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END 
          AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
          AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
          AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END)=0))
          
    THEN INSERT INTO smarkio_posvendafinanceiraportoseguro.acessos_count
    (date, dispositivo, pais, regiao, navegador)
    VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END,
        CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,
        CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,
        CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END);
    END IF;

    IF (NEW.id IS NOT NULL) THEN 
        UPDATE smarkio_posvendafinanceiraportoseguro.acessos_count
        SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
        AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
        AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
        AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END;
    END IF;	
END;

-- TRIGGER UPDATE--
USE smarkio_posvendafinanceiraportoseguro;
DELIMITER |
CREATE TRIGGER tg_acessos_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
          SELECT * FROM smarkio_posvendafinanceiraportoseguro.acessos_count 
          WHERE date = NEW.lead_creation_day
          AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END 
          AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
          AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
          AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END)=0)
          
    THEN INSERT INTO smarkio_posvendafinanceiraportoseguro.acessos_count
    (date, dispositivo, pais, regiao, navegador)
    VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END,
        CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,
        CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,
        CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END);
    END IF;

    IF (NEW.id IS NOT NULL) THEN 
        UPDATE smarkio_posvendafinanceiraportoseguro.acessos_count
        SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
        AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
        AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
        AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END;
    END IF;	

    IF (OLD.id IS NOT NULL) THEN 
        UPDATE smarkio_posvendafinanceiraportoseguro.acessos_count
        SET total = total - 1
        WHERE date = OLD.lead_creation_day
        AND dispositivo = CASE WHEN (OLD.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
        AND pais = CASE WHEN (OLD.geo_country IS NOT NULL) THEN OLD.geo_country  ELSE '-' END
        AND regiao = CASE WHEN (OLD.geo_region IS NOT NULL) THEN OLD.geo_region  ELSE '-' END 
        AND navegador = CASE WHEN (OLD.browser IS NOT NULL) THEN OLD.browser  ELSE '-' END;
    END IF;	
END;

-- SELECT -- 
INSERT INTO smarkio_posvendafinanceiraportoseguro.acessos_count (`date`, `dispositivo`, `pais`, `regiao`, `navegador`, `total`)
SELECT c.date, c.dispositivo, c.pais, c.regiao, c.navegador, c.total
FROM 
(
SELECT 
	lead_creation_day AS date,
    (CASE WHEN (is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END) AS dispositivo,
    (CASE WHEN (geo_country IS NOT NULL) THEN geo_country  ELSE '-' END) AS pais,
    (CASE WHEN (geo_region IS NOT NULL) THEN geo_region  ELSE '-' END) AS regiao,
    (CASE WHEN (browser IS NOT NULL) THEN browser  ELSE '-' END) AS navegador,
    SUM(CASE WHEN (id IS NOT NULL)  THEN 1 ELSE 0 END) AS total
	FROM smarkio_posvendafinanceiraportoseguro.leads 
    WHERE lead_creation_day between '2018-10-29' and '2018-12-31'
	GROUP BY date,dispositivo, pais, regiao, navegador) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `dispositivo` = c.dispositivo,
        `pais` = c.pais,
        `regiao` = c.regiao,
        `navegador` = c.navegador,
        `total` = c.total;