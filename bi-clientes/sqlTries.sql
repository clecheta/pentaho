--Pegar os company groups ids
select * from company where company_group_id = id

--Companies de um multiempresa
select * from company where company_group_id = 1126

--
-- Alternativa pegando a produção do appointment
--
SELECT --a.last_update,
       --ai.value,
       --ai.appointment_id,
       --ai.quantity,
       --ai.service_type_id,
       --ai.appointment_item_link_id,
       --tg.name as especialidade,
       --(select sum(airef.value) from appointment_item airef where airef.appointment_item_link_id=ai.id) as vlr_insumo
       sum (Abs(ai.value))
  FROM appointment_item ai
 INNER JOIN appointment a ON ai.appointment_id = a.id
 INNER JOIN service_type st ON ai.service_type_id = st.id 
  LEFT OUTER JOIN service_type_tag stt ON stt.service_type_id = st.id --this join add lines to t1
  LEFT OUTER JOIN tag tg ON stt.tag_id = tg.id --this join add even more lines to t1
 INNER JOIN professional p ON p.id = a.professional_id
 INNER JOIN company_professional cp ON p.id = cp.professional_id
--   left outer join appointment_item airef ON airef.appointment_item_link_id=ai.id
 WHERE a.status = 'FINISH'
   --AND ai.finish is null
   AND cp.company_id = 545
   AND st.product=false
   AND ai.value > 0
and a.begin_date >= '2016-11-10 00:00:00'
and a.begin_date <= '2016-11-10 23:59:59'

--
-- FROM MARCIO - Escolhemos esta alternativa ao invés de pegar em appointmet
--

--INSUMO
SELECT at.promo_id,
       date(t.create_date) AS production_date,
       Abs(t.value),
       Abs(ai.value),
       ap.customer_id,
       ap.professional_id,
       st.title,
       st.id as service_type_id,
       null as skill_id,
       'INSUMO' as type,
       a.type
  FROM account a
 INNER JOIN account_transaction at ON at.account_id = a.id 
 INNER JOIN transaction t ON at.transaction_id = t.id
 INNER JOIN appointment_item ai ON  ai.id = at.appointment_item_id
 INNER JOIN appointment ap ON  ap.id = ai.appointment_id
 INNER JOIN service_type st ON  st.id = ai.service_type_id
 WHERE ai.appointment_item_link_id IN (
    SELECT ai.id
      FROM account a
     INNER JOIN account_transaction at ON at.account_id = a.id 
     INNER JOIN transaction t ON at.transaction_id = t.id
     INNER join appointment_item ai on ai.id = at.appointment_item_id
     INNER join appointment ap ON ap.id = ai.appointment_id
     INNER JOIN service_type st ON st.id = ai.service_type_id
    WHERE a.company_id = 545
      --AND a.type = 'CUST'
      AND a.is_customer = true
      AND at.settle = true
      AND t.create_date >= '2016-11-30 00:00:00'
      AND t.create_date <= '2016-11-30 23:59:59'
      AND st.product = false
)

UNION ALL

--Financeiro/Producao
--SERVICO
SELECT --at.tag_type_id AS account_plan_tag_id, 
       at.promo_id,
       date(t.create_date) AS production_date,
       Abs(t.value) as valor,
       Abs(ai.value),
       --t.type_id AS payment_option_tag_id, 
       --(SELECT tag.group_id from tag tag where t.type_id = tag.id) AS account_group_tag_id, 
       ap.customer_id,
       ap.professional_id,
       ap.id as appointment_id,
       st.title,
       st.id as service_type_id,
       tg.id as skill_id,
       'SERVICO' as type
  FROM account a
 INNER JOIN account_transaction at ON at.account_id = a.id 
 INNER JOIN transaction t ON at.transaction_id = t.id
 INNER JOIN appointment_item ai ON ai.id = at.appointment_item_id
 INNER JOIN appointment ap ON ap.id = ai.appointment_id
 INNER JOIN service_type st ON st.id = ai.service_type_id
  LEFT OUTER JOIN service_type_tag stt ON stt.service_type_id = st.id
  LEFT OUTER JOIN tag tg ON stt.tag_id = tg.id
 WHERE a.company_id = 545
   AND a.type = 'CUST'
   AND st.product = false
   AND t.create_date >= '2016-11-30 00:00:00'
   AND t.create_date <= '2016-11-30 23:59:59'

UNION ALL

SELECT  --at.tag_type_id AS account_plan_tag_id, 
       at.promo_id,
       date(t.create_date) AS production_date,
       Abs(t.value),
       Abs(ai.value),
        --t.type_id AS payment_option_tag_id, 
        --(SELECT tag.group_id from tag tag where t.type_id = tag.id) AS account_group_tag_id, 
       ap.customer_id,
       ap.professional_id,
       st.title,
       st.id as service_type_id,
       0 as skill_id,
       'REVENDA' as type,
       a.type
  FROM account a
 INNER JOIN account_transaction at ON at.account_id = a.id 
 INNER JOIN transaction t ON at.transaction_id = t.id
 INNER JOIN appointment_item ai ON ai.id = at.appointment_item_id
 INNER JOIN appointment ap ON ap.id = ai.appointment_id
 INNER JOIN service_type st ON st.id = ai.service_type_id
  --LEFT OUTER JOIN service_type_tag stt ON stt.service_type_id = st.id
  --LEFT OUTER JOIN tag tg ON stt.tag_id = tg.id
 WHERE a.company_id = 545
   AND a.type = 'CUST'
   AND t.create_date >= '2016-11-30 00:00:00'
   AND t.create_date <= '2016-11-30 23:59:59'
   AND st.product = true --true for product
   AND at.tag_type_id = 27

SELECT at.create_date AS contabilization_date,
       at.description, 
       at.professional_id,
       at.type,
       at.settle,
       at.tag_type_id, --plano de contas
       at.customer_id,
       at.promo_id,
       t.value,
       t.create_date AS production_date, 
       t.type_id, --(tag FORMA DE PAGAMENTO)
       (SELECT tag.group_id from tag tag where t.type_id = tag.id), --account_group
       st.title,
       st.id as service_type_id,
       tg.id as skill_id,
       a.type as account_type
  FROM account a
 INNER JOIN account_transaction at ON at.account_id = a.id 
 INNER JOIN transaction t ON at.transaction_id = t.id
  LEFT OUTER JOIN appointment_item ai ON ai.id = at.appointment_item_id
  LEFT OUTER JOIN service_type st ON st.id = ai.service_type_id
  LEFT OUTER JOIN service_type_tag stt ON stt.service_type_id = st.id
  LEFT OUTER JOIN tag tg ON stt.tag_id = tg.id
 WHERE a.company_id = 545
--   AND tg.type = 'SKILL'

SELECT --at.promo_id,
       date(t.create_date) AS production_date,
       CASE WHEN a.type='PROF' THEN Abs(t.value) END as valor_prof,
       CASE WHEN a.type='COMP' THEN Abs(t.value) END as valor_comp,
       --Abs(ai.value),
       ap.customer_id,
       ap.professional_id,
       ap.id as appointment_id,
       st.id as service_type_id,
       tg.id as tag_id --skill_id
       --null as line,
       --'SERVICO' as type
  FROM account a
 INNER JOIN account_transaction at ON at.account_id = a.id 
 INNER JOIN transaction t ON at.transaction_id = t.id
 INNER JOIN appointment_item ai ON ai.id = at.appointment_item_id
 INNER JOIN appointment ap ON ap.id = ai.appointment_id
 INNER JOIN service_type st ON st.id = ai.service_type_id
  LEFT OUTER JOIN service_type_tag stt ON stt.service_type_id = st.id
  LEFT OUTER JOIN tag tg ON stt.tag_id = tg.id
 WHERE a.company_id = 545
   AND a.type IN ('COMP','PROF')
   AND at.tag_type_id = 25
   --AND st.product = false
   AND t.create_date >= '2017-03-01 00:00:00'
   AND t.create_date <= '2017-03-01 23:59:00'
   AND at.discount is not null


select * from account_transaction where discount is not null

   -- desconto aplicado
   -- at.descount (valor que era antes)
   -- t.value (valor calculado)

   select * from stock_product_history --fazer left join e pegar no ai.id do histórico que foi gerado, se foi gerado é produto
   --APPOINTMENT_USE = INSUMO
   --APPOINTMENT_SALA = REVENDA

   select * from tag order by id asc

--numero total de saloes cadastrados
select count(1) from company -- 1407


--QUANTIDADE DE NOVOS ENTRANTES POR CIDADE / PERIODO
select
  a.city,
  count(p.id)
 from professional p 
  left outer join address a on a.id =p.address_id
 where p.registration_date >= '2017-07-01 00:00:00'
 and p.registration_date <= '2017-07-30 23:59:59'
group by a.city order by 2 desc

--numero total de usuarios com mais de 20 agendamentos no mes
select p.company_name,
       p.full_name,
       (select count(1) from appointment a where a.professional_id = p.id)
  from professional p
 inner join appointment a on a.professional_id = p.id
 WHERE a.begin_date >= '2017-07-01 00:00:00'
   AND a.begin_date <= '2017-07-30 23:59:59'
 GROUP BY p.id, p.company_name, p.full_name
 ORDER BY 3 desc

--saloes cadastrados até 31/07
select p.company_name,
       p.full_name,
       p.phone1,
       p.phone2,
       u.username,
       a.city,
       a.state
 from professional p 
inner join company_professional cp ON cp.professional_id = p.id
inner join public.user u on u.id = p.user_id
 left outer join address a on a.id =p.address_id
WHERE cp.is_owner = true
--AND (a.city ilike '%Curitiba%' or a.state in('ES','Espirito Santo','Espírito Santo', 'State of Espírito Santo'))
  AND p.registration_date >= '2017-07-01 00:00:00'
  AND p.registration_date <= '2017-07-30 23:59:59'
ORDER BY state, p.company_name, p.full_name