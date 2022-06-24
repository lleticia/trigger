-- TABLE -- 
  CREATE TABLE `smarkio_portocorretores`.`fazeragora_count` (
  `idfazeragora` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `menu` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
   PRIMARY KEY (`idfazeragora`));

-- TRIGGER --
USE smarkio_portocorretores;
DELIMITER |
CREATE TRIGGER tg_fazeragora_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.fazer_agora IS NOT NULL) 
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portocorretores.fazeragora_count 
        WHERE date = NEW.lead_creation_day
        AND menu = CASE WHEN (NEW.fazer_agora IS NOT NULL) THEN NEW.fazer_agora ELSE '-' END)=0))

    THEN INSERT INTO smarkio_portocorretores.fazeragora_count
    (date,menu)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.fazer_agora IS NOT NULL) THEN NEW.fazer_agora ELSE '-' END);
    END IF;

	IF (NEW.fazer_agora IS NOT NULL) THEN 
    UPDATE smarkio_portocorretores.fazeragora_count
		SET total = total + 1
    WHERE date = NEW.lead_creation_day
		AND menu = CASE WHEN (NEW.fazer_agora IS NOT NULL) THEN NEW.fazer_agora ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portocorretores;
DELIMITER |
CREATE TRIGGER tg_fazeragora_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN	
    IF ((NEW.fazer_agora IS NOT NULL) 
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portocorretores.fazeragora_count 
        WHERE date = NEW.lead_creation_day
        AND menu = CASE WHEN (NEW.fazer_agora IS NOT NULL) THEN NEW.fazer_agora ELSE '-' END)=0))

    THEN INSERT INTO smarkio_portocorretores.fazeragora_count
    (date,menu)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.fazer_agora IS NOT NULL) THEN NEW.fazer_agora ELSE '-' END);
    END IF;

	IF (NEW.fazer_agora IS NOT NULL) THEN 
    UPDATE smarkio_portocorretores.fazeragora_count
		SET total = total + 1
    WHERE date = NEW.lead_creation_day
		AND menu = CASE WHEN (NEW.fazer_agora IS NOT NULL) THEN NEW.fazer_agora ELSE '-' END;
    END IF;

    IF (OLD.fazer_agora IS NOT NULL) THEN 
    UPDATE smarkio_portocorretores.fazeragora_count
		SET total = total - 1
    WHERE date = OLD.lead_creation_day
		AND menu = CASE WHEN (OLD.fazer_agora IS NOT NULL) THEN OLD.fazer_agora ELSE '-' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portocorretores.fazeragora_count (`date`, `menu`, `total`)
SELECT c.date, c.menu, c.total
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (fazer_agora IS NOT NULL) THEN fazer_agora ELSE '-' END) as menu,
    SUM(CASE WHEN (fazer_agora IS NOT NULL) THEN 1 ELSE 0 END) AS total
	FROM smarkio_portocorretores.leads 
    WHERE lead_creation_day >= '2021-02-01'
    AND fazer_agora IS NOT NULL
		GROUP BY date, menu) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `menu` = c.menu,
        `total` = c.total;
