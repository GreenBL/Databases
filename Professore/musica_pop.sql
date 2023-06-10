--
-- Create schema musica
--

CREATE DATABASE IF NOT EXISTS musica;
USE musica;

--
-- Definition of table fornitore
--

CREATE TABLE cd (
  cod_cd int(6) NOT NULL,
  autore varchar(75) NOT NULL,
  casa_disco varchar(30) NOT NULL,
  PRIMARY KEY (cod_cd)
);


--
-- Definition of table cliente
--

CREATE TABLE cliente (
  ntess char(5) NOT NULL,
  nome varchar(75) NOT NULL,
  indirizzo varchar(45) NOT NULL,
  PRIMARY KEY (ntess)
); 

--
-- Definition of table acquisto
--

CREATE TABLE acquisto (
  cod_cd_a int(6) NOT NULL,
  ntess_a char(5) NOT NULL,
  data_acquisto date NOT NULL,
  qty int(2) NOT NULL,
  PRIMARY KEY (cod_cd_a, ntess_a),
  FOREIGN KEY (cod_cd_a) REFERENCES cd(cod_cd),
  FOREIGN KEY (ntess_a) REFERENCES cliente(ntess)	
);

-- il cliente identificato da ntess ha acquistato, in una certa data_acquisto,
-- un certo numero qty di copie del compact disk cod_cd_a

--
-- populating the DB
--
INSERT INTO cd VALUES(1, 'Orazio', 'DiscoJolli');
INSERT INTO cd VALUES(2, 'Ernesto', 'DiscoLuna');
INSERT INTO cd VALUES(3, 'Francesco Guccini', 'DiscoLuna');
INSERT INTO cd VALUES(4, 'Francesco Guccini', 'DiscoLuna');
INSERT INTO cliente VALUES('T1', 'Giovanna', 'Viale Michelino');
INSERT INTO cliente VALUES('T2', 'Ludovica', 'Via Roma');
INSERT INTO cliente VALUES('T3', 'Luca', 'Via Napoli');
INSERT INTO acquisto VALUES(1, 'T1', '1998-04-06', 2);
INSERT INTO acquisto VALUES(2, 'T2', '2001-01-28', 1);
INSERT INTO acquisto VALUES(1, 'T2', '1996-01-28', 1);
INSERT INTO acquisto VALUES(3, 'T3', '1991-01-04', 1);
INSERT INTO acquisto VALUES(3, 'T1', '1993-05-23', 1);
INSERT INTO acquisto VALUES(4, 'T1', '1996-01-21', 1);
--
-- QUERY (ALGEBRA RELAZIONALE a), b))
-- 

-- a) selezionare tutti i dati dei clienti che dopo il 1/1/1997 non hanno acquistato
-- nessun cd prodotto dalla casa discografica 'DiscoJolli'

SELECT 
    *
FROM
    cliente c
WHERE
    c.ntess NOT IN (SELECT 
            a.ntess_a
        FROM
            acquisto a,
            cd
        WHERE
            a.cod_cd_a = cd.cod_cd
                AND cd.casa_disco = 'DiscoJolli'
                AND a.data_acquisto > '1997-01-01');

-- b) selezionare il numero tessera dei clienti che hanno acquistato tuttii cd
-- dell'autore 'Francesco Guccini'

SELECT 
    c.ntess
FROM
    cliente c
WHERE
    NOT EXISTS( SELECT 
            *
        FROM
            cd
        WHERE
            cd.autore = 'Francesco Guccini'
                AND NOT EXISTS( SELECT 
                    *
                FROM
                    acquisto a
                WHERE
                    a.ntess_a = c.ntess
                        AND a.cod_cd_a = cd.cod_cd));

-- c) selezionare, per ogni cd, il numero totale delle copie vendute

SELECT 
    a.cod_cd_a, SUM(a.qty)
FROM
    acquisto a
GROUP BY a.cod_cd_a;

-- d) selezionare, per ogni casa discografica, il numero tessera del cliente che ha 
-- acquistato il maggior numero di copie di cd di quella casa

SELECT 
    a1.ntess_a, cd1.casa_disco
FROM
    acquisto a1,
    cd cd1
WHERE
    a1.cod_cd_a = cd1.cod_cd
GROUP BY a1.ntess_a , cd1.casa_disco
HAVING SUM(a1.qty) >= ALL (SELECT 
        SUM(a2.qty)
    FROM
        acquisto a2,
        cd cd2
    WHERE
        a2.cod_cd_a = cd2.cod_cd
            AND cd1.casa_disco = cd2.casa_disco
    GROUP BY a2.ntess_a);