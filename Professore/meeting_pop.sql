--
-- Create schema meeting
--

CREATE DATABASE IF NOT EXISTS meeting;
USE meeting;

--
-- Definition of table nazione
--

CREATE TABLE nazione (
  cod_n char(3) NOT NULL,
  presidente varchar(75) NOT NULL,
  continente varchar(16) NOT NULL,
  PRIMARY KEY (cod_n)
);


--
-- Definition of table conferenza
--

CREATE TABLE conferenza (
  cod_c char(5) NOT NULL,
  descrizione varchar(45) NOT NULL,
  cod_n_sede char(3) NOT NULL, -- rappresenta la nazione in cui si è tenuta la conferenza  cod_c
  PRIMARY KEY (cod_c),
  FOREIGN KEY (cod_n_sede) REFERENCES nazione(cod_n)
); 

--
-- Definition of table partecipa
--

CREATE TABLE partecipa (
  cod_c_p char(5) NOT NULL,
  cod_n_p char(3) NOT NULL,
  numerop int(3) NOT NULL,
  PRIMARY KEY (cod_c_p, cod_n_p),
  FOREIGN KEY (cod_c_p) REFERENCES conferenza(cod_c),
  FOREIGN KEY (cod_n_p) REFERENCES nazione(cod_n)	
);

-- numerop è il numero di rappresentanti della nazione cod_n_p partecipanti
-- alla conferenza cod_c_p

--
-- populating the DB
--



--
-- QUERY (ALGEBRA RELAZIONALE a), b), c))
-- 

-- a) selezionare i dati relativi alle nazioni che hanno parecipato ad una
-- conferenza tenutasi in una nazione del continente Europa

SELECT 
    n1.*
FROM
    nazione n1,
    conferenza c,
    partecipa p,
    nazione n2
WHERE
    n1.cod_n = p.cod_n_p
        AND p.cod_c_p = c.cod_c
        AND c.cod_n_sede = n2.cod_n
        AND n2.continente = 'Europa';

-- b) selezionare i dati relativi alle nazioni che hanno partecipato ad una
-- conferenza tenutasi nella nazione stessa

SELECT 
    n.*
FROM
    nazione n,
    conferenza c,
    partecipa p
WHERE
    n.cod_n = p.cod_n_p
        AND p.cod_c_p = c.cod_c
        AND c.cod_n_sede = n.cod_n;

-- c) selezionare i dati relativi alle nazioni che non hanno mai partecipato ad una
-- conferenza assieme ad una nazione del continente Europa

SELECT 
    *
FROM
    nazione n
WHERE
    n.cod_n NOT IN (SELECT 
            p1.cod_n_p
        FROM
            partecipa p1,
            nazione n,
            partecipa p2
        WHERE
            p1.cod_c_p = p2.cod_c_p
                AND p2.cod_n_p = n.cod_n
                AND n.continente = 'Europa');

-- d) selezionare i dati relativi alla nazione in cui si è tyenuta la conferenza
-- con il maggior numero di rappresentanti complessivo

SELECT 
    n.*
FROM
    nazione n,
    conferenza c
WHERE
    n.cod_n = c.cod_n_sede
        AND c.cod_c IN (SELECT 
            p1.cod_c_p
        FROM
            partecipa p1
        GROUP BY p1.cod_c_p
        HAVING SUM(p1.numerop) >= ALL (SELECT 
                SUM(p2.numerop)
            FROM
                partecipa p2
            GROUP BY p2.numerop));

-- e) selezionare, per ogni nazione, la conferenza in cui vi ha partecipato con il
-- maggior numero di rappresentanti

SELECT 
    p1.cod_n_p, p1.cod_c_p
FROM
    partecipa p1
WHERE
    p1.numerop = (SELECT 
            MAX(p2.numerop)
        FROM
            partecipa p2
        WHERE
            p2.cod_n_p = p1.cod_n_p);