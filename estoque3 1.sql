-- a. criar, usar e apagar o banco de dados
CREATE DATABASE estoque;
USE estoque;
DROP DATABASE estoque;
SHOW TABLES;

-- b. criar, alterar e apagar tabelas
CREATE TABLE produto (
    idP INT PRIMARY KEY AUTO_INCREMENT,
    estoque_minimo INT NOT NULL
);
 
CREATE TABLE equipamento (
	idE INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    status ENUM ('disponível','em manutenção','indisponível') DEFAULT 'disponível'
);
 
CREATE TABLE categoria (
	idC INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL UNIQUE
);
 
CREATE TABLE endereco (
	idEnd INT PRIMARY KEY AUTO_INCREMENT,
    rua VARCHAR(45),
    bairro VARCHAR(45),
    cidade VARCHAR(45),
    sigla_estado CHAR(2)
);

CREATE TABLE fornecedor (
	idF INT AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR (100) NOT NULL,
    telefone CHAR(11) NOT NULL,
    email VARCHAR (100) NOT NULL,
    idEnd INT,
    FOREIGN KEY (idEnd) REFERENCES endereco (idEnd)
);

CREATE TABLE marca (
	idM INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    CNPJ CHAR(14) UNIQUE
);

 CREATE TABLE prod_forn (
    idF INT,
    idP INT,
    quantidade INT NOT NULL,
	preco_unit DECIMAL(10,2) NOT NULL,
    data_validade DATE NOT NULL,
    data_aquisicao DATE NOT NULL,
    PRIMARY KEY (idF,idP),
    CONSTRAINT fk_prod_forn_fornecedor FOREIGN KEY (idF) REFERENCES fornecedor (idF),
    CONSTRAINT fk_prod_forn_produto FOREIGN KEY (idP) REFERENCES produto(idP)
);
 
CREATE TABLE forn_equip (
	idF INT,
    idE INT,
	data_aquisicao DATE,
	quantidade INT,
	preco_unit DECIMAL(10,2) NOT NULL,
    vida_util VARCHAR(45),
    garantia VARCHAR(45),
    CONSTRAINT fk_forn_equip_fornecedor FOREIGN KEY (idF) REFERENCES fornecedor (idF),
    CONSTRAINT fk_forn_equip_equipamento FOREIGN KEY(idE) REFERENCES equipamento (idE)
);

CREATE TABLE prod_categ (
    idC INT,
    idP INT,
    PRIMARY KEY (idC, idP),
    CONSTRAINT fk_prod_categ_produto FOREIGN KEY (idP) REFERENCES produto(idP),
    CONSTRAINT fk_prod_categ_categoria FOREIGN KEY (idC) REFERENCES categoria(idC)
);
 
CREATE TABLE equip_marca (
    idE INT,
    idM INT,
    modelo VARCHAR(45),
	porte ENUM ('pequeno','médio','grande'),
    observacoes TEXT,
    PRIMARY KEY (idE, idM),
    CONSTRAINT fk_equip_marca_equip FOREIGN KEY (idE) REFERENCES equipamento(idE),
    CONSTRAINT fk_equip_marca_marca FOREIGN KEY (idM) REFERENCES marca(idM)
);

CREATE TABLE prod_marca (
    idP INT,
    idM INT,
    volume FLOAT,
    unidade_medida ENUM('kg','g','mg','l','ml','unidades'),
    observacoes TEXT,
    PRIMARY KEY (idP, idM),
    CONSTRAINT fk_prod_marca_prod FOREIGN KEY (idP) REFERENCES produto(idP),
    CONSTRAINT fk_prod_marca_marca FOREIGN KEY (idM) REFERENCES marca(idM)
);

CREATE TABLE forn_marca (
    idF INT,
    idM INT,
    PRIMARY KEY (idF, idM),
    CONSTRAINT fk_forn_marca_forn FOREIGN KEY (idF) REFERENCES fornecedor(idF),
    CONSTRAINT fk_forn_marca_marca FOREIGN KEY (idM) REFERENCES marca(idM)
);

-- Renomeando e adicionando colunas
ALTER TABLE prod_forn CHANGE COLUMN preco_unit preco_unitario DECIMAL(10,2) NOT NULL;
ALTER TABLE forn_equip CHANGE COLUMN preco_unit preco_unitario DECIMAL(10,2) NOT NULL;

ALTER TABLE produto ADD COLUMN frete DECIMAL(10,2);
ALTER TABLE produto DROP COLUMN frete;
ALTER TABLE produto ADD COLUMN tamanho FLOAT NOT NULL;
ALTER TABLE produto DROP COLUMN tamanho;

ALTER TABLE produto ADD COLUMN nome VARCHAR(45) NOT NULL;
ALTER TABLE produto MODIFY COLUMN nome VARCHAR(45) NOT NULL AFTER idP;
ALTER TABLE produto ADD COLUMN ativo bool;

-- Drop primeiro na tabela de relação, pois ocorre o erro 1451 de erro de constraint
DROP TABLE prod_categ;
DROP TABLE categoria;

-- c. inserir, atualizar e deletar. Inserir pelo menos três registros em cada tabela por integrante do grupo
INSERT INTO categoria (nome) VALUES 
('fertilizante'),('adubo'),('minério'),
('semente/grão'),('inseticida'),('herbicida'),
('produtos processados'),('produtos naturais'),('produtos de origem animal');

INSERT INTO produto (nome,estoque_minimo)
VALUES 
('Fertilizante para flores',50),
('Fertilizante geral',50),
('Semente Soja BRS 1003',20),
('DDMAX 1000 CE',50),
('Semente De Alface Crespa',50),
('Adubo Orgânico', 60),
('Adubo com humus de minhoca', 30),
('Calcio FORTH EQUILIBRIO', 100),
('Calcario agricola cinza', 25);

INSERT INTO marca (nome, CNPJ) VALUES
('Forth flores',11223344556677),
('Yoorin Master',12223344556677),
('IPRO',11223344556671),
('Model Bejo',11223344556672),
('Insetimax',11223344556673),
('All Garden',11223344556674),
('Forth',11223344556675),
('Calx',11223344556676),
('Toyama',11223344556678),
('Vonder',11223344556679),
('Tropical',11223344556670),
('Knapik',11223344556177),
('Calcario Itau',11223344556617),
('DX','12345678909876'),
 ('MR equipamentos','09876543212345'),
 ('SZS','57684938213456'),
 ('ABC','00998877665544');
 
DELETE FROM marca;
SELECT * FROM produto;
select * from marca;

INSERT INTO prod_marca (idP, idM, volume, unidade_medida, observacoes)
VALUES 
(1,1,3,'kg',
'O Fertilizante Forth Flores 3kg é um grande auxílio para o cultivo em jardins, varandas, sacadas, jardins, ou mesmo em estufas, pois, é pensado no favorecimento da genética da planta durante a formação das flores.'),
(2,2,1,'kg',
'Yoorin é um fertilizante que está há mais de 50 anos no mercado, e é recomendado para jardins, vasos, hortas, gramados e frutíferas. É uma fonte de fósforo e outros nutrientes, que possui certificação do ibd para uso em agricultura orgânica.'),
(3,3,40,'kg',
'A cultivar BRS 1003IPRO é uma soja transgênica com tolerância ao herbicida glifosato e com a tecnologia Intacta RR2 PROTM, que controla um grupo de lagartas.'),
(4,5,1,'l',
'DDMAX 1000 CE é um inseticida organofosforado eficaz no controle de: Formigas, Baratas, Mosquitos, Pulgas e Moscas'),
(5,4,5000,'unidades',
'Líder no mercado que busca qualidade, esta cultivar apresenta raízes muito lisas, uniformes e de excelente coloração interna e externa. Folhas verde-escuras de tamanho intermediário.');

-- Outro Insert para produtos sem observacoes
INSERT INTO prod_marca (idP, idM, volume, unidade_medida)
VALUES 
(6,2,5,'kg'),
(7,6,2,'kg'),
(8,7,60,'ml'),
(9,8,20,'kg');


INSERT INTO endereco (rua,bairro,cidade,sigla_estado)
VALUES ('Rua A','Bairro A','Poá','SP'),
('Rua B','Bairro B','Mogi das Cruzes','SP'),
('Rua C','Bairro C','Ferraz de Vasconcelos','SP'),
('Rua D','Bairro D','São Paulo','SP'),
('Rua E','Bairro E','Suzano','SP');

INSERT INTO fornecedor (nome,telefone,email,idEnd)
VALUES ('Loja XMAX',11112222222,'lojaxmax@email.com',1),
('Armazém Lins',11222333444,'armazemlins@email.com',4),
('TH store',10102233455,'thstore@email.com',3),
('Trator Agro',33445566778,'tratoragro@email.com',2),
('Suzanmaq',10101099888,'suzanmaq@email.com',5);

INSERT INTO prod_forn (idF,idP,quantidade,preco_unitario,data_validade,data_aquisicao)
VALUES
(1,1,60,62.54,'2025-05-01','2024-10-28'),
(3,2,50,21.90,'2024-12-30','2024-09-16'),
(2,3,30,17.00,'2026-01-30','2024-11-02'),
(1,4,10,192.20,'2024-11-30','2024-10-28'),
(1,5,60,149.90,'2024-10-30','2024-08-20'),
(2,6,25,40.00,'2025-05-01','2024-08-20'),
(2,7,60,7.50,'2025-05-01','2024-11-02'),
(3,8,80,24.90,'2026-06-01','2024-04-17'),
(1,9,30,29.00,'2026-12-01','2024-02-20');

DELETE FROM prod_forn;

INSERT INTO prod_categ (idC,idP)
VALUES 
(1,1),
(1,2),
(2,6),
(2,7),
(3,8),
(3,9),
(4,3),
(4,5),
(5,4),
(7,1),
(7,2),
(7,4),
(7,8),
(7,9),
(8,3),
(8,5),
(8,6),
(9,7);

SELECT * FROM produto;
SELECT * FROM categoria;

INSERT INTO forn_equip (idF,idE,data_aquisicao,quantidade,preco_unitario,vida_util,garantia)
VALUES (4,1,'2023-11-30',2,3500.00,'4 anos','1 ano'),
(4,2,'2023-08-18',3,1600.90,'3 anos','1 ano'),
(4,3,'2024-01-23',5,500.00,'2 anos',null),
(5,4,'2024-06-30',4,890.00,null,'1 ano'),
(4,5,'2024-07-25',5,500.90,'1 ano','6 meses'),
(5,6,'2023-09-20',3,670.89,'1 ano','3 meses'),
(5,7,'2024-10-23',10,40.99,'3 anos','6 meses'),
(4,8,'2023-12-30',7,29.99,'3 anos',null),
(4,9,'2024-12-29',7,35.90,'3 anos',null);

INSERT INTO forn_marca (idF,idM)
VALUES 
(1,1),
(1,5),
(1,4),
(1,8),
(2,3),
(2,2),
(2,6),
(3,2),
(3,7),
(4,9),
(4,10),
(4,11),
(4,13),
(4,16),
(4,17),
(5,12),
(5,14),
(5,15);

SELECT * FROM forn_marca;
SELECT * FROM fornecedor;
SELECT * FROM equip_marca;

INSERT INTO equipamento (nome, status) VALUES
('Motocultivador','disponível'),
('Pulverizador Costal Agrícola','em manutenção'),
('Mini Estufa Agricola','disponível'),
('Semeadeira para Motocultivador','indisponível'),
('Cortador de Grama', 'disponível'),
('Grade Aradora', 'em manutenção'),
('Mangueira', 'disponível'),
('Enxada', 'indisponível'),
('Pá', 'indisponível');
SELECT * FROM equipamento;
 
INSERT INTO equip_marca (idE, idM, modelo, porte, observacoes) VALUES
(1,9,'AX21','médio','O Motocultivador a gasolina 7 hp 4 tempos TT90R-XP-U da Toyama é projetado para uso profissional, destacando-se pela sua funcionalidade impressionante e imbatível combinação de facilidade de utilização e segurança.'),
(2,10,'11223','pequeno','Permite a reversão da alavanca, facilitando o trabalho para destros e canhotos. Possui trava no gatilho que proporciona menor fadiga, além de alça para transporte com ajuste e travamento e destravamento rápido.'),
(3,11,null,'grande','Nela pode ser cultivado diversos tipos de cultivos, como: suculentas, orquídeas, hortaliças, temperos, mudas, flores, etc…');

INSERT INTO equip_marca (idE, idM, modelo, porte) VALUES
(4,12,null,'médio'),
(5, 13,'RTS7080', 'médio'),
(6, 14, 'BYF232', 'grande'),
(7, 15, null, 'grande'),
(8, 16, null, 'médio'),
(9, 17, null, 'médio');

 SELECT * FROM equip_marca;
 SELECT * FROM marca;
 SELECT * FROM equipamento;
 
UPDATE produto SET ativo = 1 WHERE idP = 1;
UPDATE produto SET ativo = 1 WHERE idP = 2;
UPDATE produto SET ativo = 0 WHERE idP = 3;
UPDATE produto SET ativo = 1 WHERE idP = 4;
UPDATE produto SET ativo = 0 WHERE idP = 5;
UPDATE produto SET ativo = 1 WHERE idP = 6;
UPDATE produto SET ativo = 1 WHERE idP = 7;
UPDATE produto SET ativo = 0 WHERE idP = 8;
UPDATE produto SET ativo = 1 WHERE idP = 9;

-- d) criar backup das tabelas 
CREATE TABLE produto_backup (
	SELECT * FROM produto
);

CREATE TABLE equipamento_backup (
	SELECT * FROM equipamento
);

CREATE TABLE categoria_backup (
	SELECT * FROM categoria
);

CREATE TABLE endereco_backup (
	SELECT * FROM endereco
);

CREATE TABLE fornecedor_backup (
	SELECT * FROM fornecedor
);

CREATE TABLE marca_backup (
	SELECT * FROM marca
);

CREATE TABLE prod_forn_backup (
	SELECT * FROM prod_forn
);

CREATE TABLE forn_equip_backup (
	SELECT * FROM forn_equip
);

CREATE TABLE prod_categ_backup (
	SELECT * FROM prod_categ
);

CREATE TABLE equip_marca_backup (
	SELECT * FROM equip_marca
);

CREATE TABLE prod_marca_backup (
	SELECT * FROM prod_marca
);

CREATE TABLE forn_marca_backup (
	SELECT * FROM forn_marca
);
-- e) criar Select para consultar todos os dados das tabelas. Uma consulta destas por tabela do DER.
USE estoque;
SELECT * FROM categoria;
SELECT * FROM endereco;
SELECT * FROM equip_marca;
SELECT * FROM equipamento;
SELECT * FROM forn_equip;
SELECT * FROM forn_marca;
SELECT * FROM fornecedor;
SELECT * FROM marca;
SELECT * FROM prod_categ;
SELECT * FROM prod_forn;
SELECT * FROM prod_marca;
SELECT * FROM produto;
 
-- f) criar Select para consultar algum campo das tabelas. Pelo menos três selects.
SELECT nome FROM produto;
SELECT idP FROM produto;
SELECT estoque_minimo FROM produto;
 
-- g) criar Select para consultar campos que estão em mais de uma tabela, ou seja, com junção de tabelas. Pelo menos  duas junções.
SELECT e.nome, em.modelo FROM equip_marca AS em, equipamento AS e
WHERE em.idE = e.idE;

-- h) criar Select para consultar campos que estão em mais de uma tabela, ou seja, com junção de tabelas usando inner join. Pelo menos uma junção com inner join. 
-- JOIN - total de fornecedores com mais produtos ativos na plataforma
 SELECT f.nome AS nome_fornecedor, COUNT(p.idP) AS total_produtos_ativos
FROM fornecedor f
JOIN prod_forn pf ON f.idF = pf.idF
JOIN produto p ON pf.idP = p.idP
WHERE p.ativo = 1
GROUP BY f.nome
ORDER BY total_produtos_ativos DESC
LIMIT 10;

-- inner join - NOME DOS FORNECEDORES E O NOME DOS PRODUTOS ATIVOS QUE ELES POSSUEM
SELECT f.nome AS nome_fornecedor, p.nome AS nome_produto
FROM fornecedor f
INNER JOIN prod_forn pf ON f.idF = pf.idF
INNER JOIN produto p ON pf.idP = p.idP
WHERE p.ativo = 1;

-- inner join. junção das tabelas de produto, fornecedor, quantidade e preço
SELECT p.nome AS Produto, f.nome AS Fornecedor, pf.quantidade, pf.preco_unitario
FROM produto p
INNER JOIN prod_forn pf ON p.idP = pf.idP
INNER JOIN fornecedor f ON pf.idF = f.idF;

-- i) criar pelo menos duas views  abrangendo dados das tabelas com filtragem. 
-- view para adubos
CREATE VIEW produto_adu AS 
SELECT nome
FROM produto p
WHERE nome LIKE "%adubo%";

SELECT * FROM produto_adu;

-- view para fertilizante
CREATE VIEW produto_fert AS
SELECT nome
FROM produto p
WHERE nome LIKE "%fertilizante%";

SELECT * FROM produto_fert;

-- j) criar dois procedimentos e duas função, sendo uma com passagem de parâmetros.

SELECT * FROM produto;
-- 1 = inserir, 2 = atualizar, 3 = deletar
DELIMITER //
CREATE PROCEDURE gerenciamento_produto (acao INT, id INT, n VARCHAR(45),e INT, a BOOL)
BEGIN
	CASE acao
		WHEN 1 THEN -- INSERIR 
			INSERT INTO produto VALUES (id,n,e,a);
        WHEN 2 THEN -- ATUALIZAR
			UPDATE produto SET idP = id, nome = n, estoque_minimo = e, ativo = a
			WHERE idP = id;	
        WHEN 3 THEN -- DELETAR
			DELETE FROM produto WHERE idP = id;
    END CASE;
    SELECT * FROM produto;
END //
DELIMITER ;

DROP PROCEDURE gerenciamento_produto;
CALL gerenciamento_produto(1,16,'Teste da procedure',100,0);
CALL gerenciamento_produto (2,15,'Herbicida X',20,1);
CALL gerenciamento_produto(3,16,'Teste da procedure',100,0);

SELECT * FROM equipamento;

DELIMITER //
CREATE PROCEDURE gerenciamento_equipamento 
(acao INT,id INT,n VARCHAR(45),s ENUM ('disponível','em manutenção', 'indisponível'))
BEGIN
	CASE acao
		WHEN 1 THEN -- INSERIR 
			INSERT INTO equipamento VALUES (id,n,s);
        WHEN 2 THEN -- ATUALIZAR
			UPDATE equipamento SET idE = id, nome = n, status = s
			WHERE idE = id;	
        WHEN 3 THEN -- DELETAR
			DELETE FROM equipamento WHERE idE = id;
    END CASE;
    SELECT * FROM equipamento;
END //
DELIMITER ;

-- Função que mostra se precisa comprar mais produtos
DELIMITER //
CREATE FUNCTION alerta_de_estoque (idP INT)
RETURNS VARCHAR(100) NOT DETERMINISTIC
BEGIN	
	DECLARE alerta_estoque VARCHAR(100);
    SELECT IF(p.estoque_minimo >= pf.quantidade,
	'O estoque precisa ser reabastecido!',
	'Estoque dentro do esperado.')
	AS alerta_estoque INTO alerta_estoque
	FROM produto p 
	INNER JOIN prod_forn pf ON p.idP=pf.idP
    WHERE pf.idP = idP;
    RETURN alerta_estoque;
END //
DELIMITER ;

SET GLOBAL log_bin_trust_function_creators = 1;
DROP FUNCTION alerta_de_estoque;
-- Checando se a function deu certo
SELECT alerta_de_estoque(1);
SELECT alerta_de_estoque(8);

SELECT p.estoque_minimo,pf.quantidade
FROM produto p 
INNER JOIN prod_forn pf ON p.idP=pf.idP;

-- Função que calcula o custo total de acordo com a categoria
DELIMITER //
CREATE FUNCTION custo_por_categoria (nome VARCHAR(45))
RETURNS DECIMAL (10,2) NOT DETERMINISTIC
BEGIN
	DECLARE custo_por_categ DECIMAL(10,2);
	SELECT SUM(pf.preco_unitario * pf.quantidade) AS custo_por_categ
    INTO custo_por_categ
    FROM prod_forn pf 
    INNER JOIN prod_categ pc ON pf.idP = pc.idP
    INNER JOIN categoria c ON 
    pc.idC = c.idC WHERE c.nome = nome;
    RETURN custo_por_categ;
END //
DELIMITER ;

DROP FUNCTION custo_por_categoria;
SELECT custo_por_categoria ('fertilizante');

-- k) criar um procedimento para inserção de dados usando estrutura condicional  para executar commit e rollback conforme exemplificado 
DELIMITER //
CREATE PROCEDURE insere_categoria (IN id INT, IN n VARCHAR(45))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION -- Manipulador para casos de erro
		BEGIN
			ROLLBACK;
			SELECT 'Erro ao inserir categoria' AS mensagem;
		END;
    START TRANSACTION;
    IF EXISTS (SELECT 1 FROM categoria WHERE idC = id OR nome = n) -- verificação se o valor existe
    THEN
        SELECT 'id ou nome já existem!' AS mensagem; 
        ROLLBACK;
    ELSE
        INSERT INTO categoria (idC, nome) VALUES (id, n); 
        COMMIT;
        SELECT 'Inserção realizada com sucesso' AS mensagem;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE insere_categoria;
CALL insere_categoria (17,'adubo');
CALL insere_categoria (10,'areia');
SELECT * FROM categoria;

-- L) Criar pelo menos uma trigger
-- Trigger para fazer backup dos dados
DELIMITER //
CREATE TRIGGER backup_produto
AFTER INSERT ON produto
FOR EACH ROW
BEGIN
	INSERT INTO produto_backup VALUES (NEW.idP, NEW.nome, NEW.estoque_minimo);
END //
DELIMITER ;

SELECT * FROM produto_backup;
CALL insere_produto ('Semente de abobora', 35);

-- m) criar pelo menos um select que usa um subselect
-- Retorna dados do fornecedor se seus produtos são da categoria "Fertilizante"
SELECT 
    f.nome AS fornecedor, 
    f.telefone AS contato, 
    pf.preco_unitario
FROM 
    fornecedor f
INNER JOIN 
    prod_forn pf ON f.idF = pf.idF
WHERE 
    pf.idP IN (
        SELECT idP 
        FROM prod_categ 
        WHERE idC = (SELECT idC FROM categoria WHERE nome = 'Fertilizante')
    );

-- n) criar indice (por exemplo, para nome e cpf)
-- Índice para acelerar a busca por fornecedor pelo nome
CREATE INDEX idx_nome_fornecedor ON fornecedor (nome);

