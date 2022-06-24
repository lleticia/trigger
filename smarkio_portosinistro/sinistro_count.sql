-- TRIGGER INSERT --
USE smarkio_portosinistro;
DELIMITER |
CREATE TRIGGER tg_sinistro_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.susep IS NOT NULL OR NEW.cpf_cnpj IS NOT NULL OR NEW.sinistro IS NOT NULL OR NEW.placa_sinistro IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portosinistro.sinistro_count 
        WHERE date = NEW.lead_creation_day 
        AND sinistro = CASE WHEN (NEW.susep IS NOT NULL AND NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'Todos'
            WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN 'CPF/CNPJ e sinistro'
            WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'CPF/CNPJ e placa'
            WHEN (NEW.susep IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN 'Susep e sinistro'
            WHEN (NEW.susep IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'Susep e placa'
            ELSE '-' END)=0))
          
    THEN INSERT INTO smarkio_portosinistro.sinistro_count
    (date, sinistro)
    VALUES (NEW.lead_creation_day, CASE WHEN (NEW.susep IS NOT NULL AND NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'Todos'
        WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN 'CPF/CNPJ e sinistro'
        WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'CPF/CNPJ e placa'
        WHEN (NEW.susep IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN 'Susep e sinistro'
        WHEN (NEW.susep IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'Susep e placa'
        ELSE '-' END);
   END IF;

    IF (NEW.susep IS NOT NULL OR NEW.cpf_cnpj IS NOT NULL OR NEW.sinistro IS NOT NULL OR NEW.placa_sinistro IS NOT NULL) THEN 
        UPDATE smarkio_portosinistro.sinistro_count
        SET total = CASE WHEN (NEW.susep IS NOT NULL AND NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN total + 1
            WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN total + 1
            WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN total + 1
            WHEN (NEW.susep IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN total + 1
            WHEN (NEW.susep IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN total + 1
            ELSE total + 0 END
        WHERE date = NEW.lead_creation_day 
        AND sinistro = CASE WHEN (NEW.susep IS NOT NULL AND NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'Todos'
            WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN 'CPF/CNPJ e sinistro'
            WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'CPF/CNPJ e placa'
            WHEN (NEW.susep IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN 'Susep e sinistro'
            WHEN (NEW.susep IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'Susep e placa'
            ELSE '-' END;
    END IF;	
END

-- TRIGGER UPDATE --
USE smarkio_portosinistro;
DELIMITER |
CREATE TRIGGER tg_sinistro_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.susep IS NOT NULL OR NEW.cpf_cnpj IS NOT NULL OR NEW.sinistro IS NOT NULL OR NEW.placa_sinistro IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portosinistro.sinistro_count 
        WHERE date = NEW.lead_creation_day 
        AND sinistro = CASE WHEN (NEW.susep IS NOT NULL AND NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'Todos'
            WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN 'CPF/CNPJ e sinistro'
            WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'CPF/CNPJ e placa'
            WHEN (NEW.susep IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN 'Susep e sinistro'
            WHEN (NEW.susep IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'Susep e placa'
            ELSE '-' END)=0))
          
    THEN INSERT INTO smarkio_portosinistro.sinistro_count
    (date, sinistro)
    VALUES (NEW.lead_creation_day, CASE WHEN (NEW.susep IS NOT NULL AND NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'Todos'
        WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN 'CPF/CNPJ e sinistro'
        WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'CPF/CNPJ e placa'
        WHEN (NEW.susep IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN 'Susep e sinistro'
        WHEN (NEW.susep IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'Susep e placa'
        ELSE '-' END);
   END IF;

    IF (NEW.susep IS NOT NULL OR NEW.cpf_cnpj IS NOT NULL OR NEW.sinistro IS NOT NULL OR NEW.placa_sinistro IS NOT NULL) THEN 
        UPDATE smarkio_portosinistro.sinistro_count
        SET total = CASE WHEN (NEW.susep IS NOT NULL AND NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN total + 1
            WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN total + 1
            WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN total + 1
            WHEN (NEW.susep IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN total + 1
            WHEN (NEW.susep IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN total + 1
            ELSE total + 0 END
        WHERE date = NEW.lead_creation_day 
        AND sinistro = CASE WHEN (NEW.susep IS NOT NULL AND NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'Todos'
            WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN 'CPF/CNPJ e sinistro'
            WHEN (NEW.cpf_cnpj IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'CPF/CNPJ e placa'
            WHEN (NEW.susep IS NOT NULL AND NEW.sinistro IS NOT NULL) THEN 'Susep e sinistro'
            WHEN (NEW.susep IS NOT NULL AND NEW.placa_sinistro IS NOT NULL) THEN 'Susep e placa'
            ELSE '-' END;
    END IF;	

    IF (OLD.susep IS NOT NULL OR OLD.cpf_cnpj IS NOT NULL OR OLD.sinistro IS NOT NULL OR OLD.placa_sinistro IS NOT NULL) THEN 
        UPDATE smarkio_portosinistro.sinistro_count
        SET total = CASE WHEN (OLD.susep IS NOT NULL AND OLD.cpf_cnpj IS NOT NULL AND OLD.sinistro IS NOT NULL AND OLD.placa_sinistro IS NOT NULL) THEN total - 1
            WHEN (OLD.cpf_cnpj IS NOT NULL AND OLD.sinistro IS NOT NULL) THEN total - 1
            WHEN (OLD.cpf_cnpj IS NOT NULL AND OLD.placa_sinistro IS NOT NULL) THEN total - 1
            WHEN (OLD.susep IS NOT NULL AND OLD.sinistro IS NOT NULL) THEN total - 1
            WHEN (OLD.susep IS NOT NULL AND OLD.placa_sinistro IS NOT NULL) THEN total - 1
            ELSE total - 0 END
        WHERE date = OLD.lead_creation_day 
        AND sinistro = CASE WHEN (OLD.susep IS NOT NULL AND OLD.cpf_cnpj IS NOT NULL AND OLD.sinistro IS NOT NULL AND OLD.placa_sinistro IS NOT NULL) THEN 'Todos'
            WHEN (OLD.cpf_cnpj IS NOT NULL AND OLD.sinistro IS NOT NULL) THEN 'CPF/CNPJ e sinistro'
            WHEN (OLD.cpf_cnpj IS NOT NULL AND OLD.placa_sinistro IS NOT NULL) THEN 'CPF/CNPJ e placa'
            WHEN (OLD.susep IS NOT NULL AND OLD.sinistro IS NOT NULL) THEN 'Susep e sinistro'
            WHEN (OLD.susep IS NOT NULL AND OLD.placa_sinistro IS NOT NULL) THEN 'Susep e placa'
            ELSE '-' END;
    END IF;	
END