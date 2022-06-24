-- TABLE -- 
  CREATE TABLE `smarkio_portocorretores`.`base_count` (
  `idbase` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `acessos` INT NULL DEFAULT 0,
   PRIMARY KEY (`idbase`));

-- TRIGGER --
USE smarkio_portocorretores;
DELIMITER |
CREATE TRIGGER tg_base_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
        SELECT * FROM smarkio_portocorretores.base_count 
        WHERE date = NEW.lead_creation_day)=0)

    THEN INSERT INTO smarkio_portocorretores.base_count
    (date)
    VALUES (NEW.lead_creation_day);
    END IF;

	IF (NEW.id IS NOT NULL) THEN 
    UPDATE smarkio_portocorretores.base_count
		SET acessos = acessos + 1
    WHERE date = NEW.lead_creation_day;
  END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portocorretores;
DELIMITER |
CREATE TRIGGER tg_base_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN	
    	IF (SELECT EXISTS (
        SELECT * FROM smarkio_portocorretores.base_count 
        WHERE date = NEW.lead_creation_day)=0)

    THEN INSERT INTO smarkio_portocorretores.base_count
    (date)
    VALUES (NEW.lead_creation_day);
    END IF;

	IF (NEW.id IS NOT NULL) THEN 
    UPDATE smarkio_portocorretores.base_count
		SET acessos = acessos + 1
    WHERE date = NEW.lead_creation_day;
  END IF;

  IF (OLD.id IS NOT NULL) THEN 
    UPDATE smarkio_portocorretores.base_count
		SET acessos = acessos - 1
    WHERE date = OLD.lead_creation_day;
  END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portocorretores.base_count (`date`, `acessos`)
SELECT c.date, c.acessos
FROM 
(
  SELECT 
	lead_creation_day AS date,
  SUM(CASE WHEN (id IS NOT NULL) THEN 1 ELSE 0 END) AS acessos
	FROM smarkio_portocorretores.leads 
    WHERE lead_creation_day >= '2021-02-01'
		GROUP BY date) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `acessos` = c.acessos;
