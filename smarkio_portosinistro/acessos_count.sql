-- TRIGGER INSERT --
USE smarkio_portosinistro;
DELIMITER |
CREATE TRIGGER tg_acessos_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF (SELECT EXISTS (
        SELECT * FROM smarkio_portosinistro.acessos_count 
        WHERE date = NEW.lead_creation_day 
        AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country ELSE '-' END
        AND cidade = CASE WHEN (NEW.geo_city IS NOT NULL) THEN NEW.geo_city ELSE '-' END
        AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region ELSE '-' END 
        AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END)=0)
          
    THEN INSERT INTO smarkio_portosinistro.acessos_count
    (date, pais, cidade, regiao, navegador)
    VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country ELSE '-' END,
        CASE WHEN (NEW.geo_city IS NOT NULL) THEN NEW.geo_city ELSE '-' END,
        CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region ELSE '-' END,
        CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END);
   END IF;

    IF (NEW.id IS NOT NULL) THEN 
        UPDATE smarkio_portosinistro.acessos_count
        SET total = total + 1
        WHERE date = NEW.lead_creation_day 
          AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country ELSE '-' END
          AND cidade = CASE WHEN (NEW.geo_city IS NOT NULL) THEN NEW.geo_city ELSE '-' END
          AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region ELSE '-' END 
          AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END;
   END IF;	
END

-- TRIGGER UPDATE --
USE smarkio_portosinistro;
DELIMITER |
CREATE TRIGGER tg_acessos_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
        SELECT * FROM smarkio_portosinistro.acessos_count 
        WHERE date = NEW.lead_creation_day 
        AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country ELSE '-' END
        AND cidade = CASE WHEN (NEW.geo_city IS NOT NULL) THEN NEW.geo_city ELSE '-' END
        AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region ELSE '-' END 
        AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END)=0)
          
    THEN INSERT INTO smarkio_portosinistro.acessos_count
    (date, pais, cidade, regiao, navegador)
    VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country ELSE '-' END,
        CASE WHEN (NEW.geo_city IS NOT NULL) THEN NEW.geo_city ELSE '-' END,
        CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region ELSE '-' END,
        CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END);
    END IF;

    IF (NEW.id IS NOT NULL) THEN 
        UPDATE smarkio_portosinistro.acessos_count
        SET total = total + 1
        WHERE date = NEW.lead_creation_day 
          AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country ELSE '-' END
          AND cidade = CASE WHEN (NEW.geo_city IS NOT NULL) THEN NEW.geo_city ELSE '-' END
          AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region ELSE '-' END 
          AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END;
    END IF;	

    IF (OLD.id IS NOT NULL) THEN 
        UPDATE smarkio_portosinistro.acessos_count
        SET total = total - 1
        WHERE date = OLD.lead_creation_day 
          AND pais = CASE WHEN (OLD.geo_country IS NOT NULL) THEN OLD.geo_country ELSE '-' END
          AND cidade = CASE WHEN (OLD.geo_city IS NOT NULL) THEN OLD.geo_city ELSE '-' END
          AND regiao = CASE WHEN (OLD.geo_region IS NOT NULL) THEN OLD.geo_region ELSE '-' END 
          AND navegador = CASE WHEN (OLD.browser IS NOT NULL) THEN OLD.browser ELSE '-' END;
    END IF;	
END