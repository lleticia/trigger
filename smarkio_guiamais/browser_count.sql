 -- TABLE -- 
  CREATE TABLE `smarkio_guiamais`.`browser_count` (
  `idbrowser` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `browser` VARCHAR(255) NOT NULL,
  `iniciouchat` INT NULL DEFAULT 0,
  `cliente` INT NULL DEFAULT 0,
  `menu_c` INT NULL DEFAULT 0,
  `menu_nc` INT NULL DEFAULT 0,
   PRIMARY KEY (`idbrowser`));

-- TRIGGER --
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_browser_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.browser IS NOT NULL)
      AND (SELECT EXISTS (
			SELECT * FROM smarkio_guiamais.browser_count 
			WHERE date = NEW.lead_creation_day
			AND browser = NEW.browser)=0))
    THEN INSERT INTO smarkio_guiamais.browser_count
    (date,browser)
    VALUES (NEW.lead_creation_day,NEW.browser);
    END IF;

	IF (NEW.iniciou_chat IS NOT NULL) 
  THEN UPDATE smarkio_guiamais.browser_count
		SET iniciouchat = iniciouchat + 1
  WHERE date = NEW.lead_creation_day
  AND browser = NEW.browser;
  END IF;

  IF (NEW.assinante IS NOT NULL) 
  THEN UPDATE smarkio_guiamais.browser_count
		SET cliente = cliente + 1
  WHERE date = NEW.lead_creation_day
  AND browser = NEW.browser;
  END IF;

  IF (NEW.menu_principal IS NOT NULL) 
  THEN UPDATE smarkio_guiamais.browser_count
		SET menu_c = menu_c + 1
  WHERE date = NEW.lead_creation_day
  AND browser = NEW.browser;
  END IF;

  IF (NEW.menu_nao_cliente IS NOT NULL) 
  THEN UPDATE smarkio_guiamais.browser_count
		SET menu_nc = menu_nc + 1
  WHERE date = NEW.lead_creation_day
  AND browser = NEW.browser;
  END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_browser_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
  IF ((NEW.browser IS NOT NULL)
      AND (SELECT EXISTS (
			SELECT * FROM smarkio_guiamais.browser_count 
			WHERE date = NEW.lead_creation_day
			AND browser = NEW.browser)=0))
    THEN INSERT INTO smarkio_guiamais.browser_count
    (date,browser)
    VALUES (NEW.lead_creation_day,NEW.browser);
    END IF;

	IF (NEW.iniciou_chat IS NOT NULL) 
  THEN UPDATE smarkio_guiamais.browser_count
		SET iniciouchat = iniciouchat + 1
  WHERE date = NEW.lead_creation_day
  AND browser = NEW.browser;
  END IF;

  IF (NEW.assinante IS NOT NULL) 
  THEN UPDATE smarkio_guiamais.browser_count
		SET cliente = cliente + 1
  WHERE date = NEW.lead_creation_day
  AND browser = NEW.browser;
  END IF;

  IF (NEW.menu_principal IS NOT NULL) 
  THEN UPDATE smarkio_guiamais.browser_count
		SET menu_c = menu_c + 1
  WHERE date = NEW.lead_creation_day
  AND browser = NEW.browser;
  END IF;

  IF (NEW.menu_nao_cliente IS NOT NULL) 
  THEN UPDATE smarkio_guiamais.browser_count
		SET menu_nc = menu_nc + 1
  WHERE date = NEW.lead_creation_day
  AND browser = NEW.browser;
  END IF;

  IF (OLD.iniciou_chat IS NOT NULL)
  THEN UPDATE smarkio_guiamais.browser_count
		SET iniciouchat = iniciouchat - 1
  WHERE date = OLD.lead_creation_day
  AND browser = OLD.browser;
  END IF;

  IF (OLD.assinante IS NOT NULL) 
  THEN UPDATE smarkio_guiamais.browser_count
		SET cliente = cliente - 1
  WHERE date = OLD.lead_creation_day
  AND browser = OLD.browser;
  END IF;

  IF (OLD.menu_principal IS NOT NULL) 
  THEN UPDATE smarkio_guiamais.browser_count
		SET menu_c = menu_c - 1
  WHERE date = OLD.lead_creation_day
  AND browser = OLD.browser;
  END IF;

  IF (OLD.menu_nao_cliente IS NOT NULL) 
  THEN UPDATE smarkio_guiamais.browser_count
    SET menu_nc = menu_nc - 1
  WHERE date = OLD.lead_creation_day
  AND browser = OLD.browser;
  END IF;
END

-- SELECT -- 
INSERT INTO smarkio_guiamais.browser_count (`date`, `browser`, `iniciouchat`, `cliente`, `menu_c`, `menu_nc`)
SELECT c.date, c.browser, c.iniciouchat, c.cliente, c.menu_c, c.menu_nc
FROM 
(
  SELECT 
		lead_creation_day AS date,
    browser,
    SUM(CASE WHEN (iniciou_chat IS NOT NULL) THEN 1 ELSE 0 END) AS iniciouchat,
    SUM(CASE WHEN (assinante IS NOT NULL) THEN 1 ELSE 0 END) AS cliente,
    SUM(CASE WHEN (menu_principal IS NOT NULL) THEN 1 ELSE 0 END) AS menu_c,
    SUM(CASE WHEN (menu_nao_cliente IS NOT NULL) THEN 1 ELSE 0 END) AS menu_nc
	FROM smarkio_guiamais.leads 
    WHERE supplier = 'Guia Mais' AND campaign = 'Chat Guia Mais' AND lead_creation_day < '2022-06-20'
		GROUP BY date, browser) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `browser` = c.browser,
        `iniciouchat` = c.iniciouchat,
        `cliente` = c.cliente,
        `menu_c` = c.menu_c,
        `menu_nc` = c.menu_nc;
