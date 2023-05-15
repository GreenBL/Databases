-- Init {

-- Creazione delle tabelle
CREATE TABLE Cittadino (
  Nome VARCHAR(50),
  Cognome VARCHAR(50),
  Età INTEGER,
  PRIMARY KEY (Nome, Cognome)
);

CREATE TABLE Studente (
  Nome VARCHAR(50),
  Cognome VARCHAR(50),
  Matricola INTEGER,
  Età INTEGER,
  PRIMARY KEY (Nome, Cognome),
  FOREIGN KEY (Nome, Cognome) REFERENCES Cittadino(Nome, Cognome)
);

-- Inserimento delle tuple di esempio
INSERT INTO Cittadino (Nome, Cognome, Età) VALUES
  ('Mario', 'Rossi', 30),
  ('Laura', 'Bianchi', 25),
  ('Luca', 'Verdi', 28),
  ('Giulia', 'Russo', 22),
  ('Paolo', 'Ferrari', 31),
  ('Marta', 'Esposito', 27),
  ('Andrea', 'Romano', 29),
  ('Sara', 'Conti', 26),
  ('Marco', 'Galli', 24),
  ('Elena', 'Barbieri', 23);

INSERT INTO Studente (Nome, Cognome, Matricola, Età) VALUES
  ('Laura', 'Bianchi', 67890, 25),
  ('Luca', 'Verdi', 23456, 28),
  ('Giulia', 'Russo', 78901, 22),
  ('Andrea', 'Romano', 45678, 29),
  ('Sara', 'Conti', 90123, 26),
  ('Marco', 'Galli', 56789, 24),
  ('Elena', 'Barbieri', 23451, 23);
  
  -- Aggiunta della tabella "Lavoratore"
CREATE TABLE Lavoratore (
  Nome VARCHAR(50),
  Cognome VARCHAR(50),
  Età INTEGER,
  Lavoro VARCHAR(100),
  PRIMARY KEY (Nome, Cognome),
  FOREIGN KEY (Nome, Cognome) REFERENCES Cittadino(Nome, Cognome)
);

-- Inserimento di tre tuple nella tabella "Lavoratore" utilizzando gli individui già presenti nella tabella "Cittadino"
INSERT INTO Lavoratore (Nome, Cognome, Età, Lavoro) VALUES
  ('Mario', 'Rossi', 30, 'Programmatore'),
  ('Laura', 'Bianchi', 25, 'Insegnante'),
  ('Luca', 'Verdi', 28, 'Avvocato');
  
  -- End init }
  ------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  -- 1. PRENDI TUTTI GLI STUDENTI LA CUI ETA E' MAGGIORE DELLA MEDIA DELL'ETA DEI CITTADINI
  
SELECT *
FROM STUDENTE
WHERE Età >  (SELECT AVG(Età)
			  FROM CITTADINO );
                
-- La suddetta esegue prima l'interrogazione interna:

SELECT AVG(Età)
FROM CITTADINO;

-- La suddetta equivale alla relazione che contiene solo la tupla dell'attributo AVG(Età) | 26.5
-- Dunque con la nested query, dopo l'esecuzione dell'interrogazione interna, avremo:
  
SELECT *
FROM STUDENTE
WHERE Età > 26.5;

-- Risultato : Andrea e Luca

// CASISTICHE
ES: -- non eseguire questa interrogazione = #
#
SELECT *
FROM STUDENTE
WHERE ETA > (INTERROGAZIONE PIU INTERNA);
#
PRIMO CASO = SE NELL INTERROGAZIONE PIU ESTERNA USA >, <, <=, >=, <> LA QUERY PIU INTERNA DEVE OBBLIGATORIAMENTE USARE UN OPERATORE AGGREGATO
-- PERCHE PENSO CHE CI SERVA SOLO UNA TUPLA, NON POSSIAMO FARE QUESTA COSA SU PIU' TUPLE.

SECONDO CASO = SE NELL INTERROGAZIONE PIU ESTERNA USO GLI OPERATORI INSIEMISTICI O I SUOI EQUIVALENTI LOGICI, LA QUERY PIU INTERNA PUO PREVEDERE DI
RESTITUIRE PIU TUPLE

-- ES

OPERATORE INSIEMISTICO IN = INCLUSO

SELECT *
FROM STUDENTE
WHERE Età IN (SELECT DISTINCT Età
			  FROM LAVORATORE);

-- SELEZIONA PRIMA LE ETA DISTINTE DA LAVORATORE, E CREA L'INSIEME, E POI CERCA LE TUPLE DI STUDENTE CHE HANNO L'ETA IN COMUNE ALL'INSIEME

OPERATORE INSIEMISTICO LOGICO = ANY (UGUALE AD ALMENO UNO DEI VALORI RESTITUITO DALLA QUERY INTERNA)

SELECT *
FROM STUDENTE
WHERE Età = ANY (SELECT DISTINCT Età
			     FROM LAVORATORE);
  
-- SI USA PER FARE L'INTERSEZIONE TRA GLI INSIEMI
-- ANY E IN SONO OPERATORI EQUIVALENTI, FANNO LA STESSA COSA

NOT IN

SELECT NOME
FROM CITTADINO
WHERE NOME NOT IN (SELECT NOME
					FROM STUDENTE);
                    
-- Nomi dei cittadini che non sono omonimi di studenti (SOTTRAZIONE)

OPERATORE ALL O <>ALL

SELECT NOME
FROM CITTADINO
WHERE NOME <>ALL(SELECT NOME	
				FROM STUDENTE);

-- <>ALL EQUIVALENTE / MA NON ESISTE IN ALGEBRA RELAZIONALE
-- sarebbe DIVERSO DA TUTTI, <> DIVERSO, ALL PRENDE TUTTE LE TUPLE

OPERATORE EXISTS
-- BOOLEANO, RESTITUISCE VERO O FALSO A SECONDA SE LA RELAZIONE E' VUOTA O CONTIENE QUALCOSA

-- AL CONTRARIO
OPERATORE NOT EXISTS
-- BOOLEANO, RESTITUISCE VERO SE LA RELAZIONE E' VUOTA, FALSO ALTRIMENTI











  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  