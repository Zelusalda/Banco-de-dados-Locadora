USE LOCADORA;

DELIMITER $$
CREATE PROCEDURE ObterFilmesLocadosPorId(
    IN p_id_locacao INT,
    OUT p_data_locacao DATETIME,
    OUT p_data_limite DATETIME,
    OUT p_status_locacao ENUM('Atrasado', 'Devolvido', 'Locando'),
    OUT p_fk_id_cliente INT,
    OUT p_fk_id_filme INT,
    OUT p_total_locacao DECIMAL(10,2)
)
BEGIN
    SELECT
        data_locacao,
        data_limite,
        status_locacao,
        fk_id_cliente,
        fk_id_filme,
        total_locacao
    INTO
        p_data_locacao,
        p_data_limite,
        p_status_locacao,
        p_fk_id_cliente,
        p_fk_id_filme,
        p_total_locacao
    FROM tblocacoes
    WHERE id_locacao = p_id_locacao
    LIMIT 1;
END $$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE AtualizarStatusLocacao(
    IN p_id_locacao INT,
    IN p_novo_status ENUM('Atrasado', 'Devolvido', 'Locando')
)
BEGIN
    UPDATE tblocacoes
    SET status_locacao = p_novo_status
    WHERE id_locacao = p_id_locacao;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE VerificarMulta(
    IN p_id_locacao INT,
    OUT p_nome_cliente VARCHAR(50),
    OUT p_id_cliente INT,
    OUT p_total_multa DECIMAL(10,2)
)
BEGIN
    DECLARE data_devolucao DATETIME;
    DECLARE data_limite DATETIME;
    DECLARE taxa_dia DECIMAL(10,2);
    DECLARE quantidade_dias_atraso INT;

    SELECT 
        c.nome,
        c.id_cliente,
        l.data_limite,
        f.taxa_dia
    INTO
        p_nome_cliente,
        p_id_cliente,
        data_limite,
        taxa_dia
    FROM tblocacoes l
    JOIN tbclientes c ON l.fk_id_cliente = c.id_cliente
    JOIN tbfilme f ON l.fk_id_filme = f.id_filme
    WHERE l.id_locacao = p_id_locacao;

    SET data_devolucao = NOW();

    IF data_devolucao > data_limite THEN
        SET quantidade_dias_atraso = DATEDIFF(data_devolucao, data_limite);
        SET p_total_multa = quantidade_dias_atraso * taxa_dia;
    ELSE
        SET p_total_multa = 0.0;
    END IF;
    
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER AttTotalLocacao
AFTER INSERT ON tbitenslocacao
FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(subtotal) INTO total
    FROM tbitenslocacao
    WHERE fk_id_locacao = NEW.fk_id_locacao;
    
    UPDATE tblocacoes
    SET total_locacao = total
    WHERE id_locacao = NEW.fk_id_locacao;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER CalcSubtotal
BEFORE INSERT ON tbitenslocacao
FOR EACH ROW
BEGIN
	DECLARE valorFilme DECIMAL(10,2);
    
    SELECT valor_filme INTO valorFilme
    FROM tbfilme
    WHERE id_filme = NEW.fk_id_filme;

    SET NEW.subtotal = NEW.quantidade_filme * valorFilme;
    
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER AddFilmeItensLocacao
BEFORE INSERT ON tbitenslocacao
FOR EACH ROW
BEGIN
	
    DECLARE idFilme INT;
    SELECT fk_id_filme INTO idFilme
    FROM tblocacoes
    WHERE id_locacao = NEW.fk_id_locacao;

	SET NEW.fk_id_filme = idFilme;
END $$

DELIMITER ;

DELIMITER $$
CREATE TRIGGER AttDataLimite
BEFORE INSERT ON tblocacoes
FOR EACH ROW
BEGIN
    SET NEW.data_limite = DATE_ADD(NEW.data_locacao, INTERVAL 10 DAY);
END $$

DELIMITER ;