 -- TABLE -- 
  CREATE TABLE `smarkio_guiamais`.`menu_count` (
  `idmenu` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `menu` VARCHAR(255) NOT NULL,
  `cliente` VARCHAR(255) NOT NULL,
  `menu_c` VARCHAR(255) NULL,
  `menu_nc` VARCHAR(255) NULL,
  `total_c` INT NULL DEFAULT 0,
  `total_nc` INT NULL DEFAULT 0,
   PRIMARY KEY (`idmenu`));

-- TRIGGER --
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_menu_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.assinante IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_guiamais.menu_count 
        WHERE date = NEW.lead_creation_day
        AND cliente = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
        AND menu = CASE WHEN (NEW.menu_nao_encontrado = '1') THEN 'Não Encontrado' ELSE 'Encontrado' END
        AND menu_c = CASE WHEN (NEW.menu_principal IS NOT NULL) THEN NEW.menu_principal ELSE '-' END
        AND menu_nc = CASE WHEN (NEW.menu_nao_cliente IS NOT NULL) THEN NEW.menu_nao_cliente ELSE '-' END)=0))
    THEN INSERT INTO smarkio_guiamais.menu_count 
    (date, cliente, menu, menu_c, menu_nc)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END,CASE WHEN (NEW.menu_nao_encontrado = '1') THEN 'Não Encontrado' ELSE 'Encontrado' END,CASE WHEN (NEW.menu_principal IS NOT NULL) THEN NEW.menu_principal ELSE '-' END,CASE WHEN (NEW.menu_nao_cliente IS NOT NULL) THEN NEW.menu_nao_cliente ELSE '-' END);
    END IF;

	IF ((NEW.menu_principal IS NOT NULL) AND (NEW.assinante = 'Sim')) 
	THEN UPDATE smarkio_guiamais.menu_count 
	    SET total_c = total_c + 1
    WHERE date = NEW.lead_creation_day
    AND cliente = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
    AND menu = CASE WHEN (NEW.menu_nao_encontrado = '1') THEN 'Não Encontrado' ELSE 'Encontrado' END
    AND menu_c = CASE WHEN (NEW.menu_principal IS NOT NULL) THEN NEW.menu_principal ELSE '-' END
    AND menu_nc = CASE WHEN (NEW.menu_nao_cliente IS NOT NULL) THEN NEW.menu_nao_cliente ELSE '-' END;
    END IF;

    IF ((NEW.menu_nao_cliente IS NOT NULL) AND (NEW.assinante = 'Não'))  
	THEN UPDATE smarkio_guiamais.menu_count 
	    SET total_nc = total_nc + 1
    WHERE date = NEW.lead_creation_day
    AND cliente = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
    AND menu = CASE WHEN (NEW.menu_nao_encontrado = '1') THEN 'Não Encontrado' ELSE 'Encontrado' END
    AND menu_c = CASE WHEN (NEW.menu_principal IS NOT NULL) THEN NEW.menu_principal ELSE '-' END
    AND menu_nc = CASE WHEN (NEW.menu_nao_cliente IS NOT NULL) THEN NEW.menu_nao_cliente ELSE '-' END;
    END IF;	
END 

-- TRIGGER UPDATE -- 
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_menu_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.assinante IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_guiamais.menu_count 
        WHERE date = NEW.lead_creation_day
        AND cliente = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
        AND menu = CASE WHEN (NEW.menu_nao_encontrado = '1') THEN 'Não Encontrado' ELSE 'Encontrado' END
        AND menu_c = CASE WHEN (NEW.menu_principal IS NOT NULL) THEN NEW.menu_principal ELSE '-' END
        AND menu_nc = CASE WHEN (NEW.menu_nao_cliente IS NOT NULL) THEN NEW.menu_nao_cliente ELSE '-' END)=0))
    THEN INSERT INTO smarkio_guiamais.menu_count 
    (date, cliente, menu, menu_c, menu_nc)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END,CASE WHEN (NEW.menu_nao_encontrado = '1') THEN 'Não Encontrado' ELSE 'Encontrado' END,CASE WHEN (NEW.menu_principal IS NOT NULL) THEN NEW.menu_principal ELSE '-' END,CASE WHEN (NEW.menu_nao_cliente IS NOT NULL) THEN NEW.menu_nao_cliente ELSE '-' END);
    END IF;

	IF ((NEW.menu_principal IS NOT NULL) AND (NEW.assinante = 'Sim')) 
	THEN UPDATE smarkio_guiamais.menu_count 
	    SET total_c = total_c + 1
    WHERE date = NEW.lead_creation_day
    AND cliente = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
    AND menu = CASE WHEN (NEW.menu_nao_encontrado = '1') THEN 'Não Encontrado' ELSE 'Encontrado' END
    AND menu_c = CASE WHEN (NEW.menu_principal IS NOT NULL) THEN NEW.menu_principal ELSE '-' END
    AND menu_nc = CASE WHEN (NEW.menu_nao_cliente IS NOT NULL) THEN NEW.menu_nao_cliente ELSE '-' END;
    END IF;

    IF ((NEW.menu_nao_cliente IS NOT NULL) AND (NEW.assinante = 'Não'))  
	THEN UPDATE smarkio_guiamais.menu_count 
	    SET total_nc = total_nc + 1
    WHERE date = NEW.lead_creation_day
    AND cliente = CASE WHEN (NEW.assinante IS NOT NULL) THEN NEW.assinante ELSE '-' END
    AND menu = CASE WHEN (NEW.menu_nao_encontrado = '1') THEN 'Não Encontrado' ELSE 'Encontrado' END
    AND menu_c = CASE WHEN (NEW.menu_principal IS NOT NULL) THEN NEW.menu_principal ELSE '-' END
    AND menu_nc = CASE WHEN (NEW.menu_nao_cliente IS NOT NULL) THEN NEW.menu_nao_cliente ELSE '-' END;
    END IF;	

    IF ((OLD.menu_principal IS NOT NULL) AND (OLD.assinante = 'Sim'))  
	THEN UPDATE smarkio_guiamais.menu_count 
	    SET total_c = total_c - 1
    WHERE date = OLD.lead_creation_day
    AND cliente = CASE WHEN (OLD.assinante IS NOT NULL) THEN OLD.assinante ELSE '-' END
    AND menu = CASE WHEN (OLD.menu_nao_encontrado = '1') THEN 'Não Encontrado' ELSE 'Encontrado' END
    AND menu_c = CASE WHEN (OLD.menu_principal IS NOT NULL) THEN OLD.menu_principal ELSE '-' END
    AND menu_nc = CASE WHEN (OLD.menu_nao_cliente IS NOT NULL) THEN OLD.menu_nao_cliente ELSE '-' END;
    END IF;		

    IF ((OLD.menu_nao_cliente IS NOT NULL) AND (OLD.assinante = 'Não'))  
	THEN UPDATE smarkio_guiamais.menu_count 
	    SET total_nc = total_nc - 1
    WHERE date = OLD.lead_creation_day
    AND cliente = CASE WHEN (OLD.assinante IS NOT NULL) THEN OLD.assinante ELSE '-' END
    AND menu = CASE WHEN (OLD.menu_nao_encontrado = '1') THEN 'Não Encontrado' ELSE 'Encontrado' END
    AND menu_c = CASE WHEN (OLD.menu_principal IS NOT NULL) THEN OLD.menu_principal ELSE '-' END
    AND menu_nc = CASE WHEN (OLD.menu_nao_cliente IS NOT NULL) THEN OLD.menu_nao_cliente ELSE '-' END;
    END IF;	
END

-- SELECT -- 
INSERT INTO smarkio_guiamais.menu_count (`date`, `menu`, `cliente`, `menu_c`, `menu_nc`, `total_c`, `total_nc`)
SELECT c.date, c.menu, c.cliente, c.menu_c, c.menu_nc, c.total_c, c.total_nc
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (menu_nao_encontrado = '1') THEN 'Não Encontrado' ELSE 'Encontrado' END) AS menu,
    (CASE WHEN (assinante IS NOT NULL) THEN assinante ELSE '-' END) AS cliente,
    (CASE WHEN (menu_principal IS NOT NULL) THEN menu_principal ELSE '-' END) AS menu_c,
    (CASE WHEN (menu_nao_cliente IS NOT NULL) THEN menu_nao_cliente ELSE '-' END) AS menu_nc,
    SUM(CASE WHEN ((menu_principal IS NOT NULL) AND (assinante = 'Sim')) THEN 1 ELSE 0 END) AS total_c,
    SUM(CASE WHEN ((menu_nao_cliente IS NOT NULL) AND (assinante = 'Não')) THEN 1 ELSE 0 END) AS total_nc
	FROM smarkio_guiamais.leads 
        WHERE assinante IS NOT NULL AND supplier = 'Guia Mais' AND campaign = 'Chat Guia Mais' AND lead_creation_day < '2022-06-20'
	GROUP BY date, menu, cliente, menu_c, menu_nc) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `menu` = c.menu,
        `cliente` = c.cliente,
        `menu_c` = c.menu_c,
        `menu_nc` = c.menu_nc,
        `total_c` = c.total_c,
        `total_nc` = c.total_nc;