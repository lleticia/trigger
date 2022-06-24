 -- TABLE -- 
  CREATE TABLE `smarkio_portoseguroconquista`.`comentario_count` (
  `idcomentario` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `comentario` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
  `transbordo` INT NULL DEFAULT 0,
   PRIMARY KEY (`idcomentario`));

-- TRIGGER --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_comentario_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.comentario_atendimento IS NOT NULL) 
        AND (SELECT EXISTS (SELECT * FROM smarkio_portoseguroconquista.comentario_count 
        WHERE date = NEW.lead_creation_day
        AND comentario = CASE WHEN (NEW.comentario_atendimento IS NOT NULL) THEN NEW.comentario_atendimento ELSE '-' END)=0))
    THEN INSERT INTO smarkio_portoseguroconquista.comentario_count 
    (date, comentario)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.comentario_atendimento IS NOT NULL) THEN NEW.comentario_atendimento ELSE '-' END);
    END IF;

	IF (NEW.comentario_atendimento IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.comentario_count 
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND comentario = CASE WHEN (NEW.comentario_atendimento IS NOT NULL) THEN NEW.comentario_atendimento ELSE '-' END;
    END IF;

    IF (NEW.horario_atendimento = '1') THEN 
    UPDATE smarkio_portoseguroconquista.comentario_count 
	    SET transbordo = transbordo + 1
    WHERE date = NEW.lead_creation_day
        AND comentario = CASE WHEN (NEW.comentario_atendimento IS NOT NULL) THEN NEW.comentario_atendimento ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_comentario_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.comentario_atendimento IS NOT NULL) 
        AND (SELECT EXISTS (SELECT * FROM smarkio_portoseguroconquista.comentario_count 
        WHERE date = NEW.lead_creation_day
        AND comentario = CASE WHEN (NEW.comentario_atendimento IS NOT NULL) THEN NEW.comentario_atendimento ELSE '-' END)=0))
    THEN INSERT INTO smarkio_portoseguroconquista.comentario_count 
    (date, comentario)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.comentario_atendimento IS NOT NULL) THEN NEW.comentario_atendimento ELSE '-' END);
    END IF;

	IF (NEW.comentario_atendimento IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.comentario_count 
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND comentario = CASE WHEN (NEW.comentario_atendimento IS NOT NULL) THEN NEW.comentario_atendimento ELSE '-' END;
    END IF;

    IF (NEW.horario_atendimento = '1') THEN 
    UPDATE smarkio_portoseguroconquista.comentario_count 
	    SET transbordo = transbordo + 1
    WHERE date = NEW.lead_creation_day
        AND comentario = CASE WHEN (NEW.comentario_atendimento IS NOT NULL) THEN NEW.comentario_atendimento ELSE '-' END;
    END IF;

    IF (OLD.comentario_atendimento IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.comentario_count 
	    SET total = total - 1
    WHERE date = OLD.lead_creation_day
        AND comentario = CASE WHEN (OLD.comentario_atendimento IS NOT NULL) THEN OLD.comentario_atendimento ELSE '-' END;
    END IF;

    IF (OLD.horario_atendimento = '1') THEN 
    UPDATE smarkio_portoseguroconquista.comentario_count 
	    SET transbordo = transbordo - 1
    WHERE date = OLD.lead_creation_day
        AND comentario = CASE WHEN (OLD.comentario_atendimento IS NOT NULL) THEN OLD.comentario_atendimento ELSE '-' END;
    END IF;
END 

-- SELECT -- 
INSERT INTO smarkio_portoseguroconquista.comentario_count  (`date`, `comentario`, `total`, `transbordo`)
SELECT c.date, c.comentario, c.total, c.transbordo
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (comentario_atendimento IS NOT NULL) THEN comentario_atendimento ELSE '-' END) AS comentario,
    SUM(CASE WHEN (comentario_atendimento IS NOT NULL) THEN 1 ELSE 0 END) AS total,
    SUM(CASE WHEN (horario_atendimento = '1') THEN 1 ELSE 0 END) AS transbordo
	FROM smarkio_portoseguroconquista.leads 
    WHERE lead_creation_day between '2020-09-19' and '2021-05-17'
    AND comentario_atendimento IS NOT NULL
	GROUP BY date, comentario_atendimento) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `comentario` = c.comentario,
        `total` = c.total,
        `transbordo` = c.transbordo;