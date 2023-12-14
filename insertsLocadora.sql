USE LOCADORA;

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
	),
    ('Murilo Goes', '78965412333', 'murilogoes87@gmail.com', '71985621247', '2018-02-02', '6'),
	('Melanie Silva', '71456789955', 'melaniesilva14@gmail.com', '71987452136', '2018-09-01', '7');

    
    
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
	('2023-12-01 17:20:02', 3,12),
	('2023-12-01 14:12:05',1, 13),
    ('2023-12-01 15:24:06',1, 9);

INSERT INTO
	tbitenslocacao(fk_id_locacao,quantidade_filme)
    VALUES
    (43,1),
    (44,2),
    (45,2),
    (46,1),
    (45,2),
    (45,1);
