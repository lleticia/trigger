-- TRIGGER --
USE smarkio_americanet;
DELIMITER |
CREATE TRIGGER tg_comentario_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.comentario IS NOT NULL)
    AND (SELECT EXISTS ( SELECT * FROM smarkio_americanet.comentario_count 
    WHERE date = NEW.lead_creation_day
    AND comentario = NEW.comentario)=0))

    THEN INSERT INTO smarkio_americanet.comentario_count (date, comentario)
    VALUES (NEW.lead_creation_day,NEW.comentario);
    END IF;

	IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.comentario IS NOT NULL)) THEN   
        UPDATE smarkio_americanet.comentario_count 
        SET total_notas = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN total_notas + 1 ELSE total_notas + 0 END
        WHERE date = NEW.lead_creation_day
        AND comentario = NEW.comentario;

        UPDATE smarkio_americanet.comentario_count 
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN satisfacao + NEW.pesquisa_satisfacao ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
        AND comentario = NEW.comentario;
    END IF;	
END;

-- TRIGGER UPDATE -- 
USE smarkio_americanet;
DELIMITER |
CREATE TRIGGER tg_comentario_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.comentario IS NOT NULL)
    AND (SELECT EXISTS ( SELECT * FROM smarkio_americanet.comentario_count 
    WHERE date = NEW.lead_creation_day
    AND comentario = NEW.comentario)=0))

    THEN INSERT INTO smarkio_americanet.comentario_count (date, comentario)
    VALUES (NEW.lead_creation_day,NEW.comentario);
    END IF;

	IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.comentario IS NOT NULL)) THEN   
        UPDATE smarkio_americanet.comentario_count 
            SET total_notas = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN total_notas + 1 ELSE total_notas + 0 END
        WHERE date = NEW.lead_creation_day
        AND comentario = NEW.comentario;

        UPDATE smarkio_americanet.comentario_count 
            SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN satisfacao + NEW.pesquisa_satisfacao ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
        AND comentario = NEW.comentario;
    END IF;	

    IF ((OLD.supplier = 'Website') AND (OLD.campaign = 'Atendimento') AND (OLD.comentario IS NOT NULL)) THEN   
        UPDATE smarkio_americanet.comentario_count 
            SET total_notas = CASE WHEN (OLD.pesquisa_satisfacao IS NOT NULL) THEN total_notas - 1 ELSE total_notas - 0 END
        WHERE date = OLD.lead_creation_day
        AND comentario = OLD.comentario;

        UPDATE smarkio_americanet.comentario_count 
            SET satisfacao = CASE WHEN (OLD.pesquisa_satisfacao IS NOT NULL) THEN satisfacao - OLD.pesquisa_satisfacao ELSE satisfacao - 0 END
        WHERE date = OLD.lead_creation_day
        AND comentario = OLD.comentario;
    END IF;	
END

-- SELECT -- 
INSERT INTO smarkio_americanet.comentario_count (`date`, `comentario`, `total_notas`, `satisfacao`)
SELECT c.date, c.comentario, c.total_notas, c.satisfacao FROM (
    SELECT 
        lead_creation_day AS date,
        comentario,
        SUM(CASE WHEN (pesquisa_satisfacao IS NOT NULL) THEN 1 ELSE 0 END) AS total_notas,
        SUM(CASE WHEN (pesquisa_satisfacao IS NOT NULL) THEN pesquisa_satisfacao ELSE 0 END) AS satisfacao
	FROM smarkio_americanet.leads 
    WHERE supplier = 'Website' AND campaign = 'Atendimento' AND comentario IS NOT NULL AND lead_creation_day < '2022-06-20'
	GROUP BY date, comentario) AS c
ON DUPLICATE KEY UPDATE
`date` = c.date,
`comentario` = c.comentario,
`total_notas` = c.total_notas,
`satisfacao` = c.satisfacao;