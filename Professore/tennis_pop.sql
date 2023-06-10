--
-- Create schema tennis
--

CREATE DATABASE IF NOT EXISTS tennis;
USE tennis;

--
-- Definition of table campo
--

CREATE TABLE campo (
  nome_campo varchar(75) NOT NULL,
  tipo varchar(10) NOT NULL,
  indirizzo varchar(45) NOT NULL,
  PRIMARY KEY (nome_campo)
);

--
-- Definition of table tennista
--

CREATE TABLE tennista (
  cf char(16) NOT NULL,
  nome varchar(75) NOT NULL,
  nazione char(3) NOT NULL,
  PRIMARY KEY (cf)
); 

--
-- Definition of table incontro
--

CREATE TABLE incontro (
  cod_i char(6) NOT NULL,
  nome_campo_i varchar(75) NOT NULL,
  giocatore1 char(16) NOT NULL,
  giocatore2 char(16) NOT NULL,
  set1 int NOT NULL,
  set2 int NOT NULL,
  PRIMARY KEY (cod_i),
  FOREIGN KEY (nome_campo_i) REFERENCES campo(nome_campo),
  FOREIGN KEY (giocatore1) REFERENCES tennista(cf),
  FOREIGN KEY (giocatore2) REFERENCES tennista(cf)
);

-- incontro, svolto nel campo nome_campo_i, tra i tennisti giocatore1 e giocatore2:
-- in set1 e set2 sono riportati il numero di set vinti da giocatore1 e giocatore2 rispettivamente   

--
-- populating the DB
--

INSERT INTO campo VALUES ('Arthur Ashe Stadium', 'Cemento', 'Queens'),
('Rochus Club', 'Terra', 'Via Berlino'),
('Comet Club', 'Erba', 'Via Roma'),
('Tennis Club', 'Erba', 'Via Milano'),
('Crazy Tennis', 'Erba', 'Via Palermo');
INSERT INTO tennista VALUES ('N', 'Nadal', 'SPA'),
('A', 'Agassi', 'USA'),
('F', 'Federer', 'SVI'),
('L', 'Laver', 'AUS');
INSERT INTO incontro VALUES (1, 'Arthur Ashe Stadium', 'N', 'F', 6, 4),
(2, 'Arthur Ashe Stadium', 'A', 'N', 6, 0),
(3, 'Arthur Ashe Stadium', 'L', 'A', 2, 6),
(4, 'Arthur Ashe Stadium', 'F', 'L', 4, 6),
(5, 'Comet Club', 'A', 'F', 6, 2),
(6, 'Comet Club', 'L', 'N', 6, 1),
(7, 'Tennis Club', 'F', 'N', 6, 3);

--
-- QUERY (ALGEBRA RELAZIONALE a), b), c))
-- 

-- a)selezionare gli incontri disputati sull'erba (campo con tipo 'erba')

SELECT 
    i.*
FROM
    incontro i,
    campo c
WHERE
    i.nome_campo_i = c.nome_campo
        AND c.tipo = 'erba';

-- b)selezionare i campi in erba sui quali non c'è stato nessun incontro

SELECT 
    *
FROM
    campo c
WHERE
    c.tipo = 'erba'
        AND c.nome_campo NOT IN (SELECT 
            i.nome_campo_i
        FROM
            incontro i);

-- c)selezionare i dati dei tennisti vincitori di almeno una partita sull'erba

SELECT 
    *
FROM
    tennista t
WHERE
    t.cf IN (SELECT 
            i.giocatore1 -- vincitore in casa
        FROM
            incontro i,
            campo c
        WHERE
            i.nome_campo_i = c.nome_campo
                AND c.tipo = 'erba'
                AND i.set1 > i.set2)
        OR t.cf IN (SELECT 
            i.giocatore2
        FROM
            incontro i,
            campo c
        WHERE
            i.nome_campo_i = c.nome_campo
                AND c.tipo = 'erba'
                AND i.set1 < i.set2);

-- d)selezionare i dati delle nazioni in cui tutti i giocatori hanno sempre
-- vinto le partite disputate

SELECT DISTINCT
    t.nazione
FROM
    tennista t
WHERE
    t.nazione NOT IN (SELECT 
            t.nazione
        FROM
            incontro i,
            tennista t
        WHERE
            i.giocatore1 = t.cf AND i.set1 < i.set2)
        AND t.nazione NOT IN (SELECT 
            t.nazione
        FROM
            incontro i,
            tennista t
        WHERE
            i.giocatore2 = t.cf AND i.set1 > i.set2);

-- e)selezionare il campo in erba che ha ospitato il maggior numero di incontri

SELECT 
    c1.nome_campo
FROM
    incontro i1,
    campo c1
WHERE
    i1.nome_campo_i = c1.nome_campo
        AND c1.tipo = 'erba'
GROUP BY c1.nome_campo
HAVING COUNT(*) >= ALL (SELECT 
        COUNT(*)
    FROM
        incontro i2,
        campo c2
    WHERE
        i2.nome_campo_i = c2.nome_campo
            AND c2.tipo = 'erba'
    GROUP BY c2.nome_campo);
    
    
    
    