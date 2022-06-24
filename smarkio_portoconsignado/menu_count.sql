
-- TABLE -- 
  CREATE TABLE `smarkio_portoconsignado`.`menu_count` (
  `idmenu` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `menu` VARCHAR(255) NOT NULL,
  `empresa` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
   PRIMARY KEY (`idmenu`));

-- TRIGGER --
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_menu_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.menu_opcao IS NOT NULL) 
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.menu_count 
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND menu = CASE WHEN (NEW.menu_opcao IS NOT NULL) THEN NEW.menu_opcao ELSE '-' END)=0))

        THEN INSERT INTO smarkio_portoconsignado.menu_count
        (date,empresa,menu)
        VALUES (NEW.lead_creation_day,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END,CASE WHEN (NEW.menu_opcao IS NOT NULL) THEN NEW.menu_opcao ELSE '-' END);
    END IF;

	IF (NEW.menu_opcao IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.menu_count
            SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND menu = CASE WHEN (NEW.menu_opcao IS NOT NULL) THEN NEW.menu_opcao ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_menu_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN	
    IF ((NEW.menu_opcao IS NOT NULL) 
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.menu_count 
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND menu = CASE WHEN (NEW.menu_opcao IS NOT NULL) THEN NEW.menu_opcao ELSE '-' END)=0))

        THEN INSERT INTO smarkio_portoconsignado.menu_count
        (date,empresa,menu)
        VALUES (NEW.lead_creation_day,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END,CASE WHEN (NEW.menu_opcao IS NOT NULL) THEN NEW.menu_opcao ELSE '-' END);
    END IF;

	IF (NEW.menu_opcao IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.menu_count
            SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND menu = CASE WHEN (NEW.menu_opcao IS NOT NULL) THEN NEW.menu_opcao ELSE '-' END;
    END IF;

    IF (OLD.menu_opcao IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.menu_count
            SET total = total - 1
        WHERE date = OLD.lead_creation_day
        AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
        AND menu = CASE WHEN (OLD.menu_opcao IS NOT NULL) THEN OLD.menu_opcao ELSE '-' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portoconsignado.menu_count (`date`, `menu`, `empresa`, `total`)
SELECT c.date, c.menu, c.empresa, c.total
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (menu_opcao IS NOT NULL) THEN menu_opcao ELSE '-' END) AS menu,
    (CASE WHEN (nome_fantasia IS NOT NULL) THEN nome_fantasia ELSE '-' END) AS empresa,
    SUM(CASE WHEN (menu_opcao IS NOT NULL) THEN 1 ELSE 0 END) AS total
	FROM smarkio_portoconsignado.leads 
    WHERE lead_creation_day < '2021-05-25'  
    AND menu_opcao IS NOT NULL
	GROUP BY date,menu,empresa) AS c
    ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `menu` = c.menu,
        `empresa` = c.empresa,
        `total` = c.total;
