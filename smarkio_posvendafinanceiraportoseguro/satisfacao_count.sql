-- TABLE -- 
  CREATE TABLE `smarkio_posvendafinanceiraportoseguro`.`satisfacao_count` (
  `idsatisfacao` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL, 
  `assunto` VARCHAR(255) NOT NULL,
  `notas` VARCHAR(255) NOT NULL,
  `satisfacao` INT(11) NULL DEFAULT 0,
  `total_satisfacao` INT(11) NULL DEFAULT 0,
  `top_two` INT(11) NULL DEFAULT 0,
  `neutro` INT(11) NULL DEFAULT 0,
  `bottom_box` INT(11) NULL DEFAULT 0,
  PRIMARY KEY (`idsatisfacao`));

-- TRIGGER --
USE smarkio_posvendafinanceiraportoseguro;
DELIMITER |
CREATE TRIGGER tg_satisfacao_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.pesquisa_satisfacao IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_posvendafinanceiraportoseguro.satisfacao_count 
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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
            ELSE 'Atraso maior que 5 dias' END)=0))
            
      THEN INSERT INTO smarkio_posvendafinanceiraportoseguro.satisfacao_count
      (date, notas, assunto)
      VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END,
        CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
            ELSE 'Atraso maior que 5 dias' END);
    END IF;

    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN 
       UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao = '4') THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao = '3') THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao = '2') THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao = '1') THEN satisfacao + 1
            ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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

        UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET total_satisfacao = total_satisfacao + 1
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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

        UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET top_two = CASE WHEN (NEW.pesquisa_satisfacao IN ('5','4')) THEN top_two + 1
            ELSE top_two + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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
        
        UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET neutro = CASE WHEN (NEW.pesquisa_satisfacao = '3') THEN neutro + 1
            ELSE neutro + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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

        UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET bottom_box = CASE WHEN (NEW.pesquisa_satisfacao IN ('1','2')) THEN bottom_box + 1
            ELSE bottom_box + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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
CREATE TRIGGER tg_satisfacao_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
IF ((NEW.pesquisa_satisfacao IS NOT NULL)
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_posvendafinanceiraportoseguro.satisfacao_count 
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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
            ELSE 'Atraso maior que 5 dias' END)=0))
            
      THEN INSERT INTO smarkio_posvendafinanceiraportoseguro.satisfacao_count
      (date, notas, assunto)
      VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END,
        CASE WHEN (NEW.contrato_liquidado LIKE 'Consultar Hist% de Pagamento') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Antecipar Parcela%') THEN 'Antecipar Parcela'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Hist%') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Saldo Devedor') THEN 'Consultar Saldo Devedor'
            WHEN (NEW.consulta_aberto LIKE 'Consultar Segunda Vi%') THEN 'Consultar Segunda Via de Parcela'
            WHEN (NEW.consulta_aberto = 'Encerrar') THEN 'Encerrar'
            WHEN (NEW.consulta_aberto = 'Quitar Saldo Devedor') THEN 'Quitar Saldo Devedor'
            WHEN (NEW.historico_pagamento = 'Sim') THEN 'Consultar Histórico de Pagamento'
            WHEN (NEW.historico_pagamento LIKE 'N%') THEN 'Encerrar'
            ELSE 'Atraso maior que 5 dias' END);
    END IF;

    IF (NEW.pesquisa_satisfacao IS NOT NULL) THEN 
       UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao = '4') THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao = '3') THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao = '2') THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao = '1') THEN satisfacao + 1
            ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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

        UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET total_satisfacao = total_satisfacao + 1
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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

        UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET top_two = CASE WHEN (NEW.pesquisa_satisfacao IN ('5','4')) THEN top_two + 1
            ELSE top_two + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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
        
        UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET neutro = CASE WHEN (NEW.pesquisa_satisfacao = '3') THEN neutro + 1
            ELSE neutro + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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

        UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET bottom_box = CASE WHEN (NEW.pesquisa_satisfacao IN ('1','2')) THEN bottom_box + 1
            ELSE bottom_box + 0 END
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao = '5') THEN '5'
            WHEN (NEW.pesquisa_satisfacao = '4') THEN '4'
            WHEN (NEW.pesquisa_satisfacao = '3') THEN '3'
            WHEN (NEW.pesquisa_satisfacao = '2') THEN '2'
            WHEN (NEW.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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

    IF (OLD.pesquisa_satisfacao IS NOT NULL) THEN 
       UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET satisfacao = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN satisfacao - 5
            WHEN (OLD.pesquisa_satisfacao = '4') THEN satisfacao - 4
            WHEN (OLD.pesquisa_satisfacao = '3') THEN satisfacao - 3
            WHEN (OLD.pesquisa_satisfacao = '2') THEN satisfacao - 2
            WHEN (OLD.pesquisa_satisfacao = '1') THEN satisfacao - 1
            ELSE satisfacao - 0 END
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = '4') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = '3') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = '2') THEN '2'
            WHEN (OLD.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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

        UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET total_satisfacao = total_satisfacao - 1
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = '4') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = '3') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = '2') THEN '2'
            WHEN (OLD.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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

        UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET top_two = CASE WHEN (OLD.pesquisa_satisfacao IN ('5','4')) THEN top_two - 1
            ELSE top_two - 0 END
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = '4') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = '3') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = '2') THEN '2'
            WHEN (OLD.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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
        
        UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET neutro = CASE WHEN (OLD.pesquisa_satisfacao = '3') THEN neutro - 1
            ELSE neutro - 0 END
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = '4') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = '3') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = '2') THEN '2'
            WHEN (OLD.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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

        UPDATE smarkio_posvendafinanceiraportoseguro.satisfacao_count
        SET bottom_box = CASE WHEN (OLD.pesquisa_satisfacao IN ('1','2')) THEN bottom_box - 1
            ELSE bottom_box - 0 END
        WHERE date = OLD.lead_creation_day
        AND notas = CASE WHEN (OLD.pesquisa_satisfacao = '5') THEN '5'
            WHEN (OLD.pesquisa_satisfacao = '4') THEN '4'
            WHEN (OLD.pesquisa_satisfacao = '3') THEN '3'
            WHEN (OLD.pesquisa_satisfacao = '2') THEN '2'
            WHEN (OLD.pesquisa_satisfacao = '1') THEN '1'
            ELSE '0' END
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
INSERT INTO smarkio_posvendafinanceiraportoseguro.satisfacao_count (`date`, `assunto`, `notas`,`satisfacao`, `total_satisfacao`, `top_two`, `neutro`, `bottom_box`)
SELECT c.date, c.assunto, c.notas, c.satisfacao, c.total_satisfacao, c.top_two, c.neutro, c.bottom_box
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
    (CASE WHEN (pesquisa_satisfacao = '5') THEN '5'
            WHEN (pesquisa_satisfacao = '4') THEN '4'
            WHEN (pesquisa_satisfacao = '3') THEN '3'
            WHEN (pesquisa_satisfacao = '2') THEN '2'
            WHEN (pesquisa_satisfacao = '1') THEN '1'
            ELSE 0 END) AS notas,
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
    SUM(CASE WHEN (pesquisa_satisfacao = '3') THEN 1
            ELSE 0 END) AS neutro,  
    SUM(CASE WHEN (pesquisa_satisfacao IN ('1','2')) THEN 1
            ELSE 0 END) AS bottom_box
	FROM smarkio_posvendafinanceiraportoseguro.leads 
    WHERE lead_creation_day between '2018-10-29' and '2018-12-31' 
    AND pesquisa_satisfacao IS NOT NULL
	GROUP BY date, assunto,notas) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `assunto` = c.assunto,
        `notas` = c.notas,
        `satisfacao` = c.satisfacao,
        `total_satisfacao` = c.total_satisfacao,
        `top_two` = c.top_two,
        `neutro` = c.neutro,
        `bottom_box` = c.bottom_box;