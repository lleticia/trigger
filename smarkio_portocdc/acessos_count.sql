-- TRIGGER INSERT --
USE smarkio_portocdc;
DELIMITER |
Create TRIGGER trigger_acessos_experiencia AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF((NEW.campaign like "Chat Porto Experi% do Funcion%") and (SELECT EXISTS (
    SELECT * FROM smarkio_portocdc.acessos_trigger_experiencia
    WHERE date = NEW.lead_creation_day
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END 
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END
    AND mobile = CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END)=0))
    THEN INSERT INTO smarkio_portocdc.acessos_trigger_experiencia
    (date, pais, regiao, mobile)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END);
    END IF;

    IF (NEW.id IS NOT NULL) THEN 
	UPDATE smarkio_portocdc.acessos_trigger_experiencia
	SET total = total + 1
    WHERE date = NEW.lead_creation_day
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END 
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END
    AND mobile = CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END;
    END IF;	
END;

-- TRIGGER UPDATE--
USE smarkio_portocdc;
DELIMITER |
CREATE TRIGGER trigger_acessos_update_experiencia AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
	IF((NEW.campaign like "Chat Porto Experi% do Funcion%") and (SELECT EXISTS (
    SELECT * FROM smarkio_portocdc.acessos_trigger_experiencia 
    WHERE date = NEW.lead_creation_day
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END 
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END
    AND mobile = CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END)=0))
    THEN INSERT INTO smarkio_portocdc.acessos_trigger_experiencia
    (date, pais, regiao, mobile)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END);
    END IF;

    IF (NEW.id IS NOT NULL) THEN 
	UPDATE smarkio_portocdc.acessos_trigger_experiencia
	SET total = total + 1
    WHERE date = NEW.lead_creation_day
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END 
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END
    AND mobile = CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END;
    END IF;	

     IF (OLD.id IS NOT NULL) THEN 
	UPDATE smarkio_portocdc.acessos_trigger_experiencia
	SET total = total - 1
    WHERE date = OLD.lead_creation_day
    AND pais = CASE WHEN (OLD.geo_country IS NOT NULL) THEN OLD.geo_country  ELSE '-' END 
    AND regiao = CASE WHEN (OLD.geo_region IS NOT NULL) THEN OLD.geo_region  ELSE '-' END
    AND mobile = CASE WHEN (OLD.is_mobile IS NOT NULL) THEN OLD.is_mobile ELSE '-' END;
    END IF;	
END;