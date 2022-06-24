REPLACE(optin_valor, ".", "")
conversao
case 
when lead_status = "Integrated Fandi" then 1
when lead_status = "Reprovado" then 1
when lead_status = "Aprovado" then 1
else 0
end

-- TABLE -- 
  CREATE TABLE `smarkio_portoconsignado`.`valor_count` (
  `idvalor` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL,
  `tipo` VARCHAR(255) NOT NULL,
  `empresa` VARCHAR(255) NOT NULL,
  `valor` FLOAT NULL DEFAULT 0,
  `conversao` INT NULL DEFAULT 0,
   PRIMARY KEY (`idvalor`));

-- TRIGGER --
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_valor_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF (((NEW.lead_status = 'Integrated Fandi') OR (NEW.lead_status = 'Aprovado') OR (NEW.lead_status = 'Reprovado')) 
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.valor_count 
        WHERE date = NEW.created_at
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND tipo = CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END)=0))

        THEN INSERT INTO smarkio_portoconsignado.valor_count
        (date,tipo, empresa)
        VALUES (NEW.created_at,CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END);
    END IF;

	IF ((NEW.lead_status = 'Integrated Fandi') OR (NEW.lead_status = 'Aprovado') OR (NEW.lead_status = 'Reprovado')) THEN 
        UPDATE smarkio_portoconsignado.valor_count
            SET conversao = conversao + 1
        WHERE date = NEW.created_at
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND tipo = CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END;

        UPDATE smarkio_portoconsignado.valor_count
            SET valor = REPLACE(REPLACE(NEW.optin_valor, ".", ""), ",", ".")
        WHERE date = NEW.created_at
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND tipo = CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_valor_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN	
	IF (((NEW.lead_status = 'Integrated Fandi') OR (NEW.lead_status = 'Aprovado') OR (NEW.lead_status = 'Reprovado')) 
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.valor_count 
        WHERE date = NEW.created_at
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND tipo = CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END)=0))

        THEN INSERT INTO smarkio_portoconsignado.valor_count
        (date,tipo, empresa)
        VALUES (NEW.created_at,CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END);
    END IF;

	IF ((NEW.lead_status = 'Integrated Fandi') OR (NEW.lead_status = 'Aprovado') OR (NEW.lead_status = 'Reprovado')) THEN 
        UPDATE smarkio_portoconsignado.valor_count
            SET conversao = conversao + 1
        WHERE date = NEW.created_at
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND tipo = CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END;

        UPDATE smarkio_portoconsignado.valor_count
            SET valor = REPLACE(REPLACE(NEW.optin_valor, ".", ""), ",", ".")
        WHERE date = NEW.created_at
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND tipo = CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END;
    END IF;

    IF ((OLD.lead_status = 'Integrated Fandi') OR (OLD.lead_status = 'Aprovado') OR (OLD.lead_status = 'Reprovado')) THEN 
        UPDATE smarkio_portoconsignado.valor_count
            SET conversao = conversao - 1
        WHERE date = OLD.created_at
        AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
        AND tipo = CASE WHEN (OLD.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END;

        UPDATE smarkio_portoconsignado.valor_count
            SET valor = REPLACE(REPLACE(OLD.optin_valor, ".", ""), ",", ".")
        WHERE date = OLD.created_at
        AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
        AND tipo = CASE WHEN (OLD.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END;
    END IF;
    
END

-- SELECT -- 
INSERT INTO smarkio_portoconsignado.valor_count (`date`, `tipo`, `empresa`, `valor`, `conversao`)
SELECT c.date, c.tipo, c.empresa, c.valor, c.conversao
FROM 
(
  SELECT 
	created_at AS date,
    (CASE WHEN (val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END) AS tipo,
    (CASE WHEN (nome_fantasia IS NOT NULL) THEN nome_fantasia ELSE '-' END) AS empresa,
    REPLACE(REPLACE(optin_valor, ".", ""), ",", ".") AS valor,
    SUM(CASE WHEN (lead_status = 'Integrated Fandi') THEN 1
            WHEN (lead_status = 'Reprovado') THEN 1
            WHEN (lead_status = 'Aprovado') THEN 1
            ELSE 0 END) AS conversao
	FROM smarkio_portoconsignado.leads 
    WHERE created_at < '2021-05-25'       
    AND lead_status IN ('Integrated Fandi','Aprovado','Reprovado')
	GROUP BY date,tipo,valor,empresa) AS c
    ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `tipo` = c.tipo,
        `empresa` = c.empresa,
        `valor` = c.valor,
        `conversao` = c.conversao;
