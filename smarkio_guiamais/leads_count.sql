 -- TABLE -- 
  CREATE TABLE `smarkio_guiamais`.`leads_count` (
  `idleads` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `interacao_nome` INT NULL DEFAULT 0,
  `transbordo` INT NULL DEFAULT 0,
  `cpf` INT NULL DEFAULT 0,
  `celular` INT NULL DEFAULT 0,
  `email` INT NULL DEFAULT 0,
  `celular_nc` INT NULL DEFAULT 0,
  `email_nc` INT NULL DEFAULT 0,
   PRIMARY KEY (`idleads`));

-- TRIGGER --
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_leads_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
        SELECT * FROM smarkio_guiamais.leads_count 
        WHERE date = NEW.lead_creation_day)=0)
    THEN INSERT INTO smarkio_guiamais.leads_count
    (date)
    VALUES (NEW.lead_creation_day);
    END IF;

	IF (NEW.first_name IS NOT NULL) 
    THEN UPDATE smarkio_guiamais.leads_count
	    SET interacao_nome = interacao_nome + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.falar_atendente IS NOT NULL)  
    THEN UPDATE smarkio_guiamais.leads_count
	    SET transbordo = transbordo + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.identification_number1 IS NOT NULL)  
	THEN UPDATE smarkio_guiamais.leads_count
	    SET cpf = cpf + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.phone IS NOT NULL) THEN 
    UPDATE smarkio_guiamais.leads_count
	    SET celular = CASE 
        WHEN (NEW.assinante = 'Sim') THEN celular + 1
        ELSE celular + 0 END
    WHERE date = NEW.lead_creation_day;

    UPDATE smarkio_guiamais.leads_count
	    SET celular_nc = CASE 
        WHEN (NEW.assinante = 'Não') THEN celular_nc + 1
        ELSE celular_nc + 0 END
    WHERE date = NEW.lead_creation_day;
    END IF;

    IF (NEW.email IS NOT NULL)  
	THEN UPDATE smarkio_guiamais.leads_count
	    SET email = CASE 
        WHEN (NEW.assinante = 'Sim') THEN email + 1
        ELSE email + 0 END
    WHERE date = NEW.lead_creation_day;

    UPDATE smarkio_guiamais.leads_count
	    SET email_nc = CASE 
        WHEN (NEW.assinante = 'Não') THEN email_nc + 1
        ELSE email_nc + 0 END
    WHERE date = NEW.lead_creation_day;
    END IF;	 
END 

-- TRIGGER UPDATE --
USE smarkio_guiamais;
DELIMITER |
CREATE TRIGGER tg_leads_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF (SELECT EXISTS (
        SELECT * FROM smarkio_guiamais.leads_count 
        WHERE date = NEW.lead_creation_day)=0)
    THEN INSERT INTO smarkio_guiamais.leads_count
    (date)
    VALUES (NEW.lead_creation_day);
    END IF;

	IF (NEW.first_name IS NOT NULL) 
    THEN UPDATE smarkio_guiamais.leads_count
	    SET interacao_nome = interacao_nome + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.falar_atendente IS NOT NULL)  
    THEN UPDATE smarkio_guiamais.leads_count
	    SET transbordo = transbordo + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.identification_number1 IS NOT NULL)  
	THEN UPDATE smarkio_guiamais.leads_count
	    SET cpf = cpf + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

     IF (NEW.phone IS NOT NULL) THEN 
    UPDATE smarkio_guiamais.leads_count
	    SET celular = CASE 
        WHEN (NEW.assinante = 'Sim') THEN celular + 1
        ELSE celular + 0 END
    WHERE date = NEW.lead_creation_day;

    UPDATE smarkio_guiamais.leads_count
	    SET celular_nc = CASE 
        WHEN (NEW.assinante = 'Não') THEN celular_nc + 1
        ELSE celular_nc + 0 END
    WHERE date = NEW.lead_creation_day;
    END IF;

    IF (NEW.email IS NOT NULL)  
	THEN UPDATE smarkio_guiamais.leads_count
	    SET email = CASE 
        WHEN (NEW.assinante = 'Sim') THEN email + 1
        ELSE email + 0 END
    WHERE date = NEW.lead_creation_day;

    UPDATE smarkio_guiamais.leads_count
	    SET email_nc = CASE 
        WHEN (NEW.assinante = 'Não') THEN email_nc + 1
        ELSE email_nc + 0 END
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (OLD.first_name IS NOT NULL)  
	THEN UPDATE smarkio_guiamais.leads_count
	    SET interacao_nome = interacao_nome - 1
    WHERE date = OLD.lead_creation_day;
    END IF;	

    IF (OLD.falar_atendente IS NOT NULL)  
	THEN UPDATE smarkio_guiamais.leads_count
	    SET transbordo = transbordo - 1
    WHERE date = OLD.lead_creation_day;
    END IF;	

    IF (OLD.identification_number1 IS NOT NULL)  
	THEN UPDATE smarkio_guiamais.leads_count
	    SET cpf = cpf - 1
    WHERE date = OLD.lead_creation_day;
    END IF;	

     IF (OLD.phone IS NOT NULL) THEN 
    UPDATE smarkio_guiamais.leads_count
	    SET celular = CASE 
        WHEN (OLD.assinante = 'Sim') THEN celular - 1
        ELSE celular - 0 END
    WHERE date = OLD.lead_creation_day;

    UPDATE smarkio_guiamais.leads_count
	    SET celular_nc = CASE 
        WHEN (OLD.assinante = 'Não') THEN celular_nc - 1
        ELSE celular_nc - 0 END
    WHERE date = OLD.lead_creation_day;
    END IF;

    IF (OLD.email IS NOT NULL)  
	THEN UPDATE smarkio_guiamais.leads_count
	    SET email = CASE 
        WHEN (NEW.assinante = 'Sim') THEN email - 1
        ELSE email - 0 END
    WHERE date = OLD.lead_creation_day;

    UPDATE smarkio_guiamais.leads_count
	    SET email_nc = CASE 
        WHEN (OLD.assinante = 'Não') THEN email_nc - 1
        ELSE email_nc - 0 END
    WHERE date = OLD.lead_creation_day;
    END IF;	
END

-- SELECT -- 
INSERT INTO smarkio_guiamais.leads_count (`date`, `interacao_nome`, `transbordo`, `cpf`, `celular`, `email`,`celular_nc`,`email_nc`)
SELECT c.date, c.interacao_nome, c.transbordo, c.cpf, c.celular, c.email, c.celular_nc, c.email_nc
FROM 
(
  SELECT 
	lead_creation_day AS date,
    SUM(CASE WHEN (first_name IS NOT NULL) THEN 1 ELSE 0 END) AS interacao_nome,
    SUM(CASE WHEN (falar_atendente IS NOT NULL) THEN 1 ELSE 0 END) AS transbordo,
    SUM(CASE WHEN (identification_number1 IS NOT NULL) THEN 1 ELSE 0 END) AS cpf,
    SUM(CASE WHEN ((phone IS NOT NULL) AND (assinante = 'Sim')) THEN 1 ELSE 0 END) AS celular,
    SUM(CASE WHEN ((email IS NOT NULL) AND (assinante = 'Sim')) THEN 1 ELSE 0 END) AS email,
    SUM(CASE WHEN ((phone IS NOT NULL) AND (assinante = 'Não')) THEN 1 ELSE 0 END) AS celular_nc,
    SUM(CASE WHEN ((email IS NOT NULL) AND (assinante = 'Não')) THEN 1 ELSE 0 END) AS email_nc
   	FROM smarkio_guiamais.leads 
    WHERE supplier = 'Guia Mais' AND campaign = 'Chat Guia Mais' AND lead_creation_day < '2022-06-20'
	GROUP BY date) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `interacao_nome` = c.interacao_nome,
        `transbordo` = c.transbordo,
        `cpf` = c.cpf,
        `celular` = c.celular,
        `email` = c.email,
        `celular_nc` = c.celular_nc,
        `email_nc` = c.email_nc;