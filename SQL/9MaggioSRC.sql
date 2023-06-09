-- PERSONE      (NOME, ETA, REDDITO)
-- PATERNITA    (PADRE, FIGLIO)



SELECT PA.PADRE
FROM PERSONE AS PE, PATERNITA AS PA
WHERE PE.NOME = PA.FIGLIO AND PE.ETA < 30
GROUP BY PA.PADRE
HAVING AVG(PE.REDDITO) > 20;

--

SELECT PA.PADRE, AVG(PE.REDDITO) AS REDDITO_MEDIO_UNDER_30
FROM PERSONE PE, PATERNITA PA
WHERE PE.NOME = PA.FIGLIO AND P.ETA < 30
GROUP BY PA.PADRE
HAVING AVG(PE.REDDITO) > 20;

--
--
-- Selezionare nome e reddito dei padri relativamente ai figli che hanno il reddito maggiore del figlio
-- 
--
--
SELECT PE1.NOME, PE1.REDDITO
FROM PERSONE AS PE1, PERSONE AS PE2, PATERNITA AS PA
WHERE PE1.NOME = PA.PADRE AND PA.FIGLIO = PE2.NOME
GROUP BY PE1.NOME, PE1.REDDITO
HAVING PE1.REDDITO >= (calcolare il massimo stipendio dei figli del padre e lo devo fare attraverso un altra interrogazione)
