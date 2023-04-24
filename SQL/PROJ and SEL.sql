-- SQL [24/04/2023]
-- SELECT - FROM - WHERE;

-- 1. Finta proiezione, seleziona tutto il contenuto della relazione proiettando tutto

SELECT *
FROM CAVALLO; 

-- 2. Ridenominazione di una relazione

SELECT *
FROM CAVALLO C;

-- 3. Mostra il contenuto della relazione cavallo relativamente a codice e nome del cavallo

SELECT C.COD_C, C.NOME_C
FROM CAVALLO C;

-- 4. Selezionare tutte le tuple di cavalli di colore ROSSO e ordina il risultato in ordine crescente di COD_C;

SELECT	C.COD_C, C.NOME_C
FROM 	CAVALLO C
WHERE	C.COLORE = 'ROSSO'
ORDER BY C.COD_C;

-- 5. Selezionare codice, nome, eta, e colore dei cavalli con un eta' compresa tra 10 e 12 anni e di colore rosso
SELECT C.COD_C, C.NOME_C, C.ETA, C.COLORE
FROM CAVALLO C
WHERE C.ETA >= 10 AND C.ETA <= 12 AND C.COLORE = 'ROSSO';

-- 6. Ordinare per eta'

SELECT C.COD_C, C.NOME_C, C.ETA, C.COLORE
FROM CAVALLO C
WHERE C.ETA >= 10 AND C.ETA <= 12 AND C.COLORE = 'ROSSO'
ORDER BY C.ETA;

-- 7. EquiJoin tra CAVALLO e COMPETE

SELECT *
FROM CAVALLO CA, COMPETE CO
WHERE CA.COD_C = CO.REF_C;

-- 8. EquiJoin tra COMPETE e ESIBIZIONE

SELECT *
FROM COMPETE CO, ESIBIZIONE ES
WHERE CO.REF_E = ES.COD_E;

-- 9. Triplo EquiJOIN tra CAVALLO, COMPETE e ESIBIZIONE

SELECT *
FROM CAVALLO CA, COMPETE CO, ESIBIZIONE ES
WHERE CA.COD_C = CO.REF_C AND CO.REF_E = ES.COD_E;

-- 10. Selezionare le date nelle quali ha gareggiato un cavallo cavalcato dal fantino Dettori di anni 6 e di razza purosangue

SELECT CA.COGNOME_FANTINO, CO.DATA
FROM CAVALLO CA, COMPETE CO, ESIBIZIONE ES 
WHERE CA.COD_C = CO.REF_C AND CO.REF_E = ES.COD_E AND CA.COGNOME_FANTINO = 'DETTORI' AND CA.ETA = 6
ORDER BY CO.DATA;

-- 11. Selezionare le dati nelle quale ha gareggiato un cavallo cavalcato dal fantino Dettori di anni 6 e di razza purosangue nelle esibizioni che si
-- sono svolte in Italia

SELECT CA.COGNOME_FANTINO, ES.NAZIONE, CO.DATA
FROM CAVALLO CA, COMPETE CO, ESIBIZIONE ES
WHERE CA.COD_C = CO.REF_C AND CO.REF_E = ES.COD_E AND CA.ETA = 6 AND CA.RAZZA = 'PUROSANGUE' AND ES.NAZIONE = 'ITALIA' AND CA.COGNOME_FANTINO = 'DETTORI'
ORDER BY CO.DATA;

-- 12. Selezionare le coppie di codici di cavalli che si sono esibiti in una stessa competizione

SELECT CO1.REF_C, CO2.REF_C
FROM COMPETE CO1, COMPETE CO2
WHERE CO1.REF_E = CO2.REF_E AND CO1.REF_C > CO2.REF_C;

-- 13. Selezionare le coppie di codici e nomi dei cavalli che si sono esibiti in una stessa competizione

SELECT CA1.COD_C, CA1.NOME_C, CA2.COD_C, CA2.NOME_C
FROM CAVALLO CA1, COMPETE CO1, COMPETE CO2, CAVALLO CA2
WHERE CA1.COD_C = CO1.REF_C AND CO1.REF_E = CO2.REF_E AND CO2.REF_C = CA2.COD_C AND CO1.REF_C > CO2.REF_C
ORDER BY CA1.COD_C;

-- 13. Selezionare le coppie di codici e nomi dei cavalli, e nome dell'esibizione dove si sono esibiti insieme

SELECT CA1.COD_C, CA1.NOME_C, CA2.COD_C, CA2.NOME_C, ES.COD_E, ES.NOME_E
FROM CAVALLO CA1, COMPETE CO1, COMPETE CO2, CAVALLO CA2, ESIBIZIONE ES
WHERE CA1.COD_C = CO1.REF_C AND CO1.REF_E = CO2.REF_E AND CO2.REF_C = CA2.COD_C AND CO2.REF_E = ES.COD_E AND CO1.REF_C > CO2.REF_C
ORDER BY ES.COD_E;