-- TRIGGER INSERT --
USE smarkio_credz;
DELIMITER |
CREATE TRIGGER tg_transbordo_retencao_sem_atraso AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	-- VERIFICA SE O REGISTRO PARA DATA E CANPAIGN E MENU EXISTE
	IF (SELECT EXISTS(SELECT * FROM smarkio_credz.transbordo_retencao_menu_sem_atraso_tg AS w
		WHERE w.date = NEW.lead_creation_day 
        AND w.campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND w.menu_sem_atraso = CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END)=0) 
    THEN INSERT INTO smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
		(date,campaign,menu_sem_atraso)
		VALUES 
		(NEW.lead_creation_day, 
        CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END,
        CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END
        );
    END IF;
    -- MÉTRICAS
    -- TRANSBORDO
    IF((NEW.transferencia_humano LIKE "%" OR NEW.tranferencia_humano LIKE "%")
		OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "21:00:00"
                AND WEEKDAY(NEW.created_at) BETWEEN 0 AND 4 
                AND NEW.campaign = "Negociação"
                AND NEW.identification_number1 IS NOT NULL)
		OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "14:00:00"
                AND WEEKDAY(NEW.created_at) BETWEEN 5 AND 6
				AND NEW.campaign = "Negociação"
                AND NEW.identification_number1 IS NOT NULL)
		) THEN
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET transbordo = transbordo + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND menu_sem_atraso = CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END;
    END IF;
    -- INTERACAO (17 a 109)
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
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET interacao = interacao + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND menu_sem_atraso = CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END;
	END IF;
    -- RETENCAO INCREMENTO (110 A 21)
    IF ((NEW.campaign LIKE "Desbloqueio de Cart%" AND NEW.escolha_cartao_cpf IS NOT NULL)
        OR (NEW.campaign LIKE "Bot% Vermelho" AND NEW.menu_desbloqueio IS NOT NULL) 
        OR (NEW.campaign LIKE "Negocia%" AND NEW.identification_number1 IS NOT NULL)
        OR (NEW.campaign LIKE "N% Recebi meu cart%" AND (NEW.escolha_cartao_cpf IS NOT NULL OR NEW.zip_code IS NOT NULL))
        OR (NEW.campaign = "Chat Lojista" AND NEW.first_name IS NOT NULL)
        OR (NEW.campaign LIKE "Chat APP" AND NEW.menu_sem_atraso IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.atraso_negociar IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.atraso_maior77_negociar IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.atraso_maior77_com_acordo IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.menu_cartoes_sem_telesaque IS NOT NULL)
        OR ((NEW.campaign = "Canais diretos" AND NEW.menu_desbloqueio IS NOT NULL))
        OR ((NEW.campaign LIKE "Telesaque%Seguro" AND NEW.menu_desbloqueio IS NOT NULL))
        OR ((NEW.campaign = "Chat Credz" AND (NEW.menu_desbloqueio IS NOT NULL OR NEW.escolha_cartao_cpf IS NOT NULL)))
        ) THEN
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET retencao = retencao + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND menu_sem_atraso = CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END;
    END IF;
    -- RETENCAO DECREMENTO
    IF(NEW.transferencia_humano LIKE "%" OR NEW.tranferencia_humano LIKE "%"
        OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "21:00:00"
            AND WEEKDAY(NEW.created_at) BETWEEN 0 AND 4 
            AND NEW.campaign = "Negociação"
            AND NEW.identification_number1 IS NOT NULL)
        OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "14:00:00"
                AND WEEKDAY(NEW.created_at) BETWEEN 5 AND 6
				AND NEW.campaign = "Negociação"
                AND NEW.identification_number1 IS NOT NULL)
        ) THEN
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET retencao = retencao - 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND menu_sem_atraso = CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END;
    END IF;
    -- TOTAL
    IF (NEW.menu_sem_atraso IS NOT NULL) THEN
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET total = total + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND menu_sem_atraso = CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END;
    END IF;
END

-- TRIGGER UPDATE --
USE smarkio_credz;
DELIMITER |
CREATE TRIGGER tg_transbordo_retencao_sem_atraso_update AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF (SELECT EXISTS(SELECT * FROM smarkio_credz.transbordo_retencao_menu_sem_atraso_tg AS w
		WHERE w.date = NEW.lead_creation_day 
        AND w.campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND w.menu_sem_atraso = CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END)=0) 
    THEN INSERT INTO smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
		(date,campaign,menu_sem_atraso)
		VALUES 
		(NEW.lead_creation_day, 
        CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END,
        CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END
        );
    END IF;
    -- MÉTRICAS (REVERSÃO)
    -- TRANSBORDO
    IF((OLD.transferencia_humano LIKE "%" OR OLD.tranferencia_humano LIKE "%")
		OR (DATE_FORMAT(OLD.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "21:00:00"
                AND WEEKDAY(OLD.created_at) BETWEEN 0 AND 4 
                AND OLD.campaign = "Negociação"
                AND OLD.identification_number1 IS NOT NULL)
		OR (DATE_FORMAT(OLD.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "14:00:00"
                AND WEEKDAY(OLD.created_at) BETWEEN 5 AND 6
				AND OLD.campaign = "Negociação"
                AND OLD.identification_number1 IS NOT NULL)
		) THEN
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET transbordo = transbordo - 1
        WHERE date = OLD.lead_creation_day 
        AND campaign = CASE WHEN OLD.campaign IS NULL OR OLD.campaign = '' THEN '-' ELSE OLD.campaign END
        AND menu_sem_atraso = CASE WHEN OLD.menu_sem_atraso IS NULL OR OLD.menu_sem_atraso = '' THEN '-' ELSE OLD.menu_sem_atraso END;
    END IF;
    -- INTERACAO (17 a 109)
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
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET interacao = interacao - 1
        WHERE date = OLD.lead_creation_day 
        AND campaign = CASE WHEN OLD.campaign IS NULL OR OLD.campaign = '' THEN '-' ELSE OLD.campaign END
        AND menu_sem_atraso = CASE WHEN OLD.menu_sem_atraso IS NULL OR OLD.menu_sem_atraso = '' THEN '-' ELSE OLD.menu_sem_atraso END;
	END IF;
    -- RETENCAO INCREMENTO (REVERSAO)
    IF ((OLD.campaign LIKE "Desbloqueio de Cart%" AND OLD.escolha_cartao_cpf IS NOT NULL)
        OR (OLD.campaign LIKE "Bot% Vermelho" AND OLD.menu_desbloqueio IS NOT NULL) 
        OR (OLD.campaign LIKE "Negocia%" AND OLD.identification_number1 IS NOT NULL)
        OR (OLD.campaign LIKE "N% Recebi meu cart%" AND (OLD.escolha_cartao_cpf IS NOT NULL OR OLD.zip_code IS NOT NULL))
        OR (OLD.campaign = "Chat Lojista" AND OLD.first_name IS NOT NULL)
        OR (OLD.campaign LIKE "Chat APP" AND OLD.menu_sem_atraso IS NOT NULL)
        OR (OLD.campaign = "Chat APP" AND OLD.atraso_negociar IS NOT NULL)
        OR (OLD.campaign = "Chat APP" AND OLD.atraso_maior77_negociar IS NOT NULL)
        OR (OLD.campaign = "Chat APP" AND OLD.atraso_maior77_com_acordo IS NOT NULL)
        OR (OLD.campaign = "Chat APP" AND OLD.menu_cartoes_sem_telesaque IS NOT NULL)
        OR ((OLD.campaign = "Canais diretos" AND OLD.menu_desbloqueio IS NOT NULL))
        OR ((OLD.campaign LIKE "Telesaque%Seguro" AND OLD.menu_desbloqueio IS NOT NULL))
        OR ((OLD.campaign = "Chat Credz" AND (OLD.menu_desbloqueio IS NOT NULL OR OLD.escolha_cartao_cpf IS NOT NULL)))
        ) THEN
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET retencao = retencao - 1
        WHERE date = OLD.lead_creation_day 
        AND campaign = CASE WHEN OLD.campaign IS NULL OR OLD.campaign = '' THEN '-' ELSE OLD.campaign END
        AND menu_sem_atraso = CASE WHEN OLD.menu_sem_atraso IS NULL OR OLD.menu_sem_atraso = '' THEN '-' ELSE OLD.menu_sem_atraso END;
    END IF;
    -- RETENCAO DECREMENTO (REVERSÃO)
    IF(OLD.transferencia_humano LIKE "%" OR OLD.tranferencia_humano LIKE "%"
        OR (DATE_FORMAT(OLD.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "21:00:00"
            AND WEEKDAY(OLD.created_at) BETWEEN 0 AND 4 
            AND OLD.campaign = "Negociação"
            AND OLD.identification_number1 IS NOT NULL)
        OR (DATE_FORMAT(OLD.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "14:00:00"
                AND WEEKDAY(OLD.created_at) BETWEEN 5 AND 6
				AND OLD.campaign = "Negociação"
                AND OLD.identification_number1 IS NOT NULL)
        ) THEN
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET retencao = retencao + 1
        WHERE date = OLD.lead_creation_day 
        AND campaign = CASE WHEN OLD.campaign IS NULL OR OLD.campaign = '' THEN '-' ELSE OLD.campaign END
        AND menu_sem_atraso = CASE WHEN OLD.menu_sem_atraso IS NULL OR OLD.menu_sem_atraso = '' THEN '-' ELSE OLD.menu_sem_atraso END;
    END IF;
    -- TOTAL
    IF (OLD.menu_sem_atraso IS NOT NULL) THEN
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET total = total - 1
        WHERE date = OLD.lead_creation_day 
        AND campaign = CASE WHEN OLD.campaign IS NULL OR OLD.campaign = '' THEN '-' ELSE OLD.campaign END
        AND menu_sem_atraso = CASE WHEN OLD.menu_sem_atraso IS NULL OR OLD.menu_sem_atraso = '' THEN '-' ELSE OLD.menu_sem_atraso END;
    END IF;
    -- MÉTRICAS
    -- TRANSBORDO
    IF((NEW.transferencia_humano LIKE "%" OR NEW.tranferencia_humano LIKE "%")
		OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "21:00:00"
                AND WEEKDAY(NEW.created_at) BETWEEN 0 AND 4 
                AND NEW.campaign = "Negociação"
                AND NEW.identification_number1 IS NOT NULL)
		OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "14:00:00"
                AND WEEKDAY(NEW.created_at) BETWEEN 5 AND 6
				AND NEW.campaign = "Negociação"
                AND NEW.identification_number1 IS NOT NULL)
		) THEN
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET transbordo = transbordo + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND menu_sem_atraso = CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END;
    END IF;
    -- INTERACAO (17 a 109)
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
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET interacao = interacao + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND menu_sem_atraso = CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END;
	END IF;
    -- RETENCAO INCREMENTO (110 A 21)
    IF ((NEW.campaign LIKE "Desbloqueio de Cart%" AND NEW.escolha_cartao_cpf IS NOT NULL)
        OR (NEW.campaign LIKE "Bot% Vermelho" AND NEW.menu_desbloqueio IS NOT NULL) 
        OR (NEW.campaign LIKE "Negocia%" AND NEW.identification_number1 IS NOT NULL)
        OR (NEW.campaign LIKE "N% Recebi meu cart%" AND (NEW.escolha_cartao_cpf IS NOT NULL OR NEW.zip_code IS NOT NULL))
        OR (NEW.campaign = "Chat Lojista" AND NEW.first_name IS NOT NULL)
        OR (NEW.campaign LIKE "Chat APP" AND NEW.menu_sem_atraso IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.atraso_negociar IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.atraso_maior77_negociar IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.atraso_maior77_com_acordo IS NOT NULL)
        OR (NEW.campaign = "Chat APP" AND NEW.menu_cartoes_sem_telesaque IS NOT NULL)
        OR ((NEW.campaign = "Canais diretos" AND NEW.menu_desbloqueio IS NOT NULL))
        OR ((NEW.campaign LIKE "Telesaque%Seguro" AND NEW.menu_desbloqueio IS NOT NULL))
        OR ((NEW.campaign = "Chat Credz" AND (NEW.menu_desbloqueio IS NOT NULL OR NEW.escolha_cartao_cpf IS NOT NULL)))
        ) THEN
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET retencao = retencao + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND menu_sem_atraso = CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END;
    END IF;
    -- RETENCAO DECREMENTO
    IF(NEW.transferencia_humano LIKE "%" OR NEW.tranferencia_humano LIKE "%"
        OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "21:00:00"
            AND WEEKDAY(NEW.created_at) BETWEEN 0 AND 4 
            AND NEW.campaign = "Negociação"
            AND NEW.identification_number1 IS NOT NULL)
        OR (DATE_FORMAT(NEW.created_at, "%H:%i:%s") BETWEEN "09:00:00" AND "14:00:00"
                AND WEEKDAY(NEW.created_at) BETWEEN 5 AND 6
				AND NEW.campaign = "Negociação"
                AND NEW.identification_number1 IS NOT NULL)
        ) THEN
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET retencao = retencao - 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND menu_sem_atraso = CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END;
    END IF;
    -- TOTAL
    IF (NEW.menu_sem_atraso IS NOT NULL) THEN
        UPDATE smarkio_credz.transbordo_retencao_menu_sem_atraso_tg
        SET total = total + 1
        WHERE date = NEW.lead_creation_day 
        AND campaign = CASE WHEN NEW.campaign IS NULL OR NEW.campaign = '' THEN '-' ELSE NEW.campaign END
        AND menu_sem_atraso = CASE WHEN NEW.menu_sem_atraso IS NULL OR NEW.menu_sem_atraso = '' THEN '-' ELSE NEW.menu_sem_atraso END;
    END IF;
END
