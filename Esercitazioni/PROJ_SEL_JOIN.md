# Esercitazione [21/03/2023] 

1. Selezionare codice, nome e cognome di tutte le persone che hanno effettuato almeno un acquisto nel 2022.
2. Selezionare codice, nome e cognome di tutte le persone che hanno comprato un iPhone nel 20223 nei negozi di Palermo o Catania con un prezzo compreso tra 1000 e 1500 EUR.
3. Selezionare codice e nome dei negozi di Roma dove e' stato effettuato almeno un acquisto di un televisore con prezzo maggiore di 2000 EUR.
4. Selezionare codice e nome degli oggetti di categoria informatica che sono stati acquistati da persone di sesso maschile con un eta' compresa tra 40 e 50 anni.

## Schemi di relazione
### PERSONA
|COD_P | NOME | COGNOME | ETA | SESSO |
| :-: | :-: | :-: | :-: | :-:
### OGGETTO
|COD_O | NOME_O | PREZZO | CATEGORIA |
| :-: | :-: | :-: | :-: |

### ACQUISTO
|REF_P | REF_O | REF_N | DATA | QUANTITA |
| :-: | :-: | :-: | :-: | :-:

### NEGOZIO
|COD_N | NOME_N | VIA | CITTA |
| :-: | :-: | :-: | :-: |

## <text style=color:lightblue> Soluzione

[1]

SEL<sub>A.DATA >= '01/01/2022'AND A.DATA <= '31/12/2022'</sub> (P JOIN <sub>P.COD_P = A.REF_P</sub> A)

_Spiegazione_
**P JOIN <sub>P.COD_P = A.REF_P</sub> A**
|COD_P | NOME | COGNOME | ETA | SESSO | REF_P | REF_O | REF_N | DATA | QUANTITA |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-:
|<text style=color:red>00042 | :-: | :-: | :-: | :-: | <text style=color:red>00042 | :-: | :-: | :-: | :-: |

E poi si procede a eliminare le tuple selezionando quelle che soddisfano le nostre condizioni booleane. In seguito si proiettano gli attributi interessati.

[2]

PROJ<sub>P.COD_P, P.NOME, P.COGNOME</sub> (SEL<sub>N.CITTA = ‘PALERMO’ AND N.CITTA = ‘CATANIA’ AND A.DATA <= ’01/01/2023’ AND A.DATA <= ’31/12/2023’ AND O.NOME_O = ‘iPhone’ AND O.PREZZO >= 1000 AND O.PREZZO <= 1500 </sub>(((P JOIN<sub>P.COD_P = A.REF_P </sub> A) JOIN<sub>A.REF_O = O.COD_O</sub> O) JOIN<sub>A.REF_N = N.COD_N</sub> N))

[3]

PROJ<sub>N.COD_N, N.NOME_N</sub> (SEL<sub>N.CITTA = ‘ROMA’ AND O.CATEGORIA = ’Televisore’ AND O.PREZZO >= 2000</sub> ((N JOIN<sub>N.COD_N = A.REF_N</sub> A) JOIN<sub>A.REF_O = O.COD_O</sub> O))

[4]

PROJ<sub>O.COD_O, O.NOME_O</sub> (SEL<sub>O.CATEGORIA = ‘Informatica’ AND P.ETA >= 40 AND P.ETA <= 50 AND P.SESSO = ‘M’</sub> ((P JOIN<sub>P.COD_P = A.REF_P</sub> A) JOIN<sub>A.REF_O = O.COD_O</sub> O))


