-- MIN() restituisce il minimo valore

SELECT min(Stipendio)
FROM Impiegato

-- Restituisce lo stipendio minimo (sempre una colonna e una riga)

-- MAX() restituisce il massimo valore

SELECT max(Stipendio)
FROM Impiegato

-- Restituisce lo stipendio massimo

-- AVG() restituisce la media fra tutti gli attributi delle tuple

SELECT avg(Stipendio)
FROM Impiegato

-- Restituisce lo stipendio medio di tutti gli impegati

-- [[LA SEGUENTE INTERROGAZIONE NON E' CORRETTA]]

SELECT Cognome, Nome, max(Stipendio)
FROM Impiegato I, Dipartimento D
WHERE Dipart = D.Nome AND D.Citta = 'Milano'

-- SQL non offre un meccanismo per gestire questa eterogeneita', percio' non ammette che nella stessa clausola SELECT compaiano funzioni aggregate ed espressioni a livello di riga, a meno che non si faccia uso della clausola GROUP BY.

