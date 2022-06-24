-- TABLE -- 
  CREATE TABLE `smarkio_portoconsignado`.`prazo_count` (
  `idprazo` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `prazo` VARCHAR(255) NOT NULL,
  `empresa` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
   PRIMARY KEY (`idprazo`));

-- TRIGGER --
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_prazo_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.optin_prazo IS NOT NULL)
        AND (NEW.lead_status IN ('Integrated Fandi','Aprovado','Reprovado')) 
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.prazo_count 
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND prazo = CASE WHEN (NEW.optin_prazo IS NOT NULL) THEN NEW.optin_prazo ELSE '-' END)=0))

        THEN INSERT INTO smarkio_portoconsignado.prazo_count
        (date,empresa,prazo)
        VALUES (NEW.lead_creation_day,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END,CASE WHEN (NEW.optin_prazo IS NOT NULL) THEN NEW.optin_prazo ELSE '-' END);
    END IF;

	IF ((NEW.optin_prazo IS NOT NULL) AND (NEW.lead_status IN ('Integrated Fandi','Aprovado','Reprovado'))) THEN 
        UPDATE smarkio_portoconsignado.prazo_count
            SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND prazo = CASE WHEN (NEW.optin_prazo IS NOT NULL) THEN NEW.optin_prazo ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_prazo_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN	
    IF ((NEW.optin_prazo IS NOT NULL)
        AND (NEW.lead_status IN ('Integrated Fandi','Aprovado','Reprovado')) 
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.prazo_count 
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND prazo = CASE WHEN (NEW.optin_prazo IS NOT NULL) THEN NEW.optin_prazo ELSE '-' END)=0))

        THEN INSERT INTO smarkio_portoconsignado.prazo_count
        (date,empresa,prazo)
        VALUES (NEW.lead_creation_day,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END,CASE WHEN (NEW.optin_prazo IS NOT NULL) THEN NEW.optin_prazo ELSE '-' END);
    END IF;

	IF ((NEW.optin_prazo IS NOT NULL) AND (NEW.lead_status IN ('Integrated Fandi','Aprovado','Reprovado'))) THEN 
        UPDATE smarkio_portoconsignado.prazo_count
            SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND prazo = CASE WHEN (NEW.optin_prazo IS NOT NULL) THEN NEW.optin_prazo ELSE '-' END;
    END IF;

    IF ((OLD.optin_prazo IS NOT NULL) AND (OLD.lead_status IN ('Integrated Fandi','Aprovado','Reprovado'))) THEN 
        UPDATE smarkio_portoconsignado.prazo_count
            SET total = total - 1
        WHERE date = OLD.lead_creation_day
        AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
        AND prazo = CASE WHEN (OLD.optin_prazo IS NOT NULL) THEN OLD.optin_prazo ELSE '-' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portoconsignado.prazo_count (`date`, `prazo`, `empresa`, `total`)
SELECT c.date, c.prazo, c.empresa, c.total
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (optin_prazo IS NOT NULL) THEN optin_prazo ELSE '-' END) AS prazo,
    (CASE WHEN (nome_fantasia IS NOT NULL) THEN nome_fantasia ELSE '-' END) AS empresa,
    SUM(CASE WHEN (optin_prazo IS NOT NULL) THEN 1 ELSE 0 END) AS total
	FROM smarkio_portoconsignado.leads 
    WHERE lead_creation_day < '2021-05-25'       
    AND optin_prazo IS NOT NULL
    AND lead_status IN ('Integrated Fandi','Aprovado','Reprovado')
	GROUP BY date,prazo,empresa) AS c
    ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `prazo` = c.prazo,
        `empresa` = c.empresa,
        `total` = c.total;
