-- SELECT ORIGINAL -- 
case
when val_seguro > '0' then "Prestamista"
else "Não prestamista"
end 

-- TABLE -- 
  CREATE TABLE `smarkio_portoconsignado`.`cpf_count` (
  `idcpf` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `cpf` VARCHAR(255) NOT NULL,
  `empresa` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
  `total_cpf` INT NULL DEFAULT 0,
   PRIMARY KEY (`idcpf`));

-- TRIGGER --
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_cpf_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.cpf_count 
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND cpf = CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END)=0)

        THEN INSERT INTO smarkio_portoconsignado.cpf_count
        (date,empresa,cpf)
        VALUES (NEW.lead_creation_day,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END,CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END);
    END IF;

    IF (NEW.val_seguro IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.cpf_count
            SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND cpf = CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END;
    END IF;

	IF (NEW.identification_number1 IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.cpf_count
            SET total_cpf = total_cpf + 1
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND cpf = CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_cpf_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN	
   	IF (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.cpf_count 
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND cpf = CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END)=0)

        THEN INSERT INTO smarkio_portoconsignado.cpf_count
        (date,empresa,cpf)
        VALUES (NEW.lead_creation_day,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END,CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END);
    END IF;

    IF (NEW.val_seguro IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.cpf_count
            SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND cpf = CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END;
    END IF;

	IF (NEW.identification_number1 IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.cpf_count
            SET total_cpf = total_cpf + 1
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND cpf = CASE WHEN (NEW.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END;
    END IF;

    IF (OLD.val_seguro IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.cpf_count
            SET total = total - 1
        WHERE date = OLD.lead_creation_day
        AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
        AND cpf = CASE WHEN (OLD.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END;
    END IF;

	IF (OLD.identification_number1 IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.cpf_count
            SET total_cpf = total_cpf - 1
        WHERE date = OLD.lead_creation_day
        AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
        AND cpf = CASE WHEN (OLD.val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portoconsignado.cpf_count (`date`, `cpf`, `empresa`, `total`, `total_cpf`)
SELECT c.date, c.cpf, c.empresa, c.total, c.total_cpf
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (nome_fantasia IS NOT NULL) THEN nome_fantasia ELSE '-' END) AS empresa,
    (CASE WHEN (val_seguro > '0') THEN 'Prestamista' ELSE 'Não Prestamista' END) AS cpf,
    SUM(CASE WHEN (val_seguro IS NOT NULL) THEN 1 ELSE 0 END) AS total,
    SUM(CASE WHEN (identification_number1 IS NOT NULL) THEN 1 ELSE 0 END) AS total_cpf
	FROM smarkio_portoconsignado.leads 
    WHERE lead_creation_day < '2021-05-25'    
	GROUP BY date,cpf,empresa) AS c
    ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `cpf` = c.cpf,
        `empresa` = c.empresa,
        `total` = c.total,
        `total_cpf` = c.total_cpf;

