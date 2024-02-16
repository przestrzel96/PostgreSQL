-- Generowanie losowego 6-cyfrowego unikalnego numeru 

-- Tworzenie zbioru liczb
with numbers as (
    -- Wygenerowanie losowych liczb 6-cyfrowych
    select lpad(cast(trunc(random() * 900000 + 100000) as TEXT), 6, '0') as number
    from generate_series(1, 100) -- Generujemy 100 prób
    where left(lpad(cast(trunc(random() * 900000 + 100000) as TEXT), 6, '0'), 1) in ('8', '7', '9')
    -- Filtrujemy wyniki, aby początek numeru był 8, 7 lub 9
    and left(lpad(cast(trunc(random() * 900000 + 100000) as TEXT), 6, '0'), 1) <> '1'
    -- Wykluczamy wyniki, które zaczynają się od 1
    order by random() -- Losowo sortujemy wyniki, aby wybrać jeden unikalny numer
)
-- Wybór unikalnego numeru, który jeszcze nie występuje w kolumnie 'ol' tabeli 'tabela'
select number
from numbers
where not exists (select 1 from tabela where ol = number) -- Warunek, aby nie zwracał numerów z kolumny 'ol'
and left(number, 1) in ('8', '7', '9') -- Dodatkowy warunek, aby początek numeru był 8, 7 lub 9
limit 1;
