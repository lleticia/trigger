-- TRIGGER INSERT --
USE smarkio_portosinistro;
DELIMITER |
CREATE TRIGGER tg_satisfacao_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.pesquisa_satisfacao IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portosinistro.satisfacao_count 
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END)=0))
            
      THEN INSERT INTO smarkio_portosinistro.satisfacao_count
      (date, notas, assunto)
      VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END,
        CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END);
    END IF;

    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN 
       UPDATE smarkio_portosinistro.satisfacao_count
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN satisfacao + 1
            ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;

        UPDATE smarkio_portosinistro.satisfacao_count
        SET total_satisfacao = total_satisfacao + 1
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;

        UPDATE smarkio_portosinistro.satisfacao_count
        SET top_two = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN top_two + 1
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN top_two + 1
            ELSE top_two + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;
        
        UPDATE smarkio_portosinistro.satisfacao_count
        SET neutro = CASE WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN neutro + 1
            ELSE neutro + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;

        UPDATE smarkio_portosinistro.satisfacao_count
        SET bottom_box = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN bottom_box + 1
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN bottom_box + 1
            ELSE bottom_box + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;
    END IF;	
END

-- TRIGGER UPDATE --
USE smarkio_portosinistro;
DELIMITER |
CREATE TRIGGER tg_satisfacao_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.pesquisa_satisfacao IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portosinistro.satisfacao_count 
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END)=0))
            
    THEN INSERT INTO smarkio_portosinistro.satisfacao_count
    (date, notas, assunto)
    VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END,
        CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END);
    END IF;

    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN 
       UPDATE smarkio_portosinistro.satisfacao_count
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN satisfacao + 1
            ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;

        UPDATE smarkio_portosinistro.satisfacao_count
        SET total_satisfacao = total_satisfacao + 1
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;

        UPDATE smarkio_portosinistro.satisfacao_count
        SET top_two = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN top_two + 1
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN top_two + 1
            ELSE top_two + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;
        
        UPDATE smarkio_portosinistro.satisfacao_count
        SET neutro = CASE WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN neutro + 1
            ELSE neutro + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;

        UPDATE smarkio_portosinistro.satisfacao_count
        SET bottom_box = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN bottom_box + 1
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN bottom_box + 1
            ELSE bottom_box + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (NEW.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (NEW.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (NEW.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (NEW.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (NEW.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;
    END IF;	

    IF (OLD.pesquisa_satisfacao IS NOT NULL) THEN 
       UPDATE smarkio_portosinistro.satisfacao_count
        SET satisfacao = CASE WHEN (OLD.pesquisa_satisfacao LIKE '%timo') THEN satisfacao - 5
            WHEN (OLD.pesquisa_satisfacao = 'Bom') THEN satisfacao - 4
            WHEN (OLD.pesquisa_satisfacao = 'Regular') THEN satisfacao - 3
            WHEN (OLD.pesquisa_satisfacao = 'Ruim') THEN satisfacao - 2
            WHEN (OLD.pesquisa_satisfacao LIKE '%ssimo') THEN satisfacao - 1
            ELSE satisfacao - 0 END
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (OLD.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (OLD.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (OLD.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (OLD.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (OLD.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (OLD.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (OLD.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (OLD.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;

        UPDATE smarkio_portosinistro.satisfacao_count
        SET total_satisfacao = total_satisfacao - 1
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (OLD.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (OLD.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (OLD.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (OLD.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (OLD.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (OLD.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (OLD.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (OLD.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;

        UPDATE smarkio_portosinistro.satisfacao_count
        SET top_two = CASE WHEN (OLD.pesquisa_satisfacao LIKE '%timo') THEN top_two - 1
            WHEN (OLD.pesquisa_satisfacao = 'Bom') THEN top_two - 1
            ELSE top_two - 0 END
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (OLD.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (OLD.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (OLD.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (OLD.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (OLD.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (OLD.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (OLD.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (OLD.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;
        
        UPDATE smarkio_portosinistro.satisfacao_count
        SET neutro = CASE WHEN (OLD.pesquisa_satisfacao = 'Regular') THEN neutro - 1
            ELSE neutro - 0 END
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (OLD.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (OLD.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (OLD.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (OLD.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (OLD.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (OLD.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (OLD.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (OLD.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;

        UPDATE smarkio_portosinistro.satisfacao_count
        SET bottom_box = CASE WHEN (OLD.pesquisa_satisfacao LIKE '%ssimo') THEN bottom_box - 1
            WHEN (OLD.pesquisa_satisfacao = 'Ruim') THEN bottom_box - 1
            ELSE bottom_box - 0 END
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao LIKE '%timo') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = 'Bom') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = 'Regular') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = 'Ruim') THEN '2'
            WHEN (OLD.pesquisa_satisfacao LIKE '%ssimo') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (OLD.menu_principal =  'Status do processo') THEN 'Status do processo'
            WHEN (OLD.menu_principal =  'Envio de documentos') THEN 'Envio de documentos'
            WHEN (OLD.menu_principal =  'Outros assuntos') THEN 'Outros assuntos'
            WHEN (OLD.menu_principal = 'Consultar outro sinistro') THEN 'Consultar outro sinistro'
            WHEN (OLD.nao_logado = 'Acompanhar um sinistro') THEN 'Acompanhar um sinistro'
            WHEN (OLD.nao_logado = 'Comunicar um sinistro') THEN 'Comunicar um sinistro'
            WHEN (OLD.nao_logado = 'Outros assuntos') THEN 'Outros assuntos'
            ELSE '-' END;
    END IF;	
END