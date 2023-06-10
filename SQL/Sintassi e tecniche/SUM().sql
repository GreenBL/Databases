-- Operatore aggregato SUM([espressione])
-- Restituisce la somma dei valori posseduti dall'espressione

-- Estrarre la somma degli stipendi del dipartimento amministrazione

SELECT sum(Stipendio) as Somma_Stipendi_Amministrazione
FROM Impiegati as I
WHERE I.Dipart = 'Amministrazione'
