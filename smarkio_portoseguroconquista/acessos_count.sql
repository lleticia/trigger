-- TRIGGER INSERT --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_acessos_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.id IS NOT NULL) 
        AND (SELECT EXISTS (
          SELECT * FROM smarkio_portoseguroconquista.acessos_count 
          WHERE date = NEW.lead_creation_day
          AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END 
          AND cidade = CASE WHEN (NEW.geo_city IS NOT NULL) THEN NEW.geo_city  ELSE '-' END
          AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
          AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END)=0))
          
      THEN INSERT INTO smarkio_portoseguroconquista.acessos_count
      (date, dispositivo, cidade, regiao, navegador)
      VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END,
        CASE WHEN (NEW.geo_city IS NOT NULL) THEN NEW.geo_city  ELSE '-' END,
        CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,
        CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END);
    END IF;

  IF (NEW.id IS NOT NULL) THEN 
	  UPDATE smarkio_portoseguroconquista.acessos_count
      SET total = total + 1
    WHERE date = NEW.lead_creation_day
    AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
    AND cidade = CASE WHEN (NEW.geo_city IS NOT NULL) THEN NEW.geo_city  ELSE '-' END
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
    AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END;
  END IF;	
END

-- TRIGGER UPDATE --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_acessos_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
          SELECT * FROM smarkio_portoseguroconquista.acessos_count 
          WHERE date = NEW.lead_creation_day
          AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END 
          AND cidade = CASE WHEN (NEW.geo_city IS NOT NULL) THEN NEW.geo_city  ELSE '-' END
          AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
          AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END)=0)
          
      THEN INSERT INTO smarkio_portoseguroconquista.acessos_count
      (date, dispositivo, cidade, regiao, navegador)
      VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END,
        CASE WHEN (NEW.geo_city IS NOT NULL) THEN NEW.geo_city  ELSE '-' END,
        CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,
        CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END);
    END IF;

  IF (NEW.id IS NOT NULL) THEN 
	  UPDATE smarkio_portoseguroconquista.acessos_count
      SET total = total + 1
    WHERE date = NEW.lead_creation_day
    AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
    AND cidade = CASE WHEN (NEW.geo_city IS NOT NULL) THEN NEW.geo_city  ELSE '-' END
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
    AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END;
  END IF;	

  IF (OLD.id IS NOT NULL) THEN 
	  UPDATE smarkio_portoseguroconquista.acessos_count
      SET total = total - 1
    WHERE date = OLD.lead_creation_day
    AND dispositivo = CASE WHEN (OLD.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
    AND cidade = CASE WHEN (OLD.geo_city IS NOT NULL) THEN OLD.geo_city  ELSE '-' END
    AND regiao = CASE WHEN (OLD.geo_region IS NOT NULL) THEN OLD.geo_region  ELSE '-' END 
    AND navegador = CASE WHEN (OLD.browser IS NOT NULL) THEN OLD.browser  ELSE '-' END;
  END IF;	
END