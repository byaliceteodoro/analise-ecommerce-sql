-- 1. Apagar tabelas se existirem
DROP TABLE IF EXISTS itens_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS clientes;

-- 2. Criar tabelas
CREATE TABLE clientes (...);
CREATE TABLE produtos (...);
CREATE TABLE pedidos  (...);
CREATE TABLE itens_pedido (...);

-- 3. Inserir dados
INSERT INTO clientes ...;
INSERT INTO produtos ...;
INSERT INTO pedidos  ...;
INSERT INTO itens_pedido ...;

-- 4. Análises (consultas)
-- Faturamento total
SELECT ...;

-- Ticket médio
SELECT ...;

-- Faturamento por categoria
SELECT ...;

-- Cliente que mais gastou
SELECT ...;
