SELECT count(1) from suitecrm.accounts; -- 60
SELECT count(1) from suitecrm.accounts_cstm; -- 59
SELECT count(1) from suitecrm.contacts; -- 124

SELECT account.id,
       account.name,
       account.date_entered,
       account.date_modified,
       account.deleted,
       cstm.cpf_c,
       CAST(cstm.fiscal_note_c AS CHAR) as fiscal_note_c,       
       cstm.accept_contract_c,
       cstm.phone_mobile_c
FROM suitecrm.accounts account
LEFT JOIN suitecrm.accounts_cstm cstm 
  ON account.id = cstm.id_c

SELECT * FROM suitecrm.accounts;  
SELECT * FROM suitecrm.accounts_contacts;
SELECT * FROM suitecrm.contacts;

-- 
