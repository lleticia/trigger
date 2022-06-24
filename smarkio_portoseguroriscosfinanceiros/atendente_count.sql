-- TABLE -- 
  CREATE TABLE `smarkio_portoseguroriscosfinanceiros`.`atendente_count` (
  `idatendente` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL, 
  `total` INT(11) NULL DEFAULT 0,
  PRIMARY KEY (`idatendente`));

-- TRIGGER --
USE smarkio_portoseguroriscosfinanceiros;
DELIMITER |
CREATE TRIGGER tg_atendente_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF (SELECT EXISTS (
        SELECT * FROM smarkio_portoseguroriscosfinanceiros.atendente_count 
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00"))=0)
          
    THEN INSERT INTO smarkio_portoseguroriscosfinanceiros.atendente_count
    (date)
    VALUES (DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00"));
    END IF;

    IF (NEW.clicou_atendente IS NOT NULL) THEN 
        UPDATE smarkio_portoseguroriscosfinanceiros.atendente_count
        SET total = total + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00");
    END IF;	
END;

-- TRIGGER UPDATE--
USE smarkio_portoseguroriscosfinanceiros;
DELIMITER |
CREATE TRIGGER tg_atendente_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF (SELECT EXISTS (
        SELECT * FROM smarkio_portoseguroriscosfinanceiros.atendente_count 
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00"))=0)
          
    THEN INSERT INTO smarkio_portoseguroriscosfinanceiros.atendente_count
    (date)
    VALUES (DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00"));
    END IF;

    IF (NEW.clicou_atendente IS NOT NULL) THEN 
        UPDATE smarkio_portoseguroriscosfinanceiros.atendente_count
        SET total = total + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00");
    END IF;	

    IF (OLD.clicou_atendente IS NOT NULL) THEN 
        UPDATE smarkio_portoseguroriscosfinanceiros.atendente_count
        SET total = total - 1
        WHERE date = DATE_FORMAT(OLD.created_at,"%Y-%m-%d %H:00");
    END IF;	
END;

-- SELECT -- 
INSERT INTO smarkio_portoseguroriscosfinanceiros.atendente_count (`date`, `total`)
SELECT c.date, c.total
FROM 
(
SELECT 
	  DATE_FORMAT(created_at,"%Y-%m-%d %H:00") AS date,
      SUM(CASE WHEN (clicou_atendente IS NOT NULL)  THEN 1 ELSE 0 END) AS total
	FROM smarkio_portoseguroriscosfinanceiros.leads 
    WHERE lead_creation_day between '2021-06-01' and '2021-06-07'
    AND clicou_atendente IS NOT NULL
	GROUP BY date) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `total` = c.total;