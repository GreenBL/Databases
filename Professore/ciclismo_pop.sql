--
-- Create schema ciclismo
--

CREATE DATABASE IF NOT EXISTS ciclismo;
USE ciclismo;

--
-- Definition of table ciclista
--

CREATE TABLE ciclista (
  nome_ciclista varchar(75) NOT NULL,
  nazionalita char(3) NOT NULL,
  eta char(2) NOT NULL,
  PRIMARY KEY (nome_ciclista)
);

--
-- Definition of table gara
--

CREATE TABLE gara (
  nome_corsa varchar(45) NOT NULL,
  anno int(4) NOT NULL,
  partenza varchar(45) NOT NULL,
  arrivo varchar(45) NOT NULL,
  PRIMARY KEY (nome_corsa, anno)
); 

--
-- Definition of table partecipa
--

CREATE TABLE partecipa (
  nome_corsa_p varchar(45) NOT NULL,
  anno_p int(4) NOT NULL,
  nome_ciclista_p varchar(75) NOT NULL,
  posizione char,
  PRIMARY KEY (nome_corsa_p, anno_p, nome_ciclista_p),
  FOREIGN KEY (nome_corsa_p, anno_p) REFERENCES gara(nome_corsa, anno),
  FOREIGN KEY (nome_ciclista_p) REFERENCES ciclista(nome_ciclista)	
);


--
-- populating the DB
--

INSERT INTO ciclista VALUES
('Rossi','Italia','20'),
('Gialli','Italia','30'),
('Neri','Italia','50'),
('Federer','Svizzera','20'),
('Williams','America','19'),
('Hamilton','Inghilterra','24'),
('Bernabeu','Spagna','63');

INSERT INTO gara VALUES
('Giro d_Italia', 2002, 'Milano', 'Palermo'),
('Giro d_Italia', 2003, 'Milano', 'Torino'),
('Giro d_Italia', 2004, 'Milano', 'Palermo'),
('Giro d_Italia', 2005, 'Napoli', 'Trento'),
('Giro d_Italia', 2006, 'Aosta', 'Scilla'),
('Giro d_Italia', 2007, 'Milano', 'Salerno'),
('Tour de France', 2004, 'Parigi', 'Strasburgo'),
('Tour de France', 2006, 'Marsiglia', 'Versaille'),
('Tour de France', 2008, 'Parigi', 'Lione'),
('Tour de France', 2010, 'Parigi', 'Marsiglia'),
('Tour de France', 2012, 'Nyon', 'Versaille');

INSERT INTO partecipa VALUES
('Giro d_Italia',2002,'Rossi','1'),
('Giro d_Italia',2002,'Gialli','R'),
('Giro d_Italia',2002,'Hamilton','R'),
('Giro d_Italia',2003,'Williams','1'),
('Giro d_Italia',2004,'Rossi','1'),
('Giro d_Italia',2004,'Bernabeu','2'),
('Giro d_Italia',2005,'Neri','1'),
('Giro d_Italia',2006,'Federer','1'),
('Giro d_Italia',2006,'Gialli','2'),
('Giro d_Italia',2006,'Hamilton','3'),
('Giro d_Italia',2006,'Williams','4'),
('Giro d_Italia',2007,'Williams','1'),
('Giro d_Italia',2007,'Federer','R'),
('Tour de France',2004,'Rossi','1'),
('Tour de France',2006,'Neri','1'),
('Tour de France',2008,'Rossi','1'),
('Tour de France',2010,'Rossi','1'),
('Tour de France',2012,'Rossi','1');
--
-- QUERY (ALGEBRA RELAZIONALE a), b), c))
-- 

-- a) selezionare i ciclisti che si sono classificati in prima
-- posizione in una gara ciclistica partita da Milano

SELECT DISTINCT c.*
FROM ciclista c, partecipa p, gara g
WHERE c.nome_ciclista=p.nome_ciclista_p AND p.nome_corsa_p=g.nome_corsa AND p.anno_p=g.anno
AND g.partenza='Milano' AND p.posizione='1';


-- b) selezionare il nome dei ciclisti che non si sono mai ritirati al Giro
-- (corsa con nome Giro)

SELECT 
    *
FROM
    ciclista c
WHERE
    c.nome_ciclista NOT IN (SELECT 
            p.nome_ciclista_p
        FROM
            partecipa p
        WHERE
            p.nome_corsa_p = 'Giro d_Italia'
                AND p.posizione = 'R');

-- c) selezionare le corse per le quali in ogni edizione c'è stato almeno un ritirato

SELECT 
    g1.nome_corsa
FROM
    gara g1
WHERE
    NOT EXISTS( SELECT 
            *
        FROM
            gara g2
        WHERE
            g1.nome_corsa = g2.nome_corsa
                AND NOT EXISTS( SELECT 
                    *
                FROM
                    partecipa p
                WHERE
                    g2.nome_corsa = p.nome_corsa_p
                        AND g2.anno = p.anno_p
                        AND p.posizione = 'R'));

-- d) selezionare, per ogni corsa ciclistica, l'anno in cui c'è stato il maggior
-- numero di ciclisti ritirati

SELECT 
    p1.nome_corsa_p, p1.anno_p
FROM
    partecipa p1
WHERE
    p1.posizione = 'R'
GROUP BY p1.nome_corsa_p , p1.anno_p
HAVING COUNT(*) >= ALL (SELECT 
        COUNT(*)
    FROM
        partecipa p2
    WHERE
        p2.nome_corsa_p = p1.nome_corsa_p
            AND p2.posizione = 'R'
    GROUP BY anno_p)