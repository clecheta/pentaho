SELECT distinct(tm.ano) as Ano
  FROM dim_time tm
 WHERE tm.fk_time in (select distinct fk_time from fact_finance)
   AND tm.Ano is not null
 ORDER BY tm.Ano desc

 SELECT tm.mesdescabrv as SERIES,
        sum(ff.value) as VALOR
   FROM fact_finance ff, dim_time tm
  WHERE ff.fk_production_time = tm.fk_time
   AND tm.Ano = '2017'
 GROUP BY SERIES, tm.MES
 ORDER BY tm.MES ASC

 SELECT tg.name as SERIES,
        sum(ff.value) as VALOR
   FROM fact_finance ff, dim_tag tg, dim_time tm
  WHERE tm.fk_time = ff.fk_production_time
    AND tg.fk_tag = ff.fk_payment
    AND tm.Ano = 2017
    AND tm.mesdescabrv = 'FEV'
  GROUP BY SERIES
  ORDER BY VALOR DESC

SELECT 'Faturamento Total' as label,
       sum(value_prof)+sum(value_comp) as value,
       100 as Pc_total
  FROM fact_operation fo, dim_time tm
 WHERE tm.Ano = 2017
   AND tm.mesdescabrv = 'FEV'
UNION ALL
SELECT 'Desconto' as label,
       sum(discount) as value,
       round(((sum(discount))/(sum(value_prof)+sum(value_comp)))*100,2) as Pc_total
  FROM fact_operation fo, dim_time tm
 WHERE tm.Ano = 2017
   AND tm.mesdescabrv = 'FEV'
UNION ALL
SELECT 'Promoção' as label,
       sum(promotion) as value,
       round(((sum(discount))/(sum(value_prof)+sum(value_comp)))*100,2) as Pc_total
  FROM fact_operation fo, dim_time tm
 WHERE tm.Ano = 2017
   AND tm.mesdescabrv = 'FEV'
ORDER BY value desc

 select * from fact_finance
 select * from dim_time
 select * from dim_tag
 select * from fact_operation