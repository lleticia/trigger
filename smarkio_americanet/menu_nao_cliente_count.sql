-- TRIGGER --
USE smarkio_americanet;
DELIMITER |
CREATE TRIGGER tg_menu_nao_cliente_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') 
    AND (NEW.cliente = 'Não') AND (NEW.menu_nao_cliente IS NOT NULL)
    AND (SELECT EXISTS ( SELECT * FROM smarkio_americanet.menu_nao_cliente_count 
    WHERE date = NEW.lead_creation_day
    AND menu = NEW.menu_nao_cliente)=0))

    THEN INSERT INTO smarkio_americanet.menu_nao_cliente_count (date, menu)
    VALUES (NEW.lead_creation_day,NEW.menu_nao_cliente);
    END IF;

	IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.cliente = 'Não') AND (NEW.menu_nao_cliente IS NOT NULL)) THEN 
        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND menu = NEW.menu_nao_cliente;

        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET retencao = CASE WHEN (NEW.horario_atendimento IS NULL) THEN retencao + 1 ELSE retencao + 0 END
        WHERE date = NEW.lead_creation_day
        AND menu = NEW.menu_nao_cliente;

        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET transbordo = CASE WHEN (NEW.horario_atendimento IS NOT NULL) THEN transbordo + 1 ELSE transbordo + 0 END
        WHERE date = NEW.lead_creation_day
        AND menu = NEW.menu_nao_cliente;

        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET total_notas = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN total_notas + 1 ELSE total_notas + 0 END
        WHERE date = NEW.lead_creation_day
        AND menu = NEW.menu_nao_cliente;

        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN satisfacao + NEW.pesquisa_satisfacao ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
        AND menu = NEW.menu_nao_cliente;
    END IF;	
END;

-- TRIGGER UPDATE -- 
USE smarkio_americanet;
DELIMITER |
CREATE TRIGGER tg_menu_nao_cliente_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') 
    AND (NEW.cliente = 'Não') AND (NEW.menu_nao_cliente IS NOT NULL)
    AND (SELECT EXISTS ( SELECT * FROM smarkio_americanet.menu_nao_cliente_count 
    WHERE date = NEW.lead_creation_day
    AND menu = NEW.menu_nao_cliente)=0))

    THEN INSERT INTO smarkio_americanet.menu_nao_cliente_count (date, menu)
    VALUES (NEW.lead_creation_day,NEW.menu_nao_cliente);
    END IF;

	IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.cliente = 'Não') AND (NEW.menu_nao_cliente IS NOT NULL)) THEN 
        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND menu = NEW.menu_nao_cliente;

        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET retencao = CASE WHEN (NEW.horario_atendimento IS NULL) THEN retencao + 1 ELSE retencao + 0 END
        WHERE date = NEW.lead_creation_day
        AND menu = NEW.menu_nao_cliente;

        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET transbordo = CASE WHEN (NEW.horario_atendimento IS NOT NULL) THEN transbordo + 1 ELSE transbordo + 0 END
        WHERE date = NEW.lead_creation_day
        AND menu = NEW.menu_nao_cliente;

        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET total_notas = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN total_notas + 1 ELSE total_notas + 0 END
        WHERE date = NEW.lead_creation_day
        AND menu = NEW.menu_nao_cliente;

        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN satisfacao + NEW.pesquisa_satisfacao ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
        AND menu = NEW.menu_nao_cliente;
    END IF;	

    IF ((OLD.supplier = 'Website') AND (OLD.campaign = 'Atendimento') AND (OLD.cliente = 'Não') AND (OLD.menu_nao_cliente IS NOT NULL)) THEN 
        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET total = total - 1
        WHERE date = OLD.lead_creation_day
        AND menu = OLD.menu_nao_cliente;

        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET retencao = CASE WHEN (OLD.horario_atendimento IS NULL) THEN retencao - 1 ELSE retencao - 0 END
        WHERE date = OLD.lead_creation_day
        AND menu = OLD.menu_nao_cliente;

        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET transbordo = CASE WHEN (OLD.horario_atendimento IS NOT NULL) THEN transbordo - 1 ELSE transbordo - 0 END
        WHERE date = OLD.lead_creation_day
        AND menu = OLD.menu_nao_cliente;

        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET total_notas = CASE WHEN (OLD.pesquisa_satisfacao IS NOT NULL) THEN total_notas - 1 ELSE total_notas - 0 END
        WHERE date = OLD.lead_creation_day
        AND menu = OLD.menu_nao_cliente;

        UPDATE smarkio_americanet.menu_nao_cliente_count 
        SET satisfacao = CASE WHEN (OLD.pesquisa_satisfacao IS NOT NULL) THEN satisfacao - OLD.pesquisa_satisfacao ELSE satisfacao - 0 END
        WHERE date = OLD.lead_creation_day
        AND menu = OLD.menu_nao_cliente;
    END IF;	
END

-- SELECT -- 
INSERT INTO smarkio_americanet.menu_nao_cliente_count (`date`, `menu`, `total`, `retencao`, `transbordo`, `total_notas`, `satisfacao`)
SELECT c.date, c.menu, c.total, c.retencao, c.transbordo, c.total_notas, c.satisfacao FROM (
    SELECT 
        lead_creation_day AS date,
        menu_nao_cliente AS menu,
        SUM(CASE WHEN ((cliente = 'Não') AND (menu_nao_cliente IS NOT NULL)) THEN 1 ELSE 0 END) AS total,
        SUM(CASE WHEN (horario_atendimento IS NULL) THEN 1 ELSE 0 END) AS retencao,
        SUM(CASE WHEN (horario_atendimento IS NOT NULL)  THEN 1 ELSE 0 END) AS transbordo,
        SUM(CASE WHEN (pesquisa_satisfacao IS NOT NULL) THEN 1 ELSE 0 END) AS total_notas,
        SUM(CASE WHEN (pesquisa_satisfacao IS NOT NULL) THEN pesquisa_satisfacao ELSE 0 END) AS satisfacao
	FROM smarkio_americanet.leads 
    WHERE supplier = 'Website' AND campaign = 'Atendimento' AND lead_creation_day < '2022-06-20' AND cliente = 'Não' AND menu_nao_cliente IS NOT NULL
	GROUP BY date, menu) AS c
ON DUPLICATE KEY UPDATE
`date` = c.date,
`menu` = c.menu,
`total` = c.total,
`retencao` = c.retencao,
`transbordo` = c.transbordo,
`total_notas` = c.total_notas,
`satisfacao` = c.satisfacao;