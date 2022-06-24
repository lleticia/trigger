-- SELECT ORIGINAL --
interacao->case
when REGEXP_MATCH(menu_principal_fianca, ".*") then "FIA"
when REGEXP_MATCH(menu_principal_garantia, ".*") then "GAR"
when REGEXP_MATCH(menu_principal_cap, ".*") then "CAP"
else "vazio"
end

transbordo->case
when REGEXP_MATCH(transbordo2_cap, "Sim") then 1 
when REGEXP_MATCH(transbordo_fianca, "Sim") then 1 
when REGEXP_MATCH(transbordo_cap, "Sim") then 1 
when REGEXP_MATCH(transbordo_garantia, "Sim") then 1 
when horario_atendimento = "1" and lead_creation_day >= '2019-06-01' then 1 
else 0
end

-- TABLE -- 
  CREATE TABLE `smarkio_portoseguroriscosfinanceiros`.`leads_count` (
  `idleads` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL, 
  `produto` VARCHAR(255) NOT NULL,
  `interacao` INT(11) NULL DEFAULT 0,
  `transbordo` INT(11) NULL DEFAULT 0,
  PRIMARY KEY (`idleads`));

-- TRIGGER --
USE smarkio_portoseguroriscosfinanceiros;
DELIMITER |
CREATE TRIGGER tg_leads_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.susep != 'COL10J') 
        AND (SELECT EXISTS (
          SELECT * FROM smarkio_portoseguroriscosfinanceiros.leads_count 
          WHERE date = NEW.lead_creation_day
          AND produto = CASE WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END)=0))
          
    THEN INSERT INTO smarkio_portoseguroriscosfinanceiros.leads_count
    (date, produto)
    VALUES (NEW.lead_creation_day,
          CASE WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END);
    END IF;

    IF (NEW.susep != 'COL10J') THEN 
        UPDATE smarkio_portoseguroriscosfinanceiros.leads_count
        SET transbordo = CASE WHEN (NEW.transbordo2_cap = 'Sim') THEN transbordo + 1 
          WHEN (NEW.transbordo_fianca = 'Sim') THEN transbordo + 1 
          WHEN (NEW.transbordo_cap = 'Sim') THEN transbordo + 1 
          WHEN (NEW.transbordo_garantia = 'Sim') THEN transbordo + 1 
          WHEN (NEW.horario_atendimento = '1' AND NEW.lead_creation_day >= '2019-06-01') THEN transbordo + 1  
          ELSE transbordo + 0 END
        WHERE date = NEW.lead_creation_day
          AND produto = CASE WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END;

        UPDATE smarkio_portoseguroriscosfinanceiros.leads_count
        SET interacao = CASE WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN interacao + 1 
          WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN interacao + 1 
          WHEN (NEW.menu_principal_cap IS NOT NULL) THEN interacao + 1 
          ELSE interacao + 0 END
        WHERE date = NEW.lead_creation_day
          AND produto = CASE WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END;
    END IF;	
END;

-- TRIGGER UPDATE--
USE smarkio_portoseguroriscosfinanceiros;
DELIMITER |
CREATE TRIGGER tg_leads_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
	  IF ((NEW.susep != 'COL10J') 
        AND (SELECT EXISTS (
          SELECT * FROM smarkio_portoseguroriscosfinanceiros.leads_count 
          WHERE date = NEW.lead_creation_day
          AND produto = CASE WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END)=0))
          
    THEN INSERT INTO smarkio_portoseguroriscosfinanceiros.leads_count
    (date, produto)
    VALUES (NEW.lead_creation_day,
          CASE WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END);
    END IF;

    IF (NEW.susep != 'COL10J') THEN 
        UPDATE smarkio_portoseguroriscosfinanceiros.leads_count
        SET transbordo = CASE WHEN (NEW.transbordo2_cap = 'Sim') THEN transbordo + 1 
          WHEN (NEW.transbordo_fianca = 'Sim') THEN transbordo + 1 
          WHEN (NEW.transbordo_cap = 'Sim') THEN transbordo + 1 
          WHEN (NEW.transbordo_garantia = 'Sim') THEN transbordo + 1 
          WHEN (NEW.horario_atendimento = '1' AND NEW.lead_creation_day >= '2019-06-01') THEN transbordo + 1  
          ELSE transbordo + 0 END
        WHERE date = NEW.lead_creation_day
          AND produto = CASE WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END;

        UPDATE smarkio_portoseguroriscosfinanceiros.leads_count
        SET interacao = CASE WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN interacao + 1 
          WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN interacao + 1 
          WHEN (NEW.menu_principal_cap IS NOT NULL) THEN interacao + 1 
          ELSE interacao + 0 END
        WHERE date = NEW.lead_creation_day
          AND produto = CASE WHEN ((NEW.pdt = 'FIA') AND (NEW.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((NEW.pdt = 'FIA') AND (NEW.canal_atendimento = 'PORTO_ALUGUEL') AND (NEW.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (NEW.pdt = 'CAP') THEN 'CAP'
            WHEN (NEW.pdt = 'GAR') THEN 'GAR'
            WHEN (NEW.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (NEW.chat_fianca = 'sim') THEN 'FIA'
            WHEN (NEW.chat_portocap = 'sim') THEN 'CAP'
            WHEN (NEW.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END;
    END IF;	

    IF (OLD.susep != 'COL10J') THEN 
        UPDATE smarkio_portoseguroriscosfinanceiros.leads_count
        SET transbordo = CASE WHEN (OLD.transbordo2_cap = 'Sim') THEN transbordo - 1 
          WHEN (OLD.transbordo_fianca = 'Sim') THEN transbordo - 1 
          WHEN (OLD.transbordo_cap = 'Sim') THEN transbordo - 1 
          WHEN (OLD.transbordo_garantia = 'Sim') THEN transbordo - 1 
          WHEN (OLD.horario_atendimento = '1' AND OLD.lead_creation_day >= '2019-06-01') THEN transbordo - 1  
          ELSE transbordo - 0 END
        WHERE date = OLD.lead_creation_day
          AND produto = CASE WHEN ((OLD.pdt = 'FIA') AND (OLD.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((OLD.pdt = 'FIA') AND (OLD.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (OLD.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((OLD.pdt = 'FIA') AND (OLD.canal_atendimento = 'PORTO_ALUGUEL') AND (OLD.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (OLD.pdt = 'CAP') THEN 'CAP'
            WHEN (OLD.pdt = 'GAR') THEN 'GAR'
            WHEN (OLD.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (OLD.chat_fianca = 'sim') THEN 'FIA'
            WHEN (OLD.chat_portocap = 'sim') THEN 'CAP'
            WHEN (OLD.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END;

        UPDATE smarkio_portoseguroriscosfinanceiros.leads_count
        SET interacao = CASE WHEN (OLD.menu_principal_fianca IS NOT NULL) THEN interacao - 1 
          WHEN (OLD.menu_principal_garantia IS NOT NULL) THEN interacao - 1 
          WHEN (OLD.menu_principal_cap IS NOT NULL) THEN interacao - 1 
          ELSE interacao - 0 END
        WHERE date = OLD.lead_creation_day
          AND produto = CASE WHEN ((OLD.pdt = 'FIA') AND (OLD.lead_creation_day < '2019-06-19')) THEN 'FIA'
            WHEN ((OLD.pdt = 'FIA') AND (OLD.canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (OLD.lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
            WHEN ((OLD.pdt = 'FIA') AND (OLD.canal_atendimento = 'PORTO_ALUGUEL') AND (OLD.lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
            WHEN (OLD.pdt = 'CAP') THEN 'CAP'
            WHEN (OLD.pdt = 'GAR') THEN 'GAR'
            WHEN (OLD.pdt LIKE 'FIAcanal%') THEN 'FIA'
            WHEN (OLD.chat_fianca = 'sim') THEN 'FIA'
            WHEN (OLD.chat_portocap = 'sim') THEN 'CAP'
            WHEN (OLD.chat_garantia = 'sim') THEN 'GAR'
            ELSE '-' END;
    END IF;	
END;

-- SELECT -- 
INSERT INTO smarkio_portoseguroriscosfinanceiros.leads_count (`date`, `produto`, `transbordo`, `interacao`)
SELECT c.date, c.produto, c.transbordo, c.interacao
FROM 
(
SELECT 
	  lead_creation_day AS date,
    (CASE WHEN ((pdt = 'FIA') AND (lead_creation_day < '2019-06-19')) THEN 'FIA'
        WHEN ((pdt = 'FIA') AND (canal_atendimento = 'PORTO_ALUGUEL_EMISSAO') AND (lead_creation_day >= '2019-06-19')) THEN 'FIA Emissão'
        WHEN ((pdt = 'FIA') AND (canal_atendimento = 'PORTO_ALUGUEL') AND (lead_creation_day >= '2019-06-19')) THEN 'FIA Produto'
        WHEN (pdt = 'CAP') THEN 'CAP'
        WHEN (pdt = 'GAR') THEN 'GAR'
        WHEN (pdt LIKE 'FIAcanal%') THEN 'FIA'
        WHEN (chat_fianca = 'sim') THEN 'FIA'
        WHEN (chat_portocap = 'sim') THEN 'CAP'
        WHEN (chat_garantia = 'sim') THEN 'GAR'
        ELSE '-' END) AS produto,
    SUM(CASE WHEN (transbordo2_cap = 'Sim') THEN 1 
      WHEN (transbordo_fianca = 'Sim') THEN 1 
      WHEN (transbordo_cap = 'Sim') THEN 1 
      WHEN (transbordo_garantia = 'Sim') THEN 1 
      WHEN (horario_atendimento = '1' AND lead_creation_day >= '2019-06-01') THEN 1 
      ELSE 0 END) AS transbordo,
    SUM(CASE WHEN (menu_principal_fianca IS NOT NULL) THEN 1 
      WHEN (menu_principal_garantia IS NOT NULL) THEN 1
      WHEN (menu_principal_cap IS NOT NULL) THEN 1 
      ELSE 0 END) AS interacao
	FROM smarkio_portoseguroriscosfinanceiros.leads 
    WHERE lead_creation_day between '2021-06-01' and '2021-06-06'
    AND susep != 'COL10J'
	GROUP BY date, produto) AS c 
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `produto` = c.produto,
        `transbordo` = c.transbordo,
        `interacao` = c.interacao;
