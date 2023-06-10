SELECT *
FROM tabella1, tabella2, tabella3, tabella4
WHERE tabella1.ref_t2 = tabella2.cod_t2 AND tabella2.ref_t3 = tabella3.cod_t3 . . .

-- Usa FROM e WHERE per fare un equijoin tra tabelle