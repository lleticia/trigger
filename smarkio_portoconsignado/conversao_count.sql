-- SELECT ORIGINAL --
familia
REGEXP_EXTRACT(url, "familia=(.*)")

enviado consignado
case 
when tipo_proposta != "" and lead_status = "Enviado para consignado" then 1
else 0
end

conversao
case 
when lead_status = "Integrated Fandi" then 1
when lead_status = "Reprovado" then 1
when lead_status = "Aprovado" then 1
else 0
end

%conversao - conversao/simulacao
SUM(Conversões 1)/COUNT(tipo_proposta)

conversao_prestamista
case 
when val_seguro > 0 and lead_status = "Integrated Fandi" or lead_status = "Reprovado" or lead_status = "Aprovado" then 1
else 0
end

%conversao_prestamista - conversao_prestamista/conversao
SUM(Conversões Prestamista)/SUM(Conversões 1)

-- TABLE -- 
  CREATE TABLE `smarkio_portoconsignado`.`conversao_count` (
  `idconversao` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `familia` VARCHAR(255) NOT NULL,
  `empresa` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
  `simulacao` INT NULL DEFAULT 0,
  `enviado_consignado` INT NULL DEFAULT 0,
  `conversao` INT NULL DEFAULT 0,
  `conversao_prestamista` INT NULL DEFAULT 0,
   PRIMARY KEY (`idconversao`));

-- TRIGGER --
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_conversao_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.conversao_count 
        WHERE date = NEW.lead_creation_day
            AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
                ELSE '-' END)=0)

    THEN INSERT INTO smarkio_portoconsignado.conversao_count (date,empresa, familia)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END,
        CASE WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
        WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
        ELSE '-' END);
    END IF;

	IF (NEW.nome_fantasia IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.conversao_count
            SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND familia = CASE 
            WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
            WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
            ELSE '-' END;
    END IF;

    IF (NEW.tipo_proposta IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.conversao_count
            SET simulacao = simulacao + 1
        WHERE date = NEW.lead_creation_day
            AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
                ELSE '-' END;
    END IF;

    IF (NEW.lead_status IS NOT NULL) THEN
        UPDATE smarkio_portoconsignado.conversao_count
            SET enviado_consignado = CASE 
                WHEN ((NEW.tipo_proposta IS NOT NULL) AND (NEW.lead_status = 'Enviado para consignado')) THEN enviado_consignado + 1
                ELSE enviado_consignado + 0 END
        WHERE date = NEW.lead_creation_day
            AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
                ELSE '-' END;

        UPDATE smarkio_portoconsignado.conversao_count
            SET conversao = CASE 
                WHEN (NEW.lead_status = 'Integrated Fandi') THEN conversao + 1
                WHEN (NEW.lead_status = 'Reprovado') THEN conversao + 1
                WHEN (NEW.lead_status = 'Aprovado') THEN conversao + 1
                ELSE conversao + 0 END
        WHERE date = NEW.lead_creation_day
            AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
                ELSE '-' END;
                    
        UPDATE smarkio_portoconsignado.conversao_count
            SET conversao_prestamista = CASE 
                WHEN ((NEW.val_seguro > '0') AND (NEW.lead_status IN ('Integrated Fandi','Reprovado','Aprovado'))) THEN conversao_prestamista + 1
                ELSE conversao_prestamista + 0 END
        WHERE date = NEW.lead_creation_day
            AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
                ELSE '-' END;
    END IF;
END 

-- TRIGGER --
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_conversao_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.conversao_count 
        WHERE date = NEW.lead_creation_day
            AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
                ELSE '-' END)=0)

    THEN INSERT INTO smarkio_portoconsignado.conversao_count (date,empresa, familia)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END,
        CASE WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
        WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
        ELSE '-' END);
    END IF;

	IF (NEW.nome_fantasia IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.conversao_count
            SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND familia = CASE 
            WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
            WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
            ELSE '-' END;
    END IF;

    IF (NEW.tipo_proposta IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.conversao_count
            SET simulacao = simulacao + 1
        WHERE date = NEW.lead_creation_day
            AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
                ELSE '-' END;
    END IF;

    IF (NEW.lead_status IS NOT NULL) THEN
        UPDATE smarkio_portoconsignado.conversao_count
            SET enviado_consignado = CASE 
                WHEN ((NEW.tipo_proposta IS NOT NULL) AND (NEW.lead_status = 'Enviado para consignado')) THEN enviado_consignado + 1
                ELSE enviado_consignado + 0 END
        WHERE date = NEW.lead_creation_day
            AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
                ELSE '-' END;

        UPDATE smarkio_portoconsignado.conversao_count
            SET conversao = CASE 
                WHEN (NEW.lead_status = 'Integrated Fandi') THEN conversao + 1
                WHEN (NEW.lead_status = 'Reprovado') THEN conversao + 1
                WHEN (NEW.lead_status = 'Aprovado') THEN conversao + 1
                ELSE conversao + 0 END
        WHERE date = NEW.lead_creation_day
            AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
                ELSE '-' END;
                    
        UPDATE smarkio_portoconsignado.conversao_count
            SET conversao_prestamista = CASE 
                WHEN ((NEW.val_seguro > '0') AND (NEW.lead_status IN ('Integrated Fandi','Reprovado','Aprovado'))) THEN conversao_prestamista + 1
                ELSE conversao_prestamista + 0 END
        WHERE date = NEW.lead_creation_day
            AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,118)) LIKE '=%') THEN (SUBSTR(NEW.url,119))
                WHEN (NEW.url LIKE '%familia%' AND NEW.url NOT LIKE '%no_save%' AND NEW.url NOT LIKE '%dev%' AND (SUBSTR(NEW.url,55)) LIKE '=%') THEN (SUBSTR(NEW.url,56))
                ELSE '-' END;
    END IF;

    IF (OLD.nome_fantasia IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.conversao_count
            SET total = total - 1
    WHERE date = OLD.lead_creation_day
        AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
        AND familia = CASE 
            WHEN (OLD.url LIKE '%familia%' AND OLD.url NOT LIKE '%no_save%' AND OLD.url NOT LIKE '%dev%' AND (SUBSTR(OLD.url,118)) LIKE '=%') THEN (SUBSTR(OLD.url,119))
            WHEN (OLD.url LIKE '%familia%' AND OLD.url NOT LIKE '%no_save%' AND OLD.url NOT LIKE '%dev%' AND (SUBSTR(OLD.url,55)) LIKE '=%') THEN (SUBSTR(OLD.url,56))
            ELSE '-' END;
    END IF;

    IF (OLD.tipo_proposta IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.conversao_count
            SET simulacao = simulacao - 1
        WHERE date = OLD.lead_creation_day
            AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (OLD.url LIKE '%familia%' AND OLD.url NOT LIKE '%no_save%' AND OLD.url NOT LIKE '%dev%' AND (SUBSTR(OLD.url,118)) LIKE '=%') THEN (SUBSTR(OLD.url,119))
                WHEN (OLD.url LIKE '%familia%' AND OLD.url NOT LIKE '%no_save%' AND OLD.url NOT LIKE '%dev%' AND (SUBSTR(OLD.url,55)) LIKE '=%') THEN (SUBSTR(OLD.url,56))
                ELSE '-' END;
    END IF;

    IF (OLD.lead_status IS NOT NULL) THEN
        UPDATE smarkio_portoconsignado.conversao_count
            SET enviado_consignado = CASE 
                WHEN ((OLD.tipo_proposta IS NOT NULL) AND (OLD.lead_status = 'Enviado para consignado')) THEN enviado_consignado - 1
                ELSE enviado_consignado - 0 END
        WHERE date = OLD.lead_creation_day
            AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (OLD.url LIKE '%familia%' AND OLD.url NOT LIKE '%no_save%' AND OLD.url NOT LIKE '%dev%' AND (SUBSTR(OLD.url,118)) LIKE '=%') THEN (SUBSTR(OLD.url,119))
                WHEN (OLD.url LIKE '%familia%' AND OLD.url NOT LIKE '%no_save%' AND OLD.url NOT LIKE '%dev%' AND (SUBSTR(OLD.url,55)) LIKE '=%') THEN (SUBSTR(OLD.url,56))
                ELSE '-' END;

        UPDATE smarkio_portoconsignado.conversao_count
            SET conversao = CASE 
                WHEN (OLD.lead_status = 'Integrated Fandi') THEN conversao - 1
                WHEN (OLD.lead_status = 'Reprovado') THEN conversao - 1
                WHEN (OLD.lead_status = 'Aprovado') THEN conversao - 1
                ELSE conversao - 0 END
        WHERE date = OLD.lead_creation_day
            AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (OLD.url LIKE '%familia%' AND OLD.url NOT LIKE '%no_save%' AND OLD.url NOT LIKE '%dev%' AND (SUBSTR(OLD.url,118)) LIKE '=%') THEN (SUBSTR(OLD.url,119))
                WHEN (OLD.url LIKE '%familia%' AND OLD.url NOT LIKE '%no_save%' AND OLD.url NOT LIKE '%dev%' AND (SUBSTR(OLD.url,55)) LIKE '=%') THEN (SUBSTR(OLD.url,56))
                ELSE '-' END;
                    
        UPDATE smarkio_portoconsignado.conversao_count
            SET conversao_prestamista = CASE 
                WHEN ((OLD.val_seguro > '0') AND (OLD.lead_status IN ('Integrated Fandi','Reprovado','Aprovado'))) THEN conversao_prestamista - 1
                ELSE conversao_prestamista - 0 END
        WHERE date = OLD.lead_creation_day
            AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
            AND familia = CASE 
                WHEN (OLD.url LIKE '%familia%' AND OLD.url NOT LIKE '%no_save%' AND OLD.url NOT LIKE '%dev%' AND (SUBSTR(OLD.url,118)) LIKE '=%') THEN (SUBSTR(OLD.url,119))
                WHEN (OLD.url LIKE '%familia%' AND OLD.url NOT LIKE '%no_save%' AND OLD.url NOT LIKE '%dev%' AND (SUBSTR(OLD.url,55)) LIKE '=%') THEN (SUBSTR(OLD.url,56))
                ELSE '-' END;
    END IF;
END 

-- SELECT -- 
INSERT INTO smarkio_portoconsignado.conversao_count (`date`, `empresa`, `familia`, `total`, `simulacao`, `conversao`, `enviado_consignado`, `conversao_prestamista`)
SELECT c.date, c.empresa, c.familia, c.total, c.simulacao, c.conversao, c.enviado_consignado, c.conversao_prestamista
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (nome_fantasia IS NOT NULL) THEN nome_fantasia ELSE '-' END) AS empresa,
    (CASE 
    WHEN (URL LIKE '%familia%' AND URL NOT LIKE '%no_save%' AND URL NOT LIKE '%dev%' AND (SUBSTR(url,118)) LIKE '=%') THEN (SUBSTR(url,119))
    WHEN (URL LIKE '%familia%' AND URL NOT LIKE '%no_save%' AND URL NOT LIKE '%dev%' AND (SUBSTR(url,55)) LIKE '=%') THEN (SUBSTR(url,56))
    ELSE '-' END) AS familia,
    SUM(CASE WHEN (nome_fantasia IS NOT NULL) THEN 1 ELSE 0 END) AS total,
    SUM(CASE WHEN (tipo_proposta IS NOT NULL) THEN 1 ELSE 0 END) AS simulacao,
    SUM(CASE WHEN (lead_status IN ('Integrated Fandi','Reprovado','Aprovado')) THEN 1 ELSE 0 END) AS conversao,
    SUM(CASE WHEN ((tipo_proposta IS NOT NULL) AND (lead_status = 'Enviado para consignado')) THEN 1 ELSE 0 END) AS enviado_consignado,
    SUM(CASE WHEN ((val_seguro > '0') AND (lead_status IN ('Integrated Fandi','Reprovado','Aprovado'))) THEN 1 ELSE 0 END) AS conversao_prestamista
	FROM smarkio_portoconsignado.leads 
    WHERE lead_creation_day > '2021-03-01'   
	GROUP BY date,empresa,familia) AS c
    ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `empresa` = c.empresa,
        `familia` = c.familia,
        `conversao` = c.conversao,
        `simulacao` = c.simulacao,
        `total` = c.total,
        `enviado_consignado` = c.enviado_consignado,
        `conversao_prestamista` = c.conversao_prestamista;