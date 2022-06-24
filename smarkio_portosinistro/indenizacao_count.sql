-- TRIGGER INSERT --
USE smarkio_portosinistro;
DELIMITER |
CREATE TRIGGER tg_indenizacao_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.menu_perda_parcial IS NOT NULL OR NEW.sinistro_encerrado_com_indenizacao IS NOT NULL OR NEW.sinistro_sem_indenizacao IS NOT NULL OR NEW.nao_logado = 'Comunicar um sinistro' OR NEW.status_sinistro IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portosinistro.indenizacao_count 
        WHERE date = NEW.lead_creation_day 
        AND indenizacao = CASE WHEN (NEW.menu_perda_parcial IS NOT NULL) THEN 'Parcial'
            WHEN (NEW.sinistro_encerrado_com_indenizacao IS NOT NULL) THEN 'Integral'
            WHEN (NEW.sinistro_sem_indenizacao IS NOT NULL) THEN 'Integral'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Integral'
            WHEN (NEW.status_sinistro = 'Analise em atraso') THEN 'Integral'
            WHEN (NEW.status_sinistro = 'Analise liberada') THEN 'Integral'
            WHEN (NEW.status_sinistro = 'Pagamento Confirmado') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Sinistro encerrado com indeniza%') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Sinistro encerrado sem indeniza%') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
            WHEN (NEW.status_sinistro IS NOT NULL) THEN 'Integral'
            ELSE '-' END)=0))
          
    THEN INSERT INTO smarkio_portosinistro.indenizacao_count
    (date, indenizacao)
    VALUES (NEW.lead_creation_day, CASE WHEN (NEW.menu_perda_parcial IS NOT NULL) THEN 'Parcial'
        WHEN (NEW.sinistro_encerrado_com_indenizacao IS NOT NULL) THEN 'Integral'
        WHEN (NEW.sinistro_sem_indenizacao IS NOT NULL) THEN 'Integral'
        WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Integral'
        WHEN (NEW.status_sinistro = 'Analise em atraso') THEN 'Integral'
        WHEN (NEW.status_sinistro = 'Analise liberada') THEN 'Integral'
        WHEN (NEW.status_sinistro = 'Pagamento Confirmado') THEN 'Integral'
        WHEN (NEW.status_sinistro LIKE 'Sinistro encerrado com indeniza%') THEN 'Integral'
        WHEN (NEW.status_sinistro LIKE 'Sinistro encerrado sem indeniza%') THEN 'Integral'
        WHEN (NEW.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
        WHEN (NEW.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
        WHEN (NEW.status_sinistro IS NOT NULL) THEN 'Integral'
        ELSE '-' END);
    END IF;

    IF (NEW.menu_perda_parcial IS NOT NULL OR NEW.sinistro_encerrado_com_indenizacao IS NOT NULL OR NEW.sinistro_sem_indenizacao IS NOT NULL OR NEW.nao_logado = 'Comunicar um sinistro') THEN 
        UPDATE smarkio_portosinistro.indenizacao_count
        SET total = CASE WHEN (NEW.menu_perda_parcial IS NOT NULL) THEN total + 1
            WHEN (NEW.menu_perda_parcial = 'Valor da Franquia') THEN total + 1
            WHEN (NEW.menu_perda_parcial = 'Agendar vistoria') THEN total + 1
            WHEN (NEW.menu_perda_parcial = 'Outros assuntos') THEN total + 1
            WHEN (NEW.menu_perda_parcial = 'Voltar ao menu anterior') THEN total + 1
            WHEN (NEW.sinistro_encerrado_com_indenizacao IS NOT NULL) THEN total + 1
            WHEN (NEW.sinistro_sem_indenizacao IS NOT NULL) THEN total + 1
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN total + 1
            ELSE total + 0 END
        WHERE date = NEW.lead_creation_day 
        AND indenizacao = CASE WHEN (NEW.menu_perda_parcial IS NOT NULL) THEN 'Parcial'
            WHEN (NEW.sinistro_encerrado_com_indenizacao IS NOT NULL) THEN 'Integral'
            WHEN (NEW.sinistro_sem_indenizacao IS NOT NULL) THEN 'Integral'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Integral'
            WHEN (NEW.status_sinistro = 'Analise em atraso') THEN 'Integral'
            WHEN (NEW.status_sinistro = 'Analise liberada') THEN 'Integral'
            WHEN (NEW.status_sinistro = 'Pagamento Confirmado') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Sinistro encerrado com indeniza%') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Sinistro encerrado sem indeniza%') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
            WHEN (NEW.status_sinistro IS NOT NULL) THEN 'Integral'
            ELSE '-' END;
    END IF;	
END

-- TRIGGER UPDATE --
USE smarkio_portosinistro;
DELIMITER |
CREATE TRIGGER tg_indenizacao_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.menu_perda_parcial IS NOT NULL OR NEW.sinistro_encerrado_com_indenizacao IS NOT NULL OR NEW.sinistro_sem_indenizacao IS NOT NULL OR NEW.nao_logado = 'Comunicar um sinistro' OR NEW.status_sinistro IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portosinistro.indenizacao_count 
        WHERE date = NEW.lead_creation_day 
        AND indenizacao = CASE WHEN (NEW.menu_perda_parcial IS NOT NULL) THEN 'Parcial'
            WHEN (NEW.sinistro_encerrado_com_indenizacao IS NOT NULL) THEN 'Integral'
            WHEN (NEW.sinistro_sem_indenizacao IS NOT NULL) THEN 'Integral'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Integral'
            WHEN (NEW.status_sinistro = 'Analise em atraso') THEN 'Integral'
            WHEN (NEW.status_sinistro = 'Analise liberada') THEN 'Integral'
            WHEN (NEW.status_sinistro = 'Pagamento Confirmado') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Sinistro encerrado com indeniza%') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Sinistro encerrado sem indeniza%') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
            WHEN (NEW.status_sinistro IS NOT NULL) THEN 'Integral'
            ELSE '-' END)=0))
          
    THEN INSERT INTO smarkio_portosinistro.indenizacao_count
    (date, indenizacao)
    VALUES (NEW.lead_creation_day, CASE WHEN (NEW.menu_perda_parcial IS NOT NULL) THEN 'Parcial'
        WHEN (NEW.sinistro_encerrado_com_indenizacao IS NOT NULL) THEN 'Integral'
        WHEN (NEW.sinistro_sem_indenizacao IS NOT NULL) THEN 'Integral'
        WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Integral'
        WHEN (NEW.status_sinistro = 'Analise em atraso') THEN 'Integral'
        WHEN (NEW.status_sinistro = 'Analise liberada') THEN 'Integral'
        WHEN (NEW.status_sinistro = 'Pagamento Confirmado') THEN 'Integral'
        WHEN (NEW.status_sinistro LIKE 'Sinistro encerrado com indeniza%') THEN 'Integral'
        WHEN (NEW.status_sinistro LIKE 'Sinistro encerrado sem indeniza%') THEN 'Integral'
        WHEN (NEW.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
        WHEN (NEW.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
        WHEN (NEW.status_sinistro IS NOT NULL) THEN 'Integral'
        ELSE '-' END);
   END IF;

    IF (NEW.menu_perda_parcial IS NOT NULL OR NEW.sinistro_encerrado_com_indenizacao IS NOT NULL OR NEW.sinistro_sem_indenizacao IS NOT NULL OR NEW.nao_logado = 'Comunicar um sinistro') THEN 
        UPDATE smarkio_portosinistro.indenizacao_count
        SET total = CASE WHEN (NEW.menu_perda_parcial IS NOT NULL) THEN total + 1
            WHEN (NEW.menu_perda_parcial = 'Valor da Franquia') THEN total + 1
            WHEN (NEW.menu_perda_parcial = 'Agendar vistoria') THEN total + 1
            WHEN (NEW.menu_perda_parcial = 'Outros assuntos') THEN total + 1
            WHEN (NEW.menu_perda_parcial = 'Voltar ao menu anterior') THEN total + 1
            WHEN (NEW.sinistro_encerrado_com_indenizacao IS NOT NULL) THEN total + 1
            WHEN (NEW.sinistro_sem_indenizacao IS NOT NULL) THEN total + 1
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN total + 1
            ELSE total + 0 END
        WHERE date = NEW.lead_creation_day 
        AND indenizacao = CASE WHEN (NEW.menu_perda_parcial IS NOT NULL) THEN 'Parcial'
            WHEN (NEW.sinistro_encerrado_com_indenizacao IS NOT NULL) THEN 'Integral'
            WHEN (NEW.sinistro_sem_indenizacao IS NOT NULL) THEN 'Integral'
            WHEN (NEW.nao_logado = 'Comunicar um sinistro') THEN 'Integral'
            WHEN (NEW.status_sinistro = 'Analise em atraso') THEN 'Integral'
            WHEN (NEW.status_sinistro = 'Analise liberada') THEN 'Integral'
            WHEN (NEW.status_sinistro = 'Pagamento Confirmado') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Sinistro encerrado com indeniza%') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Sinistro encerrado sem indeniza%') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
            WHEN (NEW.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
            WHEN (NEW.status_sinistro IS NOT NULL) THEN 'Integral'
            ELSE '-' END;
    END IF;	

    IF (OLD.menu_perda_parcial IS NOT NULL OR OLD.sinistro_encerrado_com_indenizacao IS NOT NULL OR OLD.sinistro_sem_indenizacao IS NOT NULL OR OLD.nao_logado = 'Comunicar um sinistro') THEN 
        UPDATE smarkio_portosinistro.indenizacao_count
        SET total = CASE WHEN (OLD.menu_perda_parcial IS NOT NULL) THEN total - 1
            WHEN (OLD.menu_perda_parcial = 'Valor da Franquia') THEN total - 1
            WHEN (OLD.menu_perda_parcial = 'Agendar vistoria') THEN total - 1
            WHEN (OLD.menu_perda_parcial = 'Outros assuntos') THEN total - 1
            WHEN (OLD.menu_perda_parcial = 'Voltar ao menu anterior') THEN total - 1
            WHEN (OLD.sinistro_encerrado_com_indenizacao IS NOT NULL) THEN total - 1
            WHEN (OLD.sinistro_sem_indenizacao IS NOT NULL) THEN total - 1
            WHEN (OLD.nao_logado = 'Comunicar um sinistro') THEN total - 1
            ELSE total - 0 END
        WHERE date = OLD.lead_creation_day 
        AND indenizacao = CASE WHEN (OLD.menu_perda_parcial IS NOT NULL) THEN 'Parcial'
            WHEN (OLD.sinistro_encerrado_com_indenizacao IS NOT NULL) THEN 'Integral'
            WHEN (OLD.sinistro_sem_indenizacao IS NOT NULL) THEN 'Integral'
            WHEN (OLD.nao_logado = 'Comunicar um sinistro') THEN 'Integral'
            WHEN (OLD.status_sinistro = 'Analise em atraso') THEN 'Integral'
            WHEN (OLD.status_sinistro = 'Analise liberada') THEN 'Integral'
            WHEN (OLD.status_sinistro = 'Pagamento Confirmado') THEN 'Integral'
            WHEN (OLD.status_sinistro LIKE 'Sinistro encerrado com indeniza%') THEN 'Integral'
            WHEN (OLD.status_sinistro LIKE 'Sinistro encerrado sem indeniza%') THEN 'Integral'
            WHEN (OLD.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
            WHEN (OLD.status_sinistro LIKE 'Analise liberada%') THEN 'Integral'
            WHEN (OLD.status_sinistro IS NOT NULL) THEN 'Integral'
            ELSE '-' END;
    END IF;	
END