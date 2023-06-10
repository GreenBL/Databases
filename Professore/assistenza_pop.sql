--
-- Create schema assistenza
--

CREATE DATABASE IF NOT EXISTS assistenza;
USE assistenza;

--
-- Definition of table tecnico
--

CREATE TABLE tecnico (
  cf char(16) NOT NULL,
  indirizzo varchar(45) NOT NULL,
  qualifica varchar(30) NOT NULL,
  costo_orario int(2) NOT NULL,
  PRIMARY KEY (cf)
);


--
-- Definition of table pc
--

CREATE TABLE pc (
  cod_pc char(5) NOT NULL,
  nome varchar(45) NOT NULL,
  tipo varchar(20),
  nome_proprietario varchar(75) NOT NULL,
  PRIMARY KEY (cod_pc)
); 

--
-- Definition of table riparazione
--

CREATE TABLE riparazione (
  data_riparazione date NOT NULL,
  cf_r char(16) NOT NULL,
  cod_pc_r char(5) NOT NULL,
  ore int(2) NOT NULL,
  PRIMARY KEY (data_riparazione, cf_r, cod_pc_r),
  FOREIGN KEY (cf_r) REFERENCES tecnico(cf),
  FOREIGN KEY (cod_pc_r) REFERENCES pc(cod_pc)	
);

-- nella data-riparazione specificata, il tecnico cf ha riparato il personal computer
-- cod_pc impiegando un certo numero di ore

--
-- populating the DB
--



--
-- QUERY (ALGEBRA RELAZIONALE a), b))
-- 

-- a) selezionare i personal di tipo 'Mac' che non sono stati riparati tra il 1/7/97
-- e il 1/11/97



-- b) selezionare i tecnici che hanno riparato tutti i personal di tipo 'Mac'

SELECT 
    *
FROM
    tecnico t
WHERE
    NOT EXISTS( SELECT 
            *
        FROM
            pc
        WHERE
            pc.tipo = 'Mac'
                AND NOT EXISTS( SELECT 
                    *
                FROM
                    riparazione r
                WHERE
                    r.cod_pc_r = pc.cod_pc AND r.cf_r = t.cf));

-- c) selezionare le coppie (PC1, PC2) tali che i personal con codice PC1 e PC2
-- sono stati riparati nella stessa data dallo stesso tecnico

SELECT 
    r1.cod_pc_r, r2.cod_pc_r
FROM
    riparazione r1,
    riparazione r2
WHERE
    r1.cf_r = r2.cf_r
        AND r1.data_riparazione = r2.data_riparazione
        AND r1.cod_pc_r <> r2.cod_pc_r;

-- d) selezionare i dati dei personal che hanno richiesto almeno 10 ore di riparazione

SELECT 
    *
FROM
    pc
WHERE
    10 <= (SELECT 
            SUM(r.ore)
        FROM
            riparazione r
        WHERE
            r.cod_pc_r = pc.cod_pc);

-- e) selezionare, per ogni data, il tecnico che ha riparato ilmaggior numero di personal

SELECT DISTINCT
    r1.data_riparazione, r1.cf_r
FROM
    riparazione r1
GROUP BY r1.data_riparazione , r1.cf_r
HAVING COUNT(r1.cod_pc_r) >= ALL (SELECT 
        COUNT(r2.cod_pc_r)
    FROM
        riparazione r2
    WHERE
        r1.data_riparazione = r2.data_riparazione
    GROUP BY r2.cf_r);

-- f) selezionare il personal che ha totalizzato il maggior costo di riparazione,
-- considerando le ore di riparazione e il relativo costo orario

SELECT 
    *
FROM
    pc
WHERE
    pc.cod_pc IN (SELECT 
            r1.cod_pc_r
        FROM
            riparazione r1,
            tecnico t1
        WHERE
            r1.cf_r = t1.cf
        GROUP BY r1.cod_pc_r
        HAVING SUM(r1.ore * t1.costo_orario) >= ALL (SELECT 
                SUM(r2.ore * t2.costo_orario)
            FROM
                riparazione r2,
                tecnico t2
            WHERE
                r2.cf_r = t2.cf
            GROUP BY r2.cod_pc_r));