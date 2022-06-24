-- TRIGGER INSERT --
USE smarkio_portocorretoronline;
DELIMITER |
CREATE TRIGGER tg_satisfacao_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.pesquisa_satisfacao IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portocorretoronline.satisfacao_count 
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END)=0))
            
      THEN INSERT INTO smarkio_portocorretoronline.satisfacao_count
      (date, notas, assunto)
      VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END,
        CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END);
    END IF;

    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN 
       UPDATE smarkio_portocorretoronline.satisfacao_count
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao = '4') THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao = '3') THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao = '2') THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao = '1') THEN satisfacao + 1
            ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END;

        UPDATE smarkio_portocorretoronline.satisfacao_count
        SET total_satisfacao = total_satisfacao + 1
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END;

        UPDATE smarkio_portocorretoronline.satisfacao_count
        SET top_two = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN top_two + 1
            WHEN (NEW.pesquisa_satisfacao = '4') THEN top_two + 1
            ELSE top_two + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END;
        
        UPDATE smarkio_portocorretoronline.satisfacao_count
        SET neutro = CASE WHEN (NEW.pesquisa_satisfacao = '3') THEN neutro + 1
            ELSE neutro + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END;

        UPDATE smarkio_portocorretoronline.satisfacao_count
        SET bottom_box = CASE WHEN (NEW.pesquisa_satisfacao = '1') THEN bottom_box + 1
            WHEN (NEW.pesquisa_satisfacao = '2') THEN bottom_box + 1
            ELSE bottom_box + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END;
    END IF;	
END

-- TRIGGER UPDATE --
USE smarkio_portocorretoronline;
DELIMITER |
CREATE TRIGGER tg_satisfacao_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.pesquisa_satisfacao IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portocorretoronline.satisfacao_count 
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END)=0))
            
    THEN INSERT INTO smarkio_portocorretoronline.satisfacao_count
    (date, notas, assunto)
    VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END,
        CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END);
    END IF;

    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN 
       UPDATE smarkio_portocorretoronline.satisfacao_count
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao = '4') THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao = '3') THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao = '2') THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao = '1') THEN satisfacao + 1
            ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END;

        UPDATE smarkio_portocorretoronline.satisfacao_count
        SET total_satisfacao = total_satisfacao + 1
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END;

        UPDATE smarkio_portocorretoronline.satisfacao_count
        SET top_two = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN top_two + 1
            WHEN (NEW.pesquisa_satisfacao = '4') THEN top_two + 1
            ELSE top_two + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END;
        
        UPDATE smarkio_portocorretoronline.satisfacao_count
        SET neutro = CASE WHEN (NEW.pesquisa_satisfacao = '3') THEN neutro + 1
            ELSE neutro + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END;

        UPDATE smarkio_portocorretoronline.satisfacao_count
        SET bottom_box = CASE WHEN (NEW.pesquisa_satisfacao = '1') THEN bottom_box + 1
            WHEN (NEW.pesquisa_satisfacao = '2') THEN bottom_box + 1
            ELSE bottom_box + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_demais_assuntos IS NOT NULL) THEN NEW.menu_demais_assuntos ELSE '-' END;
    END IF;	

    IF (OLD.pesquisa_satisfacao IS NOT NULL) THEN 
       UPDATE smarkio_portocorretoronline.satisfacao_count
        SET satisfacao = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN satisfacao - 5
            WHEN (OLD.pesquisa_satisfacao = '4') THEN satisfacao - 4
            WHEN (OLD.pesquisa_satisfacao = '3') THEN satisfacao - 3
            WHEN (OLD.pesquisa_satisfacao = '2') THEN satisfacao - 2
            WHEN (OLD.pesquisa_satisfacao = '1') THEN satisfacao - 1
            ELSE satisfacao - 0 END
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = '4') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = '3') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = '2') THEN '2'
            WHEN (OLD.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (OLD.menu_demais_assuntos IS NOT NULL) THEN OLD.menu_demais_assuntos ELSE '-' END;

        UPDATE smarkio_portocorretoronline.satisfacao_count
        SET total_satisfacao = total_satisfacao - 1
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = '4') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = '3') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = '2') THEN '2'
            WHEN (OLD.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (OLD.menu_demais_assuntos IS NOT NULL) THEN OLD.menu_demais_assuntos ELSE '-' END;

        UPDATE smarkio_portocorretoronline.satisfacao_count
        SET top_two = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN top_two - 1
            WHEN (OLD.pesquisa_satisfacao = '4') THEN top_two - 1
            ELSE top_two - 0 END
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = '4') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = '3') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = '2') THEN '2'
            WHEN (OLD.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (OLD.menu_demais_assuntos IS NOT NULL) THEN OLD.menu_demais_assuntos ELSE '-' END;
        
        UPDATE smarkio_portocorretoronline.satisfacao_count
        SET neutro = CASE WHEN (OLD.pesquisa_satisfacao = '3') THEN neutro - 1
            ELSE neutro - 0 END
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = '4') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = '3') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = '2') THEN '2'
            WHEN (OLD.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (OLD.menu_demais_assuntos IS NOT NULL) THEN OLD.menu_demais_assuntos ELSE '-' END;

        UPDATE smarkio_portocorretoronline.satisfacao_count
        SET bottom_box = CASE WHEN (OLD.pesquisa_satisfacao = '1') THEN bottom_box - 1
            WHEN (OLD.pesquisa_satisfacao = '2') THEN bottom_box - 1
            ELSE bottom_box - 0 END
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = '4') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = '3') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = '2') THEN '2'
            WHEN (OLD.pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END
        AND assunto = CASE WHEN (OLD.menu_demais_assuntos IS NOT NULL) THEN OLD.menu_demais_assuntos ELSE '-' END;
    END IF;	
END