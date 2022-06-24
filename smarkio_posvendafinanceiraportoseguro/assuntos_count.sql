-- SELECT ORIGINAL --
satisfacao -> REPLACE(pesquisa_satisfacao,"00", "")

status -> case
when REGEXP_MATCH(historico_pagamento, "Sim") then "Atraso menor que 6 dias"
when REGEXP_MATCH(historico_pagamento, "N.*") then "Atraso menor que 6 dias"
when REGEXP_MATCH(contrato_liquidado, ".*") then "Liquidado"
when REGEXP_MATCH(consulta_aberto, ".*") then "Aberto"
when REGEXP_MATCH(status_contrato, "atraso_maior5dias") then "Atraso maior que 5 dias"
else "Outros" end

assunto -> case
when REGEXP_MATCH(contrato_liquidado, "Consultar Hist.* de Pagamento") then "Consultar Historico de Pagamento"
when REGEXP_MATCH(consulta_aberto, "Antecipar Parcela.*") then "Antecipar Parcela"
when REGEXP_MATCH(consulta_aberto, "Consultar Hist.*") then "Consultar Historico de Pagamento"
when REGEXP_MATCH(consulta_aberto, "Consultar Saldo Devedor") then "Consultar Saldo Devedor"
when REGEXP_MATCH(consulta_aberto, "Consultar Segunda Vi.*") then "Consultar Segunda Via de Parcela"
when REGEXP_MATCH(consulta_aberto, "Encerrar") then "Encerrar"
when REGEXP_MATCH(consulta_aberto, "Quitar Saldo Devedor") then "Quitar Saldo Devedor"
when REGEXP_MATCH(historico_pagamento, "Sim") then "Consultar Historico de Pagamento"
when REGEXP_MATCH(historico_pagamento, "N.*") then "Encerrar"
else "Atraso maior que 5 dias" end

top_box ->case when REGEXP_MATCH(pesquisa_satisfacao, "(4|5)") then 1 else 0 end SUM(Top box)/COUNT(pesquisa_satisfacao)

bottom box -> case when REGEXP_MATCH(pesquisa_satisfacao, "1|2") then 1 else 0 end SUM(Bottom box)/COUNT(pesquisa_satisfacao)

-- TABLE -- 
  CREATE TABLE `smarkio_posvendafinanceiraportoseguro`.`assuntos_count` (
  `idassuntos` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL, 
  `assunto` VARCHAR(255) NOT NULL,
  `status` VARCHAR(255) NOT NULL,
  `total_assunto` INT(11) NULL DEFAULT 0,
  `total_status` INT(11) NULL DEFAULT 0,
  `satisfacao` INT(11) NULL DEFAULT 0,
  `total_satisfacao` INT(11) NULL DEFAULT 0,
  `top_two` INT(11) NULL DEFAULT 0,
  `bottom_box` INT(11) NULL DEFAULT 0,
  PRIMARY KEY (`idassuntos`));

-- TRIGGER --
USE smarkio_posvendafinanceiraportoseguro;
DELIMITER |
CREATE TRIGGER tg_assuntos_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF (((NEW.historico_pagamento IS NOT NULL) OR (NEW.contrato_liquidado IS NOT NULL) 
        OR (NEW.consulta_aberto IS NOT NULL) OR (NEW.status_contrato IS NOT NULL))
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_posvendafinanceiraportoseguro.assuntos_count 
        WHERE date = NEW.lead_creation_day
        AND status = CASE WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
        AND assunto = CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
            ELSE 'Atraso maior que 5 dias' END)=0))
            
      THEN INSERT INTO smarkio_posvendafinanceiraportoseguro.assuntos_count
      (date, status, assunto)
      VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END,
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

    IF ((NEW.historico_pagamento IS NOT NULL) OR (NEW.contrato_liquidado IS NOT NULL) 
        OR (NEW.consulta_aberto IS NOT NULL) OR (NEW.status_contrato IS NOT NULL)) THEN 
        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET total_status = CASE
            WHEN (NEW.historico_pagamento = 'Sim') THEN total_status + 1
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN total_status + 1
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN total_status + 1
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN total_status + 1
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN total_status + 1
            ELSE total_status + 0 END
        WHERE date = NEW.lead_creation_day
        AND status = CASE
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
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
            END;
        
        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET total_assunto = CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN total_assunto + 1
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN total_assunto + 1
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN total_assunto + 1
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN total_assunto + 1
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN total_assunto + 1
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN total_assunto + 1
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN total_assunto + 1
            WHEN (NEW.historico_pagamento = 'Sim') THEN total_assunto + 1
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN total_assunto + 1
            ELSE total_assunto + 0 END
        WHERE date = NEW.lead_creation_day
        AND status = CASE WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
        AND assunto = CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
            ELSE 'Atraso maior que 5 dias'
            END;
    END IF;	

    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN 
       UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao = '4') THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao = '3') THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao = '2') THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao = '1') THEN satisfacao + 1
            ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
        AND status = CASE WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
        AND assunto = CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
            ELSE 'Atraso maior que 5 dias' END;

        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET total_satisfacao = total_satisfacao + 1
        WHERE date = NEW.lead_creation_day
        AND status = CASE WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
        AND assunto = CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
            ELSE 'Atraso maior que 5 dias' END;

        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET top_two = CASE WHEN (NEW.pesquisa_satisfacao IN ('5','4')) THEN top_two + 1
            ELSE top_two + 0 END
        WHERE date = NEW.lead_creation_day
        AND status = CASE
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
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
            END;
        
        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET bottom_box = CASE WHEN (NEW.pesquisa_satisfacao IN ('1','2')) THEN bottom_box + 1
            ELSE bottom_box + 0 END
        WHERE date = NEW.lead_creation_day
        AND status = CASE
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
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
            END;
    END IF;	
END;

-- TRIGGER UPDATE--
USE smarkio_posvendafinanceiraportoseguro;
DELIMITER |
CREATE TRIGGER tg_assunto_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF (((NEW.historico_pagamento IS NOT NULL) OR (NEW.contrato_liquidado IS NOT NULL) 
        OR (NEW.consulta_aberto IS NOT NULL) OR (NEW.status_contrato IS NOT NULL))
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_posvendafinanceiraportoseguro.assuntos_count 
        WHERE date = NEW.lead_creation_day
        AND status = CASE WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
        AND assunto = CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
            ELSE 'Atraso maior que 5 dias' END)=0))
            
      THEN INSERT INTO smarkio_posvendafinanceiraportoseguro.assuntos_count
      (date, status, assunto)
      VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END,
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

    IF ((NEW.historico_pagamento IS NOT NULL) OR (NEW.contrato_liquidado IS NOT NULL) 
        OR (NEW.consulta_aberto IS NOT NULL) OR (NEW.status_contrato IS NOT NULL)) THEN 
        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET total_status = CASE
            WHEN (NEW.historico_pagamento = 'Sim') THEN total_status + 1
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN total_status + 1
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN total_status + 1
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN total_status + 1
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN total_status + 1
            ELSE total_status + 0 END
        WHERE date = NEW.lead_creation_day
        AND status = CASE
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
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
            END;
        
        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET total_assunto = CASE  WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN total_assunto + 1
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN total_assunto + 1
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN total_assunto + 1
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN total_assunto + 1
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN total_assunto + 1
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN total_assunto + 1
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN total_assunto + 1
            WHEN (NEW.historico_pagamento = 'Sim') THEN total_assunto + 1
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN total_assunto + 1
            ELSE total_assunto + 0 END
        WHERE date = NEW.lead_creation_day
        AND status = CASE WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
        AND assunto = CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
            ELSE 'Atraso maior que 5 dias'
            END;
    END IF;	

    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN 
       UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao = '4') THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao = '3') THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao = '2') THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao = '1') THEN satisfacao + 1
            ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
        AND status = CASE WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
        AND assunto = CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
            ELSE 'Atraso maior que 5 dias' END;

        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET total_satisfacao = total_satisfacao + 1
        WHERE date = NEW.lead_creation_day
        AND status = CASE WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
        AND assunto = CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
            ELSE 'Atraso maior que 5 dias' END;

        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET top_two = CASE WHEN (NEW.pesquisa_satisfacao IN ('5','4')) THEN top_two + 1
            ELSE top_two + 0 END
        WHERE date = NEW.lead_creation_day
        AND status = CASE
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
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
            END;
        
        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET bottom_box = CASE WHEN (NEW.pesquisa_satisfacao IN ('1','2')) THEN bottom_box + 1
            ELSE bottom_box + 0 END
        WHERE date = NEW.lead_creation_day
        AND status = CASE
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (NEW.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (NEW.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (NEW.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
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
            END;
    END IF;	

    IF ((OLD.historico_pagamento IS NOT NULL) OR (OLD.contrato_liquidado IS NOT NULL) 
        OR (OLD.consulta_aberto IS NOT NULL) OR (OLD.status_contrato IS NOT NULL)) THEN 
        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET total_status = CASE
            WHEN (OLD.historico_pagamento = 'Sim') THEN total_status - 1
            WHEN (OLD.historico_pagamento LIKE 'N%') THEN total_status - 1
            WHEN (OLD.contrato_liquidado IS NOT NULL) THEN total_status - 1
            WHEN (OLD.consulta_aberto IS NOT NULL) THEN total_status - 1
            WHEN (OLD.status_contrato = 'atraso_maior5dias') THEN total_status - 1
            ELSE total_status - 0 END
        WHERE date = OLD.lead_creation_day
        AND status = CASE
            WHEN (OLD.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (OLD.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (OLD.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (OLD.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (OLD.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
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
            ELSE 'Atraso maior que 5 dias'
            END;

        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET total_assunto = CASE
            WHEN (OLD.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN total_assunto - 1
            WHEN (OLD.consulta_aberto LIKE 'Antecipar Parcela%') THEN total_assunto - 1
            WHEN (OLD.consulta_aberto LIKE 'Consultar Hist%') THEN total_assunto - 1
            WHEN (OLD.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN total_assunto - 1
            WHEN (OLD.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN total_assunto - 1
            WHEN (OLD.consulta_aberto = 'Encerrar') THEN total_assunto - 1
            WHEN (OLD.consulta_aberto = 'Quitar Saldo Devedor') THEN total_assunto - 1
            WHEN (OLD.historico_pagamento = 'Sim') THEN total_assunto - 1
            WHEN (OLD.historico_pagamento LIKE 'N%') THEN total_assunto - 1
            ELSE total_assunto - 0 END
        WHERE date = OLD.lead_creation_day
        AND status = CASE
            WHEN (OLD.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (OLD.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (OLD.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (OLD.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (OLD.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
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
            ELSE 'Atraso maior que 5 dias'
            END;
    END IF;	

    IF (OLD.pesquisa_satisfacao IS NOT NULL) THEN 
       UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET satisfacao = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN satisfacao - 5
            WHEN (OLD.pesquisa_satisfacao = '4') THEN satisfacao - 4
            WHEN (OLD.pesquisa_satisfacao = '3') THEN satisfacao - 3
            WHEN (OLD.pesquisa_satisfacao = '2') THEN satisfacao - 2
            WHEN (OLD.pesquisa_satisfacao = '1') THEN satisfacao - 1
            ELSE satisfacao - 0 END
        WHERE date = OLD.lead_creation_day
        AND status = CASE
            WHEN (OLD.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (OLD.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (OLD.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (OLD.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (OLD.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
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
            ELSE 'Atraso maior que 5 dias'
            END;

        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET total_satisfacao = total_satisfacao - 1
        WHERE date = OLD.lead_creation_day
        AND status = CASE
            WHEN (OLD.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (OLD.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (OLD.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (OLD.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (OLD.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
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
            ELSE 'Atraso maior que 5 dias'
            END;

        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET top_two = CASE WHEN (OLD.pesquisa_satisfacao IN ('5','4')) THEN top_two - 1
            ELSE top_two - 0 END
        WHERE date = OLD.lead_creation_day
        AND status = CASE
            WHEN (OLD.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (OLD.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (OLD.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (OLD.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (OLD.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
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
            ELSE 'Atraso maior que 5 dias'
            END;
        
        UPDATE smarkio_posvendafinanceiraportoseguro.assuntos_count
        SET bottom_box = CASE WHEN (OLD.pesquisa_satisfacao IN ('1','2')) THEN bottom_box - 1
            ELSE bottom_box - 0 END
        WHERE date = OLD.lead_creation_day
        AND status = CASE
            WHEN (OLD.historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
            WHEN (OLD.historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
            WHEN (OLD.contrato_liquidado IS NOT NULL) THEN 'Liquidado'
            WHEN (OLD.consulta_aberto IS NOT NULL) THEN 'Aberto'
            WHEN (OLD.status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
            ELSE 'Outros' END
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
            ELSE 'Atraso maior que 5 dias'
            END;
    END IF;	
END;

-- SELECT -- 
INSERT INTO smarkio_posvendafinanceiraportoseguro.assuntos_count (`date`, `assunto`, `status`, `total_status`, `total_assunto`,`satisfacao`, `total_satisfacao`, `top_two`, `bottom_box`)
SELECT c.date, c.assunto, c.status, c.total_status, c.total_assunto, c.satisfacao, c.total_satisfacao, c.top_two, c.bottom_box
FROM 
(
SELECT 
	lead_creation_day AS date,
    (CASE WHEN (contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
        WHEN (consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
        WHEN (consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
        WHEN (consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
        WHEN (consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
        WHEN (consulta_aberto = 'Encerrar') THEN 'Encerrar'
        WHEN (consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
        WHEN (historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
        WHEN (historico_pagamento LIKE 'N%') THEN 'Encerrar'
        ELSE 'Atraso maior que 5 dias' END) AS assunto,
    (CASE
        WHEN (historico_pagamento = 'Sim') THEN 'Atraso menor que 6 dias'
        WHEN (historico_pagamento LIKE 'N%') THEN 'Atraso menor que 6 dias'
        WHEN (contrato_liquidado IS NOT NULL) THEN 'Liquidado'
        WHEN (consulta_aberto IS NOT NULL) THEN 'Aberto'
        WHEN (status_contrato = 'atraso_maior5dias') THEN 'Atraso maior que 5 dias'
        ELSE 'Outros' END) AS status,
    SUM(CASE WHEN (historico_pagamento = 'Sim') THEN 1
        WHEN (historico_pagamento LIKE 'N%') THEN 1
        WHEN (contrato_liquidado IS NOT NULL) THEN 1
        WHEN (consulta_aberto IS NOT NULL) THEN 1
        WHEN (status_contrato = 'atraso_maior5dias') THEN 1
        ELSE 0 END) AS total_status,
    SUM(CASE
        WHEN (contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 1
        WHEN (consulta_aberto LIKE 'Antecipar Parcela%') THEN 1
        WHEN (consulta_aberto LIKE 'Consultar Hist%') THEN 1
        WHEN (consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 1
        WHEN (consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 1
        WHEN (consulta_aberto = 'Encerrar') THEN 1
        WHEN (consulta_aberto = 'Quitar Saldo Devedor') THEN 1
        WHEN (historico_pagamento = 'Sim') THEN 1
        WHEN (historico_pagamento LIKE 'N%') THEN 1
        ELSE 0 END) AS total_assunto,
    SUM(CASE WHEN (pesquisa_satisfacao = '5') THEN 5
            WHEN (pesquisa_satisfacao = '4') THEN 4
            WHEN (pesquisa_satisfacao = '3') THEN 3
            WHEN (pesquisa_satisfacao = '2') THEN 2
            WHEN (pesquisa_satisfacao = '1') THEN 1
            ELSE 0 END) AS satisfacao,     
	SUM(CASE WHEN (pesquisa_satisfacao IS NOT NULL) THEN 1
            ELSE 0 END) AS total_satisfacao,  
    SUM(CASE WHEN (pesquisa_satisfacao IN ('5','4')) THEN 1
            ELSE 0 END) AS top_two,  
    SUM(CASE WHEN (pesquisa_satisfacao IN ('1','2')) THEN 1
            ELSE 0 END) AS bottom_box
	FROM smarkio_posvendafinanceiraportoseguro.leads 
    WHERE lead_creation_day between '2018-10-29' and '2018-12-31'
    AND ((historico_pagamento IS NOT NULL) OR (contrato_liquidado IS NOT NULL) 
        OR (consulta_aberto IS NOT NULL) OR (status_contrato IS NOT NULL))
	GROUP BY date,status, assunto) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `assunto` = c.assunto,
        `status` = c.status,
        `total_status` = c.total_status,
        `total_assunto` = c.total_assunto,
        `satisfacao` = c.satisfacao,
        `total_satisfacao` = c.total_satisfacao,
        `top_two` = c.top_two,
        `bottom_box` = c.bottom_box;