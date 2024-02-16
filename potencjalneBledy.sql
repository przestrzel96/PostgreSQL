-- Tworzenie zbioru danych z tabeli1 i tabeli2, zawierających unikalne wartości dla poszczególnych kombinacji posesja, address, locality i id
with dane as (
    select 
        distinct posesja, address, locality, id
    from tabela1 rs
    left join tabela2 r on r.id = rs.id 
    group by posesja, address, locality, id
),
-- Przetwarzanie danych, dodanie kolumny typ_potencjalnego_bledu opisującej potencjalne błędy w numerze posesji
dane_pos as (
    select 
        posesja, address_cross_id, locality_name, nokia_address_id, rfo, room_status,
        case
            -- Określenie typu potencjalnego błędu na podstawie warunków
            when posesja is null or posesja='' then 'brak numeru'
            when posesja like '0%' then '0 w numerze'
            when lower(posesja) like '%dz.%' then 'numer działki w numerze'
            when lower(posesja) like '%dup%' then 'DUP w numerze' 
            when length(posesja) > 10 then 'za dlugi numer'
            when posesja like '%.%' then 'kropka w numerze'
            when substring(posesja from '\d+')::int>10000 then 'za duży numer porządkowy > 10000' 
            when posesja like '%\_%' then 'podkreślnik_w_numerze'
            else null
        end as typ_potencjalnego_bledu
    from dane
)
-- Wybór danych, gdzie typ_potencjalnego_bledu nie jest nullem
select * from dane_pos
where typ_potencjalnego_bledu is not null;
