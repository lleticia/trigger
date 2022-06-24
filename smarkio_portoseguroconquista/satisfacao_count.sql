-- SELECT ORIGINAL -- 
case
when REGEXP_MATCH(avaliacao_atendimento,".*timo") then "Top two"
when REGEXP_MATCH(avaliacao_atendimento,"Bom") then "Top two"
when REGEXP_MATCH(avaliacao_atendimento,"Regular") then "Neutro"
when REGEXP_MATCH(avaliacao_atendimento,"Ruim") then "Neutro"
when REGEXP_MATCH(avaliacao_atendimento,".*ssimo") then "Bottom box"
else ""
end

case
when REGEXP_MATCH(avaliacao_atendimento,".*timo") then 5
when REGEXP_MATCH(avaliacao_atendimento,"Bom") then 4
when REGEXP_MATCH(avaliacao_atendimento,"Regular") then 3
when REGEXP_MATCH(avaliacao_atendimento,"Ruim") then 2
when REGEXP_MATCH(avaliacao_atendimento,".*ssimo") then 1
else 0
end

 -- TABLE -- 
  CREATE TABLE `smarkio_portoseguroconquista`.`satisfacao_count` (
  `idsatisfacao` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `satisfacao` VARCHAR(255) NOT NULL,
  `tipo` VARCHAR(255) NOT NULL, 
  `menu`  VARCHAR(255) NOT NULL,
  `total_nota` INT NULL DEFAULT 0,
  `notas` INT NULL DEFAULT 0,
   PRIMARY KEY (`idsatisfacao`));

-- TRIGGER --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_satisfacao_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.avaliacao_atendimento IS NOT NULL) 
        AND (SELECT EXISTS (SELECT * FROM smarkio_portoseguroconquista.satisfacao_count
        WHERE date = NEW.lead_creation_day
        AND satisfacao = CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END
        AND menu = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND tipo = CASE 
            WHEN (NEW.avaliacao_atendimento LIKE '%timo' OR NEW.avaliacao_atendimento = 'Bom') THEN 'Top Two' 
            WHEN (NEW.avaliacao_atendimento = 'Regular' OR NEW.avaliacao_atendimento = 'Ruim') THEN 'Neutro' 
            WHEN (NEW.avaliacao_atendimento LIKE '%ssimo') THEN 'Bottom box' 
            ELSE '-' END)=0))
    THEN INSERT INTO smarkio_portoseguroconquista.satisfacao_count
    (date, satisfacao, menu, tipo)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END,
        CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END,
        CASE WHEN (NEW.avaliacao_atendimento LIKE '%timo' OR NEW.avaliacao_atendimento = 'Bom') THEN 'Top Two' 
            WHEN (NEW.avaliacao_atendimento = 'Regular' OR NEW.avaliacao_atendimento = 'Ruim') THEN 'Neutro' 
            WHEN (NEW.avaliacao_atendimento LIKE '%ssimo') THEN 'Bottom box' 
            ELSE '-' END);
    END IF;

	IF (NEW.avaliacao_atendimento IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.satisfacao_count
	    SET total_nota = total_nota + 1
    WHERE date = NEW.lead_creation_day
        AND satisfacao = CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END
        AND menu = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND tipo = CASE 
            WHEN (NEW.avaliacao_atendimento LIKE '%timo' OR NEW.avaliacao_atendimento = 'Bom') THEN 'Top Two' 
            WHEN (NEW.avaliacao_atendimento = 'Regular' OR NEW.avaliacao_atendimento = 'Ruim') THEN 'Neutro' 
            WHEN (NEW.avaliacao_atendimento LIKE '%ssimo') THEN 'Bottom box' 
            ELSE '-' END;

    UPDATE smarkio_portoseguroconquista.satisfacao_count
	    SET notas = CASE
        WHEN (NEW.avaliacao_atendimento LIKE '%timo') THEN notas + 5
        WHEN (NEW.avaliacao_atendimento = 'Bom') THEN notas + 4
        WHEN (NEW.avaliacao_atendimento = 'Regular') THEN notas + 3
        WHEN (NEW.avaliacao_atendimento = 'Ruim') THEN notas + 2
        WHEN (NEW.avaliacao_atendimento  LIKE '%ssimo') THEN notas + 1
        ELSE notas + 0
        END
    WHERE date = NEW.lead_creation_day
        AND satisfacao = CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END
        AND menu = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND tipo = CASE 
            WHEN (NEW.avaliacao_atendimento LIKE '%timo' OR NEW.avaliacao_atendimento = 'Bom') THEN 'Top Two' 
            WHEN (NEW.avaliacao_atendimento = 'Regular' OR NEW.avaliacao_atendimento = 'Ruim') THEN 'Neutro' 
            WHEN (NEW.avaliacao_atendimento LIKE '%ssimo') THEN 'Bottom box' 
            ELSE '-' END;
    END IF;
END 

-- TRIGGER UPDATE --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_satisfacao_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.avaliacao_atendimento IS NOT NULL) 
        AND (SELECT EXISTS (SELECT * FROM smarkio_portoseguroconquista.satisfacao_count
        WHERE date = NEW.lead_creation_day
        AND satisfacao = CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END
        AND menu = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND tipo = CASE 
            WHEN (NEW.avaliacao_atendimento LIKE '%timo' OR NEW.avaliacao_atendimento = 'Bom') THEN 'Top Two' 
            WHEN (NEW.avaliacao_atendimento = 'Regular' OR NEW.avaliacao_atendimento = 'Ruim') THEN 'Neutro' 
            WHEN (NEW.avaliacao_atendimento LIKE '%ssimo') THEN 'Bottom box' 
            ELSE '-' END)=0))
    THEN INSERT INTO smarkio_portoseguroconquista.satisfacao_count
    (date, satisfacao, menu, tipo)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END,
        CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END,
        CASE WHEN (NEW.avaliacao_atendimento LIKE '%timo' OR NEW.avaliacao_atendimento = 'Bom') THEN 'Top Two' 
            WHEN (NEW.avaliacao_atendimento = 'Regular' OR NEW.avaliacao_atendimento = 'Ruim') THEN 'Neutro' 
            WHEN (NEW.avaliacao_atendimento LIKE '%ssimo') THEN 'Bottom box' 
            ELSE '-' END);
    END IF;

	IF (NEW.avaliacao_atendimento IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.satisfacao_count
	    SET total_nota = total_nota + 1
    WHERE date = NEW.lead_creation_day
        AND satisfacao = CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END
        AND menu = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND tipo = CASE 
            WHEN (NEW.avaliacao_atendimento LIKE '%timo' OR NEW.avaliacao_atendimento = 'Bom') THEN 'Top Two' 
            WHEN (NEW.avaliacao_atendimento = 'Regular' OR NEW.avaliacao_atendimento = 'Ruim') THEN 'Neutro' 
            WHEN (NEW.avaliacao_atendimento LIKE '%ssimo') THEN 'Bottom box' 
            ELSE '-' END;

    UPDATE smarkio_portoseguroconquista.satisfacao_count
	    SET notas = CASE
        WHEN (NEW.avaliacao_atendimento LIKE '%timo') THEN notas + 5
        WHEN (NEW.avaliacao_atendimento = 'Bom') THEN notas + 4
        WHEN (NEW.avaliacao_atendimento = 'Regular') THEN notas + 3
        WHEN (NEW.avaliacao_atendimento = 'Ruim') THEN notas + 2
        WHEN (NEW.avaliacao_atendimento  LIKE '%ssimo') THEN notas + 1
        ELSE notas + 0
        END
    WHERE date = NEW.lead_creation_day
        AND satisfacao = CASE WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN NEW.avaliacao_atendimento ELSE '-' END
        AND menu = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND tipo = CASE 
            WHEN (NEW.avaliacao_atendimento LIKE '%timo' OR NEW.avaliacao_atendimento = 'Bom') THEN 'Top Two' 
            WHEN (NEW.avaliacao_atendimento = 'Regular' OR NEW.avaliacao_atendimento = 'Ruim') THEN 'Neutro' 
            WHEN (NEW.avaliacao_atendimento LIKE '%ssimo') THEN 'Bottom box' 
            ELSE '-' END;
    END IF;

    IF (OLD.avaliacao_atendimento IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.satisfacao_count
	    SET total_nota = total_nota - 1
    WHERE date = OLD.lead_creation_day
        AND satisfacao = CASE WHEN (OLD.avaliacao_atendimento IS NOT NULL) THEN OLD.avaliacao_atendimento ELSE '-' END
        AND menu = CASE WHEN (OLD.assunto IS NOT NULL) THEN OLD.assunto ELSE '-' END
        AND tipo = CASE 
            WHEN (OLD.avaliacao_atendimento LIKE '%timo' OR OLD.avaliacao_atendimento = 'Bom') THEN 'Top Two' 
            WHEN (OLD.avaliacao_atendimento = 'Regular' OR OLD.avaliacao_atendimento = 'Ruim') THEN 'Neutro' 
            WHEN (OLD.avaliacao_atendimento LIKE '%ssimo') THEN 'Bottom box' 
            ELSE '-' END;

    UPDATE smarkio_portoseguroconquista.satisfacao_count
	    SET notas = CASE
        WHEN (OLD.avaliacao_atendimento LIKE '%timo') THEN notas - 5
        WHEN (OLD.avaliacao_atendimento = 'Bom') THEN notas - 4
        WHEN (OLD.avaliacao_atendimento = 'Regular') THEN notas - 3
        WHEN (OLD.avaliacao_atendimento = 'Ruim') THEN notas - 2
        WHEN (OLD.avaliacao_atendimento  LIKE '%ssimo') THEN notas - 1
        ELSE notas - 0
        END
    WHERE date = OLD.lead_creation_day
        AND satisfacao = CASE WHEN (OLD.avaliacao_atendimento IS NOT NULL) THEN OLD.avaliacao_atendimento ELSE '-' END
        AND menu = CASE WHEN (OLD.assunto IS NOT NULL) THEN OLD.assunto ELSE '-' END
        AND tipo = CASE 
            WHEN (OLD.avaliacao_atendimento LIKE '%timo' OR OLD.avaliacao_atendimento = 'Bom') THEN 'Top Two' 
            WHEN (OLD.avaliacao_atendimento = 'Regular' OR OLD.avaliacao_atendimento = 'Ruim') THEN 'Neutro' 
            WHEN (OLD.avaliacao_atendimento LIKE '%ssimo') THEN 'Bottom box' 
            ELSE '-' END;
    END IF;
END 

-- SELECT -- 
INSERT INTO smarkio_portoseguroconquista.satisfacao_count (`date`, `satisfacao`, `menu`, `tipo`, `total_nota`, `notas`)
SELECT c.date, c.satisfacao, c.menu, c.tipo, c.total_nota, c.notas
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (avaliacao_atendimento IS NOT NULL) THEN avaliacao_atendimento ELSE '-' END) AS satisfacao,
    (CASE WHEN (assunto IS NOT NULL) THEN assunto ELSE '-' END) AS menu,
    (CASE WHEN (avaliacao_atendimento LIKE '%timo' OR avaliacao_atendimento = 'Bom') THEN 'Top Two' 
        WHEN (avaliacao_atendimento = 'Regular' OR avaliacao_atendimento = 'Ruim') THEN 'Neutro' 
        WHEN (avaliacao_atendimento LIKE '%ssimo') THEN 'Bottom box' 
        ELSE '-' END) AS tipo,
    SUM(CASE WHEN (avaliacao_atendimento IS NOT NULL) THEN 1 ELSE 0 END) AS total_nota,
    SUM(CASE WHEN (avaliacao_atendimento LIKE '%timo') THEN 5
		WHEN (avaliacao_atendimento = 'Bom') THEN 4
        WHEN (avaliacao_atendimento = 'Regular') THEN 3
        WHEN (avaliacao_atendimento = 'Ruim') THEN 2
        WHEN (avaliacao_atendimento  LIKE '%ssimo') THEN 1
        ELSE 0 END) AS notas
	FROM smarkio_portoseguroconquista.leads 
    WHERE lead_creation_day between '2020-09-19' and '2021-05-17'
    AND avaliacao_atendimento IS NOT NULL
	GROUP BY date, satisfacao, menu, tipo) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `satisfacao` = c.satisfacao,
        `menu` = c.menu,
        `tipo` = c.tipo,
        `total_nota` = c.total_nota,
        `notas` = c.notas;