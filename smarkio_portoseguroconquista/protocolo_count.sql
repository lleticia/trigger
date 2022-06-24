-- SELECT ORIGINAL --
case 
when REGEXP_MATCH(protocolo, ".*") then 1
when REGEXP_MATCH(protocolo_gerado, ".*") then 1
else 0
end

case 
when regexp_match(protocolo, ".*") then "Gerado"
when regexp_match(protocolo_gerado, "0") then "Nao gerado"
else "Nao Gerado"
end

-- TABLE -- 
  CREATE TABLE `smarkio_portoseguroconquista`.`protocolo_count` (
  `idprotocolo` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `protocolo` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
   PRIMARY KEY (`idprotocolo`));

-- TRIGGER --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_protocolo_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF (SELECT EXISTS ( SELECT * FROM smarkio_portoseguroconquista.protocolo_count 
        WHERE date = NEW.lead_creation_day
        AND protocolo = CASE WHEN (NEW.protocolo IS NOT NULL) THEN 'Gerado' ELSE 'Não Gerado' END)=0)

    THEN INSERT INTO smarkio_portoseguroconquista.protocolo_count 
    (date, protocolo)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.protocolo IS NOT NULL) THEN 'Gerado' ELSE 'Não Gerado' END);
    END IF;

	IF ((NEW.protocolo IS NOT NULL) OR (NEW.protocolo_gerado IS NOT NULL)) THEN   
    UPDATE smarkio_portoseguroconquista.protocolo_count
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
    AND protocolo = CASE WHEN (NEW.protocolo IS NOT NULL) THEN 'Gerado' ELSE 'Não Gerado' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_protocolo_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF (SELECT EXISTS ( SELECT * FROM smarkio_portoseguroconquista.protocolo_count 
        WHERE date = NEW.lead_creation_day
        AND protocolo = CASE WHEN (NEW.protocolo IS NOT NULL) THEN 'Gerado' ELSE 'Não Gerado' END)=0)

    THEN INSERT INTO smarkio_portoseguroconquista.protocolo_count 
    (date, protocolo)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.protocolo IS NOT NULL) THEN 'Gerado' ELSE 'Não Gerado' END);
    END IF;

	IF ((NEW.protocolo IS NOT NULL) OR (NEW.protocolo_gerado IS NOT NULL)) THEN   
    UPDATE smarkio_portoseguroconquista.protocolo_count
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
    AND protocolo = CASE WHEN (NEW.protocolo IS NOT NULL) THEN 'Gerado' ELSE 'Não Gerado' END;
    END IF;

    IF ((OLD.protocolo IS NOT NULL) OR (OLD.protocolo_gerado IS NOT NULL)) THEN   
    UPDATE smarkio_portoseguroconquista.protocolo_count
	    SET total = total - 1
    WHERE date = OLD.lead_creation_day
    AND protocolo = CASE WHEN (OLD.protocolo IS NOT NULL) THEN 'Gerado' ELSE 'Não Gerado' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portoseguroconquista.protocolo_count (`date`, `protocolo`, `total`)
SELECT c.date, c.protocolo, c.total
FROM (
    SELECT 
	lead_creation_day AS date,
    (CASE WHEN (protocolo IS NOT NULL) THEN 'Gerado' ELSE 'Não Gerado' END) AS protocolo,
    SUM(CASE WHEN ((protocolo IS NOT NULL) OR (protocolo_gerado IS NOT NULL)) THEN 1 ELSE 0 END) AS total
	FROM smarkio_portoseguroconquista.leads 
    WHERE lead_creation_day between '2020-09-19' and '2021-05-17'
	GROUP BY date, protocolo) AS c
  ON DUPLICATE KEY UPDATE
    `date` = c.date,
    `protocolo` = c.protocolo,
    `total` = c.total;