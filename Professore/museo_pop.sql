--
-- Create schema museo
--

CREATE DATABASE IF NOT EXISTS museo;
USE museo;

--
-- Definition of table quadro
--

CREATE TABLE quadro (
  cod_q char(5) NOT NULL,
  autore varchar(75) NOT NULL,
  periodo varchar(16) NOT NULL,
  PRIMARY KEY (cod_q)
);


--
-- Definition of table mostra
--

CREATE TABLE mostra (
  cod_m char(5) NOT NULL,
  nome varchar(75) NOT NULL,
  anno int(4) NOT NULL,
  organizzatore varchar(75) NOT NULL,
  PRIMARY KEY (cod_m)
); 

--
-- Definition of table espone
--

CREATE TABLE espone (
  cod_m_e char(5) NOT NULL,
  cod_q_e char(5) NOT NULL,
  sala int(3) NOT NULL,
  PRIMARY KEY (cod_m_e, cod_q_e),
  FOREIGN KEY (cod_m_e) REFERENCES mostra(cod_m),
  FOREIGN KEY (cod_q_e) REFERENCES quadro(cod_q)	
);

-- nella mostra cod_m_e, il quadro cod_q_e è stato esposto in certa sala 


--
-- populating the DB
--

INSERT INTO mostra (cod_m,nome,anno,organizzatore)
VALUES ('01','AAA',1997,'P'),
('02','BBB',2001,'S'),
('03','CCC',2222,'AS');

INSERT INTO quadro (cod_q,autore,periodo)
VALUES ('01', 'Picasso','1'),
('02', 'Picasso', '2'),
('03', 'Neruda', '321'),
('04', 'Picasso', '0'),
('05', 'Giuseppe', '12'),
('06', 'Neruda', '1');
  
INSERT INTO espone (cod_m_e, cod_q_e, sala)
VALUES ('01','01',1),
('01','02',1),
('01','03',1),
('01','05',2),
('02','01',1),
('02','03',1),
('02','02',1),
('03','03',1),
('03','04',1);

--
-- QUERY (ALGEBRA RELAZIONALE a), b), c))
-- 

-- a) selezionare le sale nelle quali è stato esposto, nell'anno 1997, un quadro di Picasso

select distinct sala
from quadro Q, espone E, mostra m
where q.cod_q=e.cod_q_e AND e.cod_m_e=m.cod_m AND
q.autore='Picasso' AND m.anno='1997';

-- b) selezionare tutti i dati dei quadri di Picasso che non sono mai stati
-- esposti nell'anno 1997

SELECT 
    *
FROM
    quadro q
WHERE
    q.autore = 'Picasso'
        AND q.cod_q NOT IN (SELECT 
            e.cod_q_e
        FROM
            mostra m,
            espone e
        WHERE
            m.cod_m = e.cod_m_e AND anno = '1997');

-- c) selezionare tutti i dati dei quadri che non sono mai stati esposti insieme con un quadro di Picasso,
-- cioè nella stessa mostra in cui compariva anche un quadro di Picasso

SELECT 
    *
FROM
    quadro q
WHERE
    q.cod_q NOT IN (SELECT 
            e2.cod_q_e
        FROM
            quadro q,
            espone e1,
            espone e2
        WHERE
            q.cod_q = e1.cod_q_e
                AND e1.cod_m_e = e2.cod_m_e
                AND q.autore = 'Picasso');

-- d) selezionare tutti i dati delle mostre in cui sono stati esposti quadri di almeno 5 autori distinti

SELECT 
    *
FROM
    mostra m
WHERE
    5 <= (SELECT 
            COUNT(DISTINCT q.autore)
        FROM
            quadro q,
            espone e
        WHERE
            q.cod_q = e.cod_q_e
                AND m.cod_m = e.cod_m_e);


-- e) selezionare, per ogni mostra, l'autore di cui si esponeva il maggior numero di quadri

SELECT 
    e1.cod_m_e, q1.autore
FROM
    espone e1,
    quadro q1
WHERE
    e1.cod_q_e = q1.cod_q
GROUP BY e1.cod_m_e , q1.autore
HAVING COUNT(*) >= ALL (SELECT 
        COUNT(*)
    FROM
        espone e2,
        quadro q2
    WHERE
        e2.cod_q_e = q2.cod_q
            AND e1.cod_m_e = e2.cod_m_e
    GROUP BY q2.autore)