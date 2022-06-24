-- TRIGGER INSERT --
USE smarkio_buddha;
DELIMITER |
CREATE TRIGGER tg_leads_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Buddha Spa')
    AND (SELECT EXISTS ( SELECT * FROM smarkio_buddha.leads_count 
    WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00") 
    AND chat = CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END
    AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END)=0))

    THEN INSERT INTO smarkio_buddha.leads_count (date, chat, dispositivo)
    VALUES (DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00"),CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END,CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END);
    END IF;

    IF ((NEW.supplier = 'Buddha Spa') AND (NEW.first_name IS NOT NULL)) THEN 
        UPDATE smarkio_buddha.leads_count
        SET interacao = interacao + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00") 
        AND chat = CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END;
    END IF;	

    IF ((NEW.supplier = 'Buddha Spa') AND (NEW.iniciou_chat IS NOT NULL)) THEN 
        UPDATE smarkio_buddha.leads_count
        SET iniciou_chat = iniciou_chat + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00") 
        AND chat = CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END;
    END IF;	

    IF ((NEW.supplier = 'Buddha Spa') AND (NEW.receber_desconto = 'Sim')) THEN 
        UPDATE smarkio_buddha.leads_count
        SET aceitou_desconto = aceitou_desconto + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00") 
        AND chat = CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END;
    END IF;	
END

-- TRIGGER UPDATE --
USE smarkio_buddha;
DELIMITER |
CREATE TRIGGER tg_leads_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Buddha Spa')
    AND (SELECT EXISTS ( SELECT * FROM smarkio_buddha.leads_count 
    WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00") 
    AND chat = CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END
    AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END)=0))

    THEN INSERT INTO smarkio_buddha.leads_count (date, chat, dispositivo)
    VALUES (DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00"),CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END,CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END);
    END IF;

    IF ((NEW.supplier = 'Buddha Spa') AND (NEW.first_name IS NOT NULL)) THEN 
        UPDATE smarkio_buddha.leads_count
        SET interacao = interacao + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00") 
        AND chat = CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END;
    END IF;	

    IF ((NEW.supplier = 'Buddha Spa') AND (NEW.iniciou_chat IS NOT NULL)) THEN 
        UPDATE smarkio_buddha.leads_count
        SET iniciou_chat = iniciou_chat + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00") 
        AND chat = CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END;
    END IF;	

    IF ((NEW.supplier = 'Buddha Spa') AND (NEW.receber_desconto = 'Sim')) THEN 
        UPDATE smarkio_buddha.leads_count
        SET aceitou_desconto = aceitou_desconto + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00") 
        AND chat = CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END
        AND dispositivo = CASE WHEN (NEW.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END;
    END IF;	

    IF ((OLD.supplier = 'Buddha Spa') AND (OLD.first_name IS NOT NULL)) THEN 
        UPDATE smarkio_buddha.leads_count
        SET interacao = interacao - 1
        WHERE date = DATE_FORMAT(OLD.created_at,"%Y-%m-%d %H:00") 
            AND chat = CASE WHEN (OLD.tipo_chat IS NOT NULL) THEN OLD.tipo_chat ELSE '-' END
            AND dispositivo = CASE WHEN (OLD.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END;
    END IF;	

    IF ((OLD.supplier = 'Buddha Spa') AND (OLD.iniciou_chat IS NOT NULL)) THEN 
        UPDATE smarkio_buddha.leads_count
        SET iniciou_chat = iniciou_chat - 1
        WHERE date = DATE_FORMAT(OLD.created_at,"%Y-%m-%d %H:00") 
            AND chat = CASE WHEN (OLD.tipo_chat IS NOT NULL) THEN OLD.tipo_chat ELSE '-' END
            AND dispositivo = CASE WHEN (OLD.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END;
    END IF;	

    IF ((OLD.supplier = 'Buddha Spa') AND (OLD.receber_desconto = 'Sim')) THEN 
        UPDATE smarkio_buddha.leads_count
        SET aceitou_desconto = aceitou_desconto - 1
        WHERE date = DATE_FORMAT(OLD.created_at,"%Y-%m-%d %H:00") 
            AND chat = CASE WHEN (OLD.tipo_chat IS NOT NULL) THEN OLD.tipo_chat ELSE '-' END
            AND dispositivo = CASE WHEN (OLD.is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END;
    END IF;	
END

-- SELECT -- 
INSERT INTO smarkio_buddha.leads_count (`date`, `chat`, `dispositivo`, `interacao`,`iniciou_chat`,`aceitou_desconto`)
SELECT c.date, c.chat, c.dispositivo, c.interacao, c.iniciou_chat, c.aceitou_desconto FROM (
    SELECT 
        DATE_FORMAT(created_at,"%Y-%m-%d %H:00") AS date,
        (CASE WHEN (tipo_chat IS NOT NULL) THEN tipo_chat ELSE '-' END) AS chat,
        (CASE WHEN (is_mobile = '1') THEN 'Mobile' ELSE 'Desktop' END) AS dispositivo,
        SUM(CASE WHEN (first_name IS NOT NULL) THEN 1 ELSE 0 END) AS interacao,
        SUM(CASE WHEN (iniciou_chat IS NOT NULL) THEN 1 ELSE 0 END) AS iniciou_chat,
        SUM(CASE WHEN (receber_desconto = 'Sim') THEN 1 ELSE 0 END) AS aceitou_desconto
   	FROM smarkio_buddha.leads 
    WHERE supplier = 'Buddha Spa' AND lead_creation_day < '2022-06-20' 
	GROUP BY date, chat, dispositivo) AS c
ON DUPLICATE KEY UPDATE
`date` = c.date,
`chat` = c.chat,
`dispositivo` = c.dispositivo,
`interacao` = c.interacao,
`iniciou_chat` = c.iniciou_chat,
`aceitou_desconto` = c.aceitou_desconto;