 -- SELECT ORIGINAL --
case 
when REGEXP_MATCH(produto, "identidade.*") then "Identidade Protegida"
when REGEXP_MATCH(produto, "cart.*") then "Cartao Protegido"
when REGEXP_MATCH(produto, "fatura.*") then "Fatura Protegida"
when REGEXP_MATCH(produto, "residencial.*") then "Seguro Residencial"
when REGEXP_MATCH(produto, "bolsa.*") then "Bolsa Protegida"
else "0"
end 

 -- TABLE -- 
  CREATE TABLE `smarkio_portomassificado`.`produto_count` (
  `idcampanha` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `campanha` VARCHAR(255) NOT NULL,
  `produto` VARCHAR(255) NOT NULL,
  `cpf` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(255) NOT NULL,
  `validados` INT NULL DEFAULT 0,
  `bolsa` INT NULL DEFAULT 0,
  `cartao` INT NULL DEFAULT 0,
  `fatura` INT NULL DEFAULT 0,
  `identidade` INT NULL DEFAULT 0,
  `seguro` INT NULL DEFAULT 0,
   PRIMARY KEY (`idcampanha`));

-- TRIGGER --
USE smarkio_portomassificado;
DELIMITER |
CREATE TRIGGER tg_produto_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
        SELECT * FROM smarkio_portomassificado.produto_count 
        WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END)=0)
    THEN INSERT INTO smarkio_portomassificado.produto_count
    (date,campanha,produto,cpf,email,phone)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END,
    CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END,CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END,
            CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END,
            CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END);
    END IF;

	IF (NEW.iniciou_chat IS NOT NULL) 
    THEN UPDATE smarkio_portomassificado.produto_count
	    SET validados = validados + 1
    WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END;
    END IF;	

    IF (NEW.confirma_bolsa_protegida = 'Sim')  
	THEN UPDATE smarkio_portomassificado.produto_count
	    SET bolsa = bolsa + 1
    WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END;
    END IF;	

    IF (NEW.confirma_cartao_protegido = 'Quero proteger') THEN 
    UPDATE smarkio_portomassificado.produto_count
	    SET cartao = cartao + 1
    WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END;
    END IF;

    IF (NEW.confirma_fatura_protegida = 'Sim')  
	THEN UPDATE smarkio_portomassificado.produto_count
	    SET fatura = fatura + 1
    WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END;
    END IF;	 

    IF (NEW.confirma_identidade_protegida LIKE 'S%') THEN 
    UPDATE smarkio_portomassificado.produto_count
	    SET identidade = identidade + 1
    WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END;
    END IF;

    IF (NEW.confirma_seguro_residencial = 'Sim')  
	THEN UPDATE smarkio_portomassificado.produto_count
	    SET seguro = seguro + 1
    WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE --
USE smarkio_portomassificado;
DELIMITER |
CREATE TRIGGER tg_produto_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
        SELECT * FROM smarkio_portomassificado.produto_count 
        WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END)=0)
    THEN INSERT INTO smarkio_portomassificado.produto_count
    (date,campanha,produto,cpf,email,phone)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END,
    CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END,CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END,
            CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END,
            CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END);
    END IF;

	IF (NEW.iniciou_chat IS NOT NULL) 
    THEN UPDATE smarkio_portomassificado.produto_count
	    SET validados = validados + 1
    WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END;
    END IF;	

    IF (NEW.confirma_bolsa_protegida = 'Sim')  
	THEN UPDATE smarkio_portomassificado.produto_count
	    SET bolsa = bolsa + 1
    WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END;
    END IF;	

    IF (NEW.confirma_cartao_protegido = 'Quero proteger') THEN 
    UPDATE smarkio_portomassificado.produto_count
	    SET cartao = cartao + 1
    WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END;
    END IF;

    IF (NEW.confirma_fatura_protegida = 'Sim')  
	THEN UPDATE smarkio_portomassificado.produto_count
	    SET fatura = fatura + 1
    WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END;
    END IF;	 

    IF (NEW.confirma_identidade_protegida LIKE 'S%') THEN 
    UPDATE smarkio_portomassificado.produto_count
	    SET identidade = identidade + 1
    WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END;
    END IF;

    IF (NEW.confirma_seguro_residencial = 'Sim')  
	THEN UPDATE smarkio_portomassificado.produto_count
	    SET seguro = seguro + 1
    WHERE date = NEW.lead_creation_day
        AND campanha = CASE WHEN (NEW.utm_medium IS NOT NULL) THEN NEW.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (NEW.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (NEW.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (NEW.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (NEW.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (NEW.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND email = CASE WHEN (NEW.email IS NOT NULL) THEN NEW.email ELSE '-' END
        AND phone = CASE WHEN (NEW.phone IS NOT NULL) THEN NEW.phone ELSE '-' END;
    END IF;


	IF (OLD.iniciou_chat IS NOT NULL) 
    THEN UPDATE smarkio_portomassificado.produto_count
	    SET validados = validados - 1
    WHERE date = OLD.lead_creation_day
        AND campanha = CASE WHEN (OLD.utm_medium IS NOT NULL) THEN OLD.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (OLD.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (OLD.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (OLD.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (OLD.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (OLD.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (OLD.identification_number1 IS NOT NULL) THEN OLD.identification_number1 ELSE '-' END
        AND email = CASE WHEN (OLD.email IS NOT NULL) THEN OLD.email ELSE '-' END
        AND phone = CASE WHEN (OLD.phone IS NOT NULL) THEN OLD.phone ELSE '-' END;
    END IF;	

    IF (OLD.confirma_bolsa_protegida = 'Sim')  
	THEN UPDATE smarkio_portomassificado.produto_count
	    SET bolsa = bolsa - 1
    WHERE date = OLD.lead_creation_day
        AND campanha = CASE WHEN (OLD.utm_medium IS NOT NULL) THEN OLD.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (OLD.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (OLD.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (OLD.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (OLD.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (OLD.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (OLD.identification_number1 IS NOT NULL) THEN OLD.identification_number1 ELSE '-' END
        AND email = CASE WHEN (OLD.email IS NOT NULL) THEN OLD.email ELSE '-' END
        AND phone = CASE WHEN (OLD.phone IS NOT NULL) THEN OLD.phone ELSE '-' END;
    END IF;	

    IF (OLD.confirma_cartao_protegido = 'Quero proteger') THEN 
    UPDATE smarkio_portomassificado.produto_count
	    SET cartao = cartao - 1
    WHERE date = OLD.lead_creation_day
        AND campanha = CASE WHEN (OLD.utm_medium IS NOT NULL) THEN OLD.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (OLD.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (OLD.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (OLD.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (OLD.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (OLD.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (OLD.identification_number1 IS NOT NULL) THEN OLD.identification_number1 ELSE '-' END
        AND email = CASE WHEN (OLD.email IS NOT NULL) THEN OLD.email ELSE '-' END
        AND phone = CASE WHEN (OLD.phone IS NOT NULL) THEN OLD.phone ELSE '-' END;
    END IF;

    IF (OLD.confirma_fatura_protegida = 'Sim')  
	THEN UPDATE smarkio_portomassificado.produto_count
	    SET fatura = fatura - 1
    WHERE date = OLD.lead_creation_day
        AND campanha = CASE WHEN (OLD.utm_medium IS NOT NULL) THEN OLD.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (OLD.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (OLD.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (OLD.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (OLD.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (OLD.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (OLD.identification_number1 IS NOT NULL) THEN OLD.identification_number1 ELSE '-' END
        AND email = CASE WHEN (OLD.email IS NOT NULL) THEN OLD.email ELSE '-' END
        AND phone = CASE WHEN (OLD.phone IS NOT NULL) THEN OLD.phone ELSE '-' END;
    END IF;	 

    IF (OLD.confirma_identidade_protegida LIKE 'S%') THEN 
    UPDATE smarkio_portomassificado.produto_count
	    SET identidade = identidade - 1
    WHERE date = OLD.lead_creation_day
        AND campanha = CASE WHEN (OLD.utm_medium IS NOT NULL) THEN OLD.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (OLD.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (OLD.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (OLD.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (OLD.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (OLD.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (OLD.identification_number1 IS NOT NULL) THEN OLD.identification_number1 ELSE '-' END
        AND email = CASE WHEN (OLD.email IS NOT NULL) THEN OLD.email ELSE '-' END
        AND phone = CASE WHEN (OLD.phone IS NOT NULL) THEN OLD.phone ELSE '-' END;
    END IF;

    IF (OLD.confirma_seguro_residencial = 'Sim')  
	THEN UPDATE smarkio_portomassificado.produto_count
	    SET seguro = seguro - 1
    WHERE date = OLD.lead_creation_day
        AND campanha = CASE WHEN (OLD.utm_medium IS NOT NULL) THEN OLD.utm_medium ELSE '-' END
        AND produto = CASE 
            WHEN (OLD.produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (OLD.produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (OLD.produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (OLD.produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (OLD.produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END 
        AND cpf = CASE WHEN (OLD.identification_number1 IS NOT NULL) THEN OLD.identification_number1 ELSE '-' END
        AND email = CASE WHEN (OLD.email IS NOT NULL) THEN OLD.email ELSE '-' END
        AND phone = CASE WHEN (OLD.phone IS NOT NULL) THEN OLD.phone ELSE '-' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portomassificado.produto_count (`date`, `campanha`, `produto`, `cpf`, `email`, `phone`,`validados`, `bolsa`, `cartao`, `fatura`,`identidade`,`seguro`)
SELECT c.date, c.campanha, c.produto, c.cpf, c.email, c.phone, c.validados, c.bolsa, c.cartao, c.fatura, c.identidade, c.seguro
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (utm_medium IS NOT NULL) THEN utm_medium ELSE '-' END) AS campanha,
    (CASE 
            WHEN (produto LIKE 'identidade%') THEN 'Identidade Protegida'
            WHEN (produto LIKE 'cart%') THEN 'Cartão Protegido'
            WHEN (produto LIKE 'fatura%') THEN 'Fatura Protegida'
            WHEN (produto LIKE 'residencial%') THEN 'Seguro Residencial'
            WHEN (produto LIKE 'bolsa%') THEN 'Bolsa Protegida'
            ELSE '-' END) AS produto,
    (CASE WHEN (identification_number1 IS NOT NULL) THEN identification_number1 ELSE '-' END) AS cpf,
    (CASE WHEN (email IS NOT NULL) THEN email ELSE '-' END) AS email,
    (CASE WHEN (phone IS NOT NULL) THEN phone ELSE '-' END) AS phone,
    SUM(CASE WHEN (iniciou_chat IS NOT NULL) THEN 1 ELSE 0 END) AS validados,
    SUM(CASE WHEN (confirma_bolsa_protegida = 'Sim') THEN 1 ELSE 0 END) AS bolsa,
    SUM(CASE WHEN (confirma_cartao_protegido = 'Quero proteger') THEN 1 ELSE 0 END) AS cartao,
    SUM(CASE WHEN (confirma_fatura_protegida = 'Sim') THEN 1 ELSE 0 END) AS fatura,
    SUM(CASE WHEN (confirma_identidade_protegida LIKE 'S%') THEN 1 ELSE 0 END) AS identidade,
    SUM(CASE WHEN (confirma_seguro_residencial = 'Sim') THEN 1 ELSE 0 END) AS seguro
   	FROM smarkio_portomassificado.leads 
    WHERE lead_creation_day >= '2021-02-01' 
	GROUP BY date, campanha, produto, cpf, email, phone) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `campanha` = c.campanha,
        `produto` = c.produto,
        `cpf` = c.cpf,
        `email` = c.email,
        `phone` = c.phone,
        `validados` = c.validados,
        `bolsa` = c.bolsa,
        `cartao` = c.cartao,
        `fatura` = c.fatura,
        `identidade` = c.identidade,
        `seguro` = c.seguro;