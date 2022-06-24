 -- TABLE -- 
  CREATE TABLE `smarkio_guiamais`.`funil_count` (
  `idfunil` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `assinante` VARCHAR(255) NOT NULL,
  `celular` VARCHAR(255) NOT NULL,
  `assinante_c` INT NULL DEFAULT 0,
  `celular_c` INT NULL DEFAULT 0,
   PRIMARY KEY (`idfunil`));

-- TRIGGER --
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_funil_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF (((NEW.assinante IS NOT NULL) OR (NEW.confirmacao_celular_cadastro IS NOT NULL))
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_guiamais.funil_count 
        WHERE date = NEW.lead_creation_day
        AND assinante = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END 
        AND celular = CASE WHEN (NEW.confirmacao_celular_cadastro IS NOT NULL) THEN NEW.confirmacao_celular_cadastro ELSE '-' END)=0))

    THEN INSERT INTO smarkio_guiamais.funil_count
    (date,assinante,celular)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END,CASE WHEN (NEW.confirmacao_celular_cadastro IS NOT NULL) THEN NEW.confirmacao_celular_cadastro ELSE '-' END);
    END IF;

	IF (NEW.assinante IS NOT NULL)  
    THEN UPDATE smarkio_guiamais.funil_count
	    SET assinante_c = assinante_c + 1
    WHERE date = NEW.lead_creation_day
    AND assinante = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
    AND celular = CASE WHEN (NEW.confirmacao_celular_cadastro IS NOT NULL) THEN NEW.confirmacao_celular_cadastro ELSE '-' END;
    END IF;	

    IF (NEW.confirmacao_celular_cadastro IS NOT NULL) 
    THEN UPDATE smarkio_guiamais.funil_count
	    SET celular_c = celular_c + 1
    WHERE date = NEW.lead_creation_day
    AND assinante = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
    AND celular = CASE WHEN (NEW.confirmacao_celular_cadastro IS NOT NULL) THEN NEW.confirmacao_celular_cadastro ELSE '-' END;
    END IF;	
END 

-- TRIGGER UPDATE --
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_funil_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF (((NEW.assinante IS NOT NULL) OR (NEW.confirmacao_celular_cadastro IS NOT NULL))
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_guiamais.funil_count 
        WHERE date = NEW.lead_creation_day
        AND assinante = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END 
        AND celular = CASE WHEN (NEW.confirmacao_celular_cadastro IS NOT NULL) THEN NEW.confirmacao_celular_cadastro ELSE '-' END)=0))

    THEN INSERT INTO smarkio_guiamais.funil_count
    (date,assinante,celular)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END,CASE WHEN (NEW.confirmacao_celular_cadastro IS NOT NULL) THEN NEW.confirmacao_celular_cadastro ELSE '-' END);
    END IF;

	IF (NEW.assinante IS NOT NULL)  
    THEN UPDATE smarkio_guiamais.funil_count
	    SET assinante_c = assinante_c + 1
    WHERE date = NEW.lead_creation_day
    AND assinante = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
    AND celular = CASE WHEN (NEW.confirmacao_celular_cadastro IS NOT NULL) THEN NEW.confirmacao_celular_cadastro ELSE '-' END;
    END IF;	

    IF (NEW.confirmacao_celular_cadastro IS NOT NULL) 
    THEN UPDATE smarkio_guiamais.funil_count
	    SET celular_c = celular_c + 1
    WHERE date = NEW.lead_creation_day
    AND assinante = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
    AND celular = CASE WHEN (NEW.confirmacao_celular_cadastro IS NOT NULL) THEN NEW.confirmacao_celular_cadastro ELSE '-' END;
    END IF;	

	IF (OLD.assinante IS NOT NULL)   
    THEN UPDATE smarkio_guiamais.funil_count
	    SET assinante_c = assinante_c - 1
    WHERE date = OLD.lead_creation_day
    AND assinante = CASE WHEN (OLD.assinante IS NOT NULL) THEN OLD.assinante ELSE '-' END
    AND celular = CASE WHEN (OLD.confirmacao_celular_cadastro IS NOT NULL) THEN OLD.confirmacao_celular_cadastro ELSE '-' END;
    END IF;	

    IF (OLD.confirmacao_celular_cadastro IS NOT NULL)  
    THEN UPDATE smarkio_guiamais.funil_count
	    SET celular_c = celular_c - 1
    WHERE date = OLD.lead_creation_day
    AND assinante = CASE WHEN (OLD.assinante IS NOT NULL) THEN OLD.assinante ELSE '-' END
    AND celular = CASE WHEN (OLD.confirmacao_celular_cadastro IS NOT NULL) THEN OLD.confirmacao_celular_cadastro ELSE '-' END;
    END IF;	
END 

-- SELECT -- 
INSERT INTO smarkio_guiamais.funil_count (`date`, `assinante`, `celular`, `celular_c`, `assinante_c`)
SELECT c.date, c.assinante, c.celular, c.celular_c, c.assinante_c
FROM
(
    SELECT 
	lead_creation_day AS date,
    (CASE WHEN (assinante IS NOT NULL) THEN assinante  ELSE '-' END) AS assinante,
    (CASE WHEN (confirmacao_celular_cadastro IS NOT NULL) THEN confirmacao_celular_cadastro ELSE '-' END) AS celular,
    SUM(CASE WHEN (confirmacao_celular_cadastro IS NOT NULL) THEN 1 ELSE 0 END) AS celular_c,
    SUM(CASE WHEN (assinante IS NOT NULL) THEN 1 ELSE 0 END) AS assinante_c
	FROM smarkio_guiamais.leads 
        WHERE assinante is not null AND supplier = 'Guia Mais' AND campaign = 'Chat Guia Mais' AND lead_creation_day < '2022-06-20'
	GROUP BY date, assinante, celular) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `assinante` = c.assinante,
        `celular` = c.celular,
        `celular_c` = c.celular_c,
        `assinante_c` = c.assinante_c;