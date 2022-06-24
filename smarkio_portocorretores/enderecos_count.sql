-- SELECT ORIGINAL -- 
endereco_nao_alterado
case 
when REGEXP_MATCH(gostaria, "Corrigir Endere.*") then 0
when REGEXP_MATCH(dados_confirmados, "Sim") then 1
when REGEXP_MATCH(fazer_agora, "Finalizar o atendimento") then 1
else 0
end

endereco_alterado
case 
when REGEXP_MATCH(gostaria, "As informa.* est.* corretas de acordo com o cadastro do cliente.*") then 0
when REGEXP_MATCH(gostaria, "Corrigir Celular") then 0
when REGEXP_MATCH(gostaria, "Corrigir Telefone") then 0
when REGEXP_MATCH(gostaria, "Corrigir Email") then 0
when REGEXP_MATCH(dados_confirmados, "Sim") then 1
when REGEXP_MATCH(fazer_agora, "Finalizar o atendimento") then 1
else 0
end

-- TABLE -- 
  CREATE TABLE `smarkio_portocorretores`.`endereco_count` (
  `idendereco` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `browser` VARCHAR(255) NOT NULL,
  `endereco_alterado` INT NULL DEFAULT 0,
  `endereco_nao_alterado` INT NULL DEFAULT 0,
   PRIMARY KEY (`idendereco`));

-- TRIGGER --
USE smarkio_portocorretores;
DELIMITER |
CREATE TRIGGER tg_endereco_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF (SELECT EXISTS (
			SELECT * FROM smarkio_portocorretores.endereco_count 
			WHERE date = NEW.lead_creation_day
			AND browser = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END)=0)

    THEN INSERT INTO smarkio_portocorretores.endereco_count
    (date,browser)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END);
    END IF;

	IF ((NEW.gostaria IS NOT NULL) OR (NEW.dados_confirmados IS NOT NULL) OR (NEW.fazer_agora IS NOT NULL))
    THEN UPDATE smarkio_portocorretores.endereco_count
		SET endereco_alterado = CASE 
            WHEN (NEW.gostaria LIKE 'As informa% est% corretas de acordo com o cadastro do cliente%') THEN endereco_alterado + 0
            WHEN (NEW.gostaria = 'Corrigir Celular') THEN endereco_alterado + 0
            WHEN (NEW.gostaria = 'Corrigir Telefone') THEN endereco_alterado + 0
            WHEN (NEW.gostaria = 'Corrigir Email') THEN endereco_alterado + 0
            WHEN (NEW.dados_confirmados = 'Sim') THEN endereco_alterado + 1
            WHEN (NEW.fazer_agora = 'Finalizar o atendimento') THEN endereco_alterado + 1
            ELSE endereco_alterado + 0 END
    WHERE date = NEW.lead_creation_day
        AND browser = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END;

    UPDATE smarkio_portocorretores.endereco_count
		SET endereco_nao_alterado = CASE 
            WHEN (NEW.gostaria LIKE 'Corrigir Endere%') THEN endereco_nao_alterado + 0
            WHEN (NEW.dados_confirmados = 'Sim') THEN endereco_nao_alterado + 1
            WHEN (NEW.fazer_agora = 'Finalizar o atendimento') THEN endereco_nao_alterado + 1
            ELSE endereco_nao_alterado + 0 END
    WHERE date = NEW.lead_creation_day
        AND browser = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE -- 
USE smarkio_portocorretores;
DELIMITER |
CREATE TRIGGER tg_endereco_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN	
    IF (SELECT EXISTS (
			SELECT * FROM smarkio_portocorretores.endereco_count 
			WHERE date = NEW.lead_creation_day
			AND browser = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END)=0)

    THEN INSERT INTO smarkio_portocorretores.endereco_count
    (date,browser)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END);
    END IF;

	IF ((NEW.gostaria IS NOT NULL) OR (NEW.dados_confirmados IS NOT NULL) OR (NEW.fazer_agora IS NOT NULL))
    THEN UPDATE smarkio_portocorretores.endereco_count
		SET endereco_alterado = CASE 
            WHEN (NEW.gostaria LIKE 'As informa% est% corretas de acordo com o cadastro do cliente%') THEN endereco_alterado + 0
            WHEN (NEW.gostaria = 'Corrigir Celular') THEN endereco_alterado + 0
            WHEN (NEW.gostaria = 'Corrigir Telefone') THEN endereco_alterado + 0
            WHEN (NEW.gostaria = 'Corrigir Email') THEN endereco_alterado + 0
            WHEN (NEW.dados_confirmados = 'Sim') THEN endereco_alterado + 1
            WHEN (NEW.fazer_agora = 'Finalizar o atendimento') THEN endereco_alterado + 1
            ELSE endereco_alterado + 0 END
    WHERE date = NEW.lead_creation_day
        AND browser = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END;

    UPDATE smarkio_portocorretores.endereco_count
		SET endereco_nao_alterado = CASE 
            WHEN (NEW.gostaria LIKE 'Corrigir Endere%') THEN endereco_nao_alterado + 0
            WHEN (NEW.dados_confirmados = 'Sim') THEN endereco_nao_alterado + 1
            WHEN (NEW.fazer_agora = 'Finalizar o atendimento') THEN endereco_nao_alterado + 1
            ELSE endereco_nao_alterado + 0 END
    WHERE date = NEW.lead_creation_day
        AND browser = CASE WHEN (NEW.browser IS NOT NULL) THEN NEW.browser ELSE '-' END;
    END IF;

    IF ((OLD.gostaria IS NOT NULL) OR (OLD.dados_confirmados IS NOT NULL) OR (OLD.fazer_agora IS NOT NULL))
    THEN UPDATE smarkio_portocorretores.endereco_count
		SET endereco_alterado = CASE 
            WHEN (OLD.gostaria LIKE 'As informa% est% corretas de acordo com o cadastro do cliente%') THEN endereco_alterado - 0
            WHEN (OLD.gostaria = 'Corrigir Celular') THEN endereco_alterado - 0
            WHEN (OLD.gostaria = 'Corrigir Telefone') THEN endereco_alterado - 0
            WHEN (OLD.gostaria = 'Corrigir Email') THEN endereco_alterado - 0
            WHEN (OLD.dados_confirmados = 'Sim') THEN endereco_alterado - 1
            WHEN (OLD.fazer_agora = 'Finalizar o atendimento') THEN endereco_alterado - 1
            ELSE endereco_alterado - 0 END
    WHERE date = OLD.lead_creation_day
        AND browser = CASE WHEN (OLD.browser IS NOT NULL) THEN OLD.browser ELSE '-' END;

    UPDATE smarkio_portocorretores.endereco_count
		SET endereco_nao_alterado = CASE 
            WHEN (OLD.gostaria LIKE 'Corrigir Endere%') THEN endereco_nao_alterado - 0
            WHEN (OLD.dados_confirmados = 'Sim') THEN endereco_nao_alterado - 1
            WHEN (OLD.fazer_agora = 'Finalizar o atendimento') THEN endereco_nao_alterado - 1
            ELSE endereco_nao_alterado - 0 END
    WHERE date = OLD.lead_creation_day
        AND browser = CASE WHEN (OLD.browser IS NOT NULL) THEN OLD.browser ELSE '-' END;
    END IF;
END

-- SELECT -- 
INSERT INTO smarkio_portocorretores.endereco_count (`date`, `browser`, `endereco_alterado`, `endereco_nao_alterado`)
SELECT c.date, c.browser, c.endereco_alterado, c.endereco_nao_alterado
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (browser IS NOT NULL) THEN browser ELSE '-' END) as browser,
    SUM(CASE WHEN (gostaria LIKE 'As informa% est% corretas de acordo com o cadastro do cliente%') THEN 0
        WHEN (gostaria = 'Corrigir Celular') THEN 0
        WHEN (gostaria = 'Corrigir Telefone') THEN 0
        WHEN (gostaria = 'Corrigir Email') THEN 0
        WHEN (dados_confirmados = 'Sim') THEN 1
        WHEN (fazer_agora = 'Finalizar o atendimento') THEN 1
        ELSE 0 END) AS endereco_alterado,
    SUM(CASE WHEN (gostaria LIKE 'Corrigir Endere%') THEN 0
        WHEN (dados_confirmados = 'Sim') THEN 1
        WHEN (fazer_agora = 'Finalizar o atendimento') THEN 1
        ELSE 0 END) AS endereco_nao_alterado
	FROM smarkio_portocorretores.leads 
    WHERE lead_creation_day >= '2021-02-01'
        AND (gostaria IS NOT NULL OR dados_confirmados IS NOT NULL OR fazer_agora IS NOT NULL)
		GROUP BY date, browser) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `browser` = c.browser,
        `endereco_alterado` = c.endereco_alterado,
        `endereco_nao_alterado` = c.endereco_nao_alterado;