-- TABLE -- 
  CREATE TABLE `smarkio_portoconsignado`.`simulacao_count` (
  `idsimulacao` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `simulacao` VARCHAR(255) NOT NULL,
  `empresa` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
  `conversao` INT NULL DEFAULT 0,
  `enviado_consignado` INT NULL DEFAULT 0,
   PRIMARY KEY (`idsimulacao`));

-- TRIGGER --
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_simulacao_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.tipo_proposta IS NOT NULL) 
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.simulacao_count 
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND simulacao = CASE WHEN (NEW.tipo_proposta IS NOT NULL) THEN NEW.tipo_proposta ELSE '-' END)=0))

        THEN INSERT INTO smarkio_portoconsignado.simulacao_count
        (date,simulacao,empresa)
        VALUES (NEW.lead_creation_day,CASE WHEN (NEW.tipo_proposta IS NOT NULL) THEN NEW.tipo_proposta ELSE '-' END,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END);
    END IF;

	IF (NEW.tipo_proposta IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.simulacao_count
            SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND simulacao = CASE WHEN (NEW.tipo_proposta IS NOT NULL) THEN NEW.tipo_proposta ELSE '-' END;
    END IF;

    IF (NEW.lead_status IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.simulacao_count
            SET conversao = CASE 
                WHEN (NEW.lead_status = 'Integrated Fandi') THEN conversao + 1
                WHEN (NEW.lead_status = 'Reprovado') THEN conversao + 1
                WHEN (NEW.lead_status = 'Aprovado') THEN conversao + 1
                ELSE conversao + 0 END
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND simulacao = CASE WHEN (NEW.tipo_proposta IS NOT NULL) THEN NEW.tipo_proposta ELSE '-' END;

        UPDATE smarkio_portoconsignado.simulacao_count
            SET enviado_consignado = CASE 
                WHEN ((NEW.tipo_proposta IS NOT NULL) AND (NEW.lead_status = 'Enviado para consignado')) THEN enviado_consignado + 1
                ELSE enviado_consignado + 0 END
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND simulacao = CASE WHEN (NEW.tipo_proposta IS NOT NULL) THEN NEW.tipo_proposta ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portoconsignado;
DELIMITER |
CREATE TRIGGER tg_simulacao_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN	
	IF ((NEW.tipo_proposta IS NOT NULL) 
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portoconsignado.simulacao_count 
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND simulacao = CASE WHEN (NEW.tipo_proposta IS NOT NULL) THEN NEW.tipo_proposta ELSE '-' END)=0))

        THEN INSERT INTO smarkio_portoconsignado.simulacao_count
        (date,simulacao,empresa)
        VALUES (NEW.lead_creation_day,CASE WHEN (NEW.tipo_proposta IS NOT NULL) THEN NEW.tipo_proposta ELSE '-' END,CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END);
    END IF;

	IF (NEW.tipo_proposta IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.simulacao_count
            SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND simulacao = CASE WHEN (NEW.tipo_proposta IS NOT NULL) THEN NEW.tipo_proposta ELSE '-' END;
    END IF;

    IF (NEW.lead_status IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.simulacao_count
            SET conversao = CASE 
                WHEN (NEW.lead_status = 'Integrated Fandi') THEN conversao + 1
                WHEN (NEW.lead_status = 'Reprovado') THEN conversao + 1
                WHEN (NEW.lead_status = 'Aprovado') THEN conversao + 1
                ELSE conversao + 0 END
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND simulacao = CASE WHEN (NEW.tipo_proposta IS NOT NULL) THEN NEW.tipo_proposta ELSE '-' END;

        UPDATE smarkio_portoconsignado.simulacao_count
            SET enviado_consignado = CASE 
                WHEN ((NEW.tipo_proposta IS NOT NULL) AND (NEW.lead_status = 'Enviado para consignado')) THEN enviado_consignado + 1
                ELSE enviado_consignado + 0 END
        WHERE date = NEW.lead_creation_day
        AND empresa = CASE WHEN (NEW.nome_fantasia IS NOT NULL) THEN NEW.nome_fantasia ELSE '-' END
        AND simulacao = CASE WHEN (NEW.tipo_proposta IS NOT NULL) THEN NEW.tipo_proposta ELSE '-' END;
    END IF;

    IF (OLD.tipo_proposta IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.simulacao_count
            SET total = total - 1
        WHERE date = OLD.lead_creation_day
        AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
        AND simulacao = CASE WHEN (OLD.tipo_proposta IS NOT NULL) THEN OLD.tipo_proposta ELSE '-' END;
    END IF;

    IF (OLD.lead_status IS NOT NULL) THEN 
        UPDATE smarkio_portoconsignado.simulacao_count
            SET conversao = CASE 
                WHEN (OLD.lead_status = 'Integrated Fandi') THEN conversao - 1
                WHEN (OLD.lead_status = 'Reprovado') THEN conversao - 1
                WHEN (OLD.lead_status = 'Aprovado') THEN conversao - 1
                ELSE conversao - 0 END
        WHERE date = OLD.lead_creation_day
        AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
        AND simulacao = CASE WHEN (OLD.tipo_proposta IS NOT NULL) THEN OLD.tipo_proposta ELSE '-' END;

        UPDATE smarkio_portoconsignado.simulacao_count
            SET enviado_consignado = CASE 
                WHEN ((OLD.tipo_proposta IS NOT NULL) AND (OLD.lead_status = 'Enviado para consignado')) THEN enviado_consignado - 1
                ELSE enviado_consignado - 0 END
        WHERE date = OLD.lead_creation_day
        AND empresa = CASE WHEN (OLD.nome_fantasia IS NOT NULL) THEN OLD.nome_fantasia ELSE '-' END
        AND simulacao = CASE WHEN (OLD.tipo_proposta IS NOT NULL) THEN OLD.tipo_proposta ELSE '-' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portoconsignado.simulacao_count (`date`, `simulacao`, `empresa`, `total`, `conversao`, `enviado_consignado`)
SELECT c.date, c.simulacao, c.empresa,c.total, c.conversao, c.enviado_consignado
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (tipo_proposta IS NOT NULL) THEN tipo_proposta ELSE '-' END) AS simulacao,
    (CASE WHEN (nome_fantasia IS NOT NULL) THEN nome_fantasia ELSE '-' END) AS empresa,
    SUM(CASE WHEN (tipo_proposta IS NOT NULL) THEN 1 ELSE 0 END) AS total,
    SUM(CASE WHEN (lead_status = 'Integrated Fandi') THEN 1
            WHEN (lead_status = 'Reprovado') THEN 1
            WHEN (lead_status = 'Aprovado') THEN 1
            ELSE 0 END) AS conversao,
    SUM(CASE WHEN ((tipo_proposta IS NOT NULL) AND (lead_status = 'Enviado para consignado')) THEN 1
            ELSE 0 END) AS enviado_consignado
	FROM smarkio_portoconsignado.leads 
    WHERE lead_creation_day < '2021-05-25'      
    AND tipo_proposta IS NOT NULL
	GROUP BY date,simulacao,empresa) AS c
    ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `simulacao` = c.simulacao,
        `empresa` = c.empresa,
        `total` = c.total,
        `conversao` = c.conversao,
        `enviado_consignado` = c.enviado_consignado;
