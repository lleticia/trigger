-- SELECT ORIGINAL --
concluiu_chat 
case
when REGEXP_MATCH(fazer_agora, "Finaliz.*") then 1
when REGEXP_MATCH(dados_confirmados, "Sim") then 1
Else 0
end 

-- TABLE -- 
  CREATE TABLE `smarkio_portocorretores`.`menu_count` (
  `idmenu` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `menu` VARCHAR(255) NOT NULL,
  `browser` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
  `concluiu_chat` INT NULL DEFAULT 0,
   PRIMARY KEY (`idmenu`));

-- TRIGGER --
USE smarkio_portocorretores;
DELIMITER |
CREATE TRIGGER tg_menu_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF  ((NEW.gostaria IS NOT NULL))
        AND (SELECT EXISTS (
			SELECT * FROM smarkio_portocorretores.menu_count 
			WHERE date = NEW.lead_creation_day
			AND menu = CASE WHEN (NEW.gostaria IS NOT NULL) THEN NEW.gostaria ELSE '-' END
            AND browser = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END)=0)

    THEN INSERT INTO smarkio_portocorretores.menu_count
    (date,menu,browser)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.gostaria IS NOT NULL) THEN NEW.gostaria ELSE '-' END,
        CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END);
    END IF;

	IF (NEW.gostaria IS NOT NULL)
    THEN UPDATE smarkio_portocorretores.menu_count
		SET total = total + 1
    WHERE date = NEW.lead_creation_day
		AND menu = CASE WHEN (NEW.gostaria IS NOT NULL) THEN NEW.gostaria ELSE '-' END
        AND browser = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END;

    UPDATE smarkio_portocorretores.menu_count
		SET concluiu_chat = CASE 
            WHEN (NEW.fazer_agora LIKE 'Finaliz%') THEN concluiu_chat + 1
            WHEN (NEW.dados_confirmados = 'Sim') THEN concluiu_chat + 1
        ELSE concluiu_chat + 0 END
    WHERE date = NEW.lead_creation_day
		AND menu = CASE WHEN (NEW.gostaria IS NOT NULL) THEN NEW.gostaria ELSE '-' END
        AND browser = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portocorretores;
DELIMITER |
CREATE TRIGGER tg_menu_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN	
    	IF  ((NEW.gostaria IS NOT NULL))
        AND (SELECT EXISTS (
			SELECT * FROM smarkio_portocorretores.menu_count 
			WHERE date = NEW.lead_creation_day
			AND menu = CASE WHEN (NEW.gostaria IS NOT NULL) THEN NEW.gostaria ELSE '-' END
            AND browser = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END)=0)

    THEN INSERT INTO smarkio_portocorretores.menu_count
    (date,menu,browser)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.gostaria IS NOT NULL) THEN NEW.gostaria ELSE '-' END,
        CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END);
    END IF;

	IF (NEW.gostaria IS NOT NULL)
    THEN UPDATE smarkio_portocorretores.menu_count
		SET total = total + 1
    WHERE date = NEW.lead_creation_day
		AND menu = CASE WHEN (NEW.gostaria IS NOT NULL) THEN NEW.gostaria ELSE '-' END
        AND browser = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END;

    UPDATE smarkio_portocorretores.menu_count
		SET concluiu_chat = CASE 
            WHEN (NEW.fazer_agora LIKE 'Finaliz%') THEN concluiu_chat + 1
            WHEN (NEW.dados_confirmados = 'Sim') THEN concluiu_chat + 1
        ELSE concluiu_chat + 0 END
    WHERE date = NEW.lead_creation_day
		AND menu = CASE WHEN (NEW.gostaria IS NOT NULL) THEN NEW.gostaria ELSE '-' END
        AND browser = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END;
    END IF;

    IF (OLD.gostaria IS NOT NULL)
    THEN UPDATE smarkio_portocorretores.menu_count
		SET total = total - 1
    WHERE date = OLD.lead_creation_day
		AND menu = CASE WHEN (OLD.gostaria IS NOT NULL) THEN OLD.gostaria ELSE '-' END
        AND browser = CASE WHEN (OLD.browser IS NOT NULL) THEN OLD.browser ELSE '-' END;

    UPDATE smarkio_portocorretores.menu_count
		SET concluiu_chat = CASE 
            WHEN (OLD.fazer_agora LIKE 'Finaliz%') THEN concluiu_chat - 1
            WHEN (OLD.dados_confirmados = 'Sim') THEN concluiu_chat - 1
        ELSE concluiu_chat - 0 END
    WHERE date = OLD.lead_creation_day
		AND menu = CASE WHEN (OLD.gostaria IS NOT NULL) THEN OLD.gostaria ELSE '-' END
        AND browser = CASE WHEN (OLD.browser IS NOT NULL) THEN OLD.browser ELSE '-' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portocorretores.menu_count (`date`, `menu`, `browser`, `total`, `concluiu_chat`)
SELECT c.date, c.menu, c.browser, c.total, c.concluiu_chat
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (gostaria IS NOT NULL) THEN gostaria ELSE '-' END) as menu,
    (CASE WHEN (browser IS NOT NULL) THEN browser ELSE '-' END) as browser,
    SUM(CASE WHEN (gostaria IS NOT NULL) THEN 1 ELSE 0 END) AS total,
    SUM(CASE WHEN (fazer_agora LIKE 'Finaliz%') THEN 1
        WHEN (dados_confirmados = 'Sim') THEN 1 ELSE 0 END) AS concluiu_chat
	FROM smarkio_portocorretores.leads 
    WHERE lead_creation_day >= '2021-02-01'
        AND gostaria IS NOT NULL 
		GROUP BY date, menu, browser) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `menu` = c.menu,
        `browser` = c.browser,
        `total` = c.total,
        `concluiu_chat` = c.concluiu_chat;