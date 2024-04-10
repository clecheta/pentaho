select * from dim_organization

SELECT * FROM (VALUES (2019), (2020)) as ano

SELECT distinct(dt.Ano)
FROM dim_time dt
WHERE dt.fk_time in (select distinct fk_time from fact_bank)
ORDER BY dt.Ano desc

--comparacao receita x despesa
SELECT 
   dt.mesdescabrvano as Mes,
   sum(case when value >= 0 then value end) as Valor_Entrada,
   sum(case when value < 0 then value end) * -1 as Valor_Saida
FROM fact_bank fb, dim_time dt
WHERE dt.fk_time = fb.fk_time
AND dt.Ano = cast('2020' as int)
GROUP BY dt.mesdescabrvano, dt.ano, dt.mes
ORDER BY dt.ano, dt.mes asc

select * from dim_time

--dispobilidade de dinheiro em caixa
SELECT
  dt.mesdescabrv as Mes,
  SUM(SUM(fb.value)) OVER (ORDER BY dt.mes ASC) AS caixa
 FROM fact_bank fb, dim_time dt
WHERE dt.fk_time = fb.fk_time
  AND dt.Ano = cast('2020' as int)
GROUP BY dt.mes, dt.mesdescabrv
ORDER BY dt.mes


-- gastos no ano anterior
SELECT
  dt.mesdescabrv as Mes,
  sum(case when value < 0 then fb.value end) * -1 as gastos_ano_anterior
 FROM fact_bank fb, dim_time dt
WHERE dt.fk_time = fb.fk_time
  AND dt.Ano = cast('2020' as int) - 1
GROUP BY dt.mes, dt.mesdescabrv, dt.ano
ORDER BY dt.mes

-- entradas no ano anterior
SELECT
  dt.mesdescabrv as Mes,
  sum(case when value >= 0 then value end) as receita_ano_anterior
 FROM fact_bank fb, dim_time dt
WHERE dt.fk_time = fb.fk_time
  AND dt.Ano = cast('2020' as int) - 1
GROUP BY dt.mes, dt.mesdescabrv, dt.ano
ORDER BY dt.mes


--- TENTATIVAS

SELECT
   sum(case when value < 0 then fb.value end) * -1 / 12 as gastos_ano_anterior
  FROM fact_bank fb
 WHERE fb.load_year >= 2019
   AND fb.load_year <= 2019
 GROUP BY fb.load_year, fb.load_month
 ORDER BY fb.load_year desc, fb.load_month desc


--tabela de saldos
select * from fact_bank_balance

SELECT
   dt.mesdesc as MES,
   fbb.value
FROM fact_bank_balance fbb, dim_time dt
WHERE dt.fk_time = fbb.fk_time
  AND dt.Ano = cast('2019' as int)
ORDER BY dt.Mes DESC
 LIMIT 6
 
 

--TODO? Tentar usar este conjunto para pré-definir a utilização de fK_expense já na extração
SELECT distinct (LEFT(description, 6))
  FROM fact_bank
