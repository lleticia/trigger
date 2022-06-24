-- TRIGGER --
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_acessos_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.supplier = 'Guia Mais') AND (NEW.campaign = 'Chat Guia Mais') 
    AND (SELECT EXISTS (SELECT * FROM smarkio_guiamais.acessos_count 
    WHERE date = NEW.lead_creation_day
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END 
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END
    AND mobile = CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END)=0))

    THEN INSERT INTO smarkio_guiamais.acessos_count (date, pais, regiao, mobile)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END);
    END IF;

    IF ((NEW.supplier = 'Guia Mais') AND (NEW.campaign = 'Chat Guia Mais') AND (NEW.id IS NOT NULL)) THEN 
	UPDATE smarkio_guiamais.acessos_count
	SET total = total + 1
    WHERE date = NEW.lead_creation_day
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END 
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END
    AND mobile = CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END;
    END IF;	
END;

-- TRIGGER UPDATE--
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_acessos_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.supplier = 'Guia Mais') AND (NEW.campaign = 'Chat Guia Mais') 
    AND (SELECT EXISTS (SELECT * FROM smarkio_guiamais.acessos_count 
    WHERE date = NEW.lead_creation_day
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END 
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END
    AND mobile = CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END)=0))

    THEN INSERT INTO smarkio_guiamais.acessos_count (date, pais, regiao, mobile)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END);
    END IF;

    IF ((NEW.supplier = 'Guia Mais') AND (NEW.campaign = 'Chat Guia Mais') AND (NEW.id IS NOT NULL)) THEN 
	UPDATE smarkio_guiamais.acessos_count
	SET total = total + 1
    WHERE date = NEW.lead_creation_day
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END 
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END
    AND mobile = CASE WHEN (NEW.is_mobile IS NOT NULL) THEN NEW.is_mobile ELSE '-' END;
    END IF;	

    IF ((OLD.supplier = 'Guia Mais') AND (OLD.campaign = 'Chat Guia Mais') AND (OLD.id IS NOT NULL)) THEN 
	UPDATE smarkio_guiamais.acessos_count
	SET total = total - 1
    WHERE date = OLD.lead_creation_day
    AND pais = CASE WHEN (OLD.geo_country IS NOT NULL) THEN OLD.geo_country  ELSE '-' END 
    AND regiao = CASE WHEN (OLD.geo_region IS NOT NULL) THEN OLD.geo_region  ELSE '-' END
    AND mobile = CASE WHEN (OLD.is_mobile IS NOT NULL) THEN OLD.is_mobile ELSE '-' END;
    END IF;	
END;

-- SELECT -- 
INSERT INTO smarkio_guiamais.acessos_count (`date`, `regiao`, `pais`, `mobile`, `total`)
SELECT c.date, c.regiao, c.pais, c.mobile, c.total FROM (
    SELECT 
        lead_creation_day AS date,
        (CASE WHEN (geo_region IS NOT NULL) THEN geo_region  ELSE '-' END) AS regiao,
        (CASE WHEN (geo_country IS NOT NULL) THEN geo_country ELSE '-' END) AS pais,
        (CASE WHEN (is_mobile IS NOT NULL) THEN is_mobile ELSE '-' END) AS mobile,
        SUM(CASE WHEN (id IS NOT NULL)  THEN 1 ELSE 0 END) AS total
	FROM smarkio_guiamais.leads 
    WHERE supplier = 'Guia Mais' AND campaign = 'Chat Guia Mais' AND lead_creation_day < '2022-06-20'
	GROUP BY date, pais, regiao, mobile ) AS c
ON DUPLICATE KEY UPDATE
`date` = c.date,
`regiao` = c.regiao,
`pais` = c.pais,
`mobile` = c.mobile,
`total` = c.total;
