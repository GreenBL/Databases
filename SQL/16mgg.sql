/*

Riprendiamo il classico
PERSONA(COD_P, NOME, COGNOME, ETA, SESSO)
OGGETTO(COD_O, NOME_O, CATEGORIA, PREZZO)
ACQUISTO(REF_P, REF_O, DATA_ACQUISTO, QUANTITA) - REF_P, REF_O, DATA_ACQUISTO chiave primaria

Supponiamo che io voglia scrivere le due possibili divisioni in SQL

ALGEBRA RELAZIONALE 1: Ottengo i dettagli degli oggetti che sono stati acquistati da tutte le persone

*/

SELECT *
FROM MASTER DA CUI VOGLIO OTTENERE I DETTAGLI
WHERE NOT EXISTS (
    SELECT *
    FROM MASTER DELLA DIVISIONE
    WHERE AND NOT EXISTS (
        SELECT *
        FROM SLAVE DELLA DIVISIONE
        WHERE PASSAGGIO DEI PARAMETRI DEL MASTER DA CUI VOGLIO OTTENERE I DETTAGLI E DEL MASTER DELLA DIVISIONE
    )
);

SELECT O.COD_O, O.NOME_O
FROM OGGETTO O
WHERE NOT EXISTS (
    SELECT *
    FROM PERSONA P
    WHERE AND NOT EXISTS (
        SELECT *
        FROM ACQUISTO A
        WHERE A.REF_P = P.COD_P AND A.REF_O = O.COD_O
    )
);

-- Seleziono gli oggetti per cui non esiste una persona che non abbia acquistato quell'oggetto
-- Seleziono un oggetto per volta e verifico che non esista una persona che non abbia acquistato quell'oggetto
/*
PRIMO CICLO FOR CHE ESEGUE FOR EACH OGGETTO =>
SECONDO CICLO FOR CHE ESEGUE FOR EACH PERSONA =>

BLOCCO OGGETTO O1 SCELTO, POI CICLO SU TUTTE LE PERSONE PER VERIFICARE NELLA TERZA QUERY ATTRAVERSO IL PASSAGGIO DEI PARAMETRI

MI BLOCCO APPENA TROVO UNA PERSONA CHE NON ABBIA ACQUISTATO L'OGGETTO O1 E DECIDO DI PASSARE ALL'OGGETTO O2 E DI FARE LE STESSE VERIFICHE
CHE HO FATTO PER L'OGGETTO O1

*/

-- L'altra interrogazione : tutte le persone che hanno acquistato tutti gli oggetti

SELECT P.COD_P, P.NOME, P.COGNOME
FROM PERSONA P
WHERE NOT EXISTS (
    SELECT *
    FROM OGGETTO O
    WHERE AND NOT EXISTS (
        SELECT *
        FROM ACQUISTO A
        WHERE A.REF_P = P.COD_P AND A.REF_O = O.COD_O
    )
);

/* SELEZIONO UNA PERSONA PER VOLTA, E VERIFICO CHE NON ESISTA UN OGGETTO CHE QUELLA PERSONA NON ABBIA ACQUISTATO

-- -- -- -- --

LE PERSONE DI SESSO MASCHILE CHE HANNO COMPRATO TUTTI GLI OGGETTI DI ELETTRONICA NEL 2023

*/

SELECT P.COD_P, P.NOME, P.COGNOME
FROM PERSONA P
WHERE P.SESSO = 'M' AND NOT EXISTS (
    SELECT *
    FROM OGGETTO O 
    WHERE O.CATEGORIA = 'ELETTRONICA' AND NOT EXISTS (
        SELECT *
        FROM ACQUISTO A 
        WHERE A.DATA_ACQUISTO >= '01/01/2023' AND 
        A.DATA_ACQUISTO <= '31/12/2023'AND 
        A.REF_P = P.COD_P AND
        A.REF_O = O.COD_O
    )
);

/*
Selezionare Codice, Nome e Categoria degli oggetti di ARREDAMENTO che sono stati acquistati da tutte le persone di sesso femminile nel 2020 in
quantita' maggiore uguale di 10

*/

SELECT O.COD_O, O.NOME_O, O.CATEGORIA
FROM OGGETTO O
WHERE O.CATEGORIA = 'ARREDAMENTO' AND NOT EXISTS (
    SELECT *
    FROM PERSONA P
    WHERE P.SESSO = 'F' AND NOT EXISTS (
        SELECT *
        FROM ACQUISTO A
        WHERE A.DATA_ACQUISTO >= '01/01/2020' AND 
        A.DATA_ACQUISTO <= '31/12/2020'AND 
        A.QUANTITA >= 10 AND
        A.REF_P = P.COD_P AND
        A.REF_O = O.COD_O
    )
);

-------------------------------------------------------------------------------------------------------------------------------------------------
/* DOPPIO GROUP BY

SELEZIONARE LE PERSONE CHE HANNO ACQUISTATO PIU' OGGETTI DI TUTTI
+ MAX GLOBALE E IL MAX LOCALE
Questo e' un problema di massimo globale, indifferentemente dal tipo di oggetti comprati io voglio sapere la persona che ha acquistato piu' oggetti



SELECT P.COD_P, P.NOME, P.COGNOME, COUNT(*) AS NUM_ACQUISTI
FROM PERSONA P, ACQUISTO A
WHERE P.COD_P = A.REF_P
GROUP BY COD_P, NOME, COGNOME
HAVING MAX(COUNT(*)) E' UN ERRORE GRAVE

1. ERRORE DUE OPERATORI DENTRO HAVING
2. NON POSSO USARE GLI OPERATORI AGGREGATI SENZA GLI OPERATORI DI CONFRONTO

*/

SELECT P.COD_P, P.NOME, P.COGNOME
FROM PERSONA P, ACQUISTO A
WHERE P.COD_P = A.REF_P
GROUP BY COD_P, NOME, COGNOME
HAVING COUNT(*) => ALL(
    SELECT COUNT(*)
    FROM PERSONA P, ACQUISTO A
    WHERE ACQUISTO A
    GROUP BY A.REF_P
);

-- 1. COSA RESTITUISCE L'INTERROGAZIONE PIU' INTERNA = IL NUMERO DI ACQUISTI PER OGNI PERSONA (REF_P)
-- 2. TRUCCO = USO 3 OPERATORI CON DUE INTERROGAZIONI
-- 3. =MAX E' UN GRAVE ERRORE LOGICO, QUINDI FACCIO >=
-- 4. >= FUNZIONA COME MAX MA MI CONSENTE DI BYPASSARE IL PROBLEMA CHE POSSO UTILIZZARE SOLO UN OPERATORE AGGREGATO PER CIASCUNA QUERY

-- MASSIMO LOCALE: VOGLIO SAPERE PER OGNI OGGETTO LE PERSONE CHE HANNO FATTO PIU ACQUISTI DI QUELL'OGGETTO
-- IO DEVO CONFRONTARE PER OGNI OGGETTO GLI ACQUISTI CHE TUTTE LE PERSONE HANNO FATTO DI SOLO QUELL'OGGETTO
-- DEVO PER FORZA USARE IL PASSAGGIO DI PARAMETRI
-- V1

SELECT COD_O, COD_P, COUNT(*) AS ACQUISTI_OGGETTO_PERSONA
FROM PERSONA P, ACQUISTO A, OGGETTO O
WHERE P.COD_P = A.REF_P AND A.REF_O = O.COD_O
GROUP BY COD_O, COD_P
HAVING COUNT(*) => ALL(
    SELECT COUNT(*)
    FROM PERSONA P, ACQUISTO A
    WHERE A.REF_O = O.COD_O
    GROUP BY A.REF_P
);