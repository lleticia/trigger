 -- TABLE -- 
  CREATE TABLE `smarkio_guiamais`.`categoria_count` (
  `idcategoria` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `assinante` VARCHAR(255) NOT NULL,
  `faq_categoria` VARCHAR(255) NOT NULL,
  `faq_categoria_c` INT NULL DEFAULT 0,
  `faq_categoria_nc` INT NULL DEFAULT 0,
   PRIMARY KEY (`idcategoria`));

-- TRIGGER --
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_categoria_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.assinante IS NOT NULL)
        AND (NEW.faq_categoria IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_guiamais.categoria_count
        WHERE date = NEW.lead_creation_day
        AND assinante = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
        AND faq_categoria = CASE WHEN (NEW.faq_categoria IS NOT NULL) THEN NEW.faq_categoria ELSE '-' END)=0))
    THEN INSERT INTO smarkio_guiamais.categoria_count
    (date,assinante,faq_categoria)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END,CASE WHEN (NEW.faq_categoria IS NOT NULL) THEN NEW.faq_categoria ELSE '-' END);
    END IF;

	IF (NEW.faq_categoria IS NOT NULL) 
    THEN UPDATE smarkio_guiamais.categoria_count
	    SET faq_categoria_c = CASE 
        WHEN (NEW.assinante = 'Sim') THEN faq_categoria_c + 1
        ELSE faq_categoria_c + 0 END
    WHERE date = NEW.lead_creation_day
    AND assinante = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
    AND faq_categoria = CASE WHEN (NEW.faq_categoria IS NOT NULL) THEN NEW.faq_categoria ELSE '-' END;

    UPDATE smarkio_guiamais.categoria_count
	    SET faq_categoria_nc = CASE 
        WHEN (NEW.assinante = 'Não') THEN faq_categoria_nc + 1
        ELSE faq_categoria_nc + 0 END
    WHERE date = NEW.lead_creation_day
    AND assinante = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
    AND faq_categoria = CASE WHEN (NEW.faq_categoria IS NOT NULL) THEN NEW.faq_categoria ELSE '-' END;
    END IF;		
END 

-- TRIGGER UPDATE --
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_categoria_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.assinante IS NOT NULL)
        AND (NEW.faq_categoria IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_guiamais.categoria_count 
        WHERE date = NEW.lead_creation_day
        AND assinante = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
        AND faq_categoria = CASE WHEN (NEW.faq_categoria IS NOT NULL) THEN NEW.faq_categoria ELSE '-' END)=0))
    THEN INSERT INTO smarkio_guiamais.categoria_count
    (date,assinante,faq_categoria)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END,CASE WHEN (NEW.faq_categoria IS NOT NULL) THEN NEW.faq_categoria ELSE '-' END);
    END IF;

	IF (NEW.faq_categoria IS NOT NULL) 
    THEN UPDATE smarkio_guiamais.categoria_count
	    SET faq_categoria_c = CASE 
        WHEN (NEW.assinante = 'Sim') THEN faq_categoria_c + 1
        ELSE faq_categoria_c + 0 END
    WHERE date = NEW.lead_creation_day
    AND assinante = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
    AND faq_categoria = CASE WHEN (NEW.faq_categoria IS NOT NULL) THEN NEW.faq_categoria ELSE '-' END;

    UPDATE smarkio_guiamais.categoria_count
	    SET faq_categoria_nc = CASE 
        WHEN (NEW.assinante = 'Não') THEN faq_categoria_nc + 1
        ELSE faq_categoria_nc + 0 END
    WHERE date = NEW.lead_creation_day
    AND assinante = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
    AND faq_categoria = CASE WHEN (NEW.faq_categoria IS NOT NULL) THEN NEW.faq_categoria ELSE '-' END;
    END IF;	

	IF (OLD.faq_categoria IS NOT NULL) 
    THEN UPDATE smarkio_guiamais.categoria_count
	    SET faq_categoria_c = CASE 
        WHEN (OLD.assinante = 'Sim') THEN faq_categoria_c - 1
        ELSE faq_categoria_c - 0 END
    WHERE date = OLD.lead_creation_day
    AND assinante = CASE WHEN (OLD.assinante IS NOT NULL) THEN OLD.assinante ELSE '-' END
    AND faq_categoria = CASE WHEN (OLD.faq_categoria IS NOT NULL) THEN OLD.faq_categoria ELSE '-' END;

    UPDATE smarkio_guiamais.categoria_count
	    SET faq_categoria_nc = CASE 
        WHEN (OLD.assinante = 'Não') THEN faq_categoria_nc - 1
        ELSE faq_categoria_nc - 0 END
    WHERE date = OLD.lead_creation_day
    AND assinante = CASE WHEN (OLD.assinante IS NOT NULL) THEN OLD.assinante ELSE '-' END
    AND faq_categoria = CASE WHEN (OLD.faq_categoria IS NOT NULL) THEN OLD.faq_categoria ELSE '-' END;
    END IF;	
END 

-- SELECT -- 
INSERT INTO smarkio_guiamais.categoria_count (`date`, `assinante`, `faq_categoria`, `faq_categoria_c`, `faq_categoria_nc`)
SELECT c.date, c.assinante, c.faq_categoria, c.faq_categoria_c, c.faq_categoria_nc
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (assinante IS NOT NULL) THEN assinante  ELSE '-' END) AS assinante,
    (CASE WHEN (faq_categoria IS NOT NULL) THEN faq_categoria ELSE '-' END) AS faq_categoria,
    SUM(CASE WHEN ((faq_categoria IS NOT NULL) AND (assinante = 'Sim')) THEN 1 ELSE 0 END) AS faq_categoria_c,
    SUM(CASE WHEN ((faq_categoria IS NOT NULL) AND (assinante = 'Não')) THEN 1 ELSE 0 END) AS faq_categoria_nc
	FROM smarkio_guiamais.leads 
        WHERE assinante is not null AND faq_categoria is not null AND supplier = 'Guia Mais' AND campaign = 'Chat Guia Mais' AND lead_creation_day < '2022-06-20'
	GROUP BY date, assinante, faq_categoria) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `assinante` = c.assinante,
        `faq_categoria` = c.faq_categoria,
        `faq_categoria_c` = c.faq_categoria_c,
        `faq_categoria_nc` = c.faq_categoria_nc;