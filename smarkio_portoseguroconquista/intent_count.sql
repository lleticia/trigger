-- TABLE -- 
  CREATE TABLE `smarkio_portoseguroconquista`.`intent_count` (
  `idintent` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `intent` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
  `transbordo` INT NULL DEFAULT 0,
   PRIMARY KEY (`idintent`));

-- TRIGGER --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_intent_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.intent IS NOT NULL) 
        AND (SELECT EXISTS (SELECT * FROM smarkio_portoseguroconquista.intent_count  
        WHERE date = NEW.lead_creation_day
        AND intent = CASE WHEN (NEW.intent IS NOT NULL) THEN NEW.intent ELSE '-' END)=0))

    THEN INSERT INTO smarkio_portoseguroconquista.intent_count  
    (date, intent)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.intent IS NOT NULL) THEN NEW.intent ELSE '-' END);
    END IF;

	IF (NEW.intent IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.intent_count  
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND intent = CASE WHEN (NEW.intent IS NOT NULL) THEN NEW.intent ELSE '-' END;
    END IF;

    IF (NEW.horario_atendimento = '1') THEN 
    UPDATE smarkio_portoseguroconquista.intent_count  
	    SET transbordo = transbordo + 1
    WHERE date = NEW.lead_creation_day
        AND intent = CASE WHEN (NEW.intent IS NOT NULL) THEN NEW.intent ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_intent_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.intent IS NOT NULL) 
        AND (SELECT EXISTS (SELECT * FROM smarkio_portoseguroconquista.intent_count  
        WHERE date = NEW.lead_creation_day
        AND intent = CASE WHEN (NEW.intent IS NOT NULL) THEN NEW.intent ELSE '-' END)=0))

    THEN INSERT INTO smarkio_portoseguroconquista.intent_count  
    (date, intent)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.intent IS NOT NULL) THEN NEW.intent ELSE '-' END);
    END IF;

	IF (NEW.intent IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.intent_count  
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND intent = CASE WHEN (NEW.intent IS NOT NULL) THEN NEW.intent ELSE '-' END;
    END IF;

    IF (NEW.horario_atendimento = '1') THEN 
    UPDATE smarkio_portoseguroconquista.intent_count  
	    SET transbordo = transbordo + 1
    WHERE date = NEW.lead_creation_day
        AND intent = CASE WHEN (NEW.intent IS NOT NULL) THEN NEW.intent ELSE '-' END;
    END IF;

    IF (OLD.intent IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.intent_count  
	    SET total = total - 1
    WHERE date = OLD.lead_creation_day
        AND intent = CASE WHEN (OLD.intent IS NOT NULL) THEN OLD.intent ELSE '-' END;
    END IF;

    IF (OLD.horario_atendimento = '1') THEN 
    UPDATE smarkio_portoseguroconquista.intent_count  
	    SET transbordo = transbordo + 1
    WHERE date = OLD.lead_creation_day
        AND intent = CASE WHEN (OLD.intent IS NOT NULL) THEN OLD.intent ELSE '-' END;
    END IF;
END 

-- SELECT -- 
INSERT INTO smarkio_portoseguroconquista.intent_count (`date`, `intent`, `total`, `transbordo`)
SELECT c.date, c.intent, c.total, c.transbordo
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (intent IS NOT NULL) THEN intent ELSE '-' END) AS intent,
    SUM(CASE WHEN (intent IS NOT NULL) THEN 1 ELSE 0 END) AS total,
    SUM(CASE WHEN (horario_atendimento = '1') THEN 1 ELSE 0 END) AS transbordo
	FROM smarkio_portoseguroconquista.leads 
    WHERE lead_creation_day between '2020-09-19' and '2021-05-17'
    AND intent IS NOT NULL
	GROUP BY date, intent) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `intent` = c.intent,
        `total` = c.total,
        `transbordo` = c.transbordo;