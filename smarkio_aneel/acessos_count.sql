-- TRIGGER --
USE smarkio_aneel;
DELIMITER |
CREATE TRIGGER tg_acessos_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Aneel') AND (NEW.campaign = 'Chat Aneel') 
    AND (SELECT EXISTS (SELECT * FROM smarkio_aneel.acessos_count 
    WHERE date = NEW.lead_creation_day
    AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END 
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
    AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END
    AND sistema = CASE WHEN (NEW.is_mobile = '1') THEN 'Android' ELSE 'Windows' END)=0))

    THEN INSERT INTO smarkio_aneel.acessos_count (date, dispositivo, pais, regiao, navegador, sistema)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END,CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END,CASE WHEN (NEW.is_mobile = '1') THEN 'Android' ELSE 'Windows' END);
    END IF;

    IF ((NEW.supplier = 'Aneel') AND (NEW.campaign = 'Chat Aneel') AND (NEW.id IS NOT NULL)) THEN 
        UPDATE smarkio_aneel.acessos_count
        SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
        AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
        AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
        AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END
        AND sistema = CASE WHEN (NEW.is_mobile = '1') THEN 'Android' ELSE 'Windows' END;
    END IF;	
END;

-- TRIGGER UPDATE--
USE smarkio_aneel;
DELIMITER |
CREATE TRIGGER tg_acessos_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Aneel') AND (NEW.campaign = 'Chat Aneel') 
    AND (SELECT EXISTS (SELECT * FROM smarkio_aneel.acessos_count 
    WHERE date = NEW.lead_creation_day
    AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END 
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
    AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END
    AND sistema = CASE WHEN (NEW.is_mobile = '1') THEN 'Android' ELSE 'Windows' END)=0))

    THEN INSERT INTO smarkio_aneel.acessos_count (date, dispositivo, pais, regiao, navegador, sistema)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END,CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END,CASE WHEN (NEW.is_mobile = '1') THEN 'Android' ELSE 'Windows' END);
    END IF;

    IF ((NEW.supplier = 'Aneel') AND (NEW.campaign = 'Chat Aneel') AND (NEW.id IS NOT NULL)) THEN 
        UPDATE smarkio_aneel.acessos_count
        SET total = total + 1
        WHERE date = NEW.lead_creation_day
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
        AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
        AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
        AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END
        AND sistema = CASE WHEN (NEW.is_mobile = '1') THEN 'Android' ELSE 'Windows' END;
    END IF;	

    IF ((OLD.supplier = 'Aneel') AND (OLD.campaign = 'Chat Aneel') AND (OLD.id IS NOT NULL)) THEN 
        UPDATE smarkio_aneel.acessos_count
        SET total = total - 1
        WHERE date = OLD.lead_creation_day
        AND dispositivo = CASE WHEN (OLD.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
        AND pais = CASE WHEN (OLD.geo_country IS NOT NULL) THEN OLD.geo_country  ELSE '-' END
        AND regiao = CASE WHEN (OLD.geo_region IS NOT NULL) THEN OLD.geo_region  ELSE '-' END 
        AND navegador = CASE WHEN (OLD.browser IS NOT NULL) THEN OLD.browser  ELSE '-' END
        AND sistema = CASE WHEN (OLD.is_mobile = '1') THEN 'Android' ELSE 'Windows' END;
    END IF;	
END;

-- SELECT -- 
INSERT INTO smarkio_aneel.acessos_count (`date`, `dispositivo`, `pais`,  `regiao`, `navegador`, `sistema`, `total`)
SELECT c.date, c.dispositivo, c.pais, c.regiao, c.navegador, c.sistema, c.total FROM (
    SELECT 
        lead_creation_day AS date,
        (CASE WHEN (is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END) AS dispositivo,
        (CASE WHEN (geo_country IS NOT NULL) THEN geo_country  ELSE '-' END) AS pais,
        (CASE WHEN (geo_region IS NOT NULL) THEN geo_region  ELSE '-' END) AS regiao,
        (CASE WHEN (browser IS NOT NULL) THEN browser  ELSE '-' END) AS navegador,
        (CASE WHEN (is_mobile = '1') THEN 'Android' ELSE 'Windows' END) AS sistema,
        SUM(CASE WHEN (id IS NOT NULL)  THEN 1 ELSE 0 END) AS total
    FROM smarkio_aneel.leads 
    WHERE supplier = 'Aneel' AND campaign = 'Chat Aneel' AND lead_creation_day < '2022-06-20'
    GROUP BY date,dispositivo, pais, regiao, navegador, sistema) AS c
ON DUPLICATE KEY UPDATE
`date` = c.date,
`dispositivo` = c.dispositivo,
`pais` = c.pais,
`regiao` = c.regiao,
`navegador` = c.navegador,
`sistema` = c.sistema,
`total` = c.total;