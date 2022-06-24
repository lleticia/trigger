-- TRIGGER INSERT -- 
USE smarkio_americanet;
DELIMITER |
CREATE TRIGGER tg_acessos_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') 
    AND (SELECT EXISTS (SELECT * FROM smarkio_americanet.acessos_count 
    WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00")
    AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
    AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END)=0))

    THEN INSERT INTO smarkio_americanet.acessos_count (date, dispositivo, pais, regiao, navegador)
    VALUES (DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00"),CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END,CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END);
    END IF;

    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.id IS NOT NULL)) THEN 
        UPDATE smarkio_americanet.acessos_count
        SET total = total + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00")
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
        AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
        AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
        AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END;
    END IF;	
END;

-- TRIGGER UPDATE -- 
USE smarkio_americanet;
DELIMITER |
CREATE TRIGGER tg_acessos_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') 
    AND (SELECT EXISTS (SELECT * FROM smarkio_americanet.acessos_count 
    WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00")
    AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
    AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
    AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
    AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END)=0))
    
    THEN INSERT INTO smarkio_americanet.acessos_count (date, dispositivo, pais, regiao, navegador)
    VALUES (DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00"),CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END,CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END,CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END,CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END);
    END IF;

    IF ((NEW.supplier = 'Website') AND (NEW.campaign = 'Atendimento') AND (NEW.id IS NOT NULL)) THEN 
        UPDATE smarkio_americanet.acessos_count
        SET total = total + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00")
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
        AND pais = CASE WHEN (NEW.geo_country IS NOT NULL) THEN NEW.geo_country  ELSE '-' END
        AND regiao = CASE WHEN (NEW.geo_region IS NOT NULL) THEN NEW.geo_region  ELSE '-' END 
        AND navegador = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser  ELSE '-' END;
    END IF;	

    IF ((OLD.supplier = 'Website') AND (OLD.campaign = 'Atendimento') AND (OLD.id IS NOT NULL)) THEN 
        UPDATE smarkio_americanet.acessos_count
        SET total = total - 1
        WHERE date = DATE_FORMAT(OLD.created_at,"%Y-%m-%d %H:00")
        AND dispositivo = CASE WHEN (OLD.is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END 
        AND pais = CASE WHEN (OLD.geo_country IS NOT NULL) THEN OLD.geo_country  ELSE '-' END
        AND regiao = CASE WHEN (OLD.geo_region IS NOT NULL) THEN OLD.geo_region  ELSE '-' END 
        AND navegador = CASE WHEN (OLD.browser IS NOT NULL) THEN OLD.browser  ELSE '-' END;
    END IF;	
END

-- SELECT -- 
INSERT INTO smarkio_americanet.acessos_count (`date`, `dispositivo`, `pais`,  `regiao`, `navegador`, `total`)
SELECT c.date, c.dispositivo, c.pais, c.regiao, c.navegador, c.total FROM (
    SELECT 
        DATE_FORMAT(created_at,"%Y-%m-%d %H:00") AS date,
        (CASE WHEN (is_mobile = '1') THEN 'Mobile'  ELSE 'Desktop' END) AS dispositivo,
        (CASE WHEN (geo_country IS NOT NULL) THEN geo_country  ELSE '-' END) AS pais,
        (CASE WHEN (geo_region IS NOT NULL) THEN geo_region  ELSE '-' END) AS regiao,
        (CASE WHEN (browser IS NOT NULL) THEN browser  ELSE '-' END) AS navegador,
        SUM(CASE WHEN (id IS NOT NULL)  THEN 1 ELSE 0 END) AS total
    FROM smarkio_americanet.leads 
    WHERE supplier = 'Website' AND campaign = 'Atendimento' AND lead_creation_day < '2022-06-20' 
    GROUP BY date,dispositivo, pais, regiao, navegador) AS c
ON DUPLICATE KEY UPDATE
`date` = c.date,
`dispositivo` = c.dispositivo,
`pais` = c.pais,
`regiao` = c.regiao,
`navegador` = c.navegador,
`total` = c.total;