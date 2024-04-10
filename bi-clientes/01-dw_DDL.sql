
--
-- PERIODO / TEMPO
--
CREATE TABLE dim_time
(
  fk_time INTEGER
, version INTEGER
, date_from DATE
, date_to DATE
, Ano SMALLINT
, DiaAno SMALLINT
, "data" DATE
, Mes SMALLINT
, DiaMes SMALLINT
, DiaMesDesc VARCHAR(6)
, DiaSemana SMALLINT
, SemanaAno SMALLINT
, SemanaAnoDesc VARCHAR(6)
, DiaSemanaDesc VARCHAR(30)
, DiaSemanaDescAbrv VARCHAR(3)
, MesDesc VARCHAR(30)
, MesDescAbrv VARCHAR(3)
, MesDescAbrvAno VARCHAR(6)
, Trimestre SMALLINT
, AnoMes VARCHAR(7)
, DiaMesSemana VARCHAR(6)
, AnoEspMes VARCHAR(7)
, Estacao VARCHAR(10)
, CONSTRAINT dim_time_pkey PRIMARY KEY (fk_time)
);
CREATE INDEX idx_dim_time ON dim_time(fk_time);
CREATE INDEX idx_dim_time_lookup ON dim_time(Ano, DiaAno, Trimestre, Mes, DiaMes, DiaSemana, estacao);


--
-- TAGS / IDENTIFICADORES
--
CREATE TABLE IF NOT EXISTS dim_tag
(
  fk_tag BIGINT NOT NULL
, versao INTEGER
, data_inicial DATE
, data_final DATE
, id_tag BIGINT
, unique_identifier NUMERIC
, name VARCHAR(255)
, type VARCHAR(255)
, descricao VARCHAR(255)
, CONSTRAINT dim_tag_pkey PRIMARY KEY (fk_tag)
);
CREATE INDEX idx_dim_tag ON dim_tag(fk_tag);
CREATE INDEX idx_dim_tag_lookup ON dim_tag(fk_tag, id_tag, unique_identifier, name, type, descricao);
CREATE VIEW skill AS SELECT fk_tag, name, id_tag, unique_identifier FROM dim_tag
    WHERE type = 'SKILL' OR fk_tag=0;
CREATE VIEW brand AS SELECT fk_tag, name, id_tag FROM dim_tag
    WHERE type = 'BRAND' OR fk_tag=0;   
CREATE VIEW line AS SELECT fk_tag, name, id_tag FROM dim_tag
    WHERE type = 'LINE' OR fk_tag=0;   
CREATE VIEW account_plan AS SELECT fk_tag, name, id_tag FROM dim_tag
    WHERE type = 'ACCOUNT_PLAN' OR fk_tag=0;   
CREATE VIEW account_group AS SELECT fk_tag, name, id_tag FROM dim_tag
    WHERE type = 'ACCOUNT_GROUP' OR fk_tag=0;   
CREATE VIEW payment AS SELECT fk_tag, name, id_tag FROM dim_tag
    WHERE type = 'PAYMENT' OR fk_tag=0;


--
-- CLIENTES
--
CREATE TABLE IF NOT EXISTS dim_customer
(
  fk_customer BIGINT NOT NULL
, versao INTEGER
, data_inicial TIMESTAMP
, data_final TIMESTAMP
, customer_id BIGINT
, nome VARCHAR(255)
, cpf VARCHAR(25)
, email VARCHAR(255)
, phone1 VARCHAR(25)
, phone2 VARCHAR(25)
, cadastro text
, nascimento DATE
, sexo VARCHAR(15)
, endereco VARCHAR(255)
, cidade VARCHAR(255)
, estado VARCHAR(255)
, bairro VARCHAR(255)
, pais VARCHAR(255)
, ultima_visita VARCHAR(12)
, CONSTRAINT dim_customer_pkey PRIMARY KEY (fk_customer)
);
CREATE INDEX idx_dim_customer ON dim_customer(fk_customer);
CREATE INDEX idx_dim_customer_lookup ON dim_customer(customer_id, nome, ultima_visita, cpf, email, phone1, phone2);


--
-- SERVICOS
--
CREATE TABLE IF NOT EXISTS dim_service
(
  versao INTEGER
, data_inicial DATE
, data_final DATE
, service_type_id BIGINT
, active VARCHAR(7)
, servico VARCHAR(150)
, valor NUMERIC(21, 2)
, max_value NUMERIC(21, 2)
, comissao DOUBLE PRECISION
, professional_id BIGINT
, duracao INTEGER
, deleted BOOLEAN
, taxa DOUBLE PRECISION
, origem VARCHAR(15)
, fk_service BIGINT NOT NULL
, CONSTRAINT dim_service_pkey PRIMARY KEY (fk_service)
);
CREATE INDEX idx_dim_service ON dim_service USING btree (fk_service);
CREATE INDEX idx_dim_service_lookup ON dim_service USING btree (service_type_id, servico);

--
-- PRODUTOS
--
CREATE TABLE IF NOT EXISTS dim_product
(
  versao INTEGER
, data_inicial DATE
, data_final DATE
, service_type_id BIGINT
, title VARCHAR(255)
, brand VARCHAR(150)
, line VARCHAR(255)
, measure_type VARCHAR(5)
, measure INTEGER
, value numeric(19,2)
, use_value NUMERIC(19, 2)
, active VARCHAR(7)
, default_value NUMERIC(19, 2)
, profit NUMERIC(19, 2)
, use_profit NUMERIC(19, 2)
, ncm_code VARCHAR(255)
, bar_code VARCHAR(255)
, cod VARCHAR(255)
, weight INTEGER
, create_date TIMESTAMP
, last_update TIMESTAMP
, deleted BOOLEAN
, fk_product BIGINT NOT NULL
, stock_quantity VARCHAR(50)
, CONSTRAINT dim_product_pkey PRIMARY KEY (fk_product)
);
CREATE INDEX idx_dim_product_pkey ON dim_product(fk_product);
--CREATE INDEX idx_dim_product ON dim_product(fk_product, measure_type, measure); --aparentemente nao resolveu a lentidao e ainda piorou um pouco
CREATE INDEX idx_dim_product_lookup ON dim_product(service_type_id, title, measure_type, measure, stock_quantity);


--
-- PROFISSIONAIS
--
CREATE TABLE IF NOT EXISTS dim_professional
(
  professional_id BIGINT
, versao INTEGER
, data_inicial TIMESTAMP
, data_final TIMESTAMP
, cpf VARCHAR(255)
, nome VARCHAR(255)
, apelido VARCHAR(255)
, banco VARCHAR(255)
, conta VARCHAR(255)
, digito_conta VARCHAR(255)
, agencia VARCHAR(255)
, email VARCHAR(255)
, endereco VARCHAR(255)
, complemento VARCHAR(255)
, cep VARCHAR(255)
, cidade VARCHAR(255)
, pais VARCHAR(255)
, bairro VARCHAR(255)
, numero VARCHAR(255)
, estado VARCHAR(255)
, telefone TEXT
, equipe VARCHAR(255)
, fk_professional BIGINT NOT NULL
, CONSTRAINT dim_professional_pkey PRIMARY KEY (fk_professional)
);
CREATE INDEX idx_dim_professional ON dim_professional(fk_professional);
CREATE INDEX idx_dim_professional_lookup ON dim_professional(professional_id, nome);

--
-- PROMOCOES
--
CREATE TABLE IF NOT EXISTS dim_promotion
(
  fk_promotion BIGINT NOT NULL
, versao INTEGER
, data_inicial DATE
, data_final DATE
, promo_id BIGINT
, enabled BOOLEAN
, title VARCHAR(255)
, begin_date DATE
, end_date DATE
, CONSTRAINT dim_promotion_pkey PRIMARY KEY (fk_promotion)
);
CREATE INDEX idx_dim_promotion ON dim_promotion(fk_promotion);
CREATE INDEX idx_dim_promotion_lookup ON dim_promotion(promo_id, title, begin_date, end_date);

--
-- VOUCHER DROP TABLE dim_voucher
--
CREATE TABLE IF NOT EXISTS dim_voucher
(
  fk_voucher BIGINT NOT NULL
, versao INTEGER
, data_inicial DATE
, data_final DATE
, voucher_id BIGINT
, create_date DATE
, use_date DATE
, status VARCHAR(25)
, key VARCHAR(255)
, value numeric(19,2)
, CONSTRAINT dim_voucher_pkey PRIMARY KEY (fk_voucher)
);
CREATE INDEX idx_dim_voucher ON dim_voucher(fk_voucher);
CREATE INDEX idx_dim_voucher_lookup ON dim_voucher(fk_voucher, voucher_id, key, create_date, use_date);

--
-- Stock
--
CREATE TABLE dim_stock
(
  fk_stock BIGINT NOT NULL
, stock_id BIGINT NOT NULL
, versao INTEGER
, data_inicial DATE
, data_final DATE
, professional_id BIGINT
, name VARCHAR(255)
, type VARCHAR(30)
, CONSTRAINT dim_stock_pkey PRIMARY KEY (fk_stock)
);
CREATE INDEX idx_dim_stock ON dim_stock(fk_stock);
CREATE INDEX idx_dim_stock_lookup ON dim_stock(stock_id, professional_id, name, type);

--
-- Company
--
CREATE TABLE IF NOT EXISTS dim_company
(
  fk_comp BIGINT NOT NULL
, version INTEGER
, begin_date DATE
, end_date DATE
, company_id BIGINT
, name VARCHAR(255)
, CONSTRAINT dim_company_pkey PRIMARY KEY (fk_comp)
);
CREATE INDEX idx_dim_company ON dim_company(fk_comp);
CREATE INDEX idx_dim_company_lookup ON dim_company(company_id, name);

--
-- FACT Tables DROP TABLE fact_operation
--
CREATE TABLE fact_operation
(
  id_fact_operation bigint NOT NULL,
  date DATE,
  appointment_id BIGINT,
  value_prof numeric(19,2),
  value_pass numeric(19,2), --repasse
  value_comp numeric(19,2),
  value_use numeric(19,2), --insumo
  value_sell numeric(19,2), --revenda
  use_service numeric(19,2), --isumo:uso_em_servico
  fix_service numeric(19,2), --insumo:fixo_em_servico
  tax numeric(19,2),
  tax_value numeric(19,2),
  discount numeric(19,2),
  before_discount numeric(19,2),
  promotion numeric(19,2),
  quantity_un DOUBLE PRECISION,
  equipe VARCHAR(255),
  movement_type VARCHAR(30),
  preference BIGINT,
  fk_time integer NOT NULL,
  fk_customer bigint,
  fk_stock bigint,
  fk_professional bigint NOT NULL,
  fk_service bigint NOT NULL,
  fk_product bigint NOT NULL,
  fk_skill bigint NOT NULL,
  fk_brand bigint NOT NULL,
  fk_comp BIGINT NOT NULL,
  fk_promotion BIGINT NOT NULL,
  fk_voucher BIGINT NOT NULL,
  CONSTRAINT fact_operation_pkey PRIMARY KEY (id_fact_operation)
);
CREATE SEQUENCE seq_fact_operation START 1;
CREATE INDEX idx_fact_operation_pkey ON fact_operation(id_fact_operation);
CREATE INDEX idx_fact_operation_lookup ON fact_operation(fk_time, fk_customer, fk_professional, fk_service, fk_skill, fk_brand, fk_comp, fk_promotion, fk_voucher);


CREATE TABLE IF NOT EXISTS fact_stock
(
  id_fact_stock BIGINT NOT NULL
, appointment_id BIGINT
, name VARCHAR(255)
, stock_type VARCHAR(30)
, stock_origin VARCHAR(255)
, product_register_date VARCHAR(10)
, quantity_un DOUBLE PRECISION
, type VARCHAR(30)
, service_type_measure INTEGER
, line VARCHAR(255)
, date DATE 
, expiration VARCHAR(10)
, fk_professional BIGINT NOT NULL
, fk_product BIGINT NOT NULL
, fk_time INTEGER NOT NULL
, fk_expire INTEGER NOT NULL
, fk_tag BIGINT NOT NULL --marca
, fk_comp BIGINT NOT NULL
, CONSTRAINT fact_stock_pkey PRIMARY KEY (id_fact_stock)
);
CREATE SEQUENCE seq_fact_stock START 1;
CREATE INDEX idx_fact_stock_pkey ON fact_stock(id_fact_stock);
CREATE INDEX idx_fact_stock ON fact_stock(name, type, line, expiration, quantity_un, service_type_measure);
CREATE INDEX idx_fact_stock_lookup ON fact_stock(id_fact_stock, fk_time, fk_professional, fk_product, fk_tag, fk_expire, fk_comp);

CREATE TABLE fact_finance
(
  id_fact_finance BIGINT NOT NULL
, date DATE   
, value numeric(21,2)
, fk_account_group BIGINT NOT NULL
, fk_payment BIGINT NOT NULL
, fk_compensation_time INTEGER NOT NULL
, fk_production_time INTEGER NOT NULL
, fk_comp BIGINT NOT NULL
, CONSTRAINT fact_finance_pkey PRIMARY KEY (id_fact_finance)
);
CREATE SEQUENCE seq_fact_finance START 1;
CREATE INDEX idx_fact_finance_pkey ON fact_finance(id_fact_finance);
--CREATE INDEX idx_fact_finance ON fact_finance(account_type,customer_account);
CREATE INDEX idx_fact_finance_lookup ON fact_finance(fk_account_group, fk_payment, fk_compensation_time, fk_production_time, fk_comp);
