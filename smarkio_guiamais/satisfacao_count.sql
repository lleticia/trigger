 -- TABLE -- 
  CREATE TABLE `smarkio_guiamais`.`satisfacao_count` (
  `idsatisfacao` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `satisfacao_c` VARCHAR(255) NOT NULL,
  `satisfacao_nc` VARCHAR(255) NOT NULL,
  `totalnota_c` INT NULL DEFAULT 0,
  `totalnota_nc` INT NULL DEFAULT 0,
  `total_c` INT NULL DEFAULT 0,
  `total_nc` INT NULL DEFAULT 0,
   PRIMARY KEY (`idsatisfacao`));

-- TRIGGER --
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_satisfacao_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF (((NEW.pesquisa_satisfacao IS NOT NULL) OR (NEW.pesquisa_nao_cliente IS NOT NULL))
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_guiamais.satisfacao_count
        WHERE date = NEW.lead_creation_day
        AND satisfacao_c = CASE WHEN (NEW.pesquisa_satisfacao IS NULL) THEN '-' ELSE NEW.pesquisa_satisfacao END
        AND satisfacao_nc = CASE WHEN (NEW.pesquisa_nao_cliente IS NULL) THEN '-' ELSE NEW.pesquisa_nao_cliente END)=0))
    THEN INSERT INTO smarkio_guiamais.satisfacao_count
    (date,satisfacao_c,satisfacao_nc)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.pesquisa_satisfacao IS NULL) THEN '-' ELSE NEW.pesquisa_satisfacao END,CASE WHEN (NEW.pesquisa_nao_cliente IS NULL) THEN '-' ELSE NEW.pesquisa_nao_cliente END);
    END IF;

	IF (NEW.pesquisa_satisfacao IS NOT NULL) 
    THEN UPDATE smarkio_guiamais.satisfacao_count
	    SET total_c = total_c + 1
    WHERE date = NEW.lead_creation_day
    AND satisfacao_c = CASE WHEN (NEW.pesquisa_satisfacao IS NULL) THEN '-' ELSE NEW.pesquisa_satisfacao END
    AND satisfacao_nc = CASE WHEN (NEW.pesquisa_nao_cliente IS NULL) THEN '-' ELSE NEW.pesquisa_nao_cliente END;

    UPDATE smarkio_guiamais.satisfacao_count
	    SET totalnota_c = CASE
        WHEN NEW.pesquisa_satisfacao = '1' THEN totalnota_c + 1
        WHEN NEW.pesquisa_satisfacao = '2' THEN totalnota_c + 2
        WHEN NEW.pesquisa_satisfacao = '3' THEN totalnota_c + 3
        WHEN NEW.pesquisa_satisfacao = '4' THEN totalnota_c + 4
        WHEN NEW.pesquisa_satisfacao = '5' THEN totalnota_c + 5
        ELSE totalnota_c + 0
        END
    WHERE date = NEW.lead_creation_day
    AND satisfacao_c = CASE WHEN (NEW.pesquisa_satisfacao IS NULL) THEN '-' ELSE NEW.pesquisa_satisfacao END
    AND satisfacao_nc = CASE WHEN (NEW.pesquisa_nao_cliente IS NULL) THEN '-' ELSE NEW.pesquisa_nao_cliente END;
    END IF;

    IF (NEW.pesquisa_nao_cliente IS NOT NULL)  
	THEN UPDATE smarkio_guiamais.satisfacao_count
	    SET total_nc = total_nc + 1
    WHERE date = NEW.lead_creation_day
    AND satisfacao_c = CASE WHEN (NEW.pesquisa_satisfacao IS NULL) THEN '-' ELSE NEW.pesquisa_satisfacao END
    AND satisfacao_nc = CASE WHEN (NEW.pesquisa_nao_cliente IS NULL) THEN '-' ELSE NEW.pesquisa_nao_cliente END;

    UPDATE smarkio_guiamais.satisfacao_count
	SET totalnota_nc = CASE
        WHEN NEW.pesquisa_nao_cliente = '1' THEN totalnota_nc + 1
        WHEN NEW.pesquisa_nao_cliente = '2' THEN totalnota_nc + 2
        WHEN NEW.pesquisa_nao_cliente = '3' THEN totalnota_nc + 3
        WHEN NEW.pesquisa_nao_cliente = '4' THEN totalnota_nc + 4
        WHEN NEW.pesquisa_nao_cliente = '5' THEN totalnota_nc + 5
        ELSE totalnota_nc + 0
        END
    WHERE date = NEW.lead_creation_day
    AND satisfacao_c = CASE WHEN (NEW.pesquisa_satisfacao IS NULL) THEN '-' ELSE NEW.pesquisa_satisfacao END
    AND satisfacao_nc = CASE WHEN (NEW.pesquisa_nao_cliente IS NULL) THEN '-' ELSE NEW.pesquisa_nao_cliente END;
    END IF;
END 

-- TRIGGER UPDATE --
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_satisfacao_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF (((NEW.pesquisa_satisfacao IS NOT NULL) OR (NEW.pesquisa_nao_cliente IS NOT NULL))
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_guiamais.satisfacao_count
        WHERE date = NEW.lead_creation_day
        AND satisfacao_c = CASE WHEN (NEW.pesquisa_satisfacao IS NULL) THEN '-' ELSE NEW.pesquisa_satisfacao END
        AND satisfacao_nc = CASE WHEN (NEW.pesquisa_nao_cliente IS NULL) THEN '-' ELSE NEW.pesquisa_nao_cliente END)=0))
    THEN INSERT INTO smarkio_guiamais.satisfacao_count
    (date,satisfacao_c,satisfacao_nc)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.pesquisa_satisfacao IS NULL) THEN '-' ELSE NEW.pesquisa_satisfacao END,CASE WHEN (NEW.pesquisa_nao_cliente IS NULL) THEN '-' ELSE NEW.pesquisa_nao_cliente END);
    END IF;

	IF (NEW.pesquisa_satisfacao IS NOT NULL) 
    THEN UPDATE smarkio_guiamais.satisfacao_count
	    SET total_c = total_c + 1
    WHERE date = NEW.lead_creation_day
    AND satisfacao_c = CASE WHEN (NEW.pesquisa_satisfacao IS NULL) THEN '-' ELSE NEW.pesquisa_satisfacao END
    AND satisfacao_nc = CASE WHEN (NEW.pesquisa_nao_cliente IS NULL) THEN '-' ELSE NEW.pesquisa_nao_cliente END;

    UPDATE smarkio_guiamais.satisfacao_count
	    SET totalnota_c = CASE
        WHEN NEW.pesquisa_satisfacao = '1' THEN totalnota_c + 1
        WHEN NEW.pesquisa_satisfacao = '2' THEN totalnota_c + 2
        WHEN NEW.pesquisa_satisfacao = '3' THEN totalnota_c + 3
        WHEN NEW.pesquisa_satisfacao = '4' THEN totalnota_c + 4
        WHEN NEW.pesquisa_satisfacao = '5' THEN totalnota_c + 5
        ELSE totalnota_c + 0
        END
    WHERE date = NEW.lead_creation_day
    AND satisfacao_c = CASE WHEN (NEW.pesquisa_satisfacao IS NULL) THEN '-' ELSE NEW.pesquisa_satisfacao END
    AND satisfacao_nc = CASE WHEN (NEW.pesquisa_nao_cliente IS NULL) THEN '-' ELSE NEW.pesquisa_nao_cliente END;
    END IF;

    IF (NEW.pesquisa_nao_cliente IS NOT NULL)  
	THEN UPDATE smarkio_guiamais.satisfacao_count
	    SET total_nc = total_nc + 1
    WHERE date = NEW.lead_creation_day
    AND satisfacao_c = CASE WHEN (NEW.pesquisa_satisfacao IS NULL) THEN '-' ELSE NEW.pesquisa_satisfacao END
    AND satisfacao_nc = CASE WHEN (NEW.pesquisa_nao_cliente IS NULL) THEN '-' ELSE NEW.pesquisa_nao_cliente END;

    UPDATE smarkio_guiamais.satisfacao_count
	SET totalnota_nc = CASE
        WHEN NEW.pesquisa_nao_cliente = '1' THEN totalnota_nc + 1
        WHEN NEW.pesquisa_nao_cliente = '2' THEN totalnota_nc + 2
        WHEN NEW.pesquisa_nao_cliente = '3' THEN totalnota_nc + 3
        WHEN NEW.pesquisa_nao_cliente = '4' THEN totalnota_nc + 4
        WHEN NEW.pesquisa_nao_cliente = '5' THEN totalnota_nc + 5
        ELSE totalnota_nc + 0
        END
    WHERE date = NEW.lead_creation_day
    AND satisfacao_c = CASE WHEN (NEW.pesquisa_satisfacao IS NULL) THEN '-' ELSE NEW.pesquisa_satisfacao END
    AND satisfacao_nc = CASE WHEN (NEW.pesquisa_nao_cliente IS NULL) THEN '-' ELSE NEW.pesquisa_nao_cliente END;
    END IF;

    IF (OLD.pesquisa_satisfacao IS NOT NULL)  
	THEN UPDATE smarkio_guiamais.satisfacao_count
	    SET total_c = total_c - 1
    WHERE date = OLD.lead_creation_day
    AND satisfacao_c = CASE WHEN (OLD.pesquisa_satisfacao IS NULL) THEN '-' ELSE OLD.pesquisa_satisfacao END
    AND satisfacao_nc = CASE WHEN (OLD.pesquisa_nao_cliente IS NULL) THEN '-' ELSE OLD.pesquisa_nao_cliente END;

    UPDATE smarkio_guiamais.satisfacao_count
	    SET totalnota_c = CASE
        WHEN OLD.pesquisa_satisfacao = '1' THEN totalnota_c - 1
        WHEN OLD.pesquisa_satisfacao = '2' THEN totalnota_c - 2
        WHEN OLD.pesquisa_satisfacao = '3' THEN totalnota_c - 3
        WHEN OLD.pesquisa_satisfacao = '4' THEN totalnota_c - 4
        WHEN OLD.pesquisa_satisfacao = '5' THEN totalnota_c - 5
        ELSE totalnota_c - 0
        END
    WHERE date = OLD.lead_creation_day
    AND satisfacao_c = CASE WHEN (OLD.pesquisa_satisfacao IS NULL) THEN '-' ELSE OLD.pesquisa_satisfacao END
    AND satisfacao_nc = CASE WHEN (OLD.pesquisa_nao_cliente IS NULL) THEN '-' ELSE OLD.pesquisa_nao_cliente END;
    END IF;
    
    IF (OLD.pesquisa_nao_cliente IS NOT NULL) 
    THEN UPDATE smarkio_guiamais.satisfacao_count 
	    SET total_nc = total_nc - 1
    WHERE date = OLD.lead_creation_day
    AND satisfacao_c = CASE WHEN (OLD.pesquisa_satisfacao IS NULL) THEN '-' ELSE OLD.pesquisa_satisfacao END
    AND satisfacao_nc = CASE WHEN (OLD.pesquisa_nao_cliente IS NULL) THEN '-' ELSE OLD.pesquisa_nao_cliente END;

    UPDATE smarkio_guiamais.satisfacao_count
	    SET totalnota_nc = CASE
        WHEN OLD.pesquisa_nao_cliente = '1' THEN totalnota_nc - 1
        WHEN OLD.pesquisa_nao_cliente = '2' THEN totalnota_nc - 2
        WHEN OLD.pesquisa_nao_cliente = '3' THEN totalnota_nc - 3
        WHEN OLD.pesquisa_nao_cliente = '4' THEN totalnota_nc - 4
        WHEN OLD.pesquisa_nao_cliente = '5' THEN totalnota_nc - 5
        ELSE totalnota_nc - 0
        END
    WHERE date = OLD.lead_creation_day
    AND satisfacao_c = CASE WHEN (OLD.pesquisa_satisfacao IS NULL) THEN '-' ELSE OLD.pesquisa_satisfacao END
    AND satisfacao_nc = CASE WHEN (OLD.pesquisa_nao_cliente IS NULL) THEN '-' ELSE OLD.pesquisa_nao_cliente END;
    END IF;
END 

-- SELECT -- 
INSERT INTO smarkio_guiamais.satisfacao_count (`date`, `satisfacao_c`, `satisfacao_nc`, `totalnota_c`, `totalnota_nc`, `total_c`, `total_nc`)
SELECT c.date, c.satisfacao_c, c.satisfacao_nc, c.totalnota_c, c.totalnota_nc, c.total_c, c.total_nc
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (pesquisa_satisfacao IS NULL) THEN '-' ELSE pesquisa_satisfacao END) AS satisfacao_c,
    (CASE WHEN (pesquisa_nao_cliente IS NULL) THEN '-' ELSE pesquisa_nao_cliente END) AS satisfacao_nc,
    SUM(CASE WHEN ((pesquisa_satisfacao = '1') AND (assinante = 'Sim')) THEN 1 
    WHEN ((pesquisa_satisfacao = '2') AND (assinante = 'Sim')) THEN 2
    WHEN ((pesquisa_satisfacao = '3') AND (assinante = 'Sim')) THEN 3 
    WHEN ((pesquisa_satisfacao = '4') AND (assinante = 'Sim')) THEN 4 
    WHEN ((pesquisa_satisfacao = '5') AND (assinante = 'Sim')) THEN 5 ELSE 0 END) AS totalnota_c,
    SUM(CASE WHEN ((pesquisa_nao_cliente  = '1') AND (assinante = 'Não')) THEN 1
    WHEN ((pesquisa_nao_cliente  = '2') AND (assinante = 'Não')) THEN 2
    WHEN ((pesquisa_nao_cliente  = '3') AND (assinante = 'Não')) THEN 3
    WHEN ((pesquisa_nao_cliente  = '4') AND (assinante = 'Não')) THEN 4
    WHEN ((pesquisa_nao_cliente  = '5') AND (assinante = 'Não')) THEN 5 ELSE 0 END) AS totalnota_nc,
    SUM(CASE WHEN ((pesquisa_satisfacao IS NOT NULL) AND (assinante = 'Sim')) THEN 1 ELSE 0 END) AS total_c,
    SUM(CASE WHEN ((pesquisa_nao_cliente IS NOT NULL) AND (assinante = 'Não')) THEN 1 ELSE 0 END) AS total_nc
	FROM smarkio_guiamais.leads 
        WHERE assinante IS NOT NULL AND ((pesquisa_satisfacao IS NOT NULL) OR (pesquisa_nao_cliente IS NOT NULL))
        AND supplier = 'Guia Mais' AND campaign = 'Chat Guia Mais' AND lead_creation_day < '2022-06-20'
	GROUP BY date, satisfacao_c, satisfacao_nc) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `satisfacao_c` = c.satisfacao_c,
        `satisfacao_nc` = c.satisfacao_nc,
        `totalnota_c` = c.totalnota_c,
        `totalnota_nc` = c.totalnota_nc,
        `total_c` = c.total_c,
        `total_nc` = c.total_nc;