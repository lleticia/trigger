-- TABLE -- 
  CREATE TABLE `smarkio_portoseguroconquista`.`duvida_count` (
  `idduvida` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `duvida` VARCHAR(255) NOT NULL,
  `tipo` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
   PRIMARY KEY (`idduvida`));

-- TRIGGER --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_duvida_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.duvida IS NOT NULL)
        AND (SELECT EXISTS ( SELECT * FROM smarkio_portoseguroconquista.duvida_count 
        WHERE date = NEW.lead_creation_day
        AND duvida = CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END 
        AND tipo = CASE WHEN (NEW.confidence >= '0.6') THEN 'Encontrada' ELSE 'Não Encontrada' END)=0))

    THEN INSERT INTO smarkio_portoseguroconquista.duvida_count 
    (date, duvida, tipo)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END,CASE WHEN (NEW.confidence >= '0.6') THEN 'Encontrada' ELSE 'Não Encontrada' END);
    END IF;

	IF (NEW.duvida IS NOT NULL) THEN   
    UPDATE smarkio_portoseguroconquista.duvida_count
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND duvida = CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END 
        AND tipo = CASE WHEN (NEW.confidence >= '0.6') THEN 'Encontrada' ELSE 'Não Encontrada' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_duvida_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.duvida IS NOT NULL)
        AND (SELECT EXISTS ( SELECT * FROM smarkio_portoseguroconquista.duvida_count 
        WHERE date = NEW.lead_creation_day
        AND duvida = CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END 
        AND tipo = CASE WHEN (NEW.confidence >= '0.6') THEN 'Encontrada' ELSE 'Não Encontrada' END)=0))

    THEN INSERT INTO smarkio_portoseguroconquista.duvida_count 
    (date, duvida, tipo)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END,CASE WHEN (NEW.confidence >= '0.6') THEN 'Encontrada' ELSE 'Não Encontrada' END);
    END IF;

	IF (NEW.duvida IS NOT NULL) THEN   
    UPDATE smarkio_portoseguroconquista.duvida_count
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND duvida = CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END 
        AND tipo = CASE WHEN (NEW.confidence >= '0.6') THEN 'Encontrada' ELSE 'Não Encontrada' END;
    END IF;

    IF (OLD.duvida IS NOT NULL) THEN   
    UPDATE smarkio_portoseguroconquista.duvida_count
	    SET total = total - 1
    WHERE date = OLD.lead_creation_day
        AND duvida = CASE WHEN (OLD.duvida IS NOT NULL) THEN OLD.duvida ELSE '-' END 
        AND tipo = CASE WHEN (OLD.confidence >= '0.6') THEN 'Encontrada' ELSE 'Não Encontrada' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portoseguroconquista.duvida_count (`date`, `duvida`, `tipo`, `total`)
SELECT c.date, c.duvida, c.tipo, c.total
FROM (
    SELECT 
	lead_creation_day AS date,
    (CASE WHEN (duvida IS NOT NULL) THEN duvida ELSE '-' END) AS duvida,
    (CASE WHEN (confidence >= '0.6') THEN 'Encontrada' ELSE 'Não Encontrada' END) AS tipo,
    SUM(CASE WHEN (duvida IS NOT NULL) THEN 1 ELSE 0 END) AS total
	FROM smarkio_portoseguroconquista.leads 
    WHERE lead_creation_day between '2020-09-19' and '2021-05-17'
    AND duvida IS NOT NULL
	GROUP BY date, duvida, tipo) AS c
  ON DUPLICATE KEY UPDATE
    `date` = c.date,
    `duvida` = c.duvida,
    `tipo` = c.tipo,
    `total` = c.total;