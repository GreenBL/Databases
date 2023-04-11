# Esercitazione [04/04/2023]

## Relazioni

<text style=color:red>CAVALLO</text>(**COD_C**, NOME_C, COGNOME_FANTINO, RAZZA, COLORE, ETA)
<text style=color:blue>ESIBIZIONE</text>(**COD_E**, NOME_E, ANNO, CITTA, NAZIONE, SOCIETA_ORGANIZZATRICE)
<text style=color:lightgreen>COMPETE</text>(**REF_C**, **REF_E**, DATA)

```mermaid
graph BT;
CA((CAVALLO))
ES((ESIBIZIONE))
CO((COMPETE))
CA_KEY[COD_C]
ES_KEY[COD_E]
CO_KEY[REF_C, REF_E]

CO --REF_C -> COD_C--> CA
CO --REF_E -> COD_E--> ES

CA --> CA_KEY
ES --> ES_KEY
CO_KEY --> CO
```

<text style=color:red>1.</text> SELEZIONARE LE DATE NELLE QUALI HA GAREGGIATO UN CAVALLO CAVALCATO DAL FANTINO
‘DETTORI’ DI ANNI 6 E DI RAZZA ‘PUROSANGUE’;
<span style="background-color: blue">
PROJ<sub>CO.DATA</sub> (SEL<sub>CA.COGNOME_FANTINO = 'DETTORI' & CA.ETA = 6 & CA.RAZZA = 'PUROSANGUE'</sub> (CA JOIN<sub>CA.COD_C = CO.COD_C</sub> CO))
</span>

<text style=color:red>2.</text> SELEZIONARE TUTTI I DATI DEI CAVALLI CAVALCATI DAL FANTINO ‘RISPOLI’ CHE NON HANNO MAI
GAREGGIATO NEL 2020;

<span style="background-color: blue">
PROJ<sub>CA.COD_C, CA_NOME_C, CA.COGNOME_FANTINO, CA.RAZZA, CA.COLORE, CA.ETA</sub> (SEL<sub>CA.COGNOME_FANTINO = 'RISPOLI'</sub> (CA JOIN<sub>CA.COD_C = CO.REF_C</sub> CO) - SEL<sub>CO.DATA > '01/01/2022' & CO.DATA < '31/12/2022'</sub> (CA JOIN<sub>CA.COD_C = CO.REF_C</sub> CO))


<text style=color:red>3.</text> SELEZIONARE TUTTI I DATI DEI CAVALLI CHE NON HANNO MAI GAREGGIATO INSIEME AD UN
CAVALLO DEL FANTINO ‘ERCEVOGIC’;

<span style="background-color: blue">
PROJ<sub>CA.COD_C, CA.NOME_C</sub> (CA) - REN<sub>COD_C <- CA1.COD_C1, NOME_C <- CA1.NOME_C1</sub> (PROJ<sub>CA1.COD_C1, CA1.NOME_C1</sub> (SEL<sub>CA2.COGNOME_FANTINO2 = 'ERCEGOVIC'</sub> ((CA1 JOIN<sub>CA1.COD_C1 = CO1.REF_C1</sub> CO1) JOIN<sub>CO1.REF_E1 = CO2.REF_E2</sub> (CA2 JOIN<sub>CA2.COD_C2 = CO2.REF_C2</sub> CO2))))
