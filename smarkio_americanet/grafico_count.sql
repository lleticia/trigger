-- TRIGGER --
USE smarkio_americanet;
DELIMITER |
CREATE TRIGGER tg_grafico_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') 
    AND (NEW.inadimplente IS NOT NULL OR NEW.cliente IS NOT NULL OR NEW.pesquisa_satisfacao IS NOT NULL)
    AND (SELECT EXISTS ( SELECT * FROM smarkio_americanet.grafico_count 
    WHERE date = NEW.lead_creation_day
    AND inadimplente = CASE WHEN (NEW.inadimplente IS NOT NULL) THEN NEW.inadimplente ELSE '-' END 
    AND interacao = CASE WHEN (NEW.cliente IS NOT NULL) THEN NEW.cliente ELSE '-' END
    AND nota = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN NEW.pesquisa_satisfacao ELSE '-' END)=0))

    THEN INSERT INTO smarkio_americanet.grafico_count (date, inadimplente, interacao,nota)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.inadimplente IS NOT NULL) THEN NEW.inadimplente ELSE '-' END,CASE WHEN (NEW.cliente IS NOT NULL) THEN NEW.cliente ELSE '-' END,CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN NEW.pesquisa_satisfacao ELSE '-' END);
    END IF;

	IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.inadimplente IS NOT NULL)) THEN   
        UPDATE smarkio_americanet.grafico_count 
        SET total_inadim = total_inadim + 1
        WHERE date = NEW.lead_creation_day
        AND inadimplente = CASE WHEN (NEW.inadimplente IS NOT NULL) THEN NEW.inadimplente ELSE '-' END 
        AND interacao = CASE WHEN (NEW.cliente IS NOT NULL) THEN NEW.cliente ELSE '-' END
        AND nota = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN NEW.pesquisa_satisfacao ELSE '-' END;
    END IF;

    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.cliente IS NOT NULL)) THEN  
        UPDATE smarkio_americanet.grafico_count 
        SET total_interacao = total_interacao + 1
        WHERE date = NEW.lead_creation_day
        AND inadimplente = CASE WHEN (NEW.inadimplente IS NOT NULL) THEN NEW.inadimplente ELSE '-' END 
        AND interacao = CASE WHEN (NEW.cliente IS NOT NULL) THEN NEW.cliente ELSE '-' END
        AND nota = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN NEW.pesquisa_satisfacao ELSE '-' END;
    END IF;	

    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.pesquisa_satisfacao IS NOT NULL)) THEN  
        UPDATE smarkio_americanet.grafico_count 
        SET total_nota = total_nota + 1
        WHERE date = NEW.lead_creation_day
        AND inadimplente = CASE WHEN (NEW.inadimplente IS NOT NULL) THEN NEW.inadimplente ELSE '-' END 
        AND interacao = CASE WHEN (NEW.cliente IS NOT NULL) THEN NEW.cliente ELSE '-' END
        AND nota = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN NEW.pesquisa_satisfacao ELSE '-' END;
    END IF;
END;

-- TRIGGER UPDATE -- 
USE smarkio_americanet;
DELIMITER |
CREATE TRIGGER tg_grafico_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') 
    AND (NEW.inadimplente IS NOT NULL OR NEW.cliente IS NOT NULL OR NEW.pesquisa_satisfacao IS NOT NULL)
    AND (SELECT EXISTS ( SELECT * FROM smarkio_americanet.grafico_count 
    WHERE date = NEW.lead_creation_day
    AND inadimplente = CASE WHEN (NEW.inadimplente IS NOT NULL) THEN NEW.inadimplente ELSE '-' END 
    AND interacao = CASE WHEN (NEW.cliente IS NOT NULL) THEN NEW.cliente ELSE '-' END
    AND nota = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN NEW.pesquisa_satisfacao ELSE '-' END)=0))

    THEN INSERT INTO smarkio_americanet.grafico_count (date, inadimplente, interacao,nota)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.inadimplente IS NOT NULL) THEN NEW.inadimplente ELSE '-' END,CASE WHEN (NEW.cliente IS NOT NULL) THEN NEW.cliente ELSE '-' END,CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN NEW.pesquisa_satisfacao ELSE '-' END);
    END IF;

	IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.inadimplente IS NOT NULL)) THEN   
        UPDATE smarkio_americanet.grafico_count 
        SET total_inadim = total_inadim + 1
        WHERE date = NEW.lead_creation_day
        AND inadimplente = CASE WHEN (NEW.inadimplente IS NOT NULL) THEN NEW.inadimplente ELSE '-' END 
        AND interacao = CASE WHEN (NEW.cliente IS NOT NULL) THEN NEW.cliente ELSE '-' END
        AND nota = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN NEW.pesquisa_satisfacao ELSE '-' END;
    END IF;

    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.cliente IS NOT NULL)) THEN  
        UPDATE smarkio_americanet.grafico_count 
        SET total_interacao = total_interacao + 1
        WHERE date = NEW.lead_creation_day
        AND inadimplente = CASE WHEN (NEW.inadimplente IS NOT NULL) THEN NEW.inadimplente ELSE '-' END 
        AND interacao = CASE WHEN (NEW.cliente IS NOT NULL) THEN NEW.cliente ELSE '-' END
        AND nota = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN NEW.pesquisa_satisfacao ELSE '-' END;
    END IF;	

    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.pesquisa_satisfacao IS NOT NULL)) THEN  
        UPDATE smarkio_americanet.grafico_count 
        SET total_nota = total_nota + 1
        WHERE date = NEW.lead_creation_day
        AND inadimplente = CASE WHEN (NEW.inadimplente IS NOT NULL) THEN NEW.inadimplente ELSE '-' END 
        AND interacao = CASE WHEN (NEW.cliente IS NOT NULL) THEN NEW.cliente ELSE '-' END
        AND nota = CASE WHEN (NEW.pesquisa_satisfacao IS NOT NULL) THEN NEW.pesquisa_satisfacao ELSE '-' END;
    END IF;

    IF ((OLD.supplier = 'Website') AND (OLD.campaign = 'Atendimento') AND (OLD.inadimplente IS NOT NULL)) THEN   
        UPDATE smarkio_americanet.grafico_count 
        SET total_inadim = total_inadim - 1
        WHERE date = OLD.lead_creation_day
        AND inadimplente = CASE WHEN (OLD.inadimplente IS NOT NULL) THEN OLD.inadimplente ELSE '-' END 
        AND interacao = CASE WHEN (OLD.cliente IS NOT NULL) THEN OLD.cliente ELSE '-' END
        AND nota = CASE WHEN (OLD.pesquisa_satisfacao IS NOT NULL) THEN OLD.pesquisa_satisfacao ELSE '-' END;
    END IF;

    IF ((OLD.supplier = 'Website') AND (OLD.campaign = 'Atendimento') AND (OLD.cliente IS NOT NULL)) THEN  
        UPDATE smarkio_americanet.grafico_count 
        SET total_interacao = total_interacao - 1
        WHERE date = OLD.lead_creation_day
        AND inadimplente = CASE WHEN (OLD.inadimplente IS NOT NULL) THEN OLD.inadimplente ELSE '-' END 
        AND interacao = CASE WHEN (OLD.cliente IS NOT NULL) THEN OLD.cliente ELSE '-' END
        AND nota = CASE WHEN (OLD.pesquisa_satisfacao IS NOT NULL) THEN OLD.pesquisa_satisfacao ELSE '-' END;
    END IF;	

    IF ((OLD.supplier = 'Website') AND (OLD.campaign = 'Atendimento') AND (OLD.pesquisa_satisfacao IS NOT NULL)) THEN  
        UPDATE smarkio_americanet.grafico_count 
        SET total_nota = total_nota - 1
        WHERE date = OLD.lead_creation_day
        AND inadimplente = CASE WHEN (OLD.inadimplente IS NOT NULL) THEN OLD.inadimplente ELSE '-' END 
        AND interacao = CASE WHEN (OLD.cliente IS NOT NULL) THEN OLD.cliente ELSE '-' END
        AND nota = CASE WHEN (OLD.pesquisa_satisfacao IS NOT NULL) THEN OLD.pesquisa_satisfacao ELSE '-' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_americanet.grafico_count (`date`, `inadimplente`, `interacao`, `nota`, `total_inadim`, `total_interacao`)
SELECT c.date, c.inadimplente, c.interacao, c.nota, c.total_inadim, c.total_interacao FROM (
  SELECT 
        lead_creation_day AS date,
        (CASE WHEN (inadimplente IS NOT NULL) THEN inadimplente ELSE '-' END) AS inadimplente,
        (CASE WHEN (cliente IS NOT NULL) THEN cliente ELSE '-' END) AS interacao,
        (CASE WHEN (pesquisa_satisfacao IS NOT NULL) THEN Opesquisa_satisfacao ELSE '-' END)  AS nota,
        SUM(CASE WHEN (inadimplente IS NOT NULL) THEN 1 ELSE 0 END) AS total_inadim,
        SUM(CASE WHEN (cliente IS NOT NULL) THEN 1 ELSE 0 END) AS total_interacao
	FROM smarkio_americanet.leads 
    WHERE supplier = 'Website' AND campaign = 'Atendimento' AND lead_creation_day < '2022-06-20' AND (inadimplente IS NOT NULL OR cliente IS NOT NULL)
	GROUP BY date, inadimplente, interacao, pesquisa_satisfacao) AS c
ON DUPLICATE KEY UPDATE
`date` = c.date,
`inadimplente` = c.inadimplente,
`interacao` = c.interacao,
`nota` = c.nota,
`total_inadim` = c.total_inadim,
`total_interacao` = c.total_interacao;