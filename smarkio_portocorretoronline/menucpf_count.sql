-- TRIGGER INSERT --
USE smarkio_portocorretoronline;
DELIMITER |
CREATE TRIGGER tg_menucpf_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.menu_cpf_nao_localizado IS NOT NULL) 
    AND (SELECT EXISTS (
      SELECT * FROM smarkio_portocorretoronline.menucpf_count 
      WHERE date = NEW.lead_creation_day 
      AND menu = CASE WHEN (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN NEW.menu_cpf_nao_localizado ELSE '-' END)=0))
        
      THEN INSERT INTO smarkio_portocorretoronline.menucpf_count
      (date, menu)
      VALUES (NEW.lead_creation_day, CASE WHEN (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN NEW.menu_cpf_nao_localizado ELSE '-' END);
    END IF;

    IF (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.menucpf_count
      SET acessos = acessos + 1 
      WHERE date = NEW.lead_creation_day 
      AND menu = CASE WHEN (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN NEW.menu_cpf_nao_localizado ELSE '-' END;
    END IF;	

    IF ((NEW.transferencia_transbordo = 'Ok!') OR (NEW.horario_atendimento IS NOT NULL)) THEN 
      UPDATE smarkio_portocorretoronline.menucpf_count
      SET transbordo = transbordo + 1
      WHERE date = NEW.lead_creation_day 
      AND menu = CASE WHEN (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN NEW.menu_cpf_nao_localizado ELSE '-' END;
    END IF;

    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.menucpf_count
      SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao = '4') THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao = '3') THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao = '2') THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao = '1') THEN satisfacao + 1
            ELSE satisfacao + 0 END
      WHERE date = NEW.lead_creation_day 
      AND menu = CASE WHEN (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN NEW.menu_cpf_nao_localizado ELSE '-' END;

      UPDATE smarkio_portocorretoronline.menucpf_count
      SET total_satisfacao = total_satisfacao + 1
      WHERE date = NEW.lead_creation_day 
      AND menu = CASE WHEN (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN NEW.menu_cpf_nao_localizado ELSE '-' END;
    END IF;
END

-- TRIGGER UPDATE --
USE smarkio_portocorretoronline;
DELIMITER |
CREATE TRIGGER tg_menucpf_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.menu_cpf_nao_localizado IS NOT NULL) 
    AND (SELECT EXISTS (
      SELECT * FROM smarkio_portocorretoronline.menucpf_count 
      WHERE date = NEW.lead_creation_day 
      AND menu = CASE WHEN (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN NEW.menu_cpf_nao_localizado ELSE '-' END)=0))
        
      THEN INSERT INTO smarkio_portocorretoronline.menucpf_count
      (date, menu)
      VALUES (NEW.lead_creation_day, CASE WHEN (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN NEW.menu_cpf_nao_localizado ELSE '-' END);
    END IF;

    IF (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.menucpf_count
      SET acessos = acessos + 1 
      WHERE date = NEW.lead_creation_day 
      AND menu = CASE WHEN (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN NEW.menu_cpf_nao_localizado ELSE '-' END;
    END IF;	

    IF ((NEW.transferencia_transbordo = 'Ok!') OR (NEW.horario_atendimento IS NOT NULL)) THEN 
      UPDATE smarkio_portocorretoronline.menucpf_count
      SET transbordo = transbordo + 1
      WHERE date = NEW.lead_creation_day 
      AND menu = CASE WHEN (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN NEW.menu_cpf_nao_localizado ELSE '-' END;
    END IF;

    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.menucpf_count
      SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao = '4') THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao = '3') THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao = '2') THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao = '1') THEN satisfacao + 1
            ELSE satisfacao + 0 END
      WHERE date = NEW.lead_creation_day 
      AND menu = CASE WHEN (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN NEW.menu_cpf_nao_localizado ELSE '-' END;

      UPDATE smarkio_portocorretoronline.menucpf_count
      SET total_satisfacao = total_satisfacao + 1
      WHERE date = NEW.lead_creation_day 
      AND menu = CASE WHEN (NEW.menu_cpf_nao_localizado IS NOT NULL) THEN NEW.menu_cpf_nao_localizado ELSE '-' END;
    END IF;

    IF (OLD.menu_cpf_nao_localizado IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.menucpf_count
      SET acessos = acessos - 1 
      WHERE date = OLD.lead_creation_day 
      AND menu = CASE WHEN (OLD.menu_cpf_nao_localizado IS NOT NULL) THEN OLD.menu_cpf_nao_localizado ELSE '-' END;
    END IF;	

    IF ((OLD.transferencia_transbordo = 'Ok!') OR (OLD.horario_atendimento IS NOT NULL)) THEN 
      UPDATE smarkio_portocorretoronline.menucpf_count
      SET transbordo = transbordo - 1
      WHERE date = OLD.lead_creation_day 
      AND menu = CASE WHEN (OLD.menu_cpf_nao_localizado IS NOT NULL) THEN OLD.menu_cpf_nao_localizado ELSE '-' END;
    END IF;

    IF (OLD.pesquisa_satisfacao IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.menucpf_count
      SET satisfacao = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN satisfacao - 5
            WHEN (OLD.pesquisa_satisfacao = '4') THEN satisfacao - 4
            WHEN (OLD.pesquisa_satisfacao = '3') THEN satisfacao - 3
            WHEN (OLD.pesquisa_satisfacao = '2') THEN satisfacao - 2
            WHEN (OLD.pesquisa_satisfacao = '1') THEN satisfacao - 1
            ELSE satisfacao - 0 END
      WHERE date = OLD.lead_creation_day 
      AND menu = CASE WHEN (OLD.menu_cpf_nao_localizado IS NOT NULL) THEN OLD.menu_cpf_nao_localizado ELSE '-' END;

      UPDATE smarkio_portocorretoronline.menucpf_count
      SET total_satisfacao = total_satisfacao - 1
      WHERE date = OLD.lead_creation_day 
      AND menu = CASE WHEN (OLD.menu_cpf_nao_localizado IS NOT NULL) THEN OLD.menu_cpf_nao_localizado ELSE '-' END;
    END IF;
END