-- SELECT ORIGINAL --
SMS/EMAIL -> case when enviar_linha is not null then "Email"
when linha_digital_sms = "Sim" then "SMS"
when confirma_email is not null then "Email"
when confirma_telefone is not null then "SMS"
else "vazio" end

CONFIRMA -> case when confirma_email = "Sim" then "Email confirmado"
when confirma_telefone = "Sim" then "Telefone confirmado"
else "" end

ASSUNTO -> case when REGEXP_MATCH(contrato_liquidado, "Consultar Hist.* de Pagamento") then "Consultar Historico de Pagamento"
when REGEXP_MATCH(consulta_aberto, "Antecipar Parcela.*") then "Antecipar Parcela"
when REGEXP_MATCH(consulta_aberto, "Consultar Hist.*") then "Consultar Historico de Pagamento"
when REGEXP_MATCH(consulta_aberto, "Consultar Saldo Devedor") then "Consultar Saldo Devedor"
when REGEXP_MATCH(consulta_aberto, "Consultar Segunda Vi.*") then "Consultar Segunda Via de Parcela"
when REGEXP_MATCH(consulta_aberto, "Encerrar") then "Encerrar"
when REGEXP_MATCH(consulta_aberto, "Quitar Saldo Devedor") then "Quitar Saldo Devedor"
when REGEXP_MATCH(historico_pagamento, "Sim") then "Consultar Historico de Pagamento"
when REGEXP_MATCH(historico_pagamento, "N.*") then "Encerrar"
else "Atraso maior que 5 dias" end

-- TABLE -- 
  CREATE TABLE `smarkio_posvendafinanceiraportoseguro`.`email_count` (
  `idemail` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL, 
  `assunto` VARCHAR(255) NOT NULL,
  `tipo` VARCHAR(255) NOT NULL,
  `confirma` VARCHAR(255) NOT NULL,
  `total` INT(11) NULL DEFAULT 0,
  PRIMARY KEY (`idemail`));

-- TRIGGER --
USE smarkio_posvendafinanceiraportoseguro;
DELIMITER |
CREATE TRIGGER tg_email_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF (((NEW.enviar_linha IS NOT NULL) OR (NEW.linha_digital_sms = 'Sim') OR (NEW.confirma_email IS NOT NULL) OR (NEW.confirma_telefone IS NOT NULL))  
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_posvendafinanceiraportoseguro.email_count 
        WHERE date = NEW.lead_creation_day
        AND tipo = CASE WHEN (NEW.enviar_linha IS NOT NULL) THEN 'E-mail'
            WHEN (NEW.linha_digital_sms = 'Sim') THEN 'SMS'
            WHEN (NEW.confirma_email IS NOT NULL) THEN 'E-mail'
            WHEN (NEW.confirma_telefone IS NOT NULL) THEN 'SMS' ELSE '-' END
        AND confirma = CASE
            WHEN (NEW.confirma_email = 'Sim') THEN 'E-mail confirmado'
            WHEN (NEW.confirma_telefone = 'Sim') THEN 'Telefone confirmado'
            ELSE '-' END
        AND assunto = CASE
            WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
            ELSE 'Atraso maior que 5 dias'
            END)=0))
            
      THEN INSERT INTO smarkio_posvendafinanceiraportoseguro.email_count
      (date, tipo, confirma, assunto)
      VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.enviar_linha IS NOT NULL) THEN 'E-mail'
                WHEN (NEW.linha_digital_sms = 'Sim') THEN 'SMS'
                WHEN (NEW.confirma_email IS NOT NULL) THEN 'E-mail'
                WHEN (NEW.confirma_telefone IS NOT NULL) THEN 'SMS' ELSE '-' END,
            CASE WHEN (NEW.confirma_email = 'Sim') THEN 'E-mail confirmado'
                WHEN (NEW.confirma_telefone = 'Sim') THEN 'Telefone confirmado'
                ELSE '-' END,
            CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
                WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
                WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
                WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
                WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
                WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
                WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
                WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
                WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
                ELSE 'Atraso maior que 5 dias'
                END);
    END IF;

    IF ((NEW.enviar_linha IS NOT NULL) OR (NEW.linha_digital_sms = 'Sim') OR (NEW.confirma_email IS NOT NULL) OR (NEW.confirma_telefone IS NOT NULL)) THEN 
        UPDATE smarkio_posvendafinanceiraportoseguro.email_count
        SET total = CASE WHEN (NEW.enviar_linha IS NOT NULL) THEN total + 1
                WHEN (NEW.linha_digital_sms = 'Sim') THEN total + 1
                WHEN (NEW.confirma_email IS NOT NULL) THEN total + 1
                WHEN (NEW.confirma_telefone IS NOT NULL) THEN total + 1 
            ELSE total + 0 END
        WHERE date = NEW.lead_creation_day
            AND tipo = CASE WHEN (NEW.enviar_linha IS NOT NULL) THEN 'E-mail'
                WHEN (NEW.linha_digital_sms = 'Sim') THEN 'SMS'
                WHEN (NEW.confirma_email IS NOT NULL) THEN 'E-mail'
                WHEN (NEW.confirma_telefone IS NOT NULL) THEN 'SMS' ELSE '-' END
            AND confirma = CASE
                WHEN (NEW.confirma_email = 'Sim') THEN 'E-mail confirmado'
                WHEN (NEW.confirma_telefone = 'Sim') THEN 'Telefone confirmado'
                ELSE '-' END
            AND assunto = CASE
                WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
                WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
                WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
                WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
                WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
                WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
                WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
                WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
                WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
                ELSE 'Atraso maior que 5 dias' END;
    END IF;	
END;

-- TRIGGER UPDATE--
USE smarkio_posvendafinanceiraportoseguro;
DELIMITER |
CREATE TRIGGER tg_email_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF (((NEW.enviar_linha IS NOT NULL) OR (NEW.linha_digital_sms = 'Sim') OR (NEW.confirma_email IS NOT NULL) OR (NEW.confirma_telefone IS NOT NULL))  
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_posvendafinanceiraportoseguro.email_count 
        WHERE date = NEW.lead_creation_day
        AND tipo = CASE WHEN (NEW.enviar_linha IS NOT NULL) THEN 'E-mail'
            WHEN (NEW.linha_digital_sms = 'Sim') THEN 'SMS'
            WHEN (NEW.confirma_email IS NOT NULL) THEN 'E-mail'
            WHEN (NEW.confirma_telefone IS NOT NULL) THEN 'SMS' ELSE '-' END
        AND confirma = CASE
            WHEN (NEW.confirma_email = 'Sim') THEN 'E-mail confirmado'
            WHEN (NEW.confirma_telefone = 'Sim') THEN 'Telefone confirmado'
            ELSE '-' END
        AND assunto = CASE
            WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
            ELSE 'Atraso maior que 5 dias'
            END)=0))
            
    THEN INSERT INTO smarkio_posvendafinanceiraportoseguro.email_count
    (date, tipo, confirma, assunto)
    VALUES (NEW.lead_creation_day,
    CASE WHEN (NEW.enviar_linha IS NOT NULL) THEN 'E-mail'
            WHEN (NEW.linha_digital_sms = 'Sim') THEN 'SMS'
            WHEN (NEW.confirma_email IS NOT NULL) THEN 'E-mail'
            WHEN (NEW.confirma_telefone IS NOT NULL) THEN 'SMS' ELSE '-' END,
        CASE WHEN (NEW.confirma_email = 'Sim') THEN 'E-mail confirmado'
            WHEN (NEW.confirma_telefone = 'Sim') THEN 'Telefone confirmado'
            ELSE '-' END,
        CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
            ELSE 'Atraso maior que 5 dias'
            END);
    END IF;

    IF ((NEW.enviar_linha IS NOT NULL) OR (NEW.linha_digital_sms = 'Sim') OR (NEW.confirma_email IS NOT NULL) OR (NEW.confirma_telefone IS NOT NULL)) THEN 
        UPDATE smarkio_posvendafinanceiraportoseguro.email_count
        SET total = CASE WHEN (NEW.enviar_linha IS NOT NULL) THEN total + 1
                WHEN (NEW.linha_digital_sms = 'Sim') THEN total + 1
                WHEN (NEW.confirma_email IS NOT NULL) THEN total + 1
                WHEN (NEW.confirma_telefone IS NOT NULL) THEN total + 1 
            ELSE total + 0 END
        WHERE date = NEW.lead_creation_day
            AND tipo = CASE WHEN (NEW.enviar_linha IS NOT NULL) THEN 'E-mail'
                WHEN (NEW.linha_digital_sms = 'Sim') THEN 'SMS'
                WHEN (NEW.confirma_email IS NOT NULL) THEN 'E-mail'
                WHEN (NEW.confirma_telefone IS NOT NULL) THEN 'SMS' ELSE '-' END
            AND confirma = CASE
                WHEN (NEW.confirma_email = 'Sim') THEN 'E-mail confirmado'
                WHEN (NEW.confirma_telefone = 'Sim') THEN 'Telefone confirmado'
                ELSE '-' END
            AND assunto = CASE
                WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
                WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
                WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
                WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
                WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
                WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
                WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
                WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
                WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
                ELSE 'Atraso maior que 5 dias' END;
    END IF;	

    IF ((OLD.enviar_linha IS NOT NULL) OR (OLD.linha_digital_sms = 'Sim') OR (OLD.confirma_email IS NOT NULL) OR (OLD.confirma_telefone IS NOT NULL)) THEN 
        UPDATE smarkio_posvendafinanceiraportoseguro.email_count
        SET total = CASE WHEN (OLD.enviar_linha IS NOT NULL) THEN total - 1
                WHEN (OLD.linha_digital_sms = 'Sim') THEN total - 1
                WHEN (OLD.confirma_email IS NOT NULL) THEN total - 1
                WHEN (OLD.confirma_telefone IS NOT NULL) THEN total - 1 
            ELSE total - 0 END
        WHERE date = OLD.lead_creation_day
            AND tipo = CASE WHEN (OLD.enviar_linha IS NOT NULL) THEN 'E-mail'
                WHEN (OLD.linha_digital_sms = 'Sim') THEN 'SMS'
                WHEN (OLD.confirma_email IS NOT NULL) THEN 'E-mail'
                WHEN (OLD.confirma_telefone IS NOT NULL) THEN 'SMS' ELSE '-' END
            AND confirma = CASE
                WHEN (OLD.confirma_email = 'Sim') THEN 'E-mail confirmado'
                WHEN (OLD.confirma_telefone = 'Sim') THEN 'Telefone confirmado'
                ELSE '-' END
            AND assunto = CASE
                WHEN (OLD.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
                WHEN (OLD.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
                WHEN (OLD.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
                WHEN (OLD.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
                WHEN (OLD.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
                WHEN (OLD.consulta_aberto = 'Encerrar') THEN 'Encerrar'
                WHEN (OLD.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
                WHEN (OLD.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
                WHEN (OLD.historico_pagamento LIKE 'N%') THEN 'Encerrar'
                ELSE 'Atraso maior que 5 dias' END;
    END IF;	
END;

-- SELECT -- 
INSERT INTO smarkio_posvendafinanceiraportoseguro.email_count (`date`, `tipo`, `assunto`, `confirma`, `total`)
SELECT c.date, c.tipo, c.assunto, c.confirma, c.total
FROM 
(
SELECT 
	lead_creation_day AS date,
    (CASE WHEN (enviar_linha IS NOT NULL) THEN 'E-mail'
        WHEN (linha_digital_sms = 'Sim') THEN 'SMS'
        WHEN (confirma_email IS NOT NULL) THEN 'E-mail'
        WHEN (confirma_telefone IS NOT NULL) THEN 'SMS' ELSE '-' END) AS tipo,
    (CASE WHEN (confirma_email = 'Sim') THEN 'E-mail confirmado'
        WHEN (confirma_telefone = 'Sim') THEN 'Telefone confirmado'
        ELSE '-' END) AS confirma,
    (CASE WHEN (contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
        WHEN (consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
        WHEN (consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
        WHEN (consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
        WHEN (consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
        WHEN (consulta_aberto = 'Encerrar') THEN 'Encerrar'
        WHEN (consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
        WHEN (historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
        WHEN (historico_pagamento LIKE 'N%') THEN 'Encerrar'
        ELSE 'Atraso maior que 5 dias'
        END) AS assunto,
    SUM(CASE WHEN (enviar_linha IS NOT NULL) THEN 1
        WHEN (linha_digital_sms = 'Sim') THEN 1
        WHEN (confirma_email IS NOT NULL) THEN 1
        WHEN (confirma_telefone IS NOT NULL) THEN 1 ELSE 0 END) AS total      
	FROM smarkio_posvendafinanceiraportoseguro.leads 
    WHERE lead_creation_day between '2018-10-29' and '2018-12-31' 
    AND ((enviar_linha IS NOT NULL) OR (linha_digital_sms = 'Sim') OR (confirma_email IS NOT NULL) OR (confirma_telefone IS NOT NULL))
	GROUP BY date,tipo, confirma, assunto) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `tipo` = c.tipo,
        `confirma` = c.confirma,
        `assunto` = c.assunto,
        `total` = c.total;