-- clausola group by

-- Estrarre la somma degli stipendi tutti gli impiegati dello stesso dipartimento

select Dipart, sum(Stipendio)
from Impiegato
group by Dipart

-- Predicato clausola having

-- Estrarre i dipartimenti che spendono piu di 100 in stipendi

select Dipart, sum(Stipendio) as SommaStipendi 
from Impiegato 
group by Dipart
having sum(Stipendio) > 100