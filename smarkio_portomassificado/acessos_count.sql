-- TRIGGER INSERT --
USE smarkio_portomassificado;
DELIMITER |
CREATE TRIGGER tg_acessos_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.id IS NOT NULL) 
        AND (SELECT EXISTS (
          SELECT * FROM smarkio_portomassificado.acessos_count 
          WHERE date = NEW.lead_creation_day
          AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END)=0))
          
      THEN INSERT INTO smarkio_portomassificado.acessos_count
      (date, dispositivo)
      VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END);
    END IF;

  IF (NEW.id IS NOT NULL) THEN 
	  UPDATE smarkio_portomassificado.acessos_count
      SET total = total + 1
    WHERE date = NEW.lead_creation_day
    AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END;
  END IF;	
END

-- TRIGGER UPDATE--
DELIMITER |
CREATE TRIGGER trigger_acessos_update_massificado AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
	IF((SELECT EXISTS (
    SELECT * FROM smarkio_portomassificado.acessos_trigger_massificado 
    WHERE date = NEW.lead_creation_day
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END 
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END
    AND mobile = CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END)=0))
    THEN INSERT INTO smarkio_portomassificado.acessos_trigger_massificados
    (date, pais, regiao, mobile)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END);
    END IF;

    IF (NEW.id IS NOT NULL) THEN 
	UPDATE smarkio_portomassificado.acessos_trigger_massificado
	SET total = total + 1
    WHERE date = NEW.lead_creation_day
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END 
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END
    AND mobile = CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END;
    END IF;	

     IF (OLD.id IS NOT NULL) THEN 
	UPDATE smarkio_portomassificado.acessos_trigger_massificado
	SET total = total - 1
    WHERE date = OLD.lead_creation_day
    AND pais = CASE WHEN (OLD.geo_country IS NOT NULL) THEN OLD.geo_country  ELSE '-' END 
    AND regiao = CASE WHEN (OLD.geo_region IS NOT NULL) THEN OLD.geo_region  ELSE '-' END
    AND mobile = CASE WHEN (OLD.is_mobile IS NOT NULL) THEN OLD.is_mobile ELSE '-' END;
    END IF;	
END;