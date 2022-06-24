-- TRIGGER --
USE smarkio_americanet;
DELIMITER |
CREATE TRIGGER tg_leads_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') 
    AND (SELECT EXISTS ( SELECT * FROM smarkio_americanet.leads_count 
    WHERE date = NEW.lead_creation_day)=0))

    THEN INSERT INTO smarkio_americanet.leads_count (date)
    VALUES (NEW.lead_creation_day);
    END IF;

	IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.id IS NOT NULL)) THEN 
        UPDATE smarkio_americanet.leads_count 
        SET inadimplente = CASE WHEN (NEW.inadimplente IS NOT NULL) THEN inadimplente + 1 ELSE inadimplente + 0 END
        WHERE date = NEW.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET interacao = CASE WHEN (NEW.cliente IS NOT NULL) THEN interacao + 1 ELSE interacao + 0 END
        WHERE date = NEW.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN cpf + 1 ELSE cpf + 0 END
        WHERE date = NEW.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET retencao = CASE WHEN ((NEW.horario_atendimento IS NULL) AND (NEW.menu_cliente IS NOT NULL OR NEW.menu_nao_cliente IS NOT NULL)) THEN retencao + 1 ELSE retencao + 0 END
        WHERE date = NEW.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET transbordo = CASE WHEN (NEW.horario_atendimento IS NOT NULL) THEN transbordo + 1 ELSE transbordo + 0 END
        WHERE date = NEW.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET total_notas = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN total_notas + 1 ELSE total_notas + 0 END
        WHERE date = NEW.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN satisfacao + NEW.pesquisa_satisfacao ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day;
    END IF;	
END;

-- TRIGGER UPDATE -- 
USE smarkio_americanet;
DELIMITER |
CREATE TRIGGER tg_leads_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
   IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') 
    AND (SELECT EXISTS ( SELECT * FROM smarkio_americanet.leads_count 
    WHERE date = NEW.lead_creation_day)=0))

    THEN INSERT INTO smarkio_americanet.leads_count (date)
    VALUES (NEW.lead_creation_day);
    END IF;

	IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.id IS NOT NULL)) THEN 
        UPDATE smarkio_americanet.leads_count 
        SET inadimplente = CASE WHEN (NEW.inadimplente IS NOT NULL) THEN inadimplente + 1 ELSE inadimplente + 0 END
        WHERE date = NEW.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET interacao = CASE WHEN (NEW.cliente IS NOT NULL) THEN interacao + 1 ELSE interacao + 0 END
        WHERE date = NEW.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN cpf + 1 ELSE cpf + 0 END
        WHERE date = NEW.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET retencao = CASE WHEN ((NEW.horario_atendimento IS NULL) AND (NEW.menu_cliente IS NOT NULL OR NEW.menu_nao_cliente IS NOT NULL)) THEN retencao + 1 ELSE retencao + 0 END
        WHERE date = NEW.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET transbordo = CASE WHEN (NEW.horario_atendimento IS NOT NULL) THEN transbordo + 1 ELSE transbordo + 0 END
        WHERE date = NEW.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET total_notas = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN total_notas + 1 ELSE total_notas + 0 END
        WHERE date = NEW.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN satisfacao + NEW.pesquisa_satisfacao ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day;
    END IF;	

    IF ((OLD.supplier = 'Website') AND (OLD.campaign = 'Atendimento') AND (OLD.id IS NOT NULL)) THEN 
        UPDATE smarkio_americanet.leads_count 
        SET inadimplente = CASE WHEN (OLD.inadimplente IS NOT NULL) THEN inadimplente - 1 ELSE inadimplente - 0 END
        WHERE date = OLD.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET interacao = CASE WHEN (OLD.cliente IS NOT NULL) THEN interacao - 1 ELSE interacao - 0 END
        WHERE date = OLD.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET cpf = CASE WHEN (OLD.identification_number1 IS NOT NULL) THEN cpf - 1 ELSE cpf - 0 END
        WHERE date = OLD.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET retencao = CASE WHEN ((OLD.horario_atendimento IS NULL) AND (OLD.menu_cliente IS NOT NULL OR OLD.menu_nao_cliente IS NOT NULL)) THEN retencao - 1 ELSE retencao - 0 END
        WHERE date = OLD.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET transbordo = CASE WHEN (OLD.horario_atendimento IS NOT NULL) THEN transbordo - 1 ELSE transbordo - 0 END
        WHERE date = OLD.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET total_notas = CASE WHEN (OLD.pesquisa_satisfacao IS NOT NULL) THEN total_notas - 1 ELSE total_notas - 0 END
        WHERE date = OLD.lead_creation_day;

        UPDATE smarkio_americanet.leads_count 
        SET satisfacao = CASE WHEN (OLD.pesquisa_satisfacao IS NOT NULL) THEN satisfacao - OLD.pesquisa_satisfacao ELSE satisfacao - 0 END
        WHERE date = OLD.lead_creation_day;
    END IF;	
END

-- SELECT -- 
INSERT INTO smarkio_americanet.leads_count (`date`, `interacao`, `cpf`, `inadimplente`, `retencao`, `transbordo`, `total_notas`, `satisfacao`)
SELECT c.date, c.interacao, c.cpf, c.inadimplente, c.retencao, c.transbordo, c.total_notas, c.satisfacao FROM (
    SELECT 
        lead_creation_day AS date,
        SUM(CASE WHEN (cliente IS NOT NULL)  THEN 1 ELSE 0 END) AS interacao,
        SUM(CASE WHEN (identification_number1 IS NOT NULL) THEN 1 ELSE 0 END) AS cpf,
        SUM(CASE WHEN (inadimplente IS NOT NULL) THEN 1 ELSE 0 END) AS inadimplente,
        SUM(CASE WHEN ((horario_atendimento IS NULL) AND (menu_cliente IS NOT NULL OR menu_nao_cliente IS NOT NULL)) THEN 1 ELSE 0 END) AS retencao,
        SUM(CASE WHEN (horario_atendimento IS NOT NULL)  THEN 1 ELSE 0 END) AS transbordo,
        SUM(CASE WHEN (pesquisa_satisfacao IS NOT NULL) THEN 1 ELSE 0 END) AS total_notas,
        SUM(CASE WHEN (pesquisa_satisfacao IS NOT NULL) THEN pesquisa_satisfacao ELSE 0 END) AS satisfacao
	FROM smarkio_americanet.leads 
    WHERE supplier = 'Website' AND campaign = 'Atendimento' AND lead_creation_day < '2022-06-20' 
	GROUP BY date) AS c
ON DUPLICATE KEY UPDATE
`date` = c.date,
`interacao` = c.interacao,
`cpf` = c.cpf,
`inadimplente` = c.inadimplente,
`retencao` = c.retencao,
`transbordo` = c.transbordo,
`total_notas` = c.total_notas,
`satisfacao` = c.satisfacao;