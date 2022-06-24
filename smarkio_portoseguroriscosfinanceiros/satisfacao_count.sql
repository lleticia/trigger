-- SELECT ORIGINAL --
SATISFACAO -> case
when pesquisa_satisfacao_cap = "5" then 5
when pesquisa_satisfacao_cap = "4" then 4
when pesquisa_satisfacao_cap = "3" then 3
when pesquisa_satisfacao_cap = "2" then 2
when pesquisa_satisfacao_cap = "1" then 1
when pesquisa_satisfacao_garantia = "5" then 5
when pesquisa_satisfacao_garantia = "4" then 4
when pesquisa_satisfacao_garantia = "3" then 3
when pesquisa_satisfacao_garantia = "2" then 2
when pesquisa_satisfacao_garantia = "1" then 1 
when pesquisa_satisfacao_fianca = "5" then 5
when pesquisa_satisfacao_fianca = "4" then 4
when pesquisa_satisfacao_fianca = "3" then 3
when pesquisa_satisfacao_fianca = "2" then 2
when pesquisa_satisfacao_fianca = "1" then 1 
when REGEXP_MATCH(pesquisa_satisfacao_cap, ".*timo") then 5
when REGEXP_MATCH(pesquisa_satisfacao_cap, "Bom") then 4
when REGEXP_MATCH(pesquisa_satisfacao_cap, "Regular") then 3
when REGEXP_MATCH(pesquisa_satisfacao_cap, "Ruim") then 2
when REGEXP_MATCH(pesquisa_satisfacao_cap ,".*ssimo") then 1
when REGEXP_MATCH(pesquisa_satisfacao_garantia, ".*timo") then 5
when REGEXP_MATCH(pesquisa_satisfacao_garantia, "Bom") then 4
when REGEXP_MATCH(pesquisa_satisfacao_garantia, "Regular") then 3
when REGEXP_MATCH(pesquisa_satisfacao_garantia, "Ruim") then 2
when REGEXP_MATCH(pesquisa_satisfacao_garantia, ".*ssimo") then 1
when REGEXP_MATCH(pesquisa_satisfacao_fianca ,".*timo") then 5
when REGEXP_MATCH(pesquisa_satisfacao_fianca ,"Bom") then 4
when REGEXP_MATCH(pesquisa_satisfacao_fianca, "Regular") then 3
when REGEXP_MATCH(pesquisa_satisfacao_fianca, "Ruim") then 2
when REGEXP_MATCH(pesquisa_satisfacao_fianca, ".*ssimo") then 1 
else 0
end 

TOP TWO -> case
when pesquisa_satisfacao_cap = "5" then 1
when pesquisa_satisfacao_cap = "4" then 1
when pesquisa_satisfacao_cap = "3" then 0
when pesquisa_satisfacao_cap = "2" then 0
when pesquisa_satisfacao_cap = "1" then 0
when pesquisa_satisfacao_garantia = "5" then 1
when pesquisa_satisfacao_garantia = "4" then 1
when pesquisa_satisfacao_garantia = "3" then 0
when pesquisa_satisfacao_garantia = "2" then 0
when pesquisa_satisfacao_garantia = "1" then 0
when pesquisa_satisfacao_fianca = "5" then 1
when pesquisa_satisfacao_fianca = "4" then 1
when pesquisa_satisfacao_fianca = "3" then 0
when pesquisa_satisfacao_fianca = "2" then 0
when pesquisa_satisfacao_fianca = "1" then 0
when REGEXP_MATCH(pesquisa_satisfacao_cap, ".*timo") then 1
when REGEXP_MATCH(pesquisa_satisfacao_cap, "Bom") then 1
when REGEXP_MATCH(pesquisa_satisfacao_cap, "Regular") then 0
when REGEXP_MATCH(pesquisa_satisfacao_cap, "Ruim") then 0
when REGEXP_MATCH(pesquisa_satisfacao_cap ,".*ssimo") then 0
when REGEXP_MATCH(pesquisa_satisfacao_garantia, ".*timo") then 1
when REGEXP_MATCH(pesquisa_satisfacao_garantia, "Bom") then 1
when REGEXP_MATCH(pesquisa_satisfacao_garantia, "Regular") then 0
when REGEXP_MATCH(pesquisa_satisfacao_garantia, "Ruim") then 0
when REGEXP_MATCH(pesquisa_satisfacao_garantia, ".*ssimo") then 0
when REGEXP_MATCH(pesquisa_satisfacao_fianca ,".*timo") then 1
when REGEXP_MATCH(pesquisa_satisfacao_fianca ,"Bom") then 1
when REGEXP_MATCH(pesquisa_satisfacao_fianca, "Regular") then 0
when REGEXP_MATCH(pesquisa_satisfacao_fianca, "Ruim") then 0
when REGEXP_MATCH(pesquisa_satisfacao_fianca, ".*ssimo") then 0
else 0
end 

BOTTOM BOX ->case
when pesquisa_satisfacao_cap = "5" then 0
when pesquisa_satisfacao_cap = "4" then 0
when pesquisa_satisfacao_cap = "3" then 0
when pesquisa_satisfacao_cap = "2" then 0
when pesquisa_satisfacao_cap = "1" then 1 
when pesquisa_satisfacao_garantia = "5" then 0
when pesquisa_satisfacao_garantia = "4" then 0
when pesquisa_satisfacao_garantia = "3" then 0
when pesquisa_satisfacao_garantia = "2" then 0
when pesquisa_satisfacao_garantia = "1" then 1
when pesquisa_satisfacao_fianca = "5" then 0
when pesquisa_satisfacao_fianca = "4" then 0
when pesquisa_satisfacao_fianca = "3" then 0
when pesquisa_satisfacao_fianca = "2" then 0
when pesquisa_satisfacao_fianca = "1" then 1
when REGEXP_MATCH(pesquisa_satisfacao_cap, ".*timo") then 0
when REGEXP_MATCH(pesquisa_satisfacao_cap, "Bom") then 0
when REGEXP_MATCH(pesquisa_satisfacao_cap, "Regular") then 0
when REGEXP_MATCH(pesquisa_satisfacao_cap, "Ruim") then 0
when REGEXP_MATCH(pesquisa_satisfacao_cap ,".*ssimo") then 1
when REGEXP_MATCH(pesquisa_satisfacao_garantia, ".*timo") then 0
when REGEXP_MATCH(pesquisa_satisfacao_garantia, "Bom") then 0
when REGEXP_MATCH(pesquisa_satisfacao_garantia, "Regular") then 0
when REGEXP_MATCH(pesquisa_satisfacao_garantia, "Ruim") then 0
when REGEXP_MATCH(pesquisa_satisfacao_garantia, ".*ssimo") then 1
when REGEXP_MATCH(pesquisa_satisfacao_fianca ,".*timo") then 0
when REGEXP_MATCH(pesquisa_satisfacao_fianca ,"Bom") then 0
when REGEXP_MATCH(pesquisa_satisfacao_fianca, "Regular") then 0
when REGEXP_MATCH(pesquisa_satisfacao_fianca, "Ruim") then 0
when REGEXP_MATCH(pesquisa_satisfacao_fianca, ".*ssimo") then 1
else 0
end 

NEUTRO -> case
when pesquisa_satisfacao_cap = "5" then 0
when pesquisa_satisfacao_cap = "4" then 0
when pesquisa_satisfacao_cap = "3" then 1
when pesquisa_satisfacao_cap = "2" then 1
when pesquisa_satisfacao_cap = "1" then 0
when pesquisa_satisfacao_garantia = "5" then 0
when pesquisa_satisfacao_garantia = "4" then 0
when pesquisa_satisfacao_garantia = "3" then 1
when pesquisa_satisfacao_garantia = "2" then 1
when pesquisa_satisfacao_garantia = "1" then 0
when pesquisa_satisfacao_fianca = "5" then 0
when pesquisa_satisfacao_fianca = "4" then 0
when pesquisa_satisfacao_fianca = "3" then 1
when pesquisa_satisfacao_fianca = "2" then 1
when pesquisa_satisfacao_fianca = "1" then 0
when REGEXP_MATCH(pesquisa_satisfacao_cap, ".*timo") then 0
when REGEXP_MATCH(pesquisa_satisfacao_cap, "Bom") then 0
when REGEXP_MATCH(pesquisa_satisfacao_cap, "Regular") then 1
when REGEXP_MATCH(pesquisa_satisfacao_cap, "Ruim") then 1
when REGEXP_MATCH(pesquisa_satisfacao_cap ,".*ssimo") then 0
when REGEXP_MATCH(pesquisa_satisfacao_garantia, ".*timo") then 0
when REGEXP_MATCH(pesquisa_satisfacao_garantia, "Bom") then 0
when REGEXP_MATCH(pesquisa_satisfacao_garantia, "Regular") then 1
when REGEXP_MATCH(pesquisa_satisfacao_garantia, "Ruim") then 1
when REGEXP_MATCH(pesquisa_satisfacao_garantia, ".*ssimo") then 0
when REGEXP_MATCH(pesquisa_satisfacao_fianca ,".*timo") then 0
when REGEXP_MATCH(pesquisa_satisfacao_fianca ,"Bom") then 0
when REGEXP_MATCH(pesquisa_satisfacao_fianca, "Regular") then 1
when REGEXP_MATCH(pesquisa_satisfacao_fianca, "Ruim") then 1
when REGEXP_MATCH(pesquisa_satisfacao_fianca, ".*ssimo") then 0
else 0
end  

-- TABLE -- 
  CREATE TABLE `smarkio_portoseguroriscosfinanceiros`.`satisfacao_count` (
  `idsatisfacao` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL, 
  `assunto` VARCHAR(255) NOT NULL,
  `produto` VARCHAR(255) NOT NULL,
  `notas` VARCHAR(255) NOT NULL,
  `satisfacao` INT(11) NULL DEFAULT 0,
  `total_satisfacao` INT(11) NULL DEFAULT 0,
  `top_two` INT(11) NULL DEFAULT 0,
  `neutro` INT(11) NULL DEFAULT 0,
  `bottom_box` INT(11) NULL DEFAULT 0,
  PRIMARY KEY (`idsatisfacao`));

-- TRIGGER --
USE smarkio_portoseguroriscosfinanceiros;
DELIMITER |
CREATE TRIGGER tg_satisfacao_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF (((NEW.pesquisa_satisfacao_cap IS NOT NULL) OR (NEW.pesquisa_satisfacao_garantia IS NOT NULL) OR (NEW.pesquisa_satisfacao_fianca IS NOT NULL))
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portoseguroriscosfinanceiros.satisfacao_count 
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
            WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
            WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
            ELSE '-' END
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
            
      THEN INSERT INTO smarkio_portoseguroriscosfinanceiros.satisfacao_count
      (date, notas, assunto, produto)
      VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                ELSE 0 END,
        CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
            WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
            WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
            ELSE '-' END,
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

    IF ((NEW.pesquisa_satisfacao_cap IS NOT NULL) OR (NEW.pesquisa_satisfacao_garantia IS NOT NULL) OR (NEW.pesquisa_satisfacao_fianca IS NOT NULL)) THEN 
       UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                OR (NEW.pesquisa_satisfacao_cap LIKE '%timo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') 
                THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') 
                THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao_cap = '3') OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') 
                THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') 
                THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') 
                THEN satisfacao + 1
            ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
            AND notas = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                    OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                    OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                    OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
                WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
                WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
                ELSE '-' END
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

        UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET total_satisfacao = total_satisfacao + 1
        WHERE date = NEW.lead_creation_day
            AND notas = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                    OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                    OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                    OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
                WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
                WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
                ELSE '-' END
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

        UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET top_two = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
            OR (NEW.pesquisa_satisfacao_cap LIKE '%timo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') 
            THEN top_two + 1
        WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
            OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') 
            THEN top_two + 1
            ELSE top_two + 0 END
        WHERE date = NEW.lead_creation_day
            AND notas = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                    OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                    OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                    OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
                WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
                WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
                ELSE '-' END
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
        
        UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET neutro = CASE WHEN (NEW.pesquisa_satisfacao_cap = '3') OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') 
                THEN neutro + 1
            WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') 
                THEN neutro + 1
                ELSE neutro + 0 END
       WHERE date = NEW.lead_creation_day
            AND notas = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                    OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                    OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                    OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
                WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
                WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
                ELSE '-' END
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

        UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET bottom_box = CASE WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
            OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') 
            THEN bottom_box + 1
            ELSE bottom_box + 0 END
        WHERE date = NEW.lead_creation_day
            AND notas = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                    OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                    OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                    OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
                WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
                WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
                ELSE '-' END
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
CREATE TRIGGER tg_satisfacao_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF (((NEW.pesquisa_satisfacao_cap IS NOT NULL) OR (NEW.pesquisa_satisfacao_garantia IS NOT NULL) OR (NEW.pesquisa_satisfacao_fianca IS NOT NULL))
        AND (SELECT EXISTS (
        SELECT * FROM smarkio_portoseguroriscosfinanceiros.satisfacao_count 
        WHERE date = NEW.lead_creation_day
        AND notas = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                ELSE 0 END
        AND assunto = CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
            WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
            WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
            ELSE '-' END
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
            
      THEN INSERT INTO smarkio_portoseguroriscosfinanceiros.satisfacao_count
      (date, notas, assunto, produto)
      VALUES (NEW.lead_creation_day,
        CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
            WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
            WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
            WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
            WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                ELSE 0 END,
        CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
            WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
            WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
            ELSE '-' END,
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

    IF ((NEW.pesquisa_satisfacao_cap IS NOT NULL) OR (NEW.pesquisa_satisfacao_garantia IS NOT NULL) OR (NEW.pesquisa_satisfacao_fianca IS NOT NULL)) THEN 
       UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET satisfacao = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                OR (NEW.pesquisa_satisfacao_cap LIKE '%timo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') 
                THEN satisfacao + 5
            WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') 
                THEN satisfacao + 4
            WHEN (NEW.pesquisa_satisfacao_cap = '3') OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') 
                THEN satisfacao + 3
            WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') 
                THEN satisfacao + 2
            WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') 
                THEN satisfacao + 1
            ELSE satisfacao + 0 END
        WHERE date = NEW.lead_creation_day
            AND notas = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                    OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                    OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                    OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
                WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
                WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
                ELSE '-' END
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

        UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET total_satisfacao = total_satisfacao + 1
        WHERE date = NEW.lead_creation_day
            AND notas = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                    OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                    OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                    OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
                WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
                WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
                ELSE '-' END
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

        UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET top_two = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
            OR (NEW.pesquisa_satisfacao_cap LIKE '%timo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') 
            THEN top_two + 1
        WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
            OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') 
            THEN top_two + 1
            ELSE top_two + 0 END
        WHERE date = NEW.lead_creation_day
            AND notas = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                    OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                    OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                    OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
                WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
                WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
                ELSE '-' END
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
        
        UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET neutro = CASE WHEN (NEW.pesquisa_satisfacao_cap = '3') OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') 
                THEN neutro + 1
            WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') 
                THEN neutro + 1
                ELSE neutro + 0 END
       WHERE date = NEW.lead_creation_day
            AND notas = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                    OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                    OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                    OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
                WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
                WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
                ELSE '-' END
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

        UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET bottom_box = CASE WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
            OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') 
            THEN bottom_box + 1
            ELSE bottom_box + 0 END
        WHERE date = NEW.lead_creation_day
            AND notas = CASE WHEN (NEW.pesquisa_satisfacao_cap = '5') OR (NEW.pesquisa_satisfacao_garantia = '5') OR (NEW.pesquisa_satisfacao_fianca = '5') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%timo')  OR (NEW.pesquisa_satisfacao_garantia LIKE '%timo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (NEW.pesquisa_satisfacao_cap = '4') OR (NEW.pesquisa_satisfacao_garantia = '4') OR (NEW.pesquisa_satisfacao_fianca = '4') 
                    OR (NEW.pesquisa_satisfacao_cap = 'Bom') OR (NEW.pesquisa_satisfacao_garantia = 'Bom') OR (NEW.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (NEW.pesquisa_satisfacao_cap = '3')  OR (NEW.pesquisa_satisfacao_garantia = '3') OR (NEW.pesquisa_satisfacao_fianca = '3')
                    OR (NEW.pesquisa_satisfacao_cap = 'Regular') OR (NEW.pesquisa_satisfacao_garantia = 'Regular') OR (NEW.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (NEW.pesquisa_satisfacao_cap = '2') OR (NEW.pesquisa_satisfacao_garantia = '2') OR (NEW.pesquisa_satisfacao_fianca = '2')
                    OR (NEW.pesquisa_satisfacao_cap = 'Ruim') OR (NEW.pesquisa_satisfacao_garantia = 'Ruim') OR (NEW.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (NEW.pesquisa_satisfacao_cap = '1') OR (NEW.pesquisa_satisfacao_garantia = '1') OR (NEW.pesquisa_satisfacao_fianca = '1') 
                    OR (NEW.pesquisa_satisfacao_cap LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (NEW.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (NEW.menu_principal_cap IS NOT NULL) THEN NEW.menu_principal_cap 
                WHEN (NEW.menu_principal_fianca IS NOT NULL) THEN NEW.menu_principal_fianca
                WHEN (NEW.menu_principal_garantia IS NOT NULL) THEN NEW.menu_principal_garantia 
                ELSE '-' END
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

    IF ((OLD.pesquisa_satisfacao_cap IS NOT NULL) OR (OLD.pesquisa_satisfacao_garantia IS NOT NULL) OR (OLD.pesquisa_satisfacao_fianca IS NOT NULL)) THEN 
       UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET satisfacao = CASE WHEN (OLD.pesquisa_satisfacao_cap = '5') OR (OLD.pesquisa_satisfacao_garantia = '5') OR (OLD.pesquisa_satisfacao_fianca = '5') 
                OR (OLD.pesquisa_satisfacao_cap LIKE '%timo') OR (OLD.pesquisa_satisfacao_garantia LIKE '%timo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%timo') 
                THEN satisfacao - 5
            WHEN (OLD.pesquisa_satisfacao_cap = '4') OR (OLD.pesquisa_satisfacao_garantia = '4') OR (OLD.pesquisa_satisfacao_fianca = '4') 
                OR (OLD.pesquisa_satisfacao_cap = 'Bom') OR (OLD.pesquisa_satisfacao_garantia = 'Bom') OR (OLD.pesquisa_satisfacao_fianca = 'Bom') 
                THEN satisfacao - 4
            WHEN (OLD.pesquisa_satisfacao_cap = '3') OR (OLD.pesquisa_satisfacao_garantia = '3') OR (OLD.pesquisa_satisfacao_fianca = '3')
                OR (OLD.pesquisa_satisfacao_cap = 'Regular') OR (OLD.pesquisa_satisfacao_garantia = 'Regular') OR (OLD.pesquisa_satisfacao_fianca = 'Regular') 
                THEN satisfacao - 3
            WHEN (OLD.pesquisa_satisfacao_cap = '2') OR (OLD.pesquisa_satisfacao_garantia = '2') OR (OLD.pesquisa_satisfacao_fianca = '2')
                OR (OLD.pesquisa_satisfacao_cap = 'Ruim') OR (OLD.pesquisa_satisfacao_garantia = 'Ruim') OR (OLD.pesquisa_satisfacao_fianca = 'Ruim') 
                THEN satisfacao - 2
            WHEN (OLD.pesquisa_satisfacao_cap = '1') OR (OLD.pesquisa_satisfacao_garantia = '1') OR (OLD.pesquisa_satisfacao_fianca = '1') 
                OR (OLD.pesquisa_satisfacao_cap LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%ssimo') 
                THEN satisfacao - 1
            ELSE satisfacao - 0 END
        WHERE date = OLD.lead_creation_day
            AND notas = CASE WHEN (OLD.pesquisa_satisfacao_cap = '5') OR (OLD.pesquisa_satisfacao_garantia = '5') OR (OLD.pesquisa_satisfacao_fianca = '5') 
                    OR (OLD.pesquisa_satisfacao_cap LIKE '%timo')  OR (OLD.pesquisa_satisfacao_garantia LIKE '%timo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (OLD.pesquisa_satisfacao_cap = '4') OR (OLD.pesquisa_satisfacao_garantia = '4') OR (OLD.pesquisa_satisfacao_fianca = '4') 
                    OR (OLD.pesquisa_satisfacao_cap = 'Bom') OR (OLD.pesquisa_satisfacao_garantia = 'Bom') OR (OLD.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (OLD.pesquisa_satisfacao_cap = '3')  OR (OLD.pesquisa_satisfacao_garantia = '3') OR (OLD.pesquisa_satisfacao_fianca = '3')
                    OR (OLD.pesquisa_satisfacao_cap = 'Regular') OR (OLD.pesquisa_satisfacao_garantia = 'Regular') OR (OLD.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (OLD.pesquisa_satisfacao_cap = '2') OR (OLD.pesquisa_satisfacao_garantia = '2') OR (OLD.pesquisa_satisfacao_fianca = '2')
                    OR (OLD.pesquisa_satisfacao_cap = 'Ruim') OR (OLD.pesquisa_satisfacao_garantia = 'Ruim') OR (OLD.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (OLD.pesquisa_satisfacao_cap = '1') OR (OLD.pesquisa_satisfacao_garantia = '1') OR (OLD.pesquisa_satisfacao_fianca = '1') 
                    OR (OLD.pesquisa_satisfacao_cap LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (OLD.menu_principal_cap IS NOT NULL) THEN OLD.menu_principal_cap 
                WHEN (OLD.menu_principal_fianca IS NOT NULL) THEN OLD.menu_principal_fianca
                WHEN (OLD.menu_principal_garantia IS NOT NULL) THEN OLD.menu_principal_garantia 
                ELSE '-' END
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

        UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET total_satisfacao = total_satisfacao - 1
        WHERE date = OLD.lead_creation_day
            AND notas = CASE WHEN (OLD.pesquisa_satisfacao_cap = '5') OR (OLD.pesquisa_satisfacao_garantia = '5') OR (OLD.pesquisa_satisfacao_fianca = '5') 
                    OR (OLD.pesquisa_satisfacao_cap LIKE '%timo')  OR (OLD.pesquisa_satisfacao_garantia LIKE '%timo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (OLD.pesquisa_satisfacao_cap = '4') OR (OLD.pesquisa_satisfacao_garantia = '4') OR (OLD.pesquisa_satisfacao_fianca = '4') 
                    OR (OLD.pesquisa_satisfacao_cap = 'Bom') OR (OLD.pesquisa_satisfacao_garantia = 'Bom') OR (OLD.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (OLD.pesquisa_satisfacao_cap = '3')  OR (OLD.pesquisa_satisfacao_garantia = '3') OR (OLD.pesquisa_satisfacao_fianca = '3')
                    OR (OLD.pesquisa_satisfacao_cap = 'Regular') OR (OLD.pesquisa_satisfacao_garantia = 'Regular') OR (OLD.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (OLD.pesquisa_satisfacao_cap = '2') OR (OLD.pesquisa_satisfacao_garantia = '2') OR (OLD.pesquisa_satisfacao_fianca = '2')
                    OR (OLD.pesquisa_satisfacao_cap = 'Ruim') OR (OLD.pesquisa_satisfacao_garantia = 'Ruim') OR (OLD.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (OLD.pesquisa_satisfacao_cap = '1') OR (OLD.pesquisa_satisfacao_garantia = '1') OR (OLD.pesquisa_satisfacao_fianca = '1') 
                    OR (OLD.pesquisa_satisfacao_cap LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (OLD.menu_principal_cap IS NOT NULL) THEN OLD.menu_principal_cap 
                WHEN (OLD.menu_principal_fianca IS NOT NULL) THEN OLD.menu_principal_fianca
                WHEN (OLD.menu_principal_garantia IS NOT NULL) THEN OLD.menu_principal_garantia 
                ELSE '-' END
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

        UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET top_two = CASE WHEN (OLD.pesquisa_satisfacao_cap = '5') OR (OLD.pesquisa_satisfacao_garantia = '5') OR (OLD.pesquisa_satisfacao_fianca = '5') 
            OR (OLD.pesquisa_satisfacao_cap LIKE '%timo') OR (OLD.pesquisa_satisfacao_garantia LIKE '%timo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%timo') 
            THEN top_two - 1
        WHEN (OLD.pesquisa_satisfacao_cap = '4') OR (OLD.pesquisa_satisfacao_garantia = '4') OR (OLD.pesquisa_satisfacao_fianca = '4') 
            OR (OLD.pesquisa_satisfacao_cap = 'Bom') OR (OLD.pesquisa_satisfacao_garantia = 'Bom') OR (OLD.pesquisa_satisfacao_fianca = 'Bom') 
            THEN top_two - 1
            ELSE top_two - 0 END
        WHERE date = OLD.lead_creation_day
            AND notas = CASE WHEN (OLD.pesquisa_satisfacao_cap = '5') OR (OLD.pesquisa_satisfacao_garantia = '5') OR (OLD.pesquisa_satisfacao_fianca = '5') 
                    OR (OLD.pesquisa_satisfacao_cap LIKE '%timo')  OR (OLD.pesquisa_satisfacao_garantia LIKE '%timo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (OLD.pesquisa_satisfacao_cap = '4') OR (OLD.pesquisa_satisfacao_garantia = '4') OR (OLD.pesquisa_satisfacao_fianca = '4') 
                    OR (OLD.pesquisa_satisfacao_cap = 'Bom') OR (OLD.pesquisa_satisfacao_garantia = 'Bom') OR (OLD.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (OLD.pesquisa_satisfacao_cap = '3')  OR (OLD.pesquisa_satisfacao_garantia = '3') OR (OLD.pesquisa_satisfacao_fianca = '3')
                    OR (OLD.pesquisa_satisfacao_cap = 'Regular') OR (OLD.pesquisa_satisfacao_garantia = 'Regular') OR (OLD.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (OLD.pesquisa_satisfacao_cap = '2') OR (OLD.pesquisa_satisfacao_garantia = '2') OR (OLD.pesquisa_satisfacao_fianca = '2')
                    OR (OLD.pesquisa_satisfacao_cap = 'Ruim') OR (OLD.pesquisa_satisfacao_garantia = 'Ruim') OR (OLD.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (OLD.pesquisa_satisfacao_cap = '1') OR (OLD.pesquisa_satisfacao_garantia = '1') OR (OLD.pesquisa_satisfacao_fianca = '1') 
                    OR (OLD.pesquisa_satisfacao_cap LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (OLD.menu_principal_cap IS NOT NULL) THEN OLD.menu_principal_cap 
                WHEN (OLD.menu_principal_fianca IS NOT NULL) THEN OLD.menu_principal_fianca
                WHEN (OLD.menu_principal_garantia IS NOT NULL) THEN OLD.menu_principal_garantia 
                ELSE '-' END
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
        
        UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET neutro = CASE WHEN (OLD.pesquisa_satisfacao_cap = '3') OR (OLD.pesquisa_satisfacao_garantia = '3') OR (OLD.pesquisa_satisfacao_fianca = '3')
                OR (OLD.pesquisa_satisfacao_cap = 'Regular') OR (OLD.pesquisa_satisfacao_garantia = 'Regular') OR (OLD.pesquisa_satisfacao_fianca = 'Regular') 
                THEN neutro - 1
            WHEN (OLD.pesquisa_satisfacao_cap = '2') OR (OLD.pesquisa_satisfacao_garantia = '2') OR (OLD.pesquisa_satisfacao_fianca = '2')
                OR (OLD.pesquisa_satisfacao_cap = 'Ruim') OR (OLD.pesquisa_satisfacao_garantia = 'Ruim') OR (OLD.pesquisa_satisfacao_fianca = 'Ruim') 
                THEN neutro - 1
                ELSE neutro - 0 END
       WHERE date = OLD.lead_creation_day
            AND notas = CASE WHEN (OLD.pesquisa_satisfacao_cap = '5') OR (OLD.pesquisa_satisfacao_garantia = '5') OR (OLD.pesquisa_satisfacao_fianca = '5') 
                    OR (OLD.pesquisa_satisfacao_cap LIKE '%timo')  OR (OLD.pesquisa_satisfacao_garantia LIKE '%timo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (OLD.pesquisa_satisfacao_cap = '4') OR (OLD.pesquisa_satisfacao_garantia = '4') OR (OLD.pesquisa_satisfacao_fianca = '4') 
                    OR (OLD.pesquisa_satisfacao_cap = 'Bom') OR (OLD.pesquisa_satisfacao_garantia = 'Bom') OR (OLD.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (OLD.pesquisa_satisfacao_cap = '3')  OR (OLD.pesquisa_satisfacao_garantia = '3') OR (OLD.pesquisa_satisfacao_fianca = '3')
                    OR (OLD.pesquisa_satisfacao_cap = 'Regular') OR (OLD.pesquisa_satisfacao_garantia = 'Regular') OR (OLD.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (OLD.pesquisa_satisfacao_cap = '2') OR (OLD.pesquisa_satisfacao_garantia = '2') OR (OLD.pesquisa_satisfacao_fianca = '2')
                    OR (OLD.pesquisa_satisfacao_cap = 'Ruim') OR (OLD.pesquisa_satisfacao_garantia = 'Ruim') OR (OLD.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (OLD.pesquisa_satisfacao_cap = '1') OR (OLD.pesquisa_satisfacao_garantia = '1') OR (OLD.pesquisa_satisfacao_fianca = '1') 
                    OR (OLD.pesquisa_satisfacao_cap LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (OLD.menu_principal_cap IS NOT NULL) THEN OLD.menu_principal_cap 
                WHEN (OLD.menu_principal_fianca IS NOT NULL) THEN OLD.menu_principal_fianca
                WHEN (OLD.menu_principal_garantia IS NOT NULL) THEN OLD.menu_principal_garantia 
                ELSE '-' END
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

        UPDATE smarkio_portoseguroriscosfinanceiros.satisfacao_count
        SET bottom_box = CASE WHEN (OLD.pesquisa_satisfacao_cap = '1') OR (OLD.pesquisa_satisfacao_garantia = '1') OR (OLD.pesquisa_satisfacao_fianca = '1') 
            OR (OLD.pesquisa_satisfacao_cap LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%ssimo') 
            THEN bottom_box - 1
            ELSE bottom_box - 0 END
        WHERE date = OLD.lead_creation_day
            AND notas = CASE WHEN (OLD.pesquisa_satisfacao_cap = '5') OR (OLD.pesquisa_satisfacao_garantia = '5') OR (OLD.pesquisa_satisfacao_fianca = '5') 
                    OR (OLD.pesquisa_satisfacao_cap LIKE '%timo')  OR (OLD.pesquisa_satisfacao_garantia LIKE '%timo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
                WHEN (OLD.pesquisa_satisfacao_cap = '4') OR (OLD.pesquisa_satisfacao_garantia = '4') OR (OLD.pesquisa_satisfacao_fianca = '4') 
                    OR (OLD.pesquisa_satisfacao_cap = 'Bom') OR (OLD.pesquisa_satisfacao_garantia = 'Bom') OR (OLD.pesquisa_satisfacao_fianca = 'Bom') THEN '4'
                WHEN (OLD.pesquisa_satisfacao_cap = '3')  OR (OLD.pesquisa_satisfacao_garantia = '3') OR (OLD.pesquisa_satisfacao_fianca = '3')
                    OR (OLD.pesquisa_satisfacao_cap = 'Regular') OR (OLD.pesquisa_satisfacao_garantia = 'Regular') OR (OLD.pesquisa_satisfacao_fianca = 'Regular') THEN '3'
                WHEN (OLD.pesquisa_satisfacao_cap = '2') OR (OLD.pesquisa_satisfacao_garantia = '2') OR (OLD.pesquisa_satisfacao_fianca = '2')
                    OR (OLD.pesquisa_satisfacao_cap = 'Ruim') OR (OLD.pesquisa_satisfacao_garantia = 'Ruim') OR (OLD.pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
                WHEN (OLD.pesquisa_satisfacao_cap = '1') OR (OLD.pesquisa_satisfacao_garantia = '1') OR (OLD.pesquisa_satisfacao_fianca = '1') 
                    OR (OLD.pesquisa_satisfacao_cap LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_garantia LIKE '%ssimo') OR (OLD.pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
                    ELSE 0 END
            AND assunto = CASE WHEN (OLD.menu_principal_cap IS NOT NULL) THEN OLD.menu_principal_cap 
                WHEN (OLD.menu_principal_fianca IS NOT NULL) THEN OLD.menu_principal_fianca
                WHEN (OLD.menu_principal_garantia IS NOT NULL) THEN OLD.menu_principal_garantia 
                ELSE '-' END
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
INSERT INTO smarkio_portoseguroriscosfinanceiros.satisfacao_count (`date`, `produto`, `assunto`, `notas`,`satisfacao`, `total_satisfacao`, `top_two`, `neutro`, `bottom_box`)
SELECT c.date, c.produto, c.assunto, c.notas, c.satisfacao, c.total_satisfacao, c.top_two, c.neutro, c.bottom_box
FROM 
(
SELECT 
	lead_creation_day AS date,
    (CASE WHEN (menu_principal_cap IS NOT NULL) THEN menu_principal_cap 
		WHEN (menu_principal_fianca IS NOT NULL) THEN menu_principal_fianca
		WHEN (menu_principal_garantia IS NOT NULL) THEN menu_principal_garantia 
		ELSE '-' END) AS assunto,
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
    (CASE WHEN (pesquisa_satisfacao_cap = '5') OR (pesquisa_satisfacao_garantia = '5') OR (pesquisa_satisfacao_fianca = '5') 
        OR (pesquisa_satisfacao_cap LIKE '%timo')  OR (pesquisa_satisfacao_garantia LIKE '%timo') OR (pesquisa_satisfacao_fianca LIKE '%timo') THEN '5'
    WHEN (pesquisa_satisfacao_cap = '4') OR (pesquisa_satisfacao_garantia = '4') OR (pesquisa_satisfacao_fianca = '4') 
        OR (pesquisa_satisfacao_cap = 'Bom') OR (pesquisa_satisfacao_garantia = 'Bom') OR (pesquisa_satisfacao_fianca = 'Bom') THEN '4'
    WHEN (pesquisa_satisfacao_cap = '3')  OR (pesquisa_satisfacao_garantia = '3') OR (pesquisa_satisfacao_fianca = '3')
        OR (pesquisa_satisfacao_cap = 'Regular') OR (pesquisa_satisfacao_garantia = 'Regular') OR (pesquisa_satisfacao_fianca = 'Regular') THEN '3'
    WHEN (pesquisa_satisfacao_cap = '2') OR (pesquisa_satisfacao_garantia = '2') OR (pesquisa_satisfacao_fianca = '2')
        OR (pesquisa_satisfacao_cap = 'Ruim') OR (pesquisa_satisfacao_garantia = 'Ruim') OR (pesquisa_satisfacao_fianca = 'Ruim') THEN '2'
    WHEN (pesquisa_satisfacao_cap = '1') OR (pesquisa_satisfacao_garantia = '1') OR (pesquisa_satisfacao_fianca = '1') 
        OR (pesquisa_satisfacao_cap LIKE '%ssimo') OR (pesquisa_satisfacao_garantia LIKE '%ssimo') OR (pesquisa_satisfacao_fianca LIKE '%ssimo') THEN '1'
        ELSE '0' END) AS notas,
    SUM(CASE WHEN (pesquisa_satisfacao_cap = '5') OR (pesquisa_satisfacao_garantia = '5') OR (pesquisa_satisfacao_fianca = '5') 
        OR (pesquisa_satisfacao_cap LIKE '%timo')  OR (pesquisa_satisfacao_garantia LIKE '%timo') OR (pesquisa_satisfacao_fianca LIKE '%timo') THEN 5
    WHEN (pesquisa_satisfacao_cap = '4') OR (pesquisa_satisfacao_garantia = '4') OR (pesquisa_satisfacao_fianca = '4') 
        OR (pesquisa_satisfacao_cap = 'Bom') OR (pesquisa_satisfacao_garantia = 'Bom') OR (pesquisa_satisfacao_fianca = 'Bom') THEN 4
    WHEN (pesquisa_satisfacao_cap = '3')  OR (pesquisa_satisfacao_garantia = '3') OR (pesquisa_satisfacao_fianca = '3')
        OR (pesquisa_satisfacao_cap = 'Regular') OR (pesquisa_satisfacao_garantia = 'Regular') OR (pesquisa_satisfacao_fianca = 'Regular') THEN 3
    WHEN (pesquisa_satisfacao_cap = '2') OR (pesquisa_satisfacao_garantia = '2') OR (pesquisa_satisfacao_fianca = '2')
        OR (pesquisa_satisfacao_cap = 'Ruim') OR (pesquisa_satisfacao_garantia = 'Ruim') OR (pesquisa_satisfacao_fianca = 'Ruim') THEN 2
    WHEN (pesquisa_satisfacao_cap = '1') OR (pesquisa_satisfacao_garantia = '1') OR (pesquisa_satisfacao_fianca = '1') 
        OR (pesquisa_satisfacao_cap LIKE '%ssimo') OR (pesquisa_satisfacao_garantia LIKE '%ssimo') OR (pesquisa_satisfacao_fianca LIKE '%ssimo') THEN 1
        ELSE 0 END) AS satisfacao,     
	SUM(CASE WHEN ((pesquisa_satisfacao_cap IS NOT NULL) OR (pesquisa_satisfacao_garantia IS NOT NULL) OR (pesquisa_satisfacao_fianca IS NOT NULL)) THEN 1
            ELSE 0 END) AS total_satisfacao,  
    SUM(CASE WHEN (pesquisa_satisfacao_cap = '5') OR (pesquisa_satisfacao_garantia = '5') OR (pesquisa_satisfacao_fianca = '5') 
        OR (pesquisa_satisfacao_cap LIKE '%timo')  OR (pesquisa_satisfacao_garantia LIKE '%timo') OR (pesquisa_satisfacao_fianca LIKE '%timo') THEN 1
        WHEN (pesquisa_satisfacao_cap = '4') OR (pesquisa_satisfacao_garantia = '4') OR (pesquisa_satisfacao_fianca = '4') 
        OR (pesquisa_satisfacao_cap = 'Bom') OR (pesquisa_satisfacao_garantia = 'Bom') OR (pesquisa_satisfacao_fianca = 'Bom') THEN 1
        ELSE 0 END) AS top_two,  
    SUM(CASE WHEN (pesquisa_satisfacao_cap = '3')  OR (pesquisa_satisfacao_garantia = '3') OR (pesquisa_satisfacao_fianca = '3')
        OR (pesquisa_satisfacao_cap = 'Regular') OR (pesquisa_satisfacao_garantia = 'Regular') OR (pesquisa_satisfacao_fianca = 'Regular') THEN 1
    WHEN (pesquisa_satisfacao_cap = '2') OR (pesquisa_satisfacao_garantia = '2') OR (pesquisa_satisfacao_fianca = '2')
        OR (pesquisa_satisfacao_cap = 'Ruim') OR (pesquisa_satisfacao_garantia = 'Ruim') OR (pesquisa_satisfacao_fianca = 'Ruim') THEN 1
            ELSE 0 END) AS neutro,  
    SUM(CASE WHEN (pesquisa_satisfacao_cap = '1') OR (pesquisa_satisfacao_garantia = '1') OR (pesquisa_satisfacao_fianca = '1') 
        OR (pesquisa_satisfacao_cap LIKE '%ssimo') OR (pesquisa_satisfacao_garantia LIKE '%ssimo') OR (pesquisa_satisfacao_fianca LIKE '%ssimo') THEN 1
            ELSE 0 END) AS bottom_box
	FROM smarkio_portoseguroriscosfinanceiros.leads 
    WHERE lead_creation_day between '2021-06-01' and '2021-06-06' 
    AND ((pesquisa_satisfacao_cap IS NOT NULL) OR (pesquisa_satisfacao_garantia IS NOT NULL) OR (pesquisa_satisfacao_fianca IS NOT NULL))
	GROUP BY date, produto, assunto, notas) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `produto` = c.produto,
        `assunto` = c.assunto,
        `notas` = c.notas,
        `satisfacao` = c.satisfacao,
        `total_satisfacao` = c.total_satisfacao,
        `top_two` = c.top_two,
        `neutro` = c.neutro,
        `bottom_box` = c.bottom_box;