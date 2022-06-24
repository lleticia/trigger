-- TRIGGER INSERT --
USE smarkio_buddha;
DELIMITER |
CREATE TRIGGER tg_menuunidades_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Buddha Spa') AND (NEW.unidades IS NOT NULL) 
    AND (SELECT EXISTS ( SELECT * FROM smarkio_buddha.menuunidades_count 
    WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00") 
    AND chat = CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END
    AND menu = CASE WHEN (NEW.unidades IS NOT NULL) THEN NEW.unidades ELSE '-' END)=0))  

    THEN INSERT INTO smarkio_buddha.menuunidades_count (date, chat, menu)
    VALUES (DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00"),CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END,CASE WHEN (NEW.unidades IS NOT NULL) THEN NEW.unidades ELSE '-' END);
    END IF;

    IF ((NEW.supplier = 'Buddha Spa') AND (NEW.unidades IS NOT NULL)) THEN 
        UPDATE smarkio_buddha.menuunidades_count
        SET total = total + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00") 
        AND chat = CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END
        AND menu = CASE WHEN (NEW.unidades IS NOT NULL) THEN NEW.unidades ELSE '-' END;
    END IF;		
END;

-- TRIGGER UPDATE --
USE smarkio_buddha;
DELIMITER |
CREATE TRIGGER tg_menuunidades_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.supplier = 'Buddha Spa') AND (NEW.unidades IS NOT NULL) 
    AND (SELECT EXISTS ( SELECT * FROM smarkio_buddha.menuunidades_count 
    WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00") 
    AND chat = CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END
    AND menu = CASE WHEN (NEW.unidades IS NOT NULL) THEN NEW.unidades ELSE '-' END)=0))  

    THEN INSERT INTO smarkio_buddha.menuunidades_count (date, chat, menu)
    VALUES (DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00"),CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END,CASE WHEN (NEW.unidades IS NOT NULL) THEN NEW.unidades ELSE '-' END);
    END IF;

    IF ((NEW.supplier = 'Buddha Spa') AND (NEW.unidades IS NOT NULL)) THEN 
        UPDATE smarkio_buddha.menuunidades_count
        SET total = total + 1
        WHERE date = DATE_FORMAT(NEW.created_at,"%Y-%m-%d %H:00") 
        AND chat = CASE WHEN (NEW.tipo_chat IS NOT NULL) THEN NEW.tipo_chat ELSE '-' END
        AND menu = CASE WHEN (NEW.unidades IS NOT NULL) THEN NEW.unidades ELSE '-' END;
    END IF;	

    IF ((OLD.supplier = 'Buddha Spa') AND (OLD.unidades IS NOT NULL)) THEN 
        UPDATE smarkio_buddha.menuunidades_count
        SET total = total + 1
        WHERE date = DATE_FORMAT(OLD.created_at,"%Y-%m-%d %H:00") 
        AND chat = CASE WHEN (OLD.tipo_chat IS NOT NULL) THEN OLD.tipo_chat ELSE '-' END
        AND menu = CASE WHEN (OLD.unidades IS NOT NULL) THEN OLD.unidades ELSE '-' END;
    END IF;	
END

-- SELECT -- 
INSERT INTO smarkio_buddha.menuunidades_count (`date`, `chat`, `menu`, `total`)
SELECT c.date, c.chat, c.menu, c.total FROM (
    SELECT 
        DATE_FORMAT(created_at,"%Y-%m-%d %H:00") AS date,
        (CASE WHEN (tipo_chat IS NOT NULL) THEN tipo_chat ELSE '-' END) AS chat,
        (CASE WHEN (unidades IS NOT NULL) THEN unidades ELSE '-' END) AS menu,
        SUM(CASE WHEN (unidades IS NOT NULL) THEN 1 ELSE 0 END) AS total
   	FROM smarkio_buddha.leads 
    WHERE supplier = 'Buddha Spa' AND lead_creation_day < '2022-06-20' 
	GROUP BY date, chat, menu) AS c
ON DUPLICATE KEY UPDATE
`date` = c.date,
`chat` = c.chat,
`menu` = c.menu,
`total` = c.total;