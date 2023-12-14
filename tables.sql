USE LOCADORA;


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