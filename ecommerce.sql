-- =====================================================
-- 📊 PROJETO E-COMMERCE SQL - Alice Teodoro Almeida Santos
-- Análise completa de loja online (abril a junho 2024)
-- =====================================================

/*
ESTRUTURA:
- 4 tabelas relacionais
- 6 clientes, 7 produtos, 8 pedidos, 10 itens
- Análises de faturamento, ticket médio, top clientes/produtos
*/

-- 1. LIMPEZA (evita erro ao rodar múltiplas vezes)
DROP TABLE IF EXISTS itens_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS clientes;

-- 2. CRIAR TABELAS
CREATE TABLE clientes (
    id_cliente     INTEGER PRIMARY KEY,
    nome           TEXT NOT NULL,
    email          TEXT,
    cidade         TEXT,
    estado         TEXT,
    data_cadastro  DATE
);

CREATE TABLE produtos (
    id_produto   INTEGER PRIMARY KEY,
    nome         TEXT NOT NULL,
    categoria    TEXT,
    preco        REAL,
    ativo        INTEGER  -- 1=ativo, 0=descontinuado
);

CREATE TABLE pedidos (
    id_pedido     INTEGER PRIMARY KEY,
    id_cliente    INTEGER,
    data_pedido   DATE,
    canal_venda   TEXT,   -- Site, App, Marketplace
    status        TEXT,   -- Pago, Cancelado
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE itens_pedido (
    id_item      INTEGER PRIMARY KEY,
    id_pedido    INTEGER,
    id_produto   INTEGER,
    quantidade   INTEGER,
    preco_unit   REAL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- 3. DADOS INICIAIS (abril 2024)
INSERT INTO clientes (id_cliente, nome, email, cidade, estado, data_cadastro) VALUES
(1, 'Ana Souza',    'ana.souza@email.com',    'São Paulo',  'SP', '2024-01-10'),
(2, 'Bruno Lima',   'bruno.lima@email.com',   'Rio de Janeiro', 'RJ', '2024-02-05'),
(3, 'Carla Menezes','carla.m@example.com',    'Belo Horizonte', 'MG', '2024-03-12'),
(4, 'Diego Ramos',  'diego.r@example.com',    'Curitiba', 'PR', '2024-03-25');

INSERT INTO produtos (id_produto, nome, categoria, preco, ativo) VALUES
(1, 'Fone Bluetooth',         'Eletrônicos', 120.00, 1),
(2, 'Mouse Gamer',            'Eletrônicos', 80.00,  1),
(3, 'Camiseta Oversized',     'Moda',        59.90,  1),
(4, 'Tênis Esportivo',        'Moda',        199.90, 1),
(5, 'Copo Térmico',           'Casa',        49.90,  1);

INSERT INTO pedidos (id_pedido, id_cliente, data_pedido, canal_venda, status) VALUES
(1, 1, '2024-04-01', 'Site',       'Pago'),
(2, 1, '2024-04-15', 'App',        'Pago'),
(3, 2, '2024-04-20', 'Marketplace','Pago'),
(4, 3, '2024-04-22', 'Site',       'Cancelado');

INSERT INTO itens_pedido (id_item, id_pedido, id_produto, quantidade, preco_unit) VALUES
(1, 1, 1, 1, 120.00),   -- Ana: 1 fone
(2, 1, 3, 2, 59.90),    -- Ana: 2 camisetas
(3, 2, 2, 1, 80.00),    -- Ana: 1 mouse
(4, 3, 4, 1, 199.90),   -- Bruno: 1 tênis
(5, 4, 5, 1, 49.90);    -- Carla: 1 copo (cancelado)

-- 4. DADOS ADICIONAIS (maio/junho 2024)
INSERT INTO clientes VALUES
(5, 'Eduardo Costa', 'eduardo.c@email.com', 'Porto Alegre', 'RS', '2024-05-01'),
(6, 'Fernanda Silva','fernanda.s@email.com','Salvador', 'BA', '2024-05-15');

INSERT INTO produtos VALUES
(6, 'Headphone Gamer', 'Eletrônicos', 250.00, 1),
(7, 'Calça Jeans',     'Moda',        129.90, 1);

INSERT INTO pedidos VALUES
(5, 4, '2024-05-10', 'Site',       'Pago'),
(6, 5, '2024-05-20', 'App',        'Pago'),
(7, 6, '2024-06-01', 'Marketplace','Pago'),
(8, 1, '2024-06-15', 'Site',       'Pago');

INSERT INTO itens_pedido VALUES
(6, 5, 2, 2, 80.00),    -- Diego: 2 mouses
(7, 6, 6, 1, 250.00),   -- Eduardo: 1 headphone
(8, 7, 7, 1, 129.90),   -- Fernanda: 1 calça
(9, 8, 1, 1, 120.00),   -- Ana: 1 fone
(10,8, 4, 1, 199.90);   -- Ana: 1 tênis

-- 5. VERIFICAR DADOS
SELECT COUNT(*) AS total_clientes FROM clientes;
SELECT COUNT(*) AS total_produtos FROM produtos;
SELECT COUNT(*) AS total_pedidos  FROM pedidos WHERE status = 'Pago';

-- =====================================================
-- 📈 ANÁLISES DE NEGÓCIO
-- =====================================================

-- Faturamento total (pedidos pagos)
SELECT ROUND(SUM(quantidade * preco_unit), 2) AS 'Faturamento Total'
FROM itens_pedido ip JOIN pedidos p ON ip.id_pedido = p.id_pedido 
WHERE p.status = 'Pago';

-- Ticket médio
SELECT ROUND(SUM(ip.quantidade * ip.preco_unit) / COUNT(DISTINCT p.id_pedido), 2) AS 'Ticket Médio'
FROM itens_pedido ip JOIN pedidos p ON ip.id_pedido = p.id_pedido 
WHERE p.status = 'Pago';

-- Faturamento por categoria
SELECT pr.categoria, 
       ROUND(SUM(ip.quantidade * ip.preco_unit), 2) AS faturamento
FROM itens_pedido ip JOIN produtos pr ON ip.id_produto = pr.id_produto 
JOIN pedidos p ON ip.id_pedido = p.id_pedido WHERE p.status = 'Pago'
GROUP BY pr.categoria ORDER BY faturamento DESC;

-- Cliente que mais gastou
SELECT c.nome AS cliente, 
       ROUND(SUM(ip.quantidade * ip.preco_unit), 2) AS total_gasto
FROM itens_pedido ip JOIN pedidos p ON ip.id_pedido = p.id_pedido 
JOIN clientes c ON p.id_cliente = c.id_cliente WHERE p.status = 'Pago'
GROUP BY c.nome ORDER BY total_gasto DESC LIMIT 1;

-- Produto mais vendido (quantidade)
SELECT pr.nome AS produto, SUM(ip.quantidade) AS qtd_vendida
FROM itens_pedido ip JOIN produtos pr ON ip.id_produto = pr.id_produto 
JOIN pedidos p ON ip.id_pedido = p.id_pedido WHERE p.status = 'Pago'
GROUP BY pr.nome ORDER BY qtd_vendida DESC LIMIT 3;

-- Clientes por estado
SELECT estado, COUNT(*) AS qtd_clientes
FROM clientes GROUP BY estado ORDER BY qtd_clientes DESC;
