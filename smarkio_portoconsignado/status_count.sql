
-- TABLE -- 
  CREATE TABLE `smarkio_portoconsignado`.`status_count` (
  `idstatus` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `status` VARCHAR(255) NOT NULL,
  `empresa` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
   PRIMARY KEY (`idstatus`));

-- TRIGGER --
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_status_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.lead_status IS NOT NULL) 
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.status_count 
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND status = CASE WHEN (NEW.lead_status IS NOT NULL) THEN NEW.lead_status ELSE '-' END)=0))

        THEN INSERT INTO smarkio_portoconsignado.status_count
        (date,status,empresa)
        VALUES (NEW.lead_creation_day,CASE WHEN (NEW.lead_status IS NOT NULL) THEN NEW.lead_status ELSE '-' END,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END);
    END IF;

	IF (NEW.lead_status IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.status_count
            SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND status = CASE WHEN (NEW.lead_status IS NOT NULL) THEN NEW.lead_status ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_status_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN	
    IF ((NEW.lead_status IS NOT NULL) 
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.status_count 
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND status = CASE WHEN (NEW.lead_status IS NOT NULL) THEN NEW.lead_status ELSE '-' END)=0))

        THEN INSERT INTO smarkio_portoconsignado.status_count
        (date,status,empresa)
        VALUES (NEW.lead_creation_day,CASE WHEN (NEW.lead_status IS NOT NULL) THEN NEW.lead_status ELSE '-' END,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END);
    END IF;

	IF (NEW.lead_status IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.status_count
            SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND status = CASE WHEN (NEW.lead_status IS NOT NULL) THEN NEW.lead_status ELSE '-' END;
    END IF;

    IF (OLD.lead_status IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.status_count
            SET total = total + 1
        WHERE date = OLD.lead_creation_day
        AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
        AND status = CASE WHEN (OLD.lead_status IS NOT NULL) THEN OLD.lead_status ELSE '-' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portoconsignado.status_count (`date`, `status`, `empresa`, `total`)
SELECT c.date, c.status, c.empresa, c.total
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (lead_status IS NOT NULL) THEN lead_status ELSE '-' END) AS status,
    (CASE WHEN (nome_fantasia IS NOT NULL) THEN nome_fantasia ELSE '-' END) AS empresa,
    SUM(CASE WHEN (lead_status IS NOT NULL) THEN 1 ELSE 0 END) AS total
	FROM smarkio_portoconsignado.leads 
    WHERE lead_creation_day < '2021-05-25'     
    AND lead_status IS NOT NULL
	GROUP BY date,status,empresa) AS c
    ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `status` = c.status,
        `empresa` = c.empresa,
        `total` = c.total;
