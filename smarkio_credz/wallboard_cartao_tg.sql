-- TRIGGER INSERT --
USE smarkio_credz;
DELIMITER |
CREATE TRIGGER tg_wallboard_cartao AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    -- VERIFICA SE O REGISTRO PARA DATA E CANPAIGN EXISTE
	IF ((SELECT EXISTS(SELECT * FROM smarkio_credz.wallboard_cartao_tg AS w
		WHERE w.date = NEW.lead_creation_day 
        AND w.campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND w.cartao_desbloquear = NEW.cartao_desbloquear))=0
        AND NEW.cartao_desbloquear IS NOT NULL) 
    THEN INSERT INTO smarkio_credz.wallboard_cartao_tg
		(date,campaign,cartao_desbloquear)
		VALUES 
		(NEW.lead_creation_day, 
        CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END,
        NEW.cartao_desbloquear);
	END IF;
	IF (NEW.cartao_desbloquear IS NOT NULL) THEN
        UPDATE smarkio_credz.wallboard_cartao_tg
        SET desbloquear = desbloquear + 1
        WHERE date = NEW.lead_creation_day
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND cartao_desbloquear = NEW.cartao_desbloquear;
    END IF;
END |

-- TRIGGER UPDATE --
USE smarkio_credz;
DELIMITER |
CREATE TRIGGER tg_wallboard_cartao_update AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    -- VERIFICA SE O REGISTRO PARA DATA E CANPAIGN EXISTE
	IF ((SELECT EXISTS(SELECT * FROM smarkio_credz.wallboard_cartao_tg AS w
		WHERE w.date = NEW.lead_creation_day 
        AND w.campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND w.cartao_desbloquear = NEW.cartao_desbloquear))=0
        AND NEW.cartao_desbloquear IS NOT NULL) 
    THEN INSERT INTO smarkio_credz.wallboard_cartao_tg
		(date,campaign,cartao_desbloquear)
		VALUES 
		(NEW.lead_creation_day, 
        CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END,
        NEW.cartao_desbloquear);
	END IF;
    IF(NEW.cartao_desbloquear IS NOT NULL) THEN
		UPDATE smarkio_credz.wallboard_cartao_tg
		SET desbloquear = desbloquear + 1
		WHERE date = NEW.lead_creation_day
		AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
		AND cartao_desbloquear = NEW.cartao_desbloquear;
	END IF;
    IF (OLD.cartao_desbloquear IS NOT NULL) THEN
		UPDATE smarkio_credz.wallboard_cartao_tg
        SET desbloquear = desbloquear - 1
        WHERE date = NEW.lead_creation_day
        AND campaign = CASE WHEN OLD.campaign IS NULL OR OLD.campaign = '' THEN '-' ELSE OLD.campaign END
        AND cartao_desbloquear = OLD.cartao_desbloquear;
    END IF;
END