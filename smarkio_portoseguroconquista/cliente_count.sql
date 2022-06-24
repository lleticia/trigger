-- TABLE -- 
  CREATE TABLE `smarkio_portoseguroconquista`.`cliente_count` (
  `idcliente` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `nome` VARCHAR(255) NOT NULL,
  `cpf` VARCHAR(255) NOT NULL,
  `menu` VARCHAR(255) NOT NULL,
  `produto` VARCHAR(255) NOT NULL,
  `protocolo` VARCHAR(255) NOT NULL,
  `duvida` VARCHAR(255) NOT NULL,
  `nota` VARCHAR(255) NOT NULL,
  `interacao` INT NULL DEFAULT 0,
  `transbordo` INT NULL DEFAULT 0,
   PRIMARY KEY (`idcliente`));

-- TRIGGER --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_cliente_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.assunto IS NOT NULL)
        AND (SELECT EXISTS ( SELECT * FROM smarkio_portoseguroconquista.cliente_count 
        WHERE date = NEW.lead_creation_day
        AND nome = CASE WHEN (NEW.first_name IS NOT NULL) THEN NEW.first_name ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND menu = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END 
        AND produto = CASE WHEN (NEW.pergunta_produto IS NOT NULL) THEN NEW.pergunta_produto ELSE '-' END
        AND protocolo = CASE WHEN (NEW.protocolo IS NOT NULL) THEN NEW.protocolo ELSE '-' END 
        AND duvida = CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END
        AND nota = CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END)=0))

    THEN INSERT INTO smarkio_portoseguroconquista.cliente_count 
    (date, nome, cpf, menu, produto, protocolo, duvida, nota)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.first_name IS NOT NULL) THEN NEW.first_name ELSE '-' END,
        CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END,
        CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END, 
        CASE WHEN (NEW.pergunta_produto IS NOT NULL) THEN NEW.pergunta_produto ELSE '-' END,
        CASE WHEN (NEW.protocolo IS NOT NULL) THEN NEW.protocolo ELSE '-' END,
        CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END,
        CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END);
    END IF;

	IF (NEW.assunto IS NOT NULL) THEN   
    UPDATE smarkio_portoseguroconquista.cliente_count
	    SET interacao = interacao + 1
    WHERE date = NEW.lead_creation_day
        AND nome = CASE WHEN (NEW.first_name IS NOT NULL) THEN NEW.first_name ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND menu = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END 
        AND produto = CASE WHEN (NEW.pergunta_produto IS NOT NULL) THEN NEW.pergunta_produto ELSE '-' END
        AND protocolo = CASE WHEN (NEW.protocolo IS NOT NULL) THEN NEW.protocolo ELSE '-' END 
        AND duvida = CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END
        AND nota = CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END;
    END IF;

    IF (NEW.horario_atendimento = '1') THEN   
    UPDATE smarkio_portoseguroconquista.cliente_count
	    SET transbordo = transbordo + 1
    WHERE date = NEW.lead_creation_day
        AND nome = CASE WHEN (NEW.first_name IS NOT NULL) THEN NEW.first_name ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND menu = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END 
        AND produto = CASE WHEN (NEW.pergunta_produto IS NOT NULL) THEN NEW.pergunta_produto ELSE '-' END
        AND protocolo = CASE WHEN (NEW.protocolo IS NOT NULL) THEN NEW.protocolo ELSE '-' END 
        AND duvida = CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END
        AND nota = CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_cliente_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.assunto IS NOT NULL)
        AND (SELECT EXISTS ( SELECT * FROM smarkio_portoseguroconquista.cliente_count 
        WHERE date = NEW.lead_creation_day
        AND nome = CASE WHEN (NEW.first_name IS NOT NULL) THEN NEW.first_name ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND menu = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END 
        AND produto = CASE WHEN (NEW.pergunta_produto IS NOT NULL) THEN NEW.pergunta_produto ELSE '-' END
        AND protocolo = CASE WHEN (NEW.protocolo IS NOT NULL) THEN NEW.protocolo ELSE '-' END 
        AND duvida = CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END
        AND nota = CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END)=0))

    THEN INSERT INTO smarkio_portoseguroconquista.cliente_count 
    (date, nome, cpf, menu, produto, protocolo, duvida, nota)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.first_name IS NOT NULL) THEN NEW.first_name ELSE '-' END,
        CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END,
        CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END, 
        CASE WHEN (NEW.pergunta_produto IS NOT NULL) THEN NEW.pergunta_produto ELSE '-' END,
        CASE WHEN (NEW.protocolo IS NOT NULL) THEN NEW.protocolo ELSE '-' END,
        CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END,
        CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END);
    END IF;

	IF (NEW.assunto IS NOT NULL) THEN   
    UPDATE smarkio_portoseguroconquista.cliente_count
	    SET interacao = interacao + 1
    WHERE date = NEW.lead_creation_day
        AND nome = CASE WHEN (NEW.first_name IS NOT NULL) THEN NEW.first_name ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND menu = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END 
        AND produto = CASE WHEN (NEW.pergunta_produto IS NOT NULL) THEN NEW.pergunta_produto ELSE '-' END
        AND protocolo = CASE WHEN (NEW.protocolo IS NOT NULL) THEN NEW.protocolo ELSE '-' END 
        AND duvida = CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END
        AND nota = CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END;
    END IF;

    IF (NEW.horario_atendimento = '1') THEN   
    UPDATE smarkio_portoseguroconquista.cliente_count
	    SET transbordo = transbordo + 1
    WHERE date = NEW.lead_creation_day
        AND nome = CASE WHEN (NEW.first_name IS NOT NULL) THEN NEW.first_name ELSE '-' END 
        AND cpf = CASE WHEN (NEW.identification_number1 IS NOT NULL) THEN NEW.identification_number1 ELSE '-' END
        AND menu = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END 
        AND produto = CASE WHEN (NEW.pergunta_produto IS NOT NULL) THEN NEW.pergunta_produto ELSE '-' END
        AND protocolo = CASE WHEN (NEW.protocolo IS NOT NULL) THEN NEW.protocolo ELSE '-' END 
        AND duvida = CASE WHEN (NEW.duvida IS NOT NULL) THEN NEW.duvida ELSE '-' END
        AND nota = CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END;
    END IF;

    IF (OLD.assunto IS NOT NULL) THEN   
    UPDATE smarkio_portoseguroconquista.cliente_count
	    SET interacao = interacao - 1
    WHERE date = OLD.lead_creation_day
        AND nome = CASE WHEN (OLD.first_name IS NOT NULL) THEN OLD.first_name ELSE '-' END 
        AND cpf = CASE WHEN (OLD.identification_number1 IS NOT NULL) THEN OLD.identification_number1 ELSE '-' END
        AND menu = CASE WHEN (OLD.assunto IS NOT NULL) THEN OLD.assunto ELSE '-' END 
        AND produto = CASE WHEN (OLD.pergunta_produto IS NOT NULL) THEN OLD.pergunta_produto ELSE '-' END
        AND protocolo = CASE WHEN (OLD.protocolo IS NOT NULL) THEN OLD.protocolo ELSE '-' END 
        AND duvida = CASE WHEN (OLD.duvida IS NOT NULL) THEN OLD.duvida ELSE '-' END
        AND nota = CASE WHEN (OLD.avaliacao_atendimento IS NOT NULL) THEN OLD.avaliacao_atendimento ELSE '-' END;
    END IF;

    IF (OLD.horario_atendimento = '1') THEN   
    UPDATE smarkio_portoseguroconquista.cliente_count
	    SET transbordo = transbordo - 1
    WHERE date = OLD.lead_creation_day
        AND nome = CASE WHEN (OLD.first_name IS NOT NULL) THEN OLD.first_name ELSE '-' END 
        AND cpf = CASE WHEN (OLD.identification_number1 IS NOT NULL) THEN OLD.identification_number1 ELSE '-' END
        AND menu = CASE WHEN (OLD.assunto IS NOT NULL) THEN OLD.assunto ELSE '-' END 
        AND produto = CASE WHEN (OLD.pergunta_produto IS NOT NULL) THEN OLD.pergunta_produto ELSE '-' END
        AND protocolo = CASE WHEN (OLD.protocolo IS NOT NULL) THEN OLD.protocolo ELSE '-' END 
        AND duvida = CASE WHEN (OLD.duvida IS NOT NULL) THEN OLD.duvida ELSE '-' END
        AND nota = CASE WHEN (OLD.avaliacao_atendimento IS NOT NULL) THEN OLD.avaliacao_atendimento ELSE '-' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portoseguroconquista.cliente_count (`date`, `nome`, `cpf`, `menu`, `produto`, `protocolo`, `duvida`, `nota`, `interacao`, `transbordo`)
SELECT c.date, c.nome, c.cpf, c.menu, c.produto, c.protocolo, c.duvida, c.nota, c.interacao, c.transbordo
FROM (
    SELECT 
	lead_creation_day AS date,
    (CASE WHEN (first_name IS NOT NULL) THEN first_name ELSE '-' END) AS nome,
    (CASE WHEN (identification_number1 IS NOT NULL) THEN identification_number1 ELSE '-' END) AS cpf,
    (CASE WHEN (assunto IS NOT NULL) THEN assunto ELSE '-' END) AS menu,
    (CASE WHEN (pergunta_produto IS NOT NULL) THEN pergunta_produto ELSE '-' END) AS produto,
    (CASE WHEN (protocolo IS NOT NULL) THEN protocolo ELSE '-' END) AS protocolo,
    (CASE WHEN (duvida IS NOT NULL) THEN duvida ELSE '-' END) AS duvida,
    (CASE WHEN (avaliacao_atendimento IS NOT NULL) THEN avaliacao_atendimento ELSE '-' END) AS nota,
    SUM(CASE WHEN (assunto IS NOT NULL) THEN 1 ELSE 0 END) AS interacao,
    SUM(CASE WHEN (horario_atendimento = '1') THEN 1 ELSE 0 END) AS transbordo
	FROM smarkio_portoseguroconquista.leads 
    WHERE lead_creation_day between '2020-09-19' and '2021-05-17'
    AND assunto IS NOT NULL
	GROUP BY date, nome, cpf, menu, produto, protocolo, duvida, nota) AS c
  ON DUPLICATE KEY UPDATE
    `date` = c.date,
    `nome` = c.nome,
    `cpf` = c.cpf,
    `menu` = c.menu,
    `produto` = c.produto,
    `protocolo` = c.protocolo,
    `duvida` = c.duvida,
    `nota` = c.nota,
    `interacao` = c.interacao,
    `transbordo` = c.transbordo;