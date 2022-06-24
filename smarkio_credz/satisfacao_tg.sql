-- TRIGGER INSERT --
USE smarkio_credz;
DELIMITER |
CREATE TRIGGER tg_satisfacao AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	-- VERIFICA SE O REGISTRO PARA DATA, CANPAIGN E PESQUISA_SATISFAÇÃO EXISTE
	IF (NEW.pesquisa_satisfacao IS NOT NULL AND
		(SELECT EXISTS(SELECT * FROM smarkio_credz.satisfacao_tg
		WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND pesquisa_satisfacao = NEW.pesquisa_satisfacao)=0)) 
    THEN INSERT INTO smarkio_credz.satisfacao_tg
		(date,campaign,pesquisa_satisfacao)
		VALUES 
		(NEW.lead_creation_day, CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END,NEW.pesquisa_satisfacao);
    END IF;
    IF(NEW.pesquisa_satisfacao IS NOT NULL) THEN
		UPDATE smarkio_credz.satisfacao_tg
        SET satisfacao = satisfacao + 1
        WHERE date = NEW.lead_creation_day
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND pesquisa_satisfacao = NEW.pesquisa_satisfacao;
	END IF;
END

-- TRIGGER UPDATE --
USE smarkio_credz;
DELIMITER |
CREATE TRIGGER tg_satisfacao_update AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
	-- VERIFICA SE O REGISTRO PARA DATA, CANPAIGN E PESQUISA_SATISFAÇÃO EXISTE
	IF (NEW.pesquisa_satisfacao IS NOT NULL AND
		(SELECT EXISTS(SELECT * FROM smarkio_credz.satisfacao_tg 
		WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND pesquisa_satisfacao = NEW.pesquisa_satisfacao)=0)) 
    THEN INSERT INTO smarkio_credz.satisfacao_tg
		(date,campaign,pesquisa_satisfacao)
		VALUES 
		(NEW.lead_creation_day, CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END,NEW.pesquisa_satisfacao);
    END IF;
	IF(NEW.pesquisa_satisfacao IS NOT NULL) THEN
		UPDATE smarkio_credz.satisfacao_tg
        SET satisfacao = satisfacao + 1
        WHERE date = NEW.lead_creation_day
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND pesquisa_satisfacao = NEW.pesquisa_satisfacao;
	END IF;
	IF (OLD.pesquisa_satisfacao IS NOT NULL) 
    THEN UPDATE smarkio_credz.satisfacao_tg
        SET satisfacao = satisfacao - 1
        WHERE date = OLD.lead_creation_day
        AND campaign = CASE WHEN OLD.campaign IS NULL OR OLD.campaign = '' THEN '-' ELSE OLD.campaign END
        AND pesquisa_satisfacao = OLD.pesquisa_satisfacao;
    END IF;
END