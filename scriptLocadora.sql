-- Active: 1697565397734@@127.0.0.1@3306@locadora
CREATE DATABASE locadora;
USE locadora;

/* CREATE TABLES */

CREATE TABLE tbendereco(
	id_endereco INT auto_increment primary key,
    CEP varchar(10),
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

-- CREATE TABLE
--     tbdependentes (
--         id_dep INT AUTO_INCREMENT PRIMARY KEY,
--         nome VARCHAR (50),
--         cpf VARCHAR(14),
--         fK_mat_func INT,
--         CONSTRAINT fk_mat_func FOREIGN KEY(fk_mat_func) REFERENCES tbfuncionarios(mat_func)
--     );

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
        fk_id_fornecedor VARCHAR(25),
        titulo VARCHAR(40),
        sinopse VARCHAR(100),
        quantidade INT,
        valor_filme DECIMAL(10, 2),
        taxa_dia DECIMAL(10, 2),
        classificacao varchar(10),
        genero VARCHAR(50),
        FOREIGN KEY (fk_id_fornecedor) REFERENCES tbfornecedor (id_fornecedor)
);

-- CREATE TABLE
--     tbvendafilmes (
--         id_vendafilmes INT PRIMARY KEY,
--         total DECIMAL(10, 2),
--         subtotal DECIMAL(10, 2)
--     );

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
        quantidade_filme INT,
        subtotal DECIMAL(10,2),
        FOREIGN KEY (fk_id_locacao) REFERENCES tblocacoes(id_locacao)
    );


-- CREATE TABLE
--     tbfilme_locado (
--         id_filme_locado INT PRIMARY KEY AUTO_INCREMENT,
--         data_locacao DATETIME,
--         data_limite DATETIME,
--         estado ENUM ('Atrasado', 'Devolvido', 'Locando'), /* Pra ver o status do filme locado */
--         fk_id_cli INT,
--         fk_id_filme INT,
--         FOREIGN KEY (fk_id_cli) REFERENCES tbclientes (id_cli),
--         FOREIGN KEY (fk_id_filme) REFERENCES tbfilme (id_filme)
--     );



/* INSERTS */
INSERT INTO
    tbfuncionarios(
        nome,
        cpf,
        email,
        telefone,
        data_matricula
    )
VALUES
(
        'Edson',
        '06586788404',
        'edcosta607@gmail.com',
        '71997130234',
        '2018-03-21'
    ), (
        'Alexandre',
        '47896798416',
        'buxexafrancis@gmail.com',
        '71997831397',
        '2022-10-08'
    ), (
        'João',
        '97745789418',
        'tijolo007@gmail.com',
        '71887900235',
        '2020-12-11'
    ), (
        'Isabel',
        '22779988407',
        'isagod004@gmail.com',
        '71987167236',
        '2019-03-15'
    ), (
        'José',
        '12586788435',
        'zeludaoslk@gmail.com',
        '71998140738',
        '2023-11-08'
    ),
    ('Mariana Senna',
        '45632145699',
        'marinasenna22@gmail.com',
        '71985652311',
        '2018-05-06');
    


INSERT INTO
    tbdependentes(nome, cpf, fk_mat_func)
VALUES (
        "José filho",
        "06678590054",
        "5"
    ), ("Eloá", "06584788504", "1"), ("Anderson", "77794687635", "3");

INSERT INTO
    tbfornecedor(
        cnpj,
        razaosocial,
        nomefantasia,
        telefone,
        whatsapp,
        email
    )
VALUES
(
        '27.654.722/0001-16',
        'PARAMOUNT PICTURES BRASIL DISTRIBUIDORA DE FILMES LTDA.',
        'Paramount',
        '36067897',
        '071988459887',
        'paramountbr@gmail.com'
    ), (
        '73.042.962/0001-87',
        'THE WALT DISNEY COMPANY (BRASIL) LTDA',
        ' Walt Disney',
        '44445555',
        '0719974596867',
        'disneyBr@gmail.com'
    ), (
        '06.152.891/0001-88',
        'WARNER BROS. ENTRETENIMENTO BRASIL LTDA.',
        ' Warner Bros',
        '78789696',
        '0759977594423',
        '@warnerBrosBR@gmail.com'
    );

INSERT INTO
    tbclientes(
        nome,
        cpf,
        email,
        telefone,
        endereco
    )
VALUES (
        "João Neto",
        "45230585",
        "joaoneto2023@gmail.com",
        "(71)98885-6563",
        "Candeias"
    ), (
        "Maria Barbosa",
        "30250275",
        "mariabarbosa2023@gmail.com",
        "(71)98877-6563",
        "Lauro de Freitas"
    ), (
        "Juarez Fernandes",
        "60230295",
        "juarezfernandes2023@gmail.com",
        "(71)98888-7777",
        "Salvador"
    );

INSERT INTO
    tbfilme (
        titulo,
        fk_cnpj,
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
        '73.042.962/0001-87',
        'Um carro de corrida muito louco',
        '10',
        '15.00',
        '5.80',
        '10',
        'Infantil'
    ), (
        'Panico 5',
        '27.654.722/0001-16',
        'homem que mata muita gente por puro prazer ',
        '20',
        '15.50',
        '6.10',
        '18',
        'Terror'
    ), (
        'Indiana Jones 2',
        '73.042.962/0001-87',
        'Um aventureiro curioso leva seus amigos para uma nova descoberta',
        '25',
        '25.50',
        '3.90',
        '14',
        'Aventura'
    );

INSERT INTO
    tblocacoes(
        data_locacao,
        fk_id_cli,
        fk_id_filme
    )
VALUES 
	(curdate(),2, 1), 
	(curdate(),1, 3), 
	(curdate(),2, 1),
	(curdate(),3, 2),
	(curdate(), 3,2),
	(curdate(),1, 2);

INSERT INTO
	tbitenslocacao(id_locacao,quantidade_filme)
    VALUES
    (1,1),
    (2,1),
    (3,1),
    (4,1),
    (5,1),
    (6,1);



-- SELECTS GERAIS
SELECT * FROM tbfuncionarios;
SELECT * FROM tbdependentes;
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

/* Ver clientes cadastrados que moram em Salvador (CONSULTA IN)*/
SELECT * FROM tbclientes WHERE endereco IN ('Salvador');

/* View que mostra todas as locações de filme que já passaram da data de devolução,
 exibindo data de locação, data limite e o id do cliente que locou (VIEW NECESSÁRIA) */
 CREATE VIEW FilmesAtrasados AS
 SELECT 
	id_locacao,
    date(data_locacao) as 'Data de Locação',
    date(data_limite) as 'Data Limite',
    fk_id_cli as 'Id Cliente'
FROM tblocacoes
WHERE data_limite >= now();

SELECT * FROM FilmesAtrasados;

-- atualizo data limite
-- armazeno data limite
-- atualizo status como atrasado onde data agora for maior que data limite
-- atualizo status como devolvido manualmente 
-- atualizado status locando como padrão


/* PROCEDURE DE ENTRADA/INPUT */
DELIMITER //
CREATE PROCEDURE InserirFuncionario(
    IN p_nome VARCHAR(50),
    IN p_cpf VARCHAR(14),
    IN p_email VARCHAR(60),
    IN p_telefone VARCHAR(20),
    IN p_data_matricula DATE
)
BEGIN
    INSERT INTO tbfuncionarios(nome, cpf, email, telefone, data_matricula)
    VALUES (p_nome, p_cpf, p_email, p_telefone, p_data_matricula)
END;

Inserir

/* PROCEDURE DE SAÍDA/OUTPUT */
CREATE PROCEDURE ObterFilmesLocados(
    OUT p_id_filme_locado INT,
    OUT p_data_locacao DATETIME,
    OUT p_data_limite DATETIME,
    OUT p_estado ENUM('Atrasado', 'Devolvido', 'Locando'),
    OUT p_fk_id_cli INT,
    OUT p_fk_id_filme INT
)
BEGIN
    SELECT
        id_filme_locado,
        data_locacao,
        data_limite,
        estado,
        fk_id_cli,
        fk_id_filme
    INTO
        p_id_filme_locado,
        p_data_locacao,
        p_data_limite,
        p_estado,
        p_fk_id_cli,
        p_fk_id_filme
    FROM tbfilme_locado;
END;

-- VARIÁVEIS
DECLARE id_locacao INT;
DECLARE data_locacao DATETIME;
DECLARE data_limite DATETIME;
DECLARE estado ENUM('Atrasado', 'Devolvido', 'Locando');
DECLARE id_cliente INT;
DECLARE id_filme INT;

CALL ObterFilmesLocados(
    OUT id_locacao,
    OUT data_locacao,
    OUT data_limite,
    OUT estado,
    OUT id_cliente,
    OUT id_filme
);

SELECT id_locacao, data_locacao, data_limite, estado, id_cliente, id_filme;


/* TRIGGER PARA ATUALIZAR ESTOQUE DE FILMES PÓS LOCAÇÃO */
CREATE TRIGGER AttQuantidadeFilmeLocado
AFTER INSERT ON tbfilme_locado
FOR EACH ROW
BEGIN
    UPDATE tbfilme
    SET quantidade = quantidade - 1
    WHERE id_filme = NEW.fk_id_filme;
END;

-- TRIGGER PARA ATUALIZAR TOTAL LOCAÇÃO

-- TRIGGER PARA ATUALIZAR DATA LIMITE LOCAÇÃO



DELIMITER ;

/* DANGER ZONE */

/* DROPS */
-- DROP DATABASE locadora;
-- DROP TABLE tbfuncionarios;
-- DROP TABLE tbdependentes;
-- DROP TABLE tbclientes;
-- DROP TABLE tbfilme;
-- DROP TABLE tblocacoes;
-- DROP TABLE tbfornecedor;
-- DROP TABLE tbitenslocacao;

/* DELETE */
-- DELETE FROM tbfuncionarios;
-- DELETE FROM tbdependentes;
-- DELETE FROM tbclientes;
-- DELETE FROM tbfilme;
-- DELETE FROM tblocacoes;
-- DELETE FROM tbfornecedor;
-- DELETE FROM tbvendafilmes;
