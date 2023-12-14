-- Active: 1697565397734@@127.0.0.1@3306@locadora
CREATE DATABASE locadora;
USE locadora;

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
/* Apresenta quantidade de filmes por gênero*/
SELECT genero, COUNT(*) AS quantidade_filmes
FROM tbfilme
GROUP BY genero;

/* Ver funcionários matriculados em um espaço de 3 anos (CONSULTA BETWEEN)*/
SELECT *
FROM tbfuncionarios
WHERE
    data_matricula BETWEEN '2020-01-01' AND '2023-12-31'
ORDER BY data_matricula;

/* Ver filmes do genêro fantasia (CONSULTA IN)*/
SELECT * FROM tbfilme WHERE genero IN ('Fantasia');

/* VIEWS */

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

/* ENDEREÇOS DOS CLIENTES */
CREATE VIEW ViewEnderecosClientes AS
SELECT
    c.id_cliente,
    c.nome AS nome_cliente,
    c.CPF,
    c.email,
    c.telefone,
    e.CEP,
    e.endereco,
    e.numero,
    e.bairro,
    e.cidade,
    e.estado,
    e.pais
FROM tbclientes c
JOIN tbendereco e ON c.fk_id_endereco = e.id_endereco;

SELECT * FROM ViewEnderecosClientes;

/*ENDEREÇO DOS FUNCIONÁRIOS */
CREATE VIEW ViewEnderecosFuncionarios AS
SELECT
    f.mat_func,
    f.nome AS nome_funcionario,
    f.CPF,
    f.email,
    f.telefone,
    e.CEP,
    e.endereco,
    e.numero,
    e.bairro,
    e.cidade,
    e.estado,
    e.pais
FROM tbfuncionarios f
JOIN tbendereco e ON f.fk_id_endereco = e.id_endereco;

SELECT * FROM ViewEnderecosFuncionarios;

/* ENDEREÇO DOS FORNECEDORES */
CREATE VIEW ViewEnderecosFornecedores AS
SELECT
    fr.id_fornecedor,
    fr.razao_social AS nome_fornecedor,
    fr.CNPJ,
    fr.nome_fantasia,
    fr.telefone,
    fr.whatsapp,
    fr.email,
    fr.ramal,
    fr.site,
    e.CEP,
    e.endereco,
    e.numero,
    e.bairro,
    e.cidade,
    e.estado,
    e.pais
FROM tbfornecedor fr
JOIN tbendereco e ON fr.fk_id_endereco = e.id_endereco;

SELECT * FROM ViewEnderecosFornecedores;

-- EXECUÇÃO PROCEDURES

CALL VerificarMulta(5, @nome_cliente, @id_cliente, @total_multa);
SELECT @nome_cliente AS nome_cliente, @id_cliente 
AS id_cliente, @total_multa AS total_multa;

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
-- DELETE FROM tblocacoes;
-- DELETE FROM tbfornecedor;
-- DELETE FROM tbitenslocacao;