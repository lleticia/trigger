 -- SELECT ORIGINAL --
CASE WHEN REGEXP_MATCH(confirma_bolsa_protegida, "Sim") THEN 1 ELSE 0 END 
CASE WHEN REGEXP_MATCH(confirma_cartao_protegido, "Quero proteger") THEN 1 ELSE 0 END 
CASE WHEN REGEXP_MATCH(confirma_fatura_protegida, "Sim") THEN 1 ELSE 0 END 
CASE WHEN REGEXP_MATCH(confirma_identidade_protegida, "S.*") THEN 1 ELSE 0 END 
CASE WHEN REGEXP_MATCH(confirma_seguro_residencial, "Sim") THEN 1 ELSE 0 END 

 -- TABLE -- 
  CREATE TABLE `smarkio_portomassificado`.`leads_count` (
  `idleads` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `validados` INT NULL DEFAULT 0,
  `desbloqueio` INT NULL DEFAULT 0,
  `bolsa` INT NULL DEFAULT 0,
  `cartao` INT NULL DEFAULT 0,
  `fatura` INT NULL DEFAULT 0,
  `identidade` INT NULL DEFAULT 0,
  `seguro` INT NULL DEFAULT 0,
   PRIMARY KEY (`idleads`));

-- TRIGGER --
USE smarkio_portomassificado;
DELIMITER |
CREATE TRIGGER tg_leads_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
        SELECT * FROM smarkio_portomassificado.leads_count 
        WHERE date = NEW.lead_creation_day)=0)
    THEN INSERT INTO smarkio_portomassificado.leads_count
    (date)
    VALUES (NEW.lead_creation_day);
    END IF;

	IF (NEW.iniciou_chat IS NOT NULL) 
    THEN UPDATE smarkio_portomassificado.leads_count
	    SET validados = validados + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.desbloqueio_cartoes IS NOT NULL)  
    THEN UPDATE smarkio_portomassificado.leads_count
	    SET desbloqueio = desbloqueio + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.confirma_bolsa_protegida = 'Sim')  
	THEN UPDATE smarkio_portomassificado.leads_count
	    SET bolsa = bolsa + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.confirma_cartao_protegido = 'Quero proteger') THEN 
    UPDATE smarkio_portomassificado.leads_count
	    SET cartao = cartao + 1
    WHERE date = NEW.lead_creation_day;
    END IF;

    IF (NEW.confirma_fatura_protegida = 'Sim')  
	THEN UPDATE smarkio_portomassificado.leads_count
	    SET fatura = fatura + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	 

    IF (NEW.confirma_identidade_protegida LIKE 'S%') THEN 
    UPDATE smarkio_portomassificado.leads_count
	    SET identidade = identidade + 1
    WHERE date = NEW.lead_creation_day;
    END IF;

    IF (NEW.confirma_seguro_residencial = 'Sim')  
	THEN UPDATE smarkio_portomassificado.leads_count
	    SET seguro = seguro + 1
    WHERE date = NEW.lead_creation_day;
    END IF;
END 

-- TRIGGER UPDATE --
USE smarkio_portomassificado;
DELIMITER |
CREATE TRIGGER tg_leads_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF (SELECT EXISTS (
        SELECT * FROM smarkio_portomassificado.leads_count 
        WHERE date = NEW.lead_creation_day)=0)
    THEN INSERT INTO smarkio_portomassificado.leads_count
    (date)
    VALUES (NEW.lead_creation_day);
    END IF;

	IF (NEW.iniciou_chat IS NOT NULL) 
    THEN UPDATE smarkio_portomassificado.leads_count
	    SET validados = validados + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.desbloqueio_cartoes IS NOT NULL)  
    THEN UPDATE smarkio_portomassificado.leads_count
	    SET desbloqueio = desbloqueio + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.confirma_bolsa_protegida = 'Sim')  
	THEN UPDATE smarkio_portomassificado.leads_count
	    SET bolsa = bolsa + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.confirma_cartao_protegido = 'Quero proteger') THEN 
    UPDATE smarkio_portomassificado.leads_count
	    SET cartao = cartao + 1
    WHERE date = NEW.lead_creation_day;
    END IF;

    IF (NEW.confirma_fatura_protegida = 'Sim')  
	THEN UPDATE smarkio_portomassificado.leads_count
	    SET fatura = fatura + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	 

    IF (NEW.confirma_identidade_protegida LIKE 'S%') THEN 
    UPDATE smarkio_portomassificado.leads_count
	    SET identidade = identidade + 1
    WHERE date = NEW.lead_creation_day;
    END IF;

    IF (NEW.confirma_seguro_residencial = 'Sim')  
	THEN UPDATE smarkio_portomassificado.leads_count
	    SET seguro = seguro + 1
    WHERE date = NEW.lead_creation_day;
    END IF;

    IF (OLD.iniciou_chat IS NOT NULL) 
    THEN UPDATE smarkio_portomassificado.leads_count
	    SET validados = validados - 1
    WHERE date = OLD.lead_creation_day;
    END IF;	

    IF (OLD.desbloqueio_cartoes IS NOT NULL)  
    THEN UPDATE smarkio_portomassificado.leads_count
	    SET desbloqueio = desbloqueio - 1
    WHERE date = OLD.lead_creation_day;
    END IF;	

    IF (OLD.confirma_bolsa_protegida = 'Sim')  
	THEN UPDATE smarkio_portomassificado.leads_count
	    SET bolsa = bolsa - 1
    WHERE date = OLD.lead_creation_day;
    END IF;	
    
    IF (OLD.confirma_cartao_protegido = 'Quero proteger') THEN 
    UPDATE smarkio_portomassificado.leads_count
	    SET cartao = cartao - 1
    WHERE date = OLD.lead_creation_day;
    END IF;

    IF (OLD.confirma_fatura_protegida = 'Sim')  
	THEN UPDATE smarkio_portomassificado.leads_count
	    SET fatura = fatura - 1
    WHERE date = OLD.lead_creation_day;
    END IF;	 

    IF (OLD.confirma_identidade_protegida LIKE 'S%') THEN 
    UPDATE smarkio_portomassificado.leads_count
	    SET identidade = identidade - 1
    WHERE date = OLD.lead_creation_day;
    END IF;

    IF (OLD.confirma_seguro_residencial = 'Sim')  
	THEN UPDATE smarkio_portomassificado.leads_count
	    SET seguro = seguro - 1
    WHERE date = OLD.lead_creation_day;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portomassificado.leads_count (`date`, `validados`, `desbloqueio`, `bolsa`, `cartao`, `fatura`,`identidade`,`seguro`)
SELECT c.date, c.validados, c.desbloqueio, c.bolsa, c.cartao, c.fatura, c.identidade, c.seguro
FROM 
(
  SELECT 
	lead_creation_day AS date,
    SUM(CASE WHEN (iniciou_chat IS NOT NULL) THEN 1 ELSE 0 END) AS validados,
    SUM(CASE WHEN (desbloqueio_cartoes IS NOT NULL) THEN 1 ELSE 0 END) AS desbloqueio,
    SUM(CASE WHEN (confirma_bolsa_protegida = 'Sim') THEN 1 ELSE 0 END) AS bolsa,
    SUM(CASE WHEN (confirma_cartao_protegido = 'Quero proteger') THEN 1 ELSE 0 END) AS cartao,
    SUM(CASE WHEN (confirma_fatura_protegida = 'Sim') THEN 1 ELSE 0 END) AS fatura,
    SUM(CASE WHEN (confirma_identidade_protegida LIKE 'S%') THEN 1 ELSE 0 END) AS identidade,
    SUM(CASE WHEN (confirma_seguro_residencial = 'Sim') THEN 1 ELSE 0 END) AS seguro
   	FROM smarkio_portomassificado.leads 
    WHERE lead_creation_day >= '2021-02-01' 
	GROUP BY date) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `validados` = c.validados,
        `desbloqueio` = c.desbloqueio,
        `bolsa` = c.bolsa,
        `cartao` = c.cartao,
        `fatura` = c.fatura,
        `identidade` = c.identidade,
        `seguro` = c.seguro;