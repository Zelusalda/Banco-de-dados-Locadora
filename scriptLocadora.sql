-- Active: 1697565397734@@127.0.0.1@3306@locadora
CREATE DATABASE locadora;
USE locadora;

/* CREATE TABLES */

CREATE TABLE tbendereco(
	id_endereco INT auto_increment primary key,
    CEP varchar(9),
    endereco varchar(100),
    numero INT,
    bairro varchar(50),
    cidade varchar(25),
    estado varchar(2) default 'BA',
    pais varchar(20) default 'Brasil'
);

CREATE TABLE
    tbfuncionarios (
        mat_func INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR (50),
        CPF VARCHAR(14),
        email VARCHAR(60),
        telefone VARCHAR(20),
        data_matricula DATE,
        fk_id_endereco INT,
        FOREIGN KEY (fk_id_endereco) references tbendereco(id_endereco)
    );

CREATE TABLE
    tbfornecedor (
		id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
        CNPJ VARCHAR(25) UNIQUE,
        razao_social VARCHAR(100) NOT NULL,
        nome_fantasia VARCHAR(60),
        telefone VARCHAR(14),
        whatsapp VARCHAR(14),
        email VARCHAR(60),
        ramal INT,
        site VARCHAR(140),
		fk_id_endereco INT,
        FOREIGN KEY (fk_id_endereco) references tbendereco(id_endereco)
    );

CREATE TABLE
    tbclientes (
        id_cliente INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(50),
        CPF VARCHAR(14),
        email VARCHAR(60),
        telefone VARCHAR(20),
		fk_id_endereco INT,
        FOREIGN KEY (fk_id_endereco) references tbendereco(id_endereco)
    );

CREATE TABLE
    tbfilme (
        id_filme INT AUTO_INCREMENT PRIMARY KEY,
        fk_id_fornecedor INT,
        titulo VARCHAR(100),
        sinopse VARCHAR(280),
        quantidade INT,
        valor_filme DECIMAL(10, 2),
        taxa_dia DECIMAL(10, 2),
        classificacao varchar(10),
        genero VARCHAR(50),
        FOREIGN KEY (fk_id_fornecedor) REFERENCES tbfornecedor (id_fornecedor)
);

CREATE TABLE
    tblocacoes(
        id_locacao INT auto_increment PRIMARY KEY,
        fk_id_cliente INT,
        fk_id_filme INT,
        data_locacao DATETIME,
        data_limite DATETIME,
        status_locacao ENUM('Atrasado','Devolvido','Locando') DEFAULT 'Locando',
        total_locacao DECIMAL(10,2),
        FOREIGN KEY (fk_id_cliente) REFERENCES tbclientes (id_cliente),
        FOREIGN KEY (fk_id_filme) REFERENCES tbfilme (id_filme)
);

CREATE TABLE
    tbitenslocacao(
        fk_id_locacao INT,
        fk_id_filme INT,
        quantidade_filme INT,
        subtotal DECIMAL(10,2),
        FOREIGN KEY (fk_id_locacao) REFERENCES tblocacoes(id_locacao),
        FOREIGN KEY (fk_id_filme) REFERENCES tbfilme(id_filme)
    );


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


/* INSERTS */
INSERT INTO `locadora`.`tbendereco` (`CEP`, `endereco`, `numero`, `bairro`, `cidade`, `estado`, `pais`) 
VALUES ('45632-650', 'Rua dos Jardineiros', '22', 'Hiberin', 'Guandi', 'RE', 'Angola'),
('56899-780', 'Rua dos Talismãs', '12', 'Pituba', 'Salvador', 'BA', 'Brasil'),
('15935-741', 'Avenida Liomar Segundo', '9', 'Rio Vermelho', 'Salvador', 'BA', 'Brasil'),
('35785-685', 'Avenida Jefferson Salgueiro', '22', 'Mussurunga', 'Salvador', 'BA', 'Brasil'),
('35795-850', 'Rua Pastor Aldemar Santos', '35', 'Pitangas', 'Feira de Santana', 'BA', 'Brasil'),
('65423-556', 'Rua Miguel Lancelo Dutra', '40', 'Pitangas', 'Feira de Santana', 'BA', 'Brasil'),
('78423-855', 'Rua Vereador Pascal Lima', '22', 'Limoeiro', 'Feira de Santana', 'BA', 'Brasil'),
('12345-678', 'Rua das Flores', '123', 'Centro', 'São Paulo', 'SP', 'Brasil'),
('98765-432', 'Avenida dos Pássaros', '456', 'Copacabana', 'Rio de Janeiro', 'RJ', 'Brasil'),
('54321-876', 'Alameda das Árvores', '789', 'Copacabana', 'Rio de Janeiro', 'RJ', 'Brasil');

INSERT INTO
    tbfuncionarios(
        nome,
        cpf,
        email,
        telefone,
        data_matricula,
        fk_id_endereco
    )
VALUES
(
        'Edson',
        '06586788404',
        'edcosta607@gmail.com',
        '71997130234',
        '2018-03-21',
        1
    ), (
        'Alexandre',
        '47896798416',
        'buxexafrancis@gmail.com',
        '71997831397',
        '2022-10-08',
        2
    ), (
        'João',
        '97745789418',
        'tijolo007@gmail.com',
        '71887900235',
        '2020-12-11',
        3
    ), (
        'Isabel',
        '22779988407',
        'isagod004@gmail.com',
        '71987167236',
        '2019-03-15',
        4
    ), (
        'José',
        '12586788435',
        'zeludaoslk@gmail.com',
        '71998140738',
        '2023-11-08',
        5
    ),
    ('Mariana Senna',
        '45632145699',
        'marinasenna22@gmail.com',
        '71985652311',
        '2018-05-06',
        6
	);
    
INSERT INTO
    tbfornecedor(
        CNPJ,
        razao_social,
        nome_fantasia,
        telefone,
        whatsapp,
        email,
        ramal,
        site,
        fk_id_endereco
    )
VALUES
(
        '27.654.722/0001-16',
        'PARAMOUNT PICTURES BRASIL DISTRIBUIDORA DE FILMES LTDA.',
        'Paramount',
        '36067897',
        '071988459887',
        'paramountbr@gmail.com',
        45,
        'www.paramount.com.br',
        7
    ), (
        '73.042.962/0001-87',
        'THE WALT DISNEY COMPANY (BRASIL) LTDA',
        ' Walt Disney',
        '44445555',
        '0719974596867',
        'disneyBr@gmail.com',
        21,
        'www.waltdisney.com.br',
        8
    ), (
        '06.152.891/0001-88',
        'WARNER BROS. ENTRETENIMENTO BRASIL LTDA.',
        ' Warner Bros',
        '78789696',
        '0759977594423',
        '@warnerBrosBR@gmail.com',
        80,
        'www.warnerbros.com.br',
        9
    );

INSERT INTO
    tbclientes(
        nome,
        CPF,
        email,
        telefone,
        fk_id_endereco
    )
VALUES (
        "João Neto",
        "45230585",
        "joaoneto2023@gmail.com",
        "(71)98885-6563",
        2
    ), (
        "Maria Barbosa",
        "30250275",
        "mariabarbosa2023@gmail.com",
        "(71)98877-6563",
        3
    ), (
        "Juarez Fernandes",
        "60230295",
        "juarezfernandes2023@gmail.com",
        "(71)98888-7777",
        4
    );

INSERT INTO
    tbfilme (
        titulo,
        fk_id_fornecedor,
        sinopse,
        quantidade,
        valor_filme,
        taxa_dia,
        classificacao,
        genero
    )
VALUES
(
        'Carros 2',
        1,
        'Um carro de corrida muito louco',
        '10',
        '15.00',
        '5.80',
        '10',
        'Infantil'
    ), (
        'Panico 5',
        2,
        'homem que mata muita gente por puro prazer ',
        '20',
        '15.50',
        '6.10',
        '18',
        'Terror'
    ), (
        'Indiana Jones 2',
        3,
        'Um aventureiro curioso leva seus amigos para uma nova descoberta',
        '25',
        '25.50',
        '3.90',
        '14',
        'Aventura'
    ),
(
'Harry Potter e A Pedra Filosofal', 3,
'Harry Potter descobre que é um bruxo e ingressa na Escola de Magia e Bruxaria de Hogwarts.',
 30, 
 24.90, 
 2.80, 
 'Livre', 
 'Fantasia'),
('Harry Potter and the Goblet of Fire', '3',
 'Harry é selecionado inesperadamente para competir no Torneio Tribruxo',
 20,
 24.90,
 2.80,
 12, 
 'Fantasia'),
( 'Harry Potter and the Order of the Phoenix', '3',
 'Harry enfrenta a indiferença do Ministério da Magia e forma a Ordem da Fênix para enfrentar o retorno de Lord Voldemort.', 
 '20',
 '24.90',
 '2.80',
 '12',
 'Fantasia'),
( 'Harry Potter and the Half-Blood Prince','2',
 'Harry descobre segredos sobre o passado de Voldemort enquanto Hogwarts se prepara para a batalha iminente entre as forças do bem e do mal.',
 '20',
 '24.90',
 '2.80',
 '10',
 'Fantasia');


INSERT INTO
    tblocacoes(
        data_locacao,
        fk_id_cliente,
        fk_id_filme
    )
VALUES 
	(current_timestamp(),2, 8), 
	(current_timestamp(),1, 9), 
	(current_timestamp(),2, 8),
	(current_timestamp(),3, 10),
	(current_timestamp(), 3,12),
	(current_timestamp(),1, 13),
    (current_timestamp(),1, 9);

INSERT INTO
	tbitenslocacao(fk_id_locacao,quantidade_filme)
    VALUES
    (43,1),
    (44,2),
    (45,2),
    (46,1),
    (45,2),
    (45,1);

-- SELECTS GERAIS
SELECT * FROM tbendereco;
SELECT * FROM tbfuncionarios;
SELECT * FROM tbclientes;
SELECT * FROM tbfilme;
SELECT * FROM tblocacoes;
SELECT * FROM tbfornecedor;
SELECT * FROM tbitenslocacao;


/* Ordenar filmes em estoque do menor preço para o maior (ORDENAÇÃO CRESCENTE)*/
SELECT valor_filme FROM tbfilme ORDER BY valor_filme ASC;

/* Ordenar filmes da maior quantidade de estoque para a menor (ORDENAÇÃO DECRESCENTE)*/
SELECT quantidade FROM tbfilme ORDER BY quantidade DESC;

/* Consulta que contenha agrupamento */
/* A FAZER */

/* Ver funcionários matriculados em um espaço de 3 anos (CONSULTA BETWEEN)*/
SELECT *
FROM tbfuncionarios
WHERE
    data_matricula BETWEEN '2020-01-01' AND '2023-12-31'
ORDER BY data_matricula;

/* Ver filmes do genêro fantasia (CONSULTA IN)*/
SELECT * FROM tbfilme WHERE genero IN ('Fantasia');

/* View que mostra todas as locações de filme que já passaram da data de devolução,
 exibindo data de locação, data limite e o id do cliente que locou (VIEW NECESSÁRIA) */
 CREATE VIEW FilmesAtrasados AS
 SELECT 
	id_locacao,
    date(data_locacao) as 'Data de Locação',
    date(data_limite) as 'Data Limite',
    fk_id_cliente as 'Id Cliente'
FROM tblocacoes
WHERE data_limite >= now();

SELECT * FROM FilmesAtrasados;


-- A FAZER
-- view que apresenta endereço dos clientes, funcionários e fornecedores



-- EXECUÇÃO PROCEDURES

CALL VerificarMulta(1, @nome_cliente, @id_cliente, @total_multa);
SELECT @nome_cliente AS nome_cliente, @id_cliente AS id_cliente, @total_multa AS total_multa;

CALL AtualizarStatusLocacao(
    1,
    'Devolvido'
);

CALL AtualizarStatusLocacao(
    2,
    'Atrasado'
);

CALL ObterFilmesLocadosPorID(
    1,
    @data_locacao,
    @data_limite,
    @status_locacao,
    @id_cliente,
    @id_filme,
    @total_locacao
);
SELECT @data_locacao, @data_limite, @status_locacao, @id_cliente, @id_filme, @total_locacao;




/* DANGER ZONE */

/* DROPS */
-- DROP DATABASE locadora;
-- DROP TABLE tbendereco;
-- DROP TABLE tbfuncionarios;
-- DROP TABLE tbdependentes;
-- DROP TABLE tbclientes;
-- DROP TABLE tbfilme;
-- DROP TABLE tblocacoes;
-- DROP TABLE tbfornecedor;
-- DROP TABLE tbitenslocacao;

/* DELETE */
-- DELETE FROM tbendereco;
-- DELETE FROM tbfuncionarios;
-- DELETE FROM tbclientes;
-- DELETE FROM tbfilme;
--- DELETE FROM tblocacoes;
-- DELETE FROM tbfornecedor;
-- DELETE FROM tbitenslocacao;


drop trigger AttTotalLocacao;
drop trigger CalcSubtotal;
drop trigger attDataLimite;
drop trigger AddFilmeItensLocacao;
