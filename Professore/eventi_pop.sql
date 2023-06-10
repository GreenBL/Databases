--
-- Create schema eventi
--

CREATE DATABASE IF NOT EXISTS eventi;
USE eventi;

--
-- Definition of table manifestazione
--

CREATE TABLE manifestazione (
  cod_m char(5) NOT NULL,
  nome_m varchar(45) NOT NULL,
  PRIMARY KEY (cod_m)
);

--
-- Definition of table luogo
--

CREATE TABLE luogo (
  nome_l varchar(45) NOT NULL,
  indirizzo varchar(45) NOT NULL,
  citta varchar(20) NOT NULL,
  PRIMARY KEY (nome_l)
); 

--
-- Definition of table spettacolo
--

CREATE TABLE spettacolo (
  cod_m_s char(5) NOT NULL,
  num int(2) NOT NULL, -- è il numero dello spettacolo all'interno della manifestazione cod_m
  ora_inizio numeric(4,2) NOT NULL,
  nome_l_s varchar(45) NOT NULL,
  giorno date NOT NULL,
  PRIMARY KEY (cod_m_s, num),
  FOREIGN KEY (cod_m_s) REFERENCES manifestazione(cod_m),
  FOREIGN KEY (nome_l_s) REFERENCES luogo(nome_l)
);


--
-- populating the DB
--
INSERT INTO manifestazione VALUES ('A', 'XX Concerto');
INSERT INTO manifestazione VALUES ('B', 'III Rappresentazione');
INSERT INTO manifestazione VALUES ('C', 'XIX Festival');
INSERT INTO manifestazione VALUES ('D', 'IX Festival');
INSERT INTO luogo VALUES ('Fontana verde', 'Via Verdi', 'Firenze');
INSERT INTO luogo VALUES ('Gugliemo', 'Via Marconi', 'Roma');
INSERT INTO luogo VALUES ('Piazza del Plebiscito', 'Piazza del Plebiscito', 'Napoli');
INSERT INTO luogo VALUES ('Cortili', 'Via piazze', 'Modena');
INSERT INTO spettacolo VALUES ('A', 1, 16.30, 'Piazza del Plebiscito', '1999-01-01');
INSERT INTO spettacolo VALUES ('A', 2, 16.00, 'Piazza del Plebiscito', '2002-02-28');
INSERT INTO spettacolo VALUES ('B', 3, 17.30, 'Piazza del Plebiscito', '2002-02-28');
INSERT INTO spettacolo VALUES ('C', 4, 15.30, 'Piazza del Plebiscito', '2002-02-28');
INSERT INTO spettacolo VALUES ('D', 5, 22.00, 'Piazza del Plebiscito', '2002-02-28');
INSERT INTO spettacolo VALUES ('B', 6, 22.30, 'Gugliemo', '2000-02-23');
INSERT INTO spettacolo VALUES ('C', 7, 11.35, 'Fontana verde', '1998-05-05');
INSERT INTO spettacolo VALUES ('A', 8, 21.10, 'Cortili', '1998-05-05');


--
-- QUERY (ALGEBRA RELAZIONALE a) e b))
-- 

-- a) selezionare ilcodice e il nome delle manifestazioni che non hanno interessato
-- luoghi della città di Modena

SELECT 
    *
FROM
    manifestazione m
WHERE
    NOT EXISTS( SELECT 
            *
        FROM
            luogo l,
            spettacolo s
        WHERE
            m.cod_m = s.cod_m_s
                AND l.nome_l = s.nome_l_s
                AND l.citta = 'Modena');

-- b)selezionare i nomi dei luoghi che hanno ospitato tutte le manifestazioni
-- (hanno ospitato almeno uno spettacolo di ciascuna manifestazione)

SELECT DISTINCT
    s1.nome_l_s
FROM
    spettacolo s1
WHERE
    NOT EXISTS( SELECT 
            *
        FROM
            manifestazione m
        WHERE
            NOT EXISTS( SELECT 
                    *
                FROM
                    spettacolo s2
                WHERE
                    s1.nome_l_s = s2.nome_l_s
                        AND m.cod_m = s2.cod_m_s));

-- c) selezionare il nome dei luoghi che, in una certa data, ospitano più di tre 
-- spettacoli dopo le ore 15

SELECT DISTINCT
    s1.nome_l_s
FROM
    spettacolo s1
WHERE
    s1.ora_inizio > 15
        AND 3 < (SELECT 
            COUNT(*)
        FROM
            spettacolo s2
        WHERE
            s1.nome_l_s = s2.nome_l_s
                AND s1.giorno = s2.giorno
                AND s2.ora_inizio > 15);

-- d) selezionare, per ogni luogo, il numero totale delle manifestazioni e il numero
-- totale degli spettacoli ospitati

SELECT 
    s.nome_l_s,
    COUNT(DISTINCT s.cod_m_s) AS n_man,
    COUNT(*) AS n_spet
FROM
    spettacolo s
GROUP BY s.nome_l_s;

-- e) descrivere sinteticamente a parole e riportare in SQL l'interrogazione descritta
-- dalla seguente espressione dell'algebra relazionale

-- PI[cod_m](spettacolo) - PI[cod_m](PI[cod_m,num](spettacolo) - PI[cod_m,num](SEL[ora_inizio>15](spettacolo))) 

-- seleziona i codici delle manifestazioni i cui spettacoli sono iniziati sempre dopo le ore 15. In SQL:

SELECT DISTINCT
    s1.cod_m_s
FROM
    spettacolo s1
WHERE
    NOT EXISTS( SELECT 
            *
        FROM
            spettacolo s2
        WHERE
            s1.cod_m_s = s2.cod_m_s
                AND s2.ora_inizio <= 15);