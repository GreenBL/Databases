SELECT count(*)
FROM impiegato
WHERE impiegato.Dipartimento = 'Produzione'

-- Prima viene eseguita l'interrogazione secondo FROM e WHERE.
-- In seguito l'operatore aggregato COUNT() conta le tuple totali della tabella risultante.

SELECT count(DISTINCT Impiegato.Stipendio)
FROM Impiegato 

-- Conta il numero di DISTINTI valori dell'attributo stipendio fra tutte le tuple di Impiegato

SELECT count(ALL Impiegato.Nome)
FROM Impiegato 

-- Conta gli impiegati che hanno nome diverso da NULL
