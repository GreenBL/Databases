-- DB Di merda

CREATE TABLE PERSONA (
  COD_P INT PRIMARY KEY,
  NOME VARCHAR(50),
  COGNOME VARCHAR(50),
  ETA INT,
  SESSO VARCHAR(10)
);

CREATE TABLE OGGETTO (
  COD_O INT PRIMARY KEY,
  NOME_O VARCHAR(50),
  CATEGORIA VARCHAR(50),
  PREZZO DECIMAL(10, 2)
);

CREATE TABLE ACQUISTO (
  REF_P INT,
  REF_O INT,
  DATA_ACQUISTO DATE,
  QUANTITA INT,
  PRIMARY KEY (REF_P, REF_O, DATA_ACQUISTO),
  FOREIGN KEY (REF_P) REFERENCES PERSONA(COD_P),
  FOREIGN KEY (REF_O) REFERENCES OGGETTO(COD_O)
);

-- Inserimento dati di esempio per PERSONA
INSERT INTO PERSONA (COD_P, NOME, COGNOME, ETA, SESSO)
VALUES
  (1, 'Mario', 'Rossi', 35, 'M'),
  (2, 'Luigi', 'Verdi', 28, 'M'),
  (3, 'Anna', 'Bianchi', 42, 'F'),
  (4, 'Giovanna', 'Russo', 31, 'F'),
  (5, 'Roberto', 'Ferrari', 47, 'M'),
  (6, 'Laura', 'Romano', 39, 'F'),
  (7, 'Paolo', 'Conti', 23, 'M'),
  (8, 'Chiara', 'Galli', 55, 'F'),
  (9, 'Marco', 'Lombardi', 41, 'M'),
  (10, 'Francesca', 'Moretti', 30, 'F'),
  (11, 'Simone', 'Marchetti', 26, 'M'),
  (12, 'Elena', 'Santoro', 33, 'F'),
  (13, 'Davide', 'Ricci', 45, 'M'),
  (14, 'Valentina', 'Gentile', 29, 'F'),
  (15, 'Antonio', 'Martini', 36, 'M'),
  (16, 'Sara', 'Barbieri', 27, 'F'),
  (17, 'Fabio', 'Negri', 38, 'M'),
  (18, 'Giulia', 'Pellegrini', 32, 'F'),
  (19, 'Stefano', 'Vitali', 37, 'M'),
  (20, 'Monica', 'Fiore', 43, 'F');

-- Inserimento dati di esempio per OGGETTO
INSERT INTO OGGETTO (COD_O, NOME_O, CATEGORIA, PREZZO)
VALUES
  (1, 'Smartphone', 'Elettronica', 699.99),
  (2, 'Cuffie wireless', 'Elettronica', 129.99),
  (3, 'Maglietta', 'Abbigliamento', 24.99),
  (4, 'Scarpe da ginnastica', 'Abbigliamento', 89.99),
  (5, 'Orologio', 'Accessori', 199.99),
  (6, 'Borsa', 'Accessori', 79.99),
  (7, 'Libro', 'Libri', 19.99),
  (8, 'Televisore', 'Elettronica', 999.99),
(9, 'Felpa con cappuccio', 'Abbigliamento', 59.99),
(10, 'Pantaloni', 'Abbigliamento', 49.99),
(11, 'Braccialetto', 'Accessori', 39.99),
(12, 'Computer portatile', 'Elettronica', 1299.99),
(13, 'Giacca', 'Abbigliamento', 119.99),
(14, 'Tastiera', 'Elettronica', 69.99),
(15, 'Zaino', 'Accessori', 49.99),
(16, 'Occhiali da sole', 'Accessori', 79.99),
(17, 'Album musicale', 'Musica', 14.99),
(18, 'DVD', 'Film', 9.99),
(19, 'Cuscino', 'Casa', 29.99),
(20, 'Tazza', 'Casa', 12.99),
(21, 'Gioiello', 'Accessori', 149.99),
(22, 'Videogioco', 'Giochi', 49.99),
(23, 'Stampante', 'Elettronica', 199.99),
(24, 'T-Shirt', 'Abbigliamento', 19.99),
(25, 'Foulard', 'Accessori', 34.99),
(26, 'Piumino', 'Abbigliamento', 139.99),
(27, 'Cintura', 'Accessori', 29.99),
(28, 'Profumo', 'Bellezza', 79.99),
(29, 'Caffettiera', 'Casa', 49.99),
(30, 'Portafoglio', 'Accessori', 39.99);

-- Inserimento dati di esempio per ACQUISTO
INSERT INTO ACQUISTO (REF_P, REF_O, DATA_ACQUISTO, QUANTITA)
VALUES
(1, 3, '2023-04-01', 1),
(1, 11, '2023-04-15', 2),
(2, 2, '2023-04-03', 1),
(2, 12, '2023-04-14', 1),
(3, 6, '2023-04-10', 1),
(3, 10, '2023-04-15', 1),
(4, 4, '2023-04-05', 1),
(4, 13, '2023-04-18', 1),
(5, 1, '2023-04-02', 1),
(5, 15, '2023-04-10', 1),
(6, 5, '2023-04-08', 1),
(6, 21, '2023-04-17', 1),
(7, 7, '2023-04-04', 1),
(7, 18, '2023-04-19', 1),
(8, 8, '2023-04-06', 1),
(8, 23, '2023-04-20', 1),

(9, 9, '2023-04-09', 1),
(9, 30, '2023-04-16', 1),
(10, 14, '2023-04-11', 1),
(10, 26, '2023-04-21', 1);

-- Inserimento di altri acquisti di esempio (per raggiungere almeno 10 acquisti)
INSERT INTO ACQUISTO (REF_P, REF_O, DATA_ACQUISTO, QUANTITA)
VALUES
(11, 16, '2023-04-05', 1),
(12, 17, '2023-04-06', 1),
(13, 19, '2023-04-07', 1),
(14, 20, '2023-04-08', 1),
(15, 22, '2023-04-09', 1),
(16, 24, '2023-04-12', 1),
(17, 25, '2023-04-13', 1),
(18, 27, '2023-04-14', 1),
(19, 28, '2023-04-15', 1),
(20, 29, '2023-04-18', 1);

-- Inserimento di altri acquisti di esempio (per raggiungere almeno 1 acquisto per persona)
INSERT INTO ACQUISTO (REF_P, REF_O, DATA_ACQUISTO, QUANTITA)
VALUES
(1, 4, '2023-04-20', 1),
(2, 5, '2023-04-21', 1),
(3, 7, '2023-04-22', 1),
(4, 8, '2023-04-23', 1),
(5, 9, '2023-04-24', 1),
(6, 14, '2023-04-25', 1),
(7, 16, '2023-04-26', 1),
(8, 17, '2023-04-27', 1),
(9, 18, '2023-04-28', 1),
(10, 20, '2023-04-29', 1);