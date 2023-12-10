-- Active: 1700955922591@@127.0.0.1@3306@locadora
CREATE DATABASE locadora;
USE locadora;

/* CREATE TABLES */
CREATE TABLE
    tbfuncionarios (
        mat_func INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR (50),
        cpf VARCHAR(14),
        email VARCHAR(60),
        telefone VARCHAR(20),
        data_matricula DATE
    );
CREATE TABLE
    tbdependentes (
        id_dep INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR (50),
        cpf VARCHAR(14),
        fK_mat_func INT,
        CONSTRAINT fk_mat_func FOREIGN KEY(fk_mat_func) REFERENCES tbfuncionarios(mat_func)
    );

CREATE TABLE
    tbfornecedor (
        cnpj VARCHAR(25) PRIMARY KEY,
        razaosocial VARCHAR(100) NOT NULL,
        nomefantasia VARCHAR(60),
        telefone VARCHAR(14),
        whatsapp VARCHAR(14),
        email VARCHAR(60)
    );

CREATE TABLE
    tbclientes (
        id_cli INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(50),
        cpf VARCHAR(14),
        email VARCHAR(60),
        telefone VARCHAR(20),
        endereco VARCHAR(30)
    );

CREATE TABLE
    tbfilme (
        id_filme INT AUTO_INCREMENT PRIMARY KEY,
        fk_cnpj VARCHAR(25),
        titulo VARCHAR(40),
        sinopse VARCHAR(100),
        quantidade INT,
        valor_filme DECIMAL(10, 2),
        taxa_dia DECIMAL(10, 2),
        classificacao varchar(10),
        genero VARCHAR(50),
        FOREIGN KEY (fk_cnpj) REFERENCES tbfornecedor (cnpj)
);

CREATE TABLE
    tbvendafilmes (
        id_vendafilmes INT PRIMARY KEY,
        total DECIMAL(10, 2),
        subtotal DECIMAL(10, 2)
    );

CREATE TABLE
    tbfilme_locado (
        id_filme_locado INT PRIMARY KEY AUTO_INCREMENT,
        data_locacao DATETIME,
        data_limite DATETIME,
        estado ENUM ('Atrasado', 'Devolvido', 'Locando'), /* Pra ver o status do filme locado */
        fk_id_cli INT,
        fk_id_filme INT,
        -- fk_id_vendafilmes INT,
        FOREIGN KEY (fk_id_cli) REFERENCES tbclientes (id_cli),
        FOREIGN KEY (fk_id_filme) REFERENCES tbfilme (id_filme)
        -- FOREIGN KEY (fk_id_vendafilmes) REFERENCES tbvendafilmes (id_vendafilmes)
    );


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
    );

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
    tbfilme_locado(
        data_locacao,
        data_limite,
        estado,
        fk_id_cli,
        fk_id_filme
        -- fk_id_vendafilmes
    )
VALUES 
	('2023-05-03 13:20:00', '2023-05-05 13:20:00', 'Devolvido', '2', '1'), 
	('2023-12-09 16:31:00', '2023-12-11 16:31:00', 'Locando', '1', '3'), 
	('2023-11-30 18:11:00', '2023-12-02 18:11:00', 'Atrasado', '2', '1'),
	('2022-10-31 17:02:00', '2023-11-02 17:02:00', 'Devolvido', '3', '2'),
	('2023-12-08 17:15:00', '2023-12-10 17:15:00', 'Locando', '3', '3'),
	('2023-12-05 14:34:00', '2023-12-07 14:34:00', 'Atrasado', '1', '2');

/* SELECTS GERAIS */
SELECT * FROM tbfuncionarios;
SELECT * FROM tbdependentes;
SELECT * FROM tbclientes;
SELECT * FROM tbfilme;
SELECT * FROM tbfilme_locado;
SELECT * FROM tbfornecedor;
SELECT * FROM tbvendafilmes;


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
	id_filme_locado,
    date(data_locacao) as 'Data de Locação',
    date(data_limite) as 'Data Limite',
    fk_id_cli as 'Id Cliente'
FROM tbfilme_locado
WHERE data_limite >= now();

SELECT * FROM FilmesAtrasados;








/* DANGER ZONE */

/* DROPS */
-- DROP DATABASE locadora;
-- DROP TABLE tbfuncionarios;
-- DROP TABLE tbdependentes;
-- DROP TABLE tbclientes;
-- DROP TABLE tbfilme;
-- DROP TABLE tbfilme_locado;
-- DROP TABLE tbfornecedor;
-- DROP TABLE tbvendafilmes;

/* DELETE */
-- DELETE FROM tbfuncionarios;
-- DELETE FROM tbdependentes;
-- DELETE FROM tbclientes;
-- DELETE FROM tbfilme;
-- DELETE FROM tbfilme_locado;
-- DELETE FROM tbfornecedor;
-- DELETE FROM tbvendafilmes;
