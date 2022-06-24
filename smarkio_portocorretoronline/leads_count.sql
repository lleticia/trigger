-- TRIGGER INSERT --
USE smarkio_portocorretoronline;
DELIMITER |
CREATE TRIGGER tg_leads_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF (SELECT EXISTS (
      SELECT * FROM smarkio_portocorretoronline.leads_count 
      WHERE date = NEW.lead_creation_day)=0)
        
      THEN INSERT INTO smarkio_portocorretoronline.leads_count
      (date)
      VALUES (NEW.lead_creation_day);
    END IF;

    IF (NEW.id IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET acessos = acessos + 1 
      WHERE date = NEW.lead_creation_day;
    END IF;	

    IF ((NEW.menu_inicial IS NOT NULL) OR (NEW.menu_cpf_nao_localizado IS NOT NULL)) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET assuntos = assuntos + 1 
      WHERE date = NEW.lead_creation_day;
    END IF;

    IF ((NEW.transferencia_transbordo = 'Ok!') OR (NEW.horario_atendimento IS NOT NULL)) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET transbordo = transbordo + 1
      WHERE date = NEW.lead_creation_day;
    END IF;

    IF (NEW.identification_number1 IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET cpf = cpf + 1
      WHERE date = NEW.lead_creation_day;
    END IF;

    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao = '4') THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao = '3') THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao = '2') THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao = '1') THEN satisfacao + 1
            ELSE satisfacao + 0 END
      WHERE date = NEW.lead_creation_day;

      UPDATE smarkio_portocorretoronline.leads_count
      SET total_satisfacao = total_satisfacao + 1
      WHERE date = NEW.lead_creation_day;
    END IF;
END

-- TRIGGER UPDATE --
USE smarkio_portocorretoronline;
DELIMITER |
CREATE TRIGGER tg_leads_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF (SELECT EXISTS (
      SELECT * FROM smarkio_portocorretoronline.leads_count 
      WHERE date = NEW.lead_creation_day)=0)
        
      THEN INSERT INTO smarkio_portocorretoronline.leads_count
      (date)
      VALUES (NEW.lead_creation_day);
    END IF;

    IF (NEW.id IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET acessos = acessos + 1 
      WHERE date = NEW.lead_creation_day;
    END IF;	

    IF ((NEW.menu_inicial IS NOT NULL) OR (NEW.menu_cpf_nao_localizado IS NOT NULL)) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET assuntos = assuntos + 1 
      WHERE date = NEW.lead_creation_day;
    END IF;

    IF ((NEW.transferencia_transbordo = 'Ok!') OR (NEW.horario_atendimento IS NOT NULL)) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET transbordo = transbordo + 1
      WHERE date = NEW.lead_creation_day;
    END IF;

    IF (NEW.identification_number1 IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET cpf = cpf + 1
      WHERE date = NEW.lead_creation_day;
    END IF;
    
    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao = '4') THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao = '3') THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao = '2') THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao = '1') THEN satisfacao + 1
            ELSE satisfacao + 0 END
      WHERE date = NEW.lead_creation_day;

      UPDATE smarkio_portocorretoronline.leads_count
      SET total_satisfacao = total_satisfacao + 1
      WHERE date = NEW.lead_creation_day;
    END IF;

    IF (OLD.id IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET acessos = acessos - 1 
      WHERE date = OLD.lead_creation_day;
    END IF;	

    IF ((OLD.menu_inicial IS NOT NULL) OR (OLD.menu_cpf_nao_localizado IS NOT NULL)) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET assuntos = assuntos - 1 
      WHERE date = OLD.lead_creation_day;
    END IF;

    IF ((OLD.transferencia_transbordo = 'Ok!') OR (OLD.horario_atendimento IS NOT NULL)) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET transbordo = transbordo - 1
      WHERE date = OLD.lead_creation_day;
    END IF;

    IF (OLD.identification_number1 IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET cpf = cpf - 1
      WHERE date = OLD.lead_creation_day;
    END IF;

    IF (OLD.pesquisa_satisfacao IS NOT NULL) THEN 
      UPDATE smarkio_portocorretoronline.leads_count
      SET satisfacao = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN satisfacao - 5
            WHEN (OLD.pesquisa_satisfacao = '4') THEN satisfacao - 4
            WHEN (OLD.pesquisa_satisfacao = '3') THEN satisfacao - 3
            WHEN (OLD.pesquisa_satisfacao = '2') THEN satisfacao - 2
            WHEN (OLD.pesquisa_satisfacao = '1') THEN satisfacao - 1
            ELSE satisfacao - 0 END
      WHERE date = OLD.lead_creation_day;

      UPDATE smarkio_portocorretoronline.leads_count
      SET total_satisfacao = total_satisfacao - 1
      WHERE date = OLD.lead_creation_day;
    END IF;
END