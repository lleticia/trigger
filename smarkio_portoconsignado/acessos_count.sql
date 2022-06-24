-- TABLE -- 
  CREATE TABLE `smarkio_portoconsignado`.`acessos_count` (
  `idacessos` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL, 
  `dispositivo` VARCHAR(255) NOT NULL,
  `empresa` VARCHAR(255) NOT NULL,
  `pais` VARCHAR(255) NOT NULL,
  `regiao` VARCHAR(255) NOT NULL,
  `navegador` VARCHAR(255) NOT NULL,
  `total` INT(11) NULL DEFAULT 0,
  PRIMARY KEY (`idacessos`));

-- TRIGGER --
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_acessos_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.id IS NOT NULL) 
        AND (SELECT EXISTS (
          SELECT * FROM smarkio_portoconsignado.acessos_count 
          WHERE date = NEW.created_at
          AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
          AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END 
          AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
          AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
          AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END)=0))
          
      THEN INSERT INTO smarkio_portoconsignado.acessos_count
      (date, empresa, dispositivo, pais, regiao, navegador)
      VALUES (NEW.created_at,
        CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END,
        CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END,
        CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,
        CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,
        CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END);
    END IF;

  IF (NEW.id IS NOT NULL) THEN 
	  UPDATE smarkio_portoconsignado.acessos_count
      SET total = total + 1
    WHERE date = NEW.created_at
    AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
    AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
    AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END;
  END IF;	
END;

-- TRIGGER UPDATE--
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_acessos_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
          SELECT * FROM smarkio_portoconsignado.acessos_count 
          WHERE date = NEW.created_at
          AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
          AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END 
          AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
          AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
          AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END)=0)
          
      THEN INSERT INTO smarkio_portoconsignado.acessos_count
      (date, empresa, dispositivo, pais, regiao, navegador)
      VALUES (NEW.created_at,
        CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END,
        CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END,
        CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,
        CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,
        CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END);
    END IF;

  IF (NEW.id IS NOT NULL) THEN 
	  UPDATE smarkio_portoconsignado.acessos_count
      SET total = total + 1
    WHERE date = NEW.created_at
    AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
    AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
    AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END;
  END IF;	

  IF (OLD.id IS NOT NULL) THEN 
	  UPDATE smarkio_portoconsignado.acessos_count
      SET total = total - 1
    WHERE date = OLD.created_at
    AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
    AND dispositivo = CASE WHEN (OLD.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
    AND pais = CASE WHEN (OLD.geo_country IS NOT NULL) THEN OLD.geo_country  ELSE '-' END
    AND regiao = CASE WHEN (OLD.geo_region IS NOT NULL) THEN OLD.geo_region  ELSE '-' END 
    AND navegador = CASE WHEN (OLD.browser IS NOT NULL) THEN OLD.browser  ELSE '-' END;
  END IF;	
END;

-- SELECT -- 
INSERT INTO smarkio_portoconsignado.acessos_count (`date`, `dispositivo`, `empresa`, `pais`, `regiao`, `navegador`, `total`)
SELECT c.date, c.dispositivo, c.empresa, c.pais, c.regiao, c.navegador, c.total
FROM 
(
 SELECT 
	created_at AS date,
  (CASE WHEN (is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END) AS dispositivo,
  (CASE WHEN (nome_fantasia IS NOT NULL) THEN nome_fantasia ELSE '-' END) AS empresa,
  (CASE WHEN (geo_country IS NOT NULL) THEN geo_country  ELSE '-' END) AS pais,
  (CASE WHEN (geo_region IS NOT NULL) THEN geo_region  ELSE '-' END) AS regiao,
  (CASE WHEN (browser IS NOT NULL) THEN browser  ELSE '-' END) AS navegador,
  SUM(CASE WHEN (id IS NOT NULL)  THEN 1 ELSE 0 END) AS total
	FROM smarkio_portoconsignado.leads 
    WHERE created_at < '2021-05-27' 
	GROUP BY date,dispositivo, pais, regiao, navegador,empresa) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `dispositivo` = c.dispositivo,
        `empresa` = c.empresa,
        `pais` = c.pais,
        `regiao` = c.regiao,
        `navegador` = c.navegador,
        `total` = c.total;