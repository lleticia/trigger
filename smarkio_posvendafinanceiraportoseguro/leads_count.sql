 -- SELECT ORIGINAL --
CASE WHEN REGEXP_MATCH(confirma_bolsa_protegida, "Sim") THEN 1 ELSE 0 END 
CASE WHEN REGEXP_MATCH(confirma_cartao_protegido, "Quero proteger") THEN 1 ELSE 0 END 
CASE WHEN REGEXP_MATCH(confirma_fatura_protegida, "Sim") THEN 1 ELSE 0 END 
CASE WHEN REGEXP_MATCH(confirma_identidade_protegida, "S.*") THEN 1 ELSE 0 END 
CASE WHEN REGEXP_MATCH(confirma_seguro_residencial, "Sim") THEN 1 ELSE 0 END 

 -- TABLE -- 
  CREATE TABLE `smarkio_posvendafinanceiraportoseguro`.`leads_count` (
  `idleads` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `validados` INT NULL DEFAULT 0,
  `cliente` INT NULL DEFAULT 0,
  `cpf` INT NULL DEFAULT 0,
  `assuntos` INT NULL DEFAULT 0,
   PRIMARY KEY (`idleads`));

-- TRIGGER --
USE smarkio_posvendafinanceiraportoseguro;
DELIMITER |
CREATE TRIGGER tg_leads_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
        SELECT * FROM smarkio_posvendafinanceiraportoseguro.leads_count 
        WHERE date = NEW.lead_creation_day)=0)
    THEN INSERT INTO smarkio_posvendafinanceiraportoseguro.leads_count
    (date)
    VALUES (NEW.lead_creation_day);
    END IF;

	IF (NEW.status_validacao IS NOT NULL) 
    THEN UPDATE smarkio_posvendafinanceiraportoseguro.leads_count
	    SET validados = validados + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.identification_number1 IS NOT NULL)  
    THEN UPDATE smarkio_posvendafinanceiraportoseguro.leads_count
	    SET cpf = cpf + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.cliente = 'Sim')  
	THEN UPDATE smarkio_posvendafinanceiraportoseguro.leads_count
	    SET cliente = cliente + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF ((NEW.historico_pagamento IS NOT NULL) OR (NEW.contrato_liquidado IS NOT NULL) 
        OR (NEW.consulta_aberto IS NOT NULL)) THEN
    UPDATE smarkio_posvendafinanceiraportoseguro.leads_count
	    SET assuntos = CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN assuntos + 1
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN assuntos + 1
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN assuntos + 1
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN assuntos + 1
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN assuntos + 1
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN assuntos + 1
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN assuntos + 1
            WHEN (NEW.historico_pagamento = 'Sim') THEN assuntos + 1
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN assuntos + 1
            ELSE assuntos + 0 END
    WHERE date = NEW.lead_creation_day;
    END IF;
END 

-- TRIGGER UPDATE --
USE smarkio_posvendafinanceiraportoseguro;
DELIMITER |
CREATE TRIGGER tg_leads_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF (SELECT EXISTS (
        SELECT * FROM smarkio_posvendafinanceiraportoseguro.leads_count 
        WHERE date = NEW.lead_creation_day)=0)
    THEN INSERT INTO smarkio_posvendafinanceiraportoseguro.leads_count
    (date)
    VALUES (NEW.lead_creation_day);
    END IF;

	IF (NEW.status_validacao IS NOT NULL) 
    THEN UPDATE smarkio_posvendafinanceiraportoseguro.leads_count
	    SET validados = validados + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.identification_number1 IS NOT NULL)  
    THEN UPDATE smarkio_posvendafinanceiraportoseguro.leads_count
	    SET cpf = cpf + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF (NEW.cliente = 'Sim')  
	THEN UPDATE smarkio_posvendafinanceiraportoseguro.leads_count
	    SET cliente = cliente + 1
    WHERE date = NEW.lead_creation_day;
    END IF;	

    IF ((NEW.historico_pagamento IS NOT NULL) OR (NEW.contrato_liquidado IS NOT NULL) 
        OR (NEW.consulta_aberto IS NOT NULL)) THEN
    UPDATE smarkio_posvendafinanceiraportoseguro.leads_count
	    SET assuntos = CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN assuntos + 1
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN assuntos + 1
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN assuntos + 1
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN assuntos + 1
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN assuntos + 1
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN assuntos + 1
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN assuntos + 1
            WHEN (NEW.historico_pagamento = 'Sim') THEN assuntos + 1
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN assuntos + 1
            ELSE assuntos + 0 END
    WHERE date = NEW.lead_creation_day;
    END IF;

    IF (OLD.status_validacao IS NOT NULL) 
    THEN UPDATE smarkio_posvendafinanceiraportoseguro.leads_count
	    SET validados = validados - 1
    WHERE date = OLD.lead_creation_day;
    END IF;	

    IF (OLD.identification_number1 IS NOT NULL)  
    THEN UPDATE smarkio_posvendafinanceiraportoseguro.leads_count
	    SET cpf = cpf - 1
    WHERE date = OLD.lead_creation_day;
    END IF;	

    IF (OLD.cliente = 'Sim')  
	THEN UPDATE smarkio_posvendafinanceiraportoseguro.leads_count
	    SET cliente = cliente - 1
    WHERE date = OLD.lead_creation_day;
    END IF;	

    IF ((OLD.historico_pagamento IS NOT NULL) OR (OLD.contrato_liquidado IS NOT NULL) 
        OR (OLD.consulta_aberto IS NOT NULL)) THEN
    UPDATE smarkio_posvendafinanceiraportoseguro.leads_count
	    SET assuntos = CASE WHEN (OLD.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN assuntos - 1
            WHEN (OLD.consulta_aberto LIKE 'Antecipar Parcela%') THEN assuntos - 1
            WHEN (OLD.consulta_aberto LIKE 'Consultar Hist%') THEN assuntos - 1
            WHEN (OLD.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN assuntos - 1
            WHEN (OLD.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN assuntos - 1
            WHEN (OLD.consulta_aberto = 'Encerrar') THEN assuntos - 1
            WHEN (OLD.consulta_aberto = 'Quitar Saldo Devedor') THEN assuntos - 1
            WHEN (OLD.historico_pagamento = 'Sim') THEN assuntos - 1
            WHEN (OLD.historico_pagamento LIKE 'N%') THEN assuntos - 1
            ELSE assuntos - 0 END
    WHERE date = OLD.lead_creation_day;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_posvendafinanceiraportoseguro.leads_count (`date`, `validados`, `cliente`, `cpf`, `assuntos`)
SELECT c.date, c.validados, c.cliente, c.cpf, c.assuntos
FROM 
(
  SELECT 
	lead_creation_day AS date,
    SUM(CASE WHEN (status_validacao IS NOT NULL) THEN 1 ELSE 0 END) AS validados,
    SUM(CASE WHEN (cliente = 'Sim') THEN 1 ELSE 0 END) AS cliente,
    SUM(CASE WHEN (identification_number1 IS NOT NULL) THEN 1 ELSE 0 END) AS cpf,
    SUM(CASE WHEN (contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 1
        WHEN (consulta_aberto LIKE 'Antecipar Parcela%') THEN 1
        WHEN (consulta_aberto LIKE 'Consultar Hist%') THEN 1
        WHEN (consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 1
        WHEN (consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 1
        WHEN (consulta_aberto = 'Encerrar') THEN 1
        WHEN (consulta_aberto = 'Quitar Saldo Devedor') THEN 1
        WHEN (historico_pagamento = 'Sim') THEN 1
        WHEN (historico_pagamento LIKE 'N%') THEN 1
        ELSE 0 END) AS assuntos
   	FROM smarkio_posvendafinanceiraportoseguro.leads 
    WHERE lead_creation_day between '2018-10-29' and '2018-12-31' 
	GROUP BY date) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `validados` = c.validados,
        `cliente` = c.cliente,
        `cpf` = c.cpf,
        `assuntos` = c.assuntos;