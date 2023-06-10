--
-- Create schema stradario
--

CREATE DATABASE IF NOT EXISTS stradario;
USE stradario;

--
-- Definition of table via
--

CREATE TABLE via (
  cod_via char(5) NOT NULL,
  nome varchar(75) NOT NULL,
  quartiere varchar(45) NOT NULL,
  lunghezza numeric(6,3),
  PRIMARY KEY (cod_via)
);

--
-- Definition of table incrocio
--

CREATE TABLE incrocio (
  cod_via_a char(5) NOT NULL,
  cod_via_b char(5) NOT NULL,
  n_volte int,
  PRIMARY KEY (cod_via_a, cod_via_b),
  FOREIGN KEY (cod_via_a) REFERENCES via(cod_via),
  FOREIGN KEY (cod_via_b) REFERENCES via(cod_via)
); 

-- la via cod_via_a incrocia n_volte la via cod_via_b
-- si assume che se nella rlazione incrocio è presente la tupla (cod_via_a, cod_via_b, 5) 
-- non sia presente la tupla simmetrica (cod_via_b, cod_via_a, 5) 

--
-- populating the DB
--

INSERT INTO via VALUES -- cod_via, nome, quartiere, lung
('01','Main St','Pastena',100),
('02','2nd Av','Pastena',101),
('03','3rd St','02',102),
('04','4th St','03',103),
('05','5th St','03',104),
('06','6th St','03',105),
('07','Wall St','02',106),
('08','New St','04',107),
('09','Old St','03',108),
('10','Marco Polo','Pastena',109);

INSERT INTO incrocio VALUES
('01','02',3),
('03','02',5),
('04','03',1),
('10','07',2),
('05','03',2),
('01','10',31),
('09','06',3),
('07','08',4),
('02','09',5),
('01','05',12),
('05','06',10);
--
-- QUERY (ALGEBRA RELAZIONALE a), b))
-- 

-- a)selezionare le vie che incrociano almeno una via del quartiere 'Pastena'

SELECT 
    *
FROM
    via v
WHERE
    v.cod_via IN (SELECT 
            i.cod_via_a
        FROM
            incrocio i,
            via v
        WHERE
            i.cod_via_b = v.cod_via AND v.quartiere = 'Pastena'
                OR v.cod_via IN (SELECT 
                    i.cod_via_b
                FROM
                    incrocio i,
                    via v
                WHERE
                    i.cod_via_a = v.cod_via AND v.quartiere = 'Pastena'));

-- b)selezionare le vie che non incrociano via 'Marco Polo'

SELECT 
    *
FROM
    via v
WHERE
    v.cod_via NOT IN (SELECT 
            i.cod_via_a
        FROM
            incrocio i,
            via v
        WHERE
            i.cod_via_b = v.cod_via AND v.nome = 'Marco Polo'
                OR v.cod_via NOT IN (SELECT 
                    i.cod_via_b
                FROM
                    incrocio i,
                    via v
                WHERE
                    i.cod_via_a = v.cod_via AND v.nome = 'Marco Polo'));

-- c)selezionare le coppie (codice1, codice2) tali che le vie con codice codice1
-- e codice2 abbiano la steessa lunghezza

SELECT 
    v1.cod_via AS codice1, v2.cod_via AS codice2
FROM
    via v1,
    via v2
WHERE
    v1.lunghezza = v2.lunghezza
        AND v1.cod_via > v2.cod_via;

-- d)selezionare il quartiere che ha il maggior numero di vie

SELECT 
    v.quartiere
FROM
    via v
GROUP BY v.quartiere
HAVING COUNT(*) >= ALL (SELECT 
        COUNT(*)
    FROM
        via v
    GROUP BY v.quartiere);

-- e)selezionare per ogni quartiere, la via di lunghezza maggiore

SELECT 
    v1.quartiere, v1.cod_via
FROM
    via v1
WHERE
    v1.lunghezza = (SELECT 
            MAX(v2.lunghezza)
        FROM
            via v2
        WHERE
            v1.quartiere = v2.quartiere);

-- f)selezionare le vie che incrociano tutte le vie del quartiere 'Pastena'

SELECT 
    *
FROM
    via v1
WHERE
    NOT EXISTS( SELECT 
            *
        FROM
            via v2
        WHERE
            v2.quartiere = 'Pastena'
                AND NOT EXISTS( SELECT 
                    *
                FROM
                    incrocio i
                WHERE
                    (v1.cod_via = cod_via_a AND v2.cod_via = cod_via_b)
                        OR (v1.cod_via = cod_via_a AND v2.cod_via = cod_via_b)));