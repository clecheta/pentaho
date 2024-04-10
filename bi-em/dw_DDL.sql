-- PERIODO / TEMPO
--
CREATE TABLE IF NOT EXISTS dim_time
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
CREATE INDEX IF NOT EXISTS idx_dim_time ON dim_time(fk_time);
CREATE INDEX IF NOT EXISTS idx_dim_time_lookup ON dim_time(fk_time, Ano, DiaAno, Trimestre, Mes, DiaMes, DiaSemana, estacao);

--
-- CONSTANT VALUE TABLES
--

-- Professional
CREATE TABLE IF NOT EXISTS dim_professional
(
  fk_professional INTEGER NOT NULL
, name VARCHAR(50)
, full_name VARCHAR(255)
, CONSTRAINT dim_professional_pkey PRIMARY KEY (fk_professional)
);
CREATE INDEX IF NOT EXISTS idx_dim_professional ON dim_professional(fk_professional, name);

-- Activity
CREATE TABLE IF NOT EXISTS dim_activity
(
  fk_activity INTEGER NOT NULL
, name VARCHAR(50)
, CONSTRAINT dim_activity_pkey PRIMARY KEY (fk_activity)
);
CREATE INDEX IF NOT EXISTS idx_dim_activity ON dim_activity(fk_activity, name);

-- Payment Form
CREATE TABLE IF NOT EXISTS dim_payment
(
  fk_payment INTEGER NOT NULL
, type VARCHAR(20)
, CONSTRAINT dim_payment_pkey PRIMARY KEY (fk_payment)
);
CREATE INDEX IF NOT EXISTS idx_dim_payment ON dim_payment(fk_payment, type);

-- Work Model
CREATE TABLE IF NOT EXISTS dim_work
(
  fk_work INTEGER NOT NULL
, model VARCHAR(15)
, CONSTRAINT dim_work_pkey PRIMARY KEY (fk_work)
);
CREATE INDEX IF NOT EXISTS idx_dim_work ON dim_work(fk_work, model);

-- Contract Status
CREATE TABLE IF NOT EXISTS dim_contract
(
  fk_contract INTEGER NOT NULL
, status VARCHAR(15)
, CONSTRAINT dim_contract_pkey PRIMARY KEY (fk_contract)
);
CREATE INDEX IF NOT EXISTS idx_dim_contract ON dim_contract(fk_contract, status);

-- Payment Plan
CREATE TABLE IF NOT EXISTS dim_plan
(
  fk_plan INTEGER NOT NULL
, type VARCHAR(15)
, CONSTRAINT dim_plan_pkey PRIMARY KEY (fk_plan)
);
CREATE INDEX IF NOT EXISTS idx_dim_plan ON dim_plan(fk_plan, type);

--
-- DIMENSION TABLES
--

-- Customer
CREATE TABLE IF NOT EXISTS dim_customer
(
  fk_customer INTEGER NOT NULL
, full_name VARCHAR(255)
, whats VARCHAR(30)
, cpf VARCHAR(30)
, email VARCHAR(255)
, son1 VARCHAR(255)
, son2 VARCHAR(255)
, son3 VARCHAR(255)
, fiscal_note VARCHAR(3)
, fk_contract INTEGER
, observation VARCHAR(255)
, CONSTRAINT dim_customer_pkey PRIMARY KEY (fk_customer)
);
CREATE INDEX IF NOT EXISTS idx_dim_customer ON dim_customer(fk_customer);
CREATE INDEX IF NOT EXISTS idx_dim_customer_lookup ON dim_customer(fk_customer, full_name, whats, cpf, email, son1, son2, fiscal_note, fk_contract);

--
-- FACT TABLES
--

-- Income
CREATE TABLE IF NOT EXISTS fact_income
(
  fk_customer BIGINT NOT NULL
, fk_activity BIGINT NOT NULL
, fk_work BIGINT NOT NULL
, fk_plan BIGINT NOT NULL
, fk_professional BIGINT NOT NULL
, fk_payment BIGINT NOT NULL
, fk_time BIGINT NOT NULL
, value numeric(19,2)
, id_fact_income BIGINT NOT NULL
, CONSTRAINT fact_income_pkey PRIMARY KEY (id_fact_income)
);
CREATE SEQUENCE seq_fact_income START 1;
CREATE INDEX idx_fact_income_pkey ON fact_income(id_fact_income, fk_customer, fk_time);
CREATE INDEX idx_fact_income_lookup ON fact_income(id_fact_income, fk_customer, fk_activity, fk_work, fk_plan, fk_professional, fk_payment, fk_time);
