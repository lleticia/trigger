-- SELECT ORIGINAL -- 
case 
when REGEXP_MATCH(pergunta_produto,"Investimento") then "Investimento"
when REGEXP_MATCH(pergunta_produto,"Cons.* Autom.*") then "Consorcio Automovel"
when regexp_match(pergunta_produto,"Cons.* Im.*") then "Consorcio Imovel"
when REGEXP_MATCH(pergunta_produto,"Vida") then "Vida"
when REGEXP_MATCH(pergunta_produto,"Previd.*") then "Previdencia"
when REGEXP_MATCH(pergunta_produto,"Financiamento") then "Financiamento"
when REGEXP_MATCH(pergunta_produto,"Viagem") then "Viagem"
when REGEXP_MATCH(pergunta_produto,"Cart.* de cr.*") then "Cartao de Credito"
when REGEXP_MATCH(pergunta_produto,"Outros Assuntos") then "Outros Assuntos"
when REGEXP_MATCH(pergunta_produto,"Outros Produtos") then "Outros produtos"
else ""
end

-- TABLE -- 
  CREATE TABLE `smarkio_portoseguroconquista`.`produto_count` (
  `idproduto` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `produto` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
   PRIMARY KEY (`idproduto`));

-- TRIGGER --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_produto_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.pergunta_produto IS NOT NULL)
        AND (SELECT EXISTS ( SELECT * FROM smarkio_portoseguroconquista.produto_count 
        WHERE date = NEW.lead_creation_day
        AND produto = CASE 
        WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
        WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
        WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
        WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
        WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
        WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
        WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
        WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
        ELSE '-' END)=0))

    THEN INSERT INTO smarkio_portoseguroconquista.produto_count 
    (date, produto)
    VALUES (NEW.lead_creation_day,CASE 
        WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
        WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
        WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
        WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
        WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
        WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
        WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
        WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
        ELSE '-' END);
    END IF;

    IF (NEW.pergunta_produto IS NOT NULL) THEN   
    UPDATE smarkio_portoseguroconquista.produto_count
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND produto = CASE 
        WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
        WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
        WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
        WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
        WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
        WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
        WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
        WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
        ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_produto_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.pergunta_produto IS NOT NULL)
        AND (SELECT EXISTS ( SELECT * FROM smarkio_portoseguroconquista.produto_count 
        WHERE date = NEW.lead_creation_day
        AND produto = CASE 
        WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
        WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
        WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
        WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
        WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
        WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
        WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
        WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
        ELSE '-' END)=0))

    THEN INSERT INTO smarkio_portoseguroconquista.produto_count 
    (date, produto)
    VALUES (NEW.lead_creation_day,CASE 
        WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
        WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
        WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
        WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
        WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
        WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
        WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
        WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
        ELSE '-' END);
    END IF;

	IF (NEW.pergunta_produto IS NOT NULL) THEN   
    UPDATE smarkio_portoseguroconquista.produto_count
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND produto = CASE 
        WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
        WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
        WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
        WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
        WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
        WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
        WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
        WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
        ELSE '-' END;
    END IF;

    IF (OLD.pergunta_produto IS NOT NULL) THEN   
    UPDATE smarkio_portoseguroconquista.produto_count
	    SET total = total - 1
    WHERE date = OLD.lead_creation_day
        AND produto = CASE 
        WHEN (OLD.pergunta_produto = 'Investimento') THEN 'Investimento'
        WHEN (OLD.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
        WHEN (OLD.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
        WHEN (OLD.pergunta_produto = 'Viagem') THEN 'Viagem'
        WHEN (OLD.pergunta_produto = 'Financiamento') THEN 'Financiamento'
        WHEN (OLD.pergunta_produto = 'Vida') THEN 'Vida'
        WHEN (OLD.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
        WHEN (OLD.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
        WHEN (OLD.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
        WHEN (OLD.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
        ELSE '-' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portoseguroconquista.produto_count (`date`, `produto`, `total`)
SELECT c.date, c.produto, c.total
FROM (
    SELECT 
	lead_creation_day AS date,
    (CASE 
        WHEN (pergunta_produto = 'Investimento') THEN 'Investimento'
        WHEN (pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
        WHEN (pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
        WHEN (pergunta_produto = 'Viagem') THEN 'Viagem'
        WHEN (pergunta_produto = 'Financiamento') THEN 'Financiamento'
        WHEN (pergunta_produto = 'Vida') THEN 'Vida'
        WHEN (pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
        WHEN (pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
        WHEN (pergunta_produto LIKE 'Previd%') THEN 'Previdência'
        WHEN (pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
        ELSE '-' END) AS produto,
    SUM(CASE WHEN (pergunta_produto IS NOT NULL) THEN 1 ELSE 0 END) AS total
	FROM smarkio_portoseguroconquista.leads 
    WHERE lead_creation_day between '2020-09-19' and '2021-05-17'
    AND pergunta_produto IS NOT NULL
	GROUP BY date, produto) AS c
  ON DUPLICATE KEY UPDATE
    `date` = c.date,
    `produto` = c.produto,
    `total` = c.total;