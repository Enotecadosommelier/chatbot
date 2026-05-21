-- SQL Schema for Surf Lodge Drink Management

CREATE TABLE IF NOT EXISTS ingredientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    unidade VARCHAR(20),
    custo_unidade FLOAT NOT NULL,
    fornecedor VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS fichas_tecnicas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_drink VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    preco_venda FLOAT NOT NULL,
    rendimento INTEGER DEFAULT 1,
    descricao TEXT,
    copo_utilizado VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS composicao_drink (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_drink INTEGER,
    id_ingrediente INTEGER,
    quantidade_utilizada FLOAT NOT NULL,
    fator_desperdicio FLOAT DEFAULT 1.0,
    FOREIGN KEY(id_drink) REFERENCES fichas_tecnicas(id),
    FOREIGN KEY(id_ingrediente) REFERENCES ingredientes(id)
);

CREATE TABLE IF NOT EXISTS funcionarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS vendas_lancamentos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_drink INTEGER,
    quantidade INTEGER DEFAULT 1,
    id_funcionario INTEGER,
    local_consumo VARCHAR(50),
    id_quarto_hospede VARCHAR(20),
    FOREIGN KEY(id_drink) REFERENCES fichas_tecnicas(id),
    FOREIGN KEY(id_funcionario) REFERENCES funcionarios(id)
);
