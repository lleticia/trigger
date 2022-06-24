-- TRIGGER INSERT --
USE smarkio_credz;
DELIMITER |
CREATE TRIGGER tg_wallboard AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	-- VERIFICA SE O REGISTRO PARA DATA E CANPAIGN EXISTE
	IF (SELECT EXISTS(SELECT * FROM smarkio_credz.wallboard_tg AS w
		WHERE w.date = NEW.lead_creation_day 
        AND w.campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END))=0 
    THEN INSERT INTO smarkio_credz.wallboard_tg
		(date,campaign)
		VALUES 
		(NEW.lead_creation_day, CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END);
    END IF;
    -- MÉTRICAS
    -- ACESSOS
    IF (NEW.iniciou_chat IS NOT NULL) THEN
		UPDATE smarkio_credz.wallboard_tg
        SET acessos = acessos + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END;
	END IF;
    IF ((NEW.transferencia_humano LIKE "%" or NEW.tranferencia_humano LIKE "%")
		OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "21:00:00"
			AND WEEKDAY(NEW.created_at) BETWEEN 0 AND 4 
			AND NEW.campaign = "Negociação"
			AND NEW.identification_number1 IS NOT NULL)
		OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "14:00:00"
                AND WEEKDAY(NEW.created_at) BETWEEN 5 AND 6
				AND NEW.campaign = "Negociação"
                AND NEW.identification_number1 IS NOT NULL)
		) THEN
        UPDATE smarkio_credz.wallboard_tg
		SET transbordo = transbordo + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END;
	END IF;
    -- INTERAÇÕES E RETENÇÕES (18 a 110)
    IF((NEW.campaign LIKE "Desbloqueio de Cart%" AND NEW.escolha_cartao_cpf IS NOT NULL)
		OR (NEW.campaign LIKE "Bot% Vermelho" AND NEW.menu_desbloqueio IS NOT NULL)
		OR (NEW.campaign LIKE "Negocia%" AND NEW.identification_number1 IS NOT NULL)
        OR (NEW.campaign LIKE "N% Recebi meu cart%" AND (NEW.escolha_cartao_cpf IS NOT NULL OR NEW.zip_code IS NOT NULL))
        OR (NEW.campaign = "Chat Lojista" AND NEW.first_name IS NOT NULL)
        OR (NEW.campaign LIKE "Chat APP" AND NEW.menu_sem_atraso IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.atraso_negociar IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.atraso_maior77_negociar IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.atraso_maior77_com_acordo IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.menu_cartoes_sem_telesaque IS NOT NULL)
        OR (NEW.campaign = "Canais diretos" AND NEW.menu_desbloqueio IS NOT NULL)
        OR (NEW.campaign LIKE "Telesaque%Seguro" AND NEW.menu_desbloqueio IS NOT NULL)
        OR (NEW.campaign = "Chat Credz" AND (NEW.menu_desbloqueio IS NOT NULL OR NEW.escolha_cartao_cpf IS NOT NULL))
	) THEN
		UPDATE smarkio_credz.wallboard_tg
		SET interacao = interacao + 1,
        retencao = retencao + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END;
	END IF;
	-- RETENÇÕES DECREMENTAR
    IF ((NEW.transferencia_humano LIKE "%" or NEW.tranferencia_humano LIKE "%")
		OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "21:00:00"
			AND WEEKDAY(NEW.created_at) BETWEEN 0 AND 4 
			AND NEW.campaign = "Negociação"
			AND NEW.identification_number1 IS NOT NULL)
		OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "14:00:00"
                AND WEEKDAY(NEW.created_at) BETWEEN 5 AND 6
				AND NEW.campaign = "Negociação"
                AND NEW.identification_number1 IS NOT NULL)
		) THEN
        UPDATE smarkio_credz.wallboard_tg
		SET retencao = retencao - 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END;
	END IF;
    -- DESBLOQUEAR
    IF (NEW.cartao_desbloquear IS NOT NULL) THEN
		UPDATE smarkio_credz.wallboard_tg
        SET desbloquear = desbloquear + 1
		WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END;
	END IF;
    -- MÉDIA DE NOTAS
    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN
		UPDATE smarkio_credz.wallboard_tg
        SET pesquisa_satisfacao = (((total_notas*pesquisa_satisfacao)/(total_notas+1)) + (NEW.pesquisa_satisfacao/(total_notas+1))),
        total_notas = total_notas + 1
		WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END;
	END IF;
END

-- TRIGGER UPDATE --
USE smarkio_credz;
DELIMITER |
CREATE TRIGGER tg_wallboard_update AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    -- VERIFICA SE O REGISTRO PARA DATA E CANPAIGN EXISTE
	IF (SELECT EXISTS(SELECT * FROM smarkio_credz.wallboard_tg AS w
		WHERE w.date = NEW.lead_creation_day 
        AND w.campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END))=0 
    THEN INSERT INTO smarkio_credz.wallboard_tg
		(date,campaign)
		VALUES 
		(NEW.lead_creation_day, CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END);
    END IF;
    -- MÉTRICAS REVERSÃO
    -- ACESSOS
    IF (OLD.iniciou_chat IS NOT NULL) THEN
		UPDATE smarkio_credz.wallboard_tg
        SET acessos = acessos - 1
        WHERE date = OLD.lead_creation_day 
        AND campaign = CASE WHEN OLD.campaign IS NULL OR OLD.campaign = '' THEN '-' ELSE OLD.campaign END;
	END IF;
    IF ((OLD.transferencia_humano LIKE "%" or OLD.tranferencia_humano LIKE "%")
		OR (DATE_FORMAT(OLD.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "21:00:00"
			AND WEEKDAY(OLD.created_at) BETWEEN 0 AND 4 
			AND OLD.campaign = "Negociação"
			AND OLD.identification_number1 IS NOT NULL)
		OR (DATE_FORMAT(OLD.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "14:00:00"
                AND WEEKDAY(OLD.created_at) BETWEEN 5 AND 6
				AND OLD.campaign = "Negociação"
                AND OLD.identification_number1 IS NOT NULL)
		) THEN
        UPDATE smarkio_credz.wallboard_tg
		SET transbordo = transbordo - 1
        WHERE date = OLD.lead_creation_day 
        AND campaign = CASE WHEN OLD.campaign IS NULL OR OLD.campaign = '' THEN '-' ELSE OLD.campaign END;
	END IF;
    -- INTERAÇÕES E RETENÇÕES (18 a 110)
    IF((OLD.campaign LIKE "Desbloqueio de Cart%" AND OLD.escolha_cartao_cpf IS NOT NULL)
		OR (OLD.campaign LIKE "Bot% Vermelho" AND OLD.menu_desbloqueio IS NOT NULL)
		OR (OLD.campaign LIKE "Negocia%" AND OLD.identification_number1 IS NOT NULL)
        OR (OLD.campaign LIKE "N% Recebi meu cart%" AND (OLD.escolha_cartao_cpf IS NOT NULL OR OLD.zip_code IS NOT NULL))
        OR (OLD.campaign = "Chat Lojista" AND OLD.first_name IS NOT NULL)
        OR (OLD.campaign LIKE "Chat APP" AND OLD.menu_sem_atraso IS NOT NULL)
        OR (OLD.campaign = "Chat APP" AND OLD.atraso_negociar IS NOT NULL)
        OR (OLD.campaign = "Chat APP" AND OLD.atraso_maior77_negociar IS NOT NULL)
        OR (OLD.campaign = "Chat APP" AND OLD.atraso_maior77_com_acordo IS NOT NULL)
        OR (OLD.campaign = "Chat APP" AND OLD.menu_cartoes_sem_telesaque IS NOT NULL)
        OR (OLD.campaign = "Canais diretos" AND OLD.menu_desbloqueio IS NOT NULL)
        OR (OLD.campaign LIKE "Telesaque%Seguro" AND OLD.menu_desbloqueio IS NOT NULL)
        OR (OLD.campaign = "Chat Credz" AND (OLD.menu_desbloqueio IS NOT NULL OR OLD.escolha_cartao_cpf IS NOT NULL))
	) THEN
		UPDATE smarkio_credz.wallboard_tg
		SET interacao = interacao - 1,
        retencao = retencao - 1
        WHERE date = OLD.lead_creation_day 
        AND campaign = CASE WHEN OLD.campaign IS NULL OR OLD.campaign = '' THEN '-' ELSE OLD.campaign END;
	END IF;
	-- RETENÇÕES DECREMENTAR (REVERSÃO)
    IF ((OLD.transferencia_humano LIKE "%" or OLD.tranferencia_humano LIKE "%")
		OR (DATE_FORMAT(OLD.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "21:00:00"
			AND WEEKDAY(OLD.created_at) BETWEEN 0 AND 4 
			AND OLD.campaign = "Negociação"
			AND OLD.identification_number1 IS NOT NULL)
		OR (DATE_FORMAT(OLD.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "14:00:00"
                AND WEEKDAY(OLD.created_at) BETWEEN 5 AND 6
				AND OLD.campaign = "Negociação"
                AND OLD.identification_number1 IS NOT NULL)
		) THEN
        UPDATE smarkio_credz.wallboard_tg
		SET retencao = retencao + 1 
        WHERE date = OLD.lead_creation_day 
        AND campaign = CASE WHEN OLD.campaign IS NULL OR OLD.campaign = '' THEN '-' ELSE OLD.campaign END;
	END IF;
    -- DESBLOQUEAR
    IF (OLD.cartao_desbloquear IS NOT NULL) THEN
		UPDATE smarkio_credz.wallboard_tg
        SET desbloquear = desbloquear - 1
		WHERE date = OLD.lead_creation_day 
        AND campaign = CASE WHEN OLD.campaign IS NULL OR OLD.campaign = '' THEN '-' ELSE OLD.campaign END;
	END IF;
    -- MÉDIA DE NOTAS (REVERSÃO)
    IF (OLD.pesquisa_satisfacao IS NOT NULL) THEN
		UPDATE smarkio_credz.wallboard_tg
        SET pesquisa_satisfacao = (pesquisa_satisfacao  - (OLD.pesquisa_satisfacao/total_notas))*(total_notas/(total_notas-1)),
        total_notas = total_notas - 1
		WHERE date = OLD.lead_creation_day 
        AND campaign = CASE WHEN OLD.campaign IS NULL OR OLD.campaign = '' THEN '-' ELSE OLD.campaign END;
	END IF;
    -- MÉTRICAS ATUALIZAÇÃO
    -- ACESSOS
    IF (NEW.iniciou_chat IS NOT NULL) THEN
		UPDATE smarkio_credz.wallboard_tg
        SET acessos = acessos + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END;
	END IF;
    IF ((NEW.transferencia_humano LIKE "%" or NEW.tranferencia_humano LIKE "%")
		OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "21:00:00"
			AND WEEKDAY(NEW.created_at) BETWEEN 0 AND 4 
			AND NEW.campaign = "Negociação"
			AND NEW.identification_number1 IS NOT NULL)
		OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "14:00:00"
                AND WEEKDAY(NEW.created_at) BETWEEN 5 AND 6
				AND NEW.campaign = "Negociação"
                AND NEW.identification_number1 IS NOT NULL)
		) THEN
        UPDATE smarkio_credz.wallboard_tg
		SET transbordo = transbordo + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END;
	END IF;
    -- INTERAÇÕES E RETENÇÕES (18 a 110)
    IF((NEW.campaign LIKE "Desbloqueio de Cart%" AND NEW.escolha_cartao_cpf IS NOT NULL)
		OR (NEW.campaign LIKE "Bot% Vermelho" AND NEW.menu_desbloqueio IS NOT NULL)
		OR (NEW.campaign LIKE "Negocia%" AND NEW.identification_number1 IS NOT NULL)
        OR (NEW.campaign LIKE "N% Recebi meu cart%" AND (NEW.escolha_cartao_cpf IS NOT NULL OR NEW.zip_code IS NOT NULL))
        OR (NEW.campaign = "Chat Lojista" AND NEW.first_name IS NOT NULL)
        OR (NEW.campaign LIKE "Chat APP" AND NEW.menu_sem_atraso IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.atraso_negociar IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.atraso_maior77_negociar IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.atraso_maior77_com_acordo IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.menu_cartoes_sem_telesaque IS NOT NULL)
        OR (NEW.campaign = "Canais diretos" AND NEW.menu_desbloqueio IS NOT NULL)
        OR (NEW.campaign LIKE "Telesaque%Seguro" AND NEW.menu_desbloqueio IS NOT NULL)
        OR (NEW.campaign = "Chat Credz" AND (NEW.menu_desbloqueio IS NOT NULL OR NEW.escolha_cartao_cpf IS NOT NULL))
	) THEN
		UPDATE smarkio_credz.wallboard_tg
		SET interacao = interacao + 1,
        retencao = retencao + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END;
	END IF;
	-- RETENÇÕES DECREMENTAR
    IF ((NEW.transferencia_humano LIKE "%" or NEW.tranferencia_humano LIKE "%")
		OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "21:00:00"
			AND WEEKDAY(NEW.created_at) BETWEEN 0 AND 4 
			AND NEW.campaign = "Negociação"
			AND NEW.identification_number1 IS NOT NULL)
		OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "14:00:00"
                AND WEEKDAY(NEW.created_at) BETWEEN 5 AND 6
				AND NEW.campaign = "Negociação"
                AND NEW.identification_number1 IS NOT NULL)
		) THEN
        UPDATE smarkio_credz.wallboard_tg
		SET retencao = retencao - 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END;
	END IF;
    -- DESBLOQUEAR
    IF (NEW.cartao_desbloquear IS NOT NULL) THEN
		UPDATE smarkio_credz.wallboard_tg
        SET desbloquear = desbloquear + 1
		WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END;
	END IF;
    -- MÉDIA DE NOTAS
    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN
		UPDATE smarkio_credz.wallboard_tg
        SET pesquisa_satisfacao = ((total_notas*pesquisa_satisfacao)/(total_notas+1)) + (NEW.pesquisa_satisfacao/(total_notas+1)),
        total_notas = total_notas + 1
		WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END;
	END IF;
END