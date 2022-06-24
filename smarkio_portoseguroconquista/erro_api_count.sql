case
when REGEXP_MATCH(erro_api,"100") then "Continuar"
when REGEXP_MATCH(erro_api,"101") then "Mudando Protocolos"
when REGEXP_MATCH(erro_api,"102") then "Processando"
when REGEXP_MATCH(erro_api,"201") then "Criado"
when REGEXP_MATCH(erro_api,"203") then "Nao autorizado"
when REGEXP_MATCH(erro_api,"204") then "Nenhum conteudo"
when REGEXP_MATCH(erro_api,"205") then "Resetar conteudo"
when REGEXP_MATCH(erro_api,"206") then "Conteudo Parcial"
when REGEXP_MATCH(erro_api,"300") then "Multipla Escolha"
when REGEXP_MATCH(erro_api,"301") then "Movido Permanentemente"
when REGEXP_MATCH(erro_api,"302") then "Encontrado"
when REGEXP_MATCH(erro_api,"303") then "Veja Outro"
when REGEXP_MATCH(erro_api,"304") then "Nao Modificado"
when REGEXP_MATCH(erro_api,"305") then "Use Proxy"
when REGEXP_MATCH(erro_api,"306") then "Proxy Trocado"
when REGEXP_MATCH(erro_api,"400") then "Solicitacao Invalida"
when REGEXP_MATCH(erro_api,"401") then "Nao autorizado"
when REGEXP_MATCH(erro_api,"402") then "Pagamento necessario"
when REGEXP_MATCH(erro_api,"403") then "Proibido"
when REGEXP_MATCH(erro_api,"404") then "Nao encontrado"
when REGEXP_MATCH(erro_api,"405") then "Metodo nao Permitido"
when REGEXP_MATCH(erro_api,"406") then "Nao aceito"
when REGEXP_MATCH(erro_api,"407") then "autenticacao de Proxy Necessaria"
when REGEXP_MATCH(erro_api,"408") then "Tempo de solicitacao esgotado"
when REGEXP_MATCH(erro_api,"409") then "Conflito"
when REGEXP_MATCH(erro_api,"410") then "Perdido"
when REGEXP_MATCH(erro_api,"411") then "Duracao necessaria"
when REGEXP_MATCH(erro_api,"412") then "Falha de pre condicao"
when REGEXP_MATCH(erro_api,"413") then "Solicitacao da entidade muito extensa"
when REGEXP_MATCH(erro_api,"414") then "Solicitacao de URL muito Longa"
when REGEXP_MATCH(erro_api,"415") then "Tipo de midia nao suportado"
when REGEXP_MATCH(erro_api,"416") then "Solicitacao de faixa nao satisfatorio"
when REGEXP_MATCH(erro_api,"417") then "Falha na expectativa"
when REGEXP_MATCH(erro_api,"500") then "Erro do servidor Interno"
when REGEXP_MATCH(erro_api,"501") then "Nao implementado"
when REGEXP_MATCH(erro_api,"502") then "Portal de entrada ruim"
when REGEXP_MATCH(erro_api,"503") then "Servico indisponivel"
when REGEXP_MATCH(erro_api,"504") then "Tempo limite da Porta de Entrada"
when REGEXP_MATCH(erro_api,"505") then "Versap HTTP nao suportada"
else "Erro nao listado"
end

-- TABLE -- 
  CREATE TABLE `smarkio_portoseguroconquista`.`erro_api_count` (
  `iderro_api` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `retorno` VARCHAR(255) NOT NULL,
  `assunto` VARCHAR(255) NOT NULL,
  `funcao_api` VARCHAR(255) NOT NULL,
  `total` INT NULL DEFAULT 0,
   PRIMARY KEY (`iderro_api`));

-- TRIGGER --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_erro_api_in AFTER INSERT ON leads
FOR EACH ROW
BEGIN
	IF ((NEW.erro_api IS NOT NULL) 
        AND (NEW.funcao_api IS NOT NULL)
        AND (NEW.assunto IS NOT NULL)
        AND (SELECT EXISTS (SELECT * FROM smarkio_portoseguroconquista.erro_api_count  
            WHERE date = NEW.lead_creation_day
            AND assunto = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
            AND funcao_api = CASE WHEN (NEW.funcao_api IS NOT NULL) THEN NEW.funcao_api ELSE '-' END
            AND retorno = CASE
            WHEN (NEW.erro_api = '100') THEN 'Continuar'
            WHEN (NEW.erro_api = '101') THEN 'Mudando protocolos'
            WHEN (NEW.erro_api = '102') THEN 'Processando'
            WHEN (NEW.erro_api = '201') THEN 'Criado'
            WHEN (NEW.erro_api = '203') THEN 'Não autorizado'
            WHEN (NEW.erro_api = '204') THEN 'Nenhum conteúdo'
            WHEN (NEW.erro_api = '205') THEN 'Resetar conteúdo'
            WHEN (NEW.erro_api = '206') THEN 'Conteúdo parcial'
            WHEN (NEW.erro_api = '300') THEN 'Múltipla escolha'
            WHEN (NEW.erro_api = '301') THEN 'Movido permanentemente'
            WHEN (NEW.erro_api = '302') THEN 'Encontrado'
            WHEN (NEW.erro_api = '303') THEN 'Veja outro'
            WHEN (NEW.erro_api = '304') THEN 'Não modificado'
            WHEN (NEW.erro_api = '305') THEN 'Use proxy'
            WHEN (NEW.erro_api = '306') THEN 'Proxy trocado'
            WHEN (NEW.erro_api = '400') THEN 'Solicitação inválida'
            WHEN (NEW.erro_api = '401') THEN 'Não autorizado'
            WHEN (NEW.erro_api = '402') THEN 'Pagamento necessário'
            WHEN (NEW.erro_api = '403') THEN 'Proibido'
            WHEN (NEW.erro_api = '404') THEN 'Não encontrado'
            WHEN (NEW.erro_api = '405') THEN 'Método não permitido'
            WHEN (NEW.erro_api = '406') THEN 'Não aceito'
            WHEN (NEW.erro_api = '407') THEN 'Autenticacão de proxy necessária'
            WHEN (NEW.erro_api = '408') THEN 'Tempo de solicitação esgotado'
            WHEN (NEW.erro_api = '409') THEN 'Conflito'
            WHEN (NEW.erro_api = '410') THEN 'Perdido'
            WHEN (NEW.erro_api = '411') THEN 'Duração necessária'
            WHEN (NEW.erro_api = '412') THEN 'Falha de pré condição'
            WHEN (NEW.erro_api = '413') THEN 'Solicitação da entidade muito extensa'
            WHEN (NEW.erro_api = '414') THEN 'Solicitação de URL muito longa'
            WHEN (NEW.erro_api = '415') THEN 'Tipo de mídia não suportado'
            WHEN (NEW.erro_api = '416') THEN 'Solicitação de faixa não satisfatória'
            WHEN (NEW.erro_api = '417') THEN 'Falha na expectativa'
            WHEN (NEW.erro_api = '500') THEN 'Erro do servidor interno'
            WHEN (NEW.erro_api = '501') THEN 'Não implementado'
            WHEN (NEW.erro_api = '502') THEN 'Portal de entrada ruim'
            WHEN (NEW.erro_api = '503') THEN 'Serviço indisponível'
            WHEN (NEW.erro_api = '504') THEN 'Tempo limite da porta de entrada'
            WHEN (NEW.erro_api = '505') THEN 'Versão HTTP não suportada'
            ELSE 'Erro não listado'
            END)=0))

    THEN INSERT INTO smarkio_portoseguroconquista.erro_api_count  
    (date, assunto, funcao_api,retorno)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END,
        CASE WHEN (NEW.funcao_api IS NOT NULL) THEN NEW.funcao_api ELSE '-' END,
        CASE WHEN (NEW.erro_api = '100') THEN 'Continuar'
            WHEN (NEW.erro_api = '101') THEN 'Mudando protocolos'
            WHEN (NEW.erro_api = '102') THEN 'Processando'
            WHEN (NEW.erro_api = '201') THEN 'Criado'
            WHEN (NEW.erro_api = '203') THEN 'Não autorizado'
            WHEN (NEW.erro_api = '204') THEN 'Nenhum conteúdo'
            WHEN (NEW.erro_api = '205') THEN 'Resetar conteúdo'
            WHEN (NEW.erro_api = '206') THEN 'Conteúdo parcial'
            WHEN (NEW.erro_api = '300') THEN 'Múltipla escolha'
            WHEN (NEW.erro_api = '301') THEN 'Movido permanentemente'
            WHEN (NEW.erro_api = '302') THEN 'Encontrado'
            WHEN (NEW.erro_api = '303') THEN 'Veja outro'
            WHEN (NEW.erro_api = '304') THEN 'Não modificado'
            WHEN (NEW.erro_api = '305') THEN 'Use proxy'
            WHEN (NEW.erro_api = '306') THEN 'Proxy trocado'
            WHEN (NEW.erro_api = '400') THEN 'Solicitação inválida'
            WHEN (NEW.erro_api = '401') THEN 'Não autorizado'
            WHEN (NEW.erro_api = '402') THEN 'Pagamento necessário'
            WHEN (NEW.erro_api = '403') THEN 'Proibido'
            WHEN (NEW.erro_api = '404') THEN 'Não encontrado'
            WHEN (NEW.erro_api = '405') THEN 'Método não permitido'
            WHEN (NEW.erro_api = '406') THEN 'Não aceito'
            WHEN (NEW.erro_api = '407') THEN 'Autenticacão de proxy necessária'
            WHEN (NEW.erro_api = '408') THEN 'Tempo de solicitação esgotado'
            WHEN (NEW.erro_api = '409') THEN 'Conflito'
            WHEN (NEW.erro_api = '410') THEN 'Perdido'
            WHEN (NEW.erro_api = '411') THEN 'Duração necessária'
            WHEN (NEW.erro_api = '412') THEN 'Falha de pré condição'
            WHEN (NEW.erro_api = '413') THEN 'Solicitação da entidade muito extensa'
            WHEN (NEW.erro_api = '414') THEN 'Solicitação de URL muito longa'
            WHEN (NEW.erro_api = '415') THEN 'Tipo de mídia não suportado'
            WHEN (NEW.erro_api = '416') THEN 'Solicitação de faixa não satisfatória'
            WHEN (NEW.erro_api = '417') THEN 'Falha na expectativa'
            WHEN (NEW.erro_api = '500') THEN 'Erro do servidor interno'
            WHEN (NEW.erro_api = '501') THEN 'Não implementado'
            WHEN (NEW.erro_api = '502') THEN 'Portal de entrada ruim'
            WHEN (NEW.erro_api = '503') THEN 'Serviço indisponível'
            WHEN (NEW.erro_api = '504') THEN 'Tempo limite da porta de entrada'
            WHEN (NEW.erro_api = '505') THEN 'Versão HTTP não suportada'
            ELSE 'Erro não listado' END);
    END IF;

	IF (NEW.erro_api IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.erro_api_count  
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND assunto = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND funcao_api = CASE WHEN (NEW.funcao_api IS NOT NULL) THEN NEW.funcao_api ELSE '-' END
        AND retorno = CASE
            WHEN (NEW.erro_api = '100') THEN 'Continuar'
            WHEN (NEW.erro_api = '101') THEN 'Mudando protocolos'
            WHEN (NEW.erro_api = '102') THEN 'Processando'
            WHEN (NEW.erro_api = '201') THEN 'Criado'
            WHEN (NEW.erro_api = '203') THEN 'Não autorizado'
            WHEN (NEW.erro_api = '204') THEN 'Nenhum conteúdo'
            WHEN (NEW.erro_api = '205') THEN 'Resetar conteúdo'
            WHEN (NEW.erro_api = '206') THEN 'Conteúdo parcial'
            WHEN (NEW.erro_api = '300') THEN 'Múltipla escolha'
            WHEN (NEW.erro_api = '301') THEN 'Movido permanentemente'
            WHEN (NEW.erro_api = '302') THEN 'Encontrado'
            WHEN (NEW.erro_api = '303') THEN 'Veja outro'
            WHEN (NEW.erro_api = '304') THEN 'Não modificado'
            WHEN (NEW.erro_api = '305') THEN 'Use proxy'
            WHEN (NEW.erro_api = '306') THEN 'Proxy trocado'
            WHEN (NEW.erro_api = '400') THEN 'Solicitação inválida'
            WHEN (NEW.erro_api = '401') THEN 'Não autorizado'
            WHEN (NEW.erro_api = '402') THEN 'Pagamento necessário'
            WHEN (NEW.erro_api = '403') THEN 'Proibido'
            WHEN (NEW.erro_api = '404') THEN 'Não encontrado'
            WHEN (NEW.erro_api = '405') THEN 'Método não permitido'
            WHEN (NEW.erro_api = '406') THEN 'Não aceito'
            WHEN (NEW.erro_api = '407') THEN 'Autenticacão de proxy necessária'
            WHEN (NEW.erro_api = '408') THEN 'Tempo de solicitação esgotado'
            WHEN (NEW.erro_api = '409') THEN 'Conflito'
            WHEN (NEW.erro_api = '410') THEN 'Perdido'
            WHEN (NEW.erro_api = '411') THEN 'Duração necessária'
            WHEN (NEW.erro_api = '412') THEN 'Falha de pré condição'
            WHEN (NEW.erro_api = '413') THEN 'Solicitação da entidade muito extensa'
            WHEN (NEW.erro_api = '414') THEN 'Solicitação de URL muito longa'
            WHEN (NEW.erro_api = '415') THEN 'Tipo de mídia não suportado'
            WHEN (NEW.erro_api = '416') THEN 'Solicitação de faixa não satisfatória'
            WHEN (NEW.erro_api = '417') THEN 'Falha na expectativa'
            WHEN (NEW.erro_api = '500') THEN 'Erro do servidor interno'
            WHEN (NEW.erro_api = '501') THEN 'Não implementado'
            WHEN (NEW.erro_api = '502') THEN 'Portal de entrada ruim'
            WHEN (NEW.erro_api = '503') THEN 'Serviço indisponível'
            WHEN (NEW.erro_api = '504') THEN 'Tempo limite da porta de entrada'
            WHEN (NEW.erro_api = '505') THEN 'Versão HTTP não suportada'
            ELSE 'Erro não listado'
            END;
    END IF;
END 

-- TRIGGER UPDATE --
USE smarkio_portoseguroconquista;
DELIMITER |
CREATE TRIGGER tg_erro_api_up AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF ((NEW.erro_api IS NOT NULL) 
        AND (NEW.funcao_api IS NOT NULL)
        AND (NEW.assunto IS NOT NULL)
        AND (SELECT EXISTS (SELECT * FROM smarkio_portoseguroconquista.erro_api_count  
        WHERE date = NEW.lead_creation_day
        AND assunto = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND funcao_api = CASE WHEN (NEW.funcao_api IS NOT NULL) THEN NEW.funcao_api ELSE '-' END
        AND retorno = CASE
            WHEN (NEW.erro_api = '100') THEN 'Continuar'
            WHEN (NEW.erro_api = '101') THEN 'Mudando protocolos'
            WHEN (NEW.erro_api = '102') THEN 'Processando'
            WHEN (NEW.erro_api = '201') THEN 'Criado'
            WHEN (NEW.erro_api = '203') THEN 'Não autorizado'
            WHEN (NEW.erro_api = '204') THEN 'Nenhum conteúdo'
            WHEN (NEW.erro_api = '205') THEN 'Resetar conteúdo'
            WHEN (NEW.erro_api = '206') THEN 'Conteúdo parcial'
            WHEN (NEW.erro_api = '300') THEN 'Múltipla escolha'
            WHEN (NEW.erro_api = '301') THEN 'Movido permanentemente'
            WHEN (NEW.erro_api = '302') THEN 'Encontrado'
            WHEN (NEW.erro_api = '303') THEN 'Veja outro'
            WHEN (NEW.erro_api = '304') THEN 'Não modificado'
            WHEN (NEW.erro_api = '305') THEN 'Use proxy'
            WHEN (NEW.erro_api = '306') THEN 'Proxy trocado'
            WHEN (NEW.erro_api = '400') THEN 'Solicitação inválida'
            WHEN (NEW.erro_api = '401') THEN 'Não autorizado'
            WHEN (NEW.erro_api = '402') THEN 'Pagamento necessário'
            WHEN (NEW.erro_api = '403') THEN 'Proibido'
            WHEN (NEW.erro_api = '404') THEN 'Não encontrado'
            WHEN (NEW.erro_api = '405') THEN 'Método não permitido'
            WHEN (NEW.erro_api = '406') THEN 'Não aceito'
            WHEN (NEW.erro_api = '407') THEN 'Autenticacão de proxy necessária'
            WHEN (NEW.erro_api = '408') THEN 'Tempo de solicitação esgotado'
            WHEN (NEW.erro_api = '409') THEN 'Conflito'
            WHEN (NEW.erro_api = '410') THEN 'Perdido'
            WHEN (NEW.erro_api = '411') THEN 'Duração necessária'
            WHEN (NEW.erro_api = '412') THEN 'Falha de pré condição'
            WHEN (NEW.erro_api = '413') THEN 'Solicitação da entidade muito extensa'
            WHEN (NEW.erro_api = '414') THEN 'Solicitação de URL muito longa'
            WHEN (NEW.erro_api = '415') THEN 'Tipo de mídia não suportado'
            WHEN (NEW.erro_api = '416') THEN 'Solicitação de faixa não satisfatória'
            WHEN (NEW.erro_api = '417') THEN 'Falha na expectativa'
            WHEN (NEW.erro_api = '500') THEN 'Erro do servidor interno'
            WHEN (NEW.erro_api = '501') THEN 'Não implementado'
            WHEN (NEW.erro_api = '502') THEN 'Portal de entrada ruim'
            WHEN (NEW.erro_api = '503') THEN 'Serviço indisponível'
            WHEN (NEW.erro_api = '504') THEN 'Tempo limite da porta de entrada'
            WHEN (NEW.erro_api = '505') THEN 'Versão HTTP não suportada'
            ELSE 'Erro não listado'
            END)=0))

    THEN INSERT INTO smarkio_portoseguroconquista.erro_api_count  
    (date, assunto, funcao_api,retorno)
    VALUES (NEW.lead_creation_day,CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END,
        CASE WHEN (NEW.funcao_api IS NOT NULL) THEN NEW.funcao_api ELSE '-' END,
        CASE WHEN (NEW.erro_api = '100') THEN 'Continuar'
            WHEN (NEW.erro_api = '101') THEN 'Mudando protocolos'
            WHEN (NEW.erro_api = '102') THEN 'Processando'
            WHEN (NEW.erro_api = '201') THEN 'Criado'
            WHEN (NEW.erro_api = '203') THEN 'Não autorizado'
            WHEN (NEW.erro_api = '204') THEN 'Nenhum conteúdo'
            WHEN (NEW.erro_api = '205') THEN 'Resetar conteúdo'
            WHEN (NEW.erro_api = '206') THEN 'Conteúdo parcial'
            WHEN (NEW.erro_api = '300') THEN 'Múltipla escolha'
            WHEN (NEW.erro_api = '301') THEN 'Movido permanentemente'
            WHEN (NEW.erro_api = '302') THEN 'Encontrado'
            WHEN (NEW.erro_api = '303') THEN 'Veja outro'
            WHEN (NEW.erro_api = '304') THEN 'Não modificado'
            WHEN (NEW.erro_api = '305') THEN 'Use proxy'
            WHEN (NEW.erro_api = '306') THEN 'Proxy trocado'
            WHEN (NEW.erro_api = '400') THEN 'Solicitação inválida'
            WHEN (NEW.erro_api = '401') THEN 'Não autorizado'
            WHEN (NEW.erro_api = '402') THEN 'Pagamento necessário'
            WHEN (NEW.erro_api = '403') THEN 'Proibido'
            WHEN (NEW.erro_api = '404') THEN 'Não encontrado'
            WHEN (NEW.erro_api = '405') THEN 'Método não permitido'
            WHEN (NEW.erro_api = '406') THEN 'Não aceito'
            WHEN (NEW.erro_api = '407') THEN 'Autenticacão de proxy necessária'
            WHEN (NEW.erro_api = '408') THEN 'Tempo de solicitação esgotado'
            WHEN (NEW.erro_api = '409') THEN 'Conflito'
            WHEN (NEW.erro_api = '410') THEN 'Perdido'
            WHEN (NEW.erro_api = '411') THEN 'Duração necessária'
            WHEN (NEW.erro_api = '412') THEN 'Falha de pré condição'
            WHEN (NEW.erro_api = '413') THEN 'Solicitação da entidade muito extensa'
            WHEN (NEW.erro_api = '414') THEN 'Solicitação de URL muito longa'
            WHEN (NEW.erro_api = '415') THEN 'Tipo de mídia não suportado'
            WHEN (NEW.erro_api = '416') THEN 'Solicitação de faixa não satisfatória'
            WHEN (NEW.erro_api = '417') THEN 'Falha na expectativa'
            WHEN (NEW.erro_api = '500') THEN 'Erro do servidor interno'
            WHEN (NEW.erro_api = '501') THEN 'Não implementado'
            WHEN (NEW.erro_api = '502') THEN 'Portal de entrada ruim'
            WHEN (NEW.erro_api = '503') THEN 'Serviço indisponível'
            WHEN (NEW.erro_api = '504') THEN 'Tempo limite da porta de entrada'
            WHEN (NEW.erro_api = '505') THEN 'Versão HTTP não suportada'
            ELSE 'Erro não listado' END);
    END IF;

	IF (NEW.erro_api IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.erro_api_count  
	    SET total = total + 1
    WHERE date = NEW.lead_creation_day
        AND assunto = CASE WHEN (NEW.assunto IS NOT NULL) THEN NEW.assunto ELSE '-' END
        AND funcao_api = CASE WHEN (NEW.funcao_api IS NOT NULL) THEN NEW.funcao_api ELSE '-' END
        AND retorno = CASE
            WHEN (NEW.erro_api = '100') THEN 'Continuar'
            WHEN (NEW.erro_api = '101') THEN 'Mudando protocolos'
            WHEN (NEW.erro_api = '102') THEN 'Processando'
            WHEN (NEW.erro_api = '201') THEN 'Criado'
            WHEN (NEW.erro_api = '203') THEN 'Não autorizado'
            WHEN (NEW.erro_api = '204') THEN 'Nenhum conteúdo'
            WHEN (NEW.erro_api = '205') THEN 'Resetar conteúdo'
            WHEN (NEW.erro_api = '206') THEN 'Conteúdo parcial'
            WHEN (NEW.erro_api = '300') THEN 'Múltipla escolha'
            WHEN (NEW.erro_api = '301') THEN 'Movido permanentemente'
            WHEN (NEW.erro_api = '302') THEN 'Encontrado'
            WHEN (NEW.erro_api = '303') THEN 'Veja outro'
            WHEN (NEW.erro_api = '304') THEN 'Não modificado'
            WHEN (NEW.erro_api = '305') THEN 'Use proxy'
            WHEN (NEW.erro_api = '306') THEN 'Proxy trocado'
            WHEN (NEW.erro_api = '400') THEN 'Solicitação inválida'
            WHEN (NEW.erro_api = '401') THEN 'Não autorizado'
            WHEN (NEW.erro_api = '402') THEN 'Pagamento necessário'
            WHEN (NEW.erro_api = '403') THEN 'Proibido'
            WHEN (NEW.erro_api = '404') THEN 'Não encontrado'
            WHEN (NEW.erro_api = '405') THEN 'Método não permitido'
            WHEN (NEW.erro_api = '406') THEN 'Não aceito'
            WHEN (NEW.erro_api = '407') THEN 'Autenticacão de proxy necessária'
            WHEN (NEW.erro_api = '408') THEN 'Tempo de solicitação esgotado'
            WHEN (NEW.erro_api = '409') THEN 'Conflito'
            WHEN (NEW.erro_api = '410') THEN 'Perdido'
            WHEN (NEW.erro_api = '411') THEN 'Duração necessária'
            WHEN (NEW.erro_api = '412') THEN 'Falha de pré condição'
            WHEN (NEW.erro_api = '413') THEN 'Solicitação da entidade muito extensa'
            WHEN (NEW.erro_api = '414') THEN 'Solicitação de URL muito longa'
            WHEN (NEW.erro_api = '415') THEN 'Tipo de mídia não suportado'
            WHEN (NEW.erro_api = '416') THEN 'Solicitação de faixa não satisfatória'
            WHEN (NEW.erro_api = '417') THEN 'Falha na expectativa'
            WHEN (NEW.erro_api = '500') THEN 'Erro do servidor interno'
            WHEN (NEW.erro_api = '501') THEN 'Não implementado'
            WHEN (NEW.erro_api = '502') THEN 'Portal de entrada ruim'
            WHEN (NEW.erro_api = '503') THEN 'Serviço indisponível'
            WHEN (NEW.erro_api = '504') THEN 'Tempo limite da porta de entrada'
            WHEN (NEW.erro_api = '505') THEN 'Versão HTTP não suportada'
            ELSE 'Erro não listado'
            END;
    END IF;

	IF (OLD.erro_api IS NOT NULL) THEN 
    UPDATE smarkio_portoseguroconquista.erro_api_count  
	    SET total = total - 1
    WHERE date = OLD.lead_creation_day
        AND assunto = CASE WHEN (OLD.assunto IS NOT NULL) THEN OLD.assunto ELSE '-' END
        AND funcao_api = CASE WHEN (OLD.funcao_api IS NOT NULL) THEN OLD.funcao_api ELSE '-' END
        AND retorno = CASE
            WHEN (OLD.erro_api = '100') THEN 'Continuar'
            WHEN (OLD.erro_api = '101') THEN 'Mudando protocolos'
            WHEN (OLD.erro_api = '102') THEN 'Processando'
            WHEN (OLD.erro_api = '201') THEN 'Criado'
            WHEN (OLD.erro_api = '203') THEN 'Não autorizado'
            WHEN (OLD.erro_api = '204') THEN 'Nenhum conteúdo'
            WHEN (OLD.erro_api = '205') THEN 'Resetar conteúdo'
            WHEN (OLD.erro_api = '206') THEN 'Conteúdo parcial'
            WHEN (OLD.erro_api = '300') THEN 'Múltipla escolha'
            WHEN (OLD.erro_api = '301') THEN 'Movido permanentemente'
            WHEN (OLD.erro_api = '302') THEN 'Encontrado'
            WHEN (OLD.erro_api = '303') THEN 'Veja outro'
            WHEN (OLD.erro_api = '304') THEN 'Não modificado'
            WHEN (OLD.erro_api = '305') THEN 'Use proxy'
            WHEN (OLD.erro_api = '306') THEN 'Proxy trocado'
            WHEN (OLD.erro_api = '400') THEN 'Solicitação inválida'
            WHEN (OLD.erro_api = '401') THEN 'Não autorizado'
            WHEN (OLD.erro_api = '402') THEN 'Pagamento necessário'
            WHEN (OLD.erro_api = '403') THEN 'Proibido'
            WHEN (OLD.erro_api = '404') THEN 'Não encontrado'
            WHEN (OLD.erro_api = '405') THEN 'Método não permitido'
            WHEN (OLD.erro_api = '406') THEN 'Não aceito'
            WHEN (OLD.erro_api = '407') THEN 'Autenticacão de proxy necessária'
            WHEN (OLD.erro_api = '408') THEN 'Tempo de solicitação esgotado'
            WHEN (OLD.erro_api = '409') THEN 'Conflito'
            WHEN (OLD.erro_api = '410') THEN 'Perdido'
            WHEN (OLD.erro_api = '411') THEN 'Duração necessária'
            WHEN (OLD.erro_api = '412') THEN 'Falha de pré condição'
            WHEN (OLD.erro_api = '413') THEN 'Solicitação da entidade muito extensa'
            WHEN (OLD.erro_api = '414') THEN 'Solicitação de URL muito longa'
            WHEN (OLD.erro_api = '415') THEN 'Tipo de mídia não suportado'
            WHEN (OLD.erro_api = '416') THEN 'Solicitação de faixa não satisfatória'
            WHEN (OLD.erro_api = '417') THEN 'Falha na expectativa'
            WHEN (OLD.erro_api = '500') THEN 'Erro do servidor interno'
            WHEN (OLD.erro_api = '501') THEN 'Não implementado'
            WHEN (OLD.erro_api = '502') THEN 'Portal de entrada ruim'
            WHEN (OLD.erro_api = '503') THEN 'Serviço indisponível'
            WHEN (OLD.erro_api = '504') THEN 'Tempo limite da porta de entrada'
            WHEN (OLD.erro_api = '505') THEN 'Versão HTTP não suportada'
            ELSE 'Erro não listado'
            END;
    END IF;
END 

-- SELECT -- 
INSERT INTO smarkio_portoseguroconquista.erro_api_count   (`date`, `retorno`, `assunto`, `funcao_api`, `total`)
SELECT c.date, c.retorno, c.assunto, c.funcao_api, c.total
FROM 
(
  SELECT 
	lead_creation_day AS date,
    (CASE
            WHEN (erro_api = '100') THEN 'Continuar'
            WHEN (erro_api = '101') THEN 'Mudando protocolos'
            WHEN (erro_api = '102') THEN 'Processando'
            WHEN (erro_api = '201') THEN 'Criado'
            WHEN (erro_api = '203') THEN 'Não autorizado'
            WHEN (erro_api = '204') THEN 'Nenhum conteúdo'
            WHEN (erro_api = '205') THEN 'Resetar conteúdo'
            WHEN (erro_api = '206') THEN 'Conteúdo parcial'
            WHEN (erro_api = '300') THEN 'Múltipla escolha'
            WHEN (erro_api = '301') THEN 'Movido permanentemente'
            WHEN (erro_api = '302') THEN 'Encontrado'
            WHEN (erro_api = '303') THEN 'Veja outro'
            WHEN (erro_api = '304') THEN 'Não modificado'
            WHEN (erro_api = '305') THEN 'Use proxy'
            WHEN (erro_api = '306') THEN 'Proxy trocado'
            WHEN (erro_api = '400') THEN 'Solicitação inválida'
            WHEN (erro_api = '401') THEN 'Não autorizado'
            WHEN (erro_api = '402') THEN 'Pagamento necessário'
            WHEN (erro_api = '403') THEN 'Proibido'
            WHEN (erro_api = '404') THEN 'Não encontrado'
            WHEN (erro_api = '405') THEN 'Método não permitido'
            WHEN (erro_api = '406') THEN 'Não aceito'
            WHEN (erro_api = '407') THEN 'Autenticacão de proxy necessária'
            WHEN (erro_api = '408') THEN 'Tempo de solicitação esgotado'
            WHEN (erro_api = '409') THEN 'Conflito'
            WHEN (erro_api = '410') THEN 'Perdido'
            WHEN (erro_api = '411') THEN 'Duração necessária'
            WHEN (erro_api = '412') THEN 'Falha de pré condição'
            WHEN (erro_api = '413') THEN 'Solicitação da entidade muito extensa'
            WHEN (erro_api = '414') THEN 'Solicitação de URL muito longa'
            WHEN (erro_api = '415') THEN 'Tipo de mídia não suportado'
            WHEN (erro_api = '416') THEN 'Solicitação de faixa não satisfatória'
            WHEN (erro_api = '417') THEN 'Falha na expectativa'
            WHEN (erro_api = '500') THEN 'Erro do servidor interno'
            WHEN (erro_api = '501') THEN 'Não implementado'
            WHEN (erro_api = '502') THEN 'Portal de entrada ruim'
            WHEN (erro_api = '503') THEN 'Serviço indisponível'
            WHEN (erro_api = '504') THEN 'Tempo limite da porta de entrada'
            WHEN (erro_api = '505') THEN 'Versão HTTP não suportada'
            ELSE 'Erro não listado'
            END) AS retorno,
    (CASE WHEN (assunto IS NOT NULL) THEN assunto ELSE '-' END) AS assunto,
    (CASE WHEN (funcao_api IS NOT NULL) THEN funcao_api ELSE '-' END) AS funcao_api,
    SUM(CASE WHEN (erro_api IS NOT NULL) THEN 1 ELSE 0 END) AS total
	FROM smarkio_portoseguroconquista.leads 
    WHERE lead_creation_day between '2020-09-19' and '2021-05-17'
    AND erro_api IS NOT NULL  AND funcao_api IS NOT NULL  AND assunto IS NOT NULL
	GROUP BY date, erro_api,assunto,funcao_api) AS c
  ON DUPLICATE KEY UPDATE
        `date` = c.date,
        `retorno` = c.retorno,
        `assunto` = c.assunto,
        `funcao_api` = c.funcao_api,
        `total` = c.total;