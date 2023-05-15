CREATE TABLE persona (
  nome VARCHAR(50),
  cognome VARCHAR(50),
  reddito INT,
  PRIMARY KEY (nome, cognome)
);

CREATE TABLE paternita (
  padre VARCHAR(50),
  figlio VARCHAR(50),
  FOREIGN KEY (padre) REFERENCES persona(nome),
  FOREIGN KEY (figlio) REFERENCES persona(nome),
  PRIMARY KEY (padre, figlio)
);

INSERT INTO persona (nome, cognome, reddito)
VALUES ('Mario', 'Rossi', 30000),
       ('Paolo', 'Bianchi', 25000),
       ('Luca', 'Rossi', 0),
       ('Anna', 'Verdi', 15000),
       ('Marco', 'Neri', 20000),
       ('Sara', 'Bianchi', 28000),
       ('Gino', 'Verdi', 22000);

INSERT INTO paternita (padre, figlio)
VALUES ('Mario', 'Luca'),
       ('Paolo', 'Sara'),
       ('Anna', 'Gino');
       
-- Nome del padre, del figlio e dello spirito santo

SELECT *
FROM persona as pe1, paternita as pa, persona as pe2
WHERE pe1.nome = pa.padre AND pa.figlio = pe2.nome;
