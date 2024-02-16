select *,cast(st_asewkb(t."WKT") as varchar(255)) as wkb -- p."WKT" wybrana kolumna współrzędnych
from TabelaWKT t
