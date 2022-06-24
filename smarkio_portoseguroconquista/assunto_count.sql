        case 
when regexp_match(horario_atendimento,"1") then 0
when regexp_match(pergunta_produto,"Investimento") then 0
when regexp_match(pergunta_produto,".*rcio Auto.*") then 0
when regexp_match(pergunta_produto,".*rcio .*vel") then 0
when regexp_match(pergunta_produto,"Vida") then 0
when regexp_match(pergunta_produto,"Previd.*") then 0
when regexp_match(pergunta_produto,"Financiamento") then 0
when regexp_match(pergunta_produto,"Viagem")then 0
when regexp_match(pergunta_produto,"Cart.* de .*dito") then 0
when regexp_match(pergunta_produto,"Outros assuntos") then 0
when regexp_match(posso_auxiliar_alguma_consulta,"N.*") then 0
when regexp_match(posso_auxiliar_alguma_consulta,"Sim") then 0
when regexp_match(deseja_continuar_falando,"Desejo Encerrar a conversa") then 0
when regexp_match(avaliacao_atendimento,".*") then 0
when regexp_match(duvida,".*") then 0
when regexp_match(consegui_ajudar,"Sim% conseguiu") then 0
when regexp_match(consegui_ajudar,"N% conseguiu") then 0
else 1
end

sub menu case 
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
  CREATE TABLE `smarkio_portoseguroconquista`.`assunto_count` (
  `idassunto` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `assunto` VARCHAR(255) NOT NULL,
  `submenu` VARCHAR(255) NOT NULL,
  `retencao` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
  `transbordo` INT NULL DEFAULT 0,
  `abandono` INT NULL DEFAULT 0,
   PRIMARY KEY (`idassunto`));

-- TRIGGER --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_assunto_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.assunto IS NOT NULL) 
        AND (SELECT EXISTS (SELECT * FROM smarkio_portoseguroconquista.assunto_count  
        WHERE date = NEW.lead_creation_day
        AND assunto = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND submenu = CASE 
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
            WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
            WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
            WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
            ELSE '-' END
        AND retencao = CASE 
            WHEN (NEW.horario_atendimento = '0') THEN 'Não Resolvido'
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Viagem')then 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
            WHEN (NEW.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
            WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
            WHEN (NEW.duvida IS NOT NULL) THEN 'Não Resolvido'
            ELSE 'Abandono'
            END)=0))

    THEN INSERT INTO smarkio_portoseguroconquista.assunto_count  
    (date, assunto, submenu, retencao)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END,
    CASE WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
        WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
        WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
        WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
        WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
        WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
        WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
        WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
        ELSE '-' END,
    CASE 
        WHEN (NEW.horario_atendimento = '0') THEN 'Não Resolvido'
        WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto = 'Vida') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto = 'Viagem')then 'Resolvido'
        WHEN (NEW.pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
        WHEN (NEW.posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
        WHEN (NEW.posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
        WHEN (NEW.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
        WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
        WHEN (NEW.consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
        WHEN (NEW.consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
        WHEN (NEW.duvida IS NOT NULL) THEN 'Não Resolvido'
        ELSE 'Abandono'
        END);
    END IF;

	IF (NEW.assunto IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.assunto_count  
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND assunto = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND submenu = CASE 
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
            WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
            WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
            WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
            ELSE '-' END
        AND retencao = CASE 
            WHEN (NEW.horario_atendimento = '0') THEN 'Não Resolvido'
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Viagem')then 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
            WHEN (NEW.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
            WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
            WHEN (NEW.duvida IS NOT NULL) THEN 'Não Resolvido'
            ELSE 'Abandono'
            END;

    UPDATE smarkio_portoseguroconquista.assunto_count  
	    SET abandono = CASE 
        WHEN (NEW.horario_atendimento = '1') THEN abandono + 0
        WHEN (NEW.pergunta_produto = 'Investimento') THEN abandono + 0
        WHEN (NEW.pergunta_produto LIKE '%rcio Auto%') THEN abandono + 0
        WHEN (NEW.pergunta_produto LIKE '%rcio %vel') THEN abandono + 0
        WHEN (NEW.pergunta_produto = 'Vida') THEN abandono + 0
        WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN abandono + 0
        WHEN (NEW.pergunta_produto = 'Financiamento') THEN abandono + 0
        WHEN (NEW.pergunta_produto = 'Viagem') THEN abandono + 0
        WHEN (NEW.pergunta_produto LIKE 'Cart% de %dito') THEN abandono + 0
        WHEN (NEW.pergunta_produto = 'Outros assuntos') THEN abandono + 0
        WHEN (NEW.posso_auxiliar_alguma_consulta LIKE 'N%') THEN abandono + 0
        WHEN (NEW.posso_auxiliar_alguma_consulta = 'Sim') THEN abandono + 0
        WHEN (NEW.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN abandono + 0
        WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN abandono + 0
        WHEN (NEW.duvida IS NOT NULL) THEN abandono + 0
        WHEN (NEW.consegui_ajudar LIKE 'Sim% conseguiu') THEN abandono + 0
        WHEN (NEW.consegui_ajudar LIKE 'N% conseguiu') THEN abandono + 0
        ELSE abandono + 1
        END
        WHERE date = NEW.lead_creation_day
        AND assunto = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND submenu = CASE 
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
            WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
            WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
            WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
            ELSE '-' END
        AND retencao = CASE 
            WHEN (NEW.horario_atendimento = '0') THEN 'Não Resolvido'
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Viagem')then 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
            WHEN (NEW.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
            WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
            WHEN (NEW.duvida IS NOT NULL) THEN 'Não Resolvido'
            ELSE 'Abandono'
            END;
    END IF;

    IF (NEW.horario_atendimento = '1') THEN 
    UPDATE smarkio_portoseguroconquista.assunto_count  
	    SET transbordo = transbordo + 1
    WHERE date = NEW.lead_creation_day
        AND assunto = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND submenu = CASE 
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
            WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
            WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
            WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
            ELSE '-' END
        AND retencao = CASE 
            WHEN (NEW.horario_atendimento = '0') THEN 'Não Resolvido'
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Viagem')then 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
            WHEN (NEW.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
            WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
            WHEN (NEW.duvida IS NOT NULL) THEN 'Não Resolvido'
            ELSE 'Abandono'
            END;
    END IF;
END 

-- TRIGGER UPDATE --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_assunto_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    	IF ((NEW.assunto IS NOT NULL) 
        AND (SELECT EXISTS (SELECT * FROM smarkio_portoseguroconquista.assunto_count  
        WHERE date = NEW.lead_creation_day
        AND assunto = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND submenu = CASE 
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
            WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
            WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
            WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
            ELSE '-' END
        AND retencao = CASE 
            WHEN (NEW.horario_atendimento = '0') THEN 'Não Resolvido'
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Viagem')then 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
            WHEN (NEW.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
            WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
            WHEN (NEW.duvida IS NOT NULL) THEN 'Não Resolvido'
            ELSE 'Abandono'
            END)=0))

    THEN INSERT INTO smarkio_portoseguroconquista.assunto_count  
    (date, assunto, submenu, retencao)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END,
    CASE WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
        WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
        WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
        WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
        WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
        WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
        WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
        WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
        WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
        ELSE '-' END,
    CASE 
        WHEN (NEW.horario_atendimento = '0') THEN 'Não Resolvido'
        WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto = 'Vida') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto = 'Viagem')then 'Resolvido'
        WHEN (NEW.pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
        WHEN (NEW.pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
        WHEN (NEW.posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
        WHEN (NEW.posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
        WHEN (NEW.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
        WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
        WHEN (NEW.consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
        WHEN (NEW.consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
        WHEN (NEW.duvida IS NOT NULL) THEN 'Não Resolvido'
        ELSE 'Abandono'
        END);
    END IF;

	IF (NEW.assunto IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.assunto_count  
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND assunto = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND submenu = CASE 
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
            WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
            WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
            WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
            ELSE '-' END
        AND retencao = CASE 
            WHEN (NEW.horario_atendimento = '0') THEN 'Não Resolvido'
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Viagem')then 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
            WHEN (NEW.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
            WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
            WHEN (NEW.duvida IS NOT NULL) THEN 'Não Resolvido'
            ELSE 'Abandono'
            END;

    UPDATE smarkio_portoseguroconquista.assunto_count  
	    SET abandono = CASE 
        WHEN (NEW.horario_atendimento = '1') THEN abandono + 0
        WHEN (NEW.pergunta_produto = 'Investimento') THEN abandono + 0
        WHEN (NEW.pergunta_produto LIKE '%rcio Auto%') THEN abandono + 0
        WHEN (NEW.pergunta_produto LIKE '%rcio %vel') THEN abandono + 0
        WHEN (NEW.pergunta_produto = 'Vida') THEN abandono + 0
        WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN abandono + 0
        WHEN (NEW.pergunta_produto = 'Financiamento') THEN abandono + 0
        WHEN (NEW.pergunta_produto = 'Viagem') THEN abandono + 0
        WHEN (NEW.pergunta_produto LIKE 'Cart% de %dito') THEN abandono + 0
        WHEN (NEW.pergunta_produto = 'Outros assuntos') THEN abandono + 0
        WHEN (NEW.posso_auxiliar_alguma_consulta LIKE 'N%') THEN abandono + 0
        WHEN (NEW.posso_auxiliar_alguma_consulta = 'Sim') THEN abandono + 0
        WHEN (NEW.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN abandono + 0
        WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN abandono + 0
        WHEN (NEW.duvida IS NOT NULL) THEN abandono + 0
        WHEN (NEW.consegui_ajudar LIKE 'Sim% conseguiu') THEN abandono + 0
        WHEN (NEW.consegui_ajudar LIKE 'N% conseguiu') THEN abandono + 0
        ELSE abandono + 1
        END
        WHERE date = NEW.lead_creation_day
        AND assunto = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND submenu = CASE 
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
            WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
            WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
            WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
            ELSE '-' END
        AND retencao = CASE 
            WHEN (NEW.horario_atendimento = '0') THEN 'Não Resolvido'
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Viagem')then 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
            WHEN (NEW.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
            WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
            WHEN (NEW.duvida IS NOT NULL) THEN 'Não Resolvido'
            ELSE 'Abandono'
            END;
    END IF;

    IF (NEW.horario_atendimento = '1') THEN 
    UPDATE smarkio_portoseguroconquista.assunto_count  
	    SET transbordo = transbordo + 1
    WHERE date = NEW.lead_creation_day
        AND assunto = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND submenu = CASE 
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Investimento'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
            WHEN (NEW.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Vida'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Financiamento'
            WHEN (NEW.pergunta_produto = 'Viagem') THEN 'Viagem'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
            WHEN (NEW.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
            WHEN (NEW.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
            ELSE '-' END
        AND retencao = CASE 
            WHEN (NEW.horario_atendimento = '0') THEN 'Não Resolvido'
            WHEN (NEW.pergunta_produto = 'Investimento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Vida') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Financiamento') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Viagem')then 'Resolvido'
            WHEN (NEW.pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
            WHEN (NEW.pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
            WHEN (NEW.posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
            WHEN (NEW.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
            WHEN (NEW.avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
            WHEN (NEW.consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
            WHEN (NEW.duvida IS NOT NULL) THEN 'Não Resolvido'
            ELSE 'Abandono'
            END;
    END IF;
    
	IF (OLD.assunto IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.assunto_count  
	    SET total = total - 1
    WHERE date = OLD.lead_creation_day
        AND assunto = CASE WHEN (OLD.assunto IS NOT NULL) THEN OLD.assunto ELSE '-' END
        AND submenu = CASE 
            WHEN (OLD.pergunta_produto = 'Investimento') THEN 'Investimento'
            WHEN (OLD.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
            WHEN (OLD.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
            WHEN (OLD.pergunta_produto = 'Vida') THEN 'Vida'
            WHEN (OLD.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
            WHEN (OLD.pergunta_produto = 'Financiamento') THEN 'Financiamento'
            WHEN (OLD.pergunta_produto = 'Viagem') THEN 'Viagem'
            WHEN (OLD.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
            WHEN (OLD.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
            WHEN (OLD.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
            ELSE '-' END
        AND retencao = CASE 
            WHEN (OLD.horario_atendimento = '0') THEN 'Não Resolvido'
            WHEN (OLD.pergunta_produto = 'Investimento') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto = 'Vida') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto = 'Financiamento') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto = 'Viagem')then 'Resolvido'
            WHEN (OLD.pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
            WHEN (OLD.posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
            WHEN (OLD.posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
            WHEN (OLD.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
            WHEN (OLD.avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
            WHEN (OLD.consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
            WHEN (OLD.consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
            WHEN (OLD.duvida IS NOT NULL) THEN 'Não Resolvido'
            ELSE 'Abandono'
            END;

    UPDATE smarkio_portoseguroconquista.assunto_count  
	    SET abandono = CASE 
        WHEN (OLD.horario_atendimento = '1') THEN abandono - 0
        WHEN (OLD.pergunta_produto = 'Investimento') THEN abandono - 0
        WHEN (OLD.pergunta_produto LIKE '%rcio Auto%') THEN abandono - 0
        WHEN (OLD.pergunta_produto LIKE '%rcio %vel') THEN abandono - 0
        WHEN (OLD.pergunta_produto = 'Vida') THEN abandono - 0
        WHEN (OLD.pergunta_produto LIKE 'Previd%') THEN abandono - 0
        WHEN (OLD.pergunta_produto = 'Financiamento') THEN abandono - 0
        WHEN (OLD.pergunta_produto = 'Viagem') THEN abandono - 0
        WHEN (OLD.pergunta_produto LIKE 'Cart% de %dito') THEN abandono - 0
        WHEN (OLD.pergunta_produto = 'Outros assuntos') THEN abandono - 0
        WHEN (OLD.posso_auxiliar_alguma_consulta LIKE 'N%') THEN abandono - 0
        WHEN (OLD.posso_auxiliar_alguma_consulta = 'Sim') THEN abandono - 0
        WHEN (OLD.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN abandono - 0
        WHEN (OLD.avaliacao_atendimento IS NOT NULL) THEN abandono - 0
        WHEN (OLD.duvida IS NOT NULL) THEN abandono - 0
        WHEN (OLD.consegui_ajudar LIKE 'Sim% conseguiu') THEN abandono - 0
        WHEN (OLD.consegui_ajudar LIKE 'N% conseguiu') THEN abandono - 0
        ELSE abandono - 1
        END
        WHERE date = OLD.lead_creation_day
        AND assunto = CASE WHEN (OLD.assunto IS NOT NULL) THEN OLD.assunto ELSE '-' END
        AND submenu = CASE 
            WHEN (OLD.pergunta_produto = 'Investimento') THEN 'Investimento'
            WHEN (OLD.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
            WHEN (OLD.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
            WHEN (OLD.pergunta_produto = 'Vida') THEN 'Vida'
            WHEN (OLD.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
            WHEN (OLD.pergunta_produto = 'Financiamento') THEN 'Financiamento'
            WHEN (OLD.pergunta_produto = 'Viagem') THEN 'Viagem'
            WHEN (OLD.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
            WHEN (OLD.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
            WHEN (OLD.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
            ELSE '-' END
        AND retencao = CASE 
            WHEN (OLD.horario_atendimento = '0') THEN 'Não Resolvido'
            WHEN (OLD.pergunta_produto = 'Investimento') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto = 'Vida') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto = 'Financiamento') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto = 'Viagem')then 'Resolvido'
            WHEN (OLD.pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
            WHEN (OLD.posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
            WHEN (OLD.posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
            WHEN (OLD.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
            WHEN (OLD.avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
            WHEN (OLD.consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
            WHEN (OLD.consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
            WHEN (OLD.duvida IS NOT NULL) THEN 'Não Resolvido'
            ELSE 'Abandono'
            END;
    END IF;

    IF (OLD.horario_atendimento = '1') THEN 
    UPDATE smarkio_portoseguroconquista.assunto_count  
	    SET transbordo = transbordo - 1
    WHERE date = OLD.lead_creation_day
        AND assunto = CASE WHEN (OLD.assunto IS NOT NULL) THEN OLD.assunto ELSE '-' END
        AND submenu = CASE 
            WHEN (OLD.pergunta_produto = 'Investimento') THEN 'Investimento'
            WHEN (OLD.pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
            WHEN (OLD.pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
            WHEN (OLD.pergunta_produto = 'Vida') THEN 'Vida'
            WHEN (OLD.pergunta_produto LIKE 'Previd%') THEN 'Previdência'
            WHEN (OLD.pergunta_produto = 'Financiamento') THEN 'Financiamento'
            WHEN (OLD.pergunta_produto = 'Viagem') THEN 'Viagem'
            WHEN (OLD.pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
            WHEN (OLD.pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
            WHEN (OLD.pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
            ELSE '-' END
        AND retencao = CASE 
            WHEN (OLD.horario_atendimento = '0') THEN 'Não Resolvido'
            WHEN (OLD.pergunta_produto = 'Investimento') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto = 'Vida') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto = 'Financiamento') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto = 'Viagem')then 'Resolvido'
            WHEN (OLD.pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
            WHEN (OLD.pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
            WHEN (OLD.posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
            WHEN (OLD.posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
            WHEN (OLD.deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
            WHEN (OLD.avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
            WHEN (OLD.consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
            WHEN (OLD.consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
            WHEN (OLD.duvida IS NOT NULL) THEN 'Não Resolvido'
            ELSE 'Abandono'
            END;
    END IF;
END 

-- SELECT -- 
INSERT INTO smarkio_portoseguroconquista.assunto_count (`date`, `assunto`, `submenu`, `retencao`, `total`, `transbordo`, `abandono`)
SELECT c.date, c.assunto, c.submenu, c.retencao, c.total, c.transbordo, c.abandono
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE WHEN (assunto IS NOT NULL) THEN assunto ELSE '-' END) AS assunto,
    (CASE 
            WHEN (pergunta_produto = 'Investimento') THEN 'Investimento'
            WHEN (pergunta_produto LIKE 'Cons% Autom%') THEN 'Consórcio Automóvel'
            WHEN (pergunta_produto LIKE 'Cons% Im%') THEN 'Consórcio Imóvel'
            WHEN (pergunta_produto = 'Vida') THEN 'Vida'
            WHEN (pergunta_produto LIKE 'Previd%') THEN 'Previdência'
            WHEN (pergunta_produto = 'Financiamento') THEN 'Financiamento'
            WHEN (pergunta_produto = 'Viagem') THEN 'Viagem'
            WHEN (pergunta_produto LIKE 'Cart% de cr%') THEN 'Cartão de Crédito'
            WHEN (pergunta_produto = 'Outros Assuntos') THEN 'Outros Assuntos'
            WHEN (pergunta_produto = 'Outros Produtos') THEN 'Outros Produtos'
            ELSE '-' END) AS submenu,
    (CASE 
            WHEN (horario_atendimento = '0') THEN 'Não Resolvido'
            WHEN (pergunta_produto = 'Investimento') THEN 'Resolvido'
            WHEN (pergunta_produto LIKE '%rcio Auto%') THEN 'Resolvido'
            WHEN (pergunta_produto LIKE '%rcio %vel') THEN 'Resolvido'
            WHEN (pergunta_produto = 'Vida') THEN 'Resolvido'
            WHEN (pergunta_produto LIKE 'Previd%') THEN 'Resolvido'
            WHEN (pergunta_produto = 'Financiamento') THEN 'Resolvido'
            WHEN (pergunta_produto = 'Viagem')then 'Resolvido'
            WHEN (pergunta_produto LIKE 'Cart% de %dito') THEN 'Resolvido'
            WHEN (pergunta_produto = 'Outros assuntos') THEN 'Resolvido'
            WHEN (posso_auxiliar_alguma_consulta LIKE 'N%') THEN 'Resolvido'
            WHEN (posso_auxiliar_alguma_consulta = 'Sim') THEN 'Resolvido'
            WHEN (deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN 'Resolvido'
            WHEN (avaliacao_atendimento IS NOT NULL) THEN 'Resolvido'
            WHEN (consegui_ajudar LIKE 'N% conseguiu') THEN 'Não Resolvido'
            WHEN (consegui_ajudar LIKE 'Sim% conseguiu') THEN 'Resolvido'
            WHEN (duvida IS NOT NULL) THEN 'Não Resolvido'
            ELSE 'Abandono'
            END) AS retencao,
    SUM(CASE WHEN (assunto IS NOT NULL) THEN 1 ELSE 0 END) AS total,
    SUM(CASE WHEN (horario_atendimento = '1') THEN 1 ELSE 0 END) AS transbordo,
    SUM(CASE WHEN (horario_atendimento = '1') THEN  0
        WHEN (pergunta_produto = 'Investimento') THEN  0
        WHEN (pergunta_produto LIKE '%rcio Auto%') THEN  0
        WHEN (pergunta_produto LIKE '%rcio %vel') THEN  0
        WHEN (pergunta_produto = 'Vida') THEN  0
        WHEN (pergunta_produto LIKE 'Previd%') THEN  0
        WHEN (pergunta_produto = 'Financiamento') THEN  0
        WHEN (pergunta_produto = 'Viagem') THEN  0
        WHEN (pergunta_produto LIKE 'Cart% de %dito') THEN  0
        WHEN (pergunta_produto = 'Outros assuntos') THEN  0
        WHEN (posso_auxiliar_alguma_consulta LIKE 'N%') THEN  0
        WHEN (posso_auxiliar_alguma_consulta = 'Sim') THEN  0
        WHEN (deseja_continuar_falando = 'Desejo Encerrar a conversa') THEN  0
        WHEN (avaliacao_atendimento IS NOT NULL) THEN  0
        WHEN (duvida IS NOT NULL) THEN  0
        WHEN (consegui_ajudar LIKE 'Sim% conseguiu') THEN  0
        WHEN (consegui_ajudar LIKE 'N% conseguiu') THEN  0
        ELSE  1 END) AS abandono
	FROM smarkio_portoseguroconquista.leads 
    WHERE lead_creation_day between '2020-09-19' and '2021-05-17'
    AND assunto IS NOT NULL
	GROUP BY date, assunto, submenu,retencao) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `assunto` = c.assunto,
        `submenu` = c.submenu,
        `retencao` = c.retencao,
        `total` = c.total,
        `transbordo` = c.transbordo,
        `abandono` = c.abandono;


