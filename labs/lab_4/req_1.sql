!УСЛОВИЯ ЗАДАНИЙ НЕ ИЗМЕНЕНЫ! кроме % = 3

--- 1 ------------------------------------------------------
-- Вывести адреса объектов недвижимости, у которых стоимость
-- 1 м2 меньше средней стоимости по району
------------------------------------------------------------


--- 2 -------------------------------------------
-- Вывести название районов, в которых количество
-- проданных квартир больше 5
-------------------------------------------------

--- 3 --------------------------------------
-- Добавить таблицу зп риэлтора.
-- Сделать так, чтобы функция из задания 2 сохраняла
-- зп в этой таблице
--------------------------------------------
DROP TABLE IF EXISTS salary;
CREATE TABLE realtors_salary
(
	realtor_id bigint references realtors(id),
	month smallint,
	year smallint,
	salary double precision
)

--- 4 -----------------------------------
-- Вывести ФИО риэлторов, которые продали
-- меньше 5 объектов недвижимости
-----------------------------------------


--- 5 --------------------------------------
-- Определить годы, в которых было размещено
-- от 2 до 3 объектов недвижимости
--------------------------------------------


--- 6 -------------------------------------
-- Определить адреса квартир, стоимость 1м2
-- которых меньше средней по району
-------------------------------------------

--- 7 ------------------------------
-- Определить ФИО риэлторов, которые
-- ничего не продали в текущем году
------------------------------------

--- 8 -------------------------------------------
-- Создать функуцию, которая формирует список 
-- объектов недвижимости, стоимость м2 у которых
-- находится в заданном диапазоне, и они 
-- принадлежат конкретному типу
-------------------------------------------------
CREATE OR REPLACE FUNCTION lab_4_ex8
(
	low_cost double precision,
	high_cost double precision,
	obj_type character varying(32)
)
RETURNS TABLE
(
	adress character varying(64),
	district character varying(32),
	rooms_num bigint
)
AS $$
SELECT address, name, rooms 
FROM 
(
	(
		SELECT address, district_id, square, rooms, cost, type_id
		FROM objects
	) AS "a"
	JOIN 
	(	
		SELECT * 
		FROM districts
	) AS "b" 
	ON 
	"a".district_id = "b".id) 
WHERE 
cost/square 
BETWEEN "low_cost" AND "high_cost"
AND
type_id =
(
	SELECT id 
	FROM types 
	WHERE
	name = "obj_type"
) 
$$
LANGUAGE SQL;

select * from lab_4_ex8(100000, 500000, 'Квартира')

--- 9 --------------------------------------------------
-- Вывести для указанного риэлтора (ФИО) года, в которых
-- он продал больше 2 объектов недвижимости
--------------------------------------------------------

--- 10 -------------------------------------------------------------
-- Вывести ФИО риэлторов, которые заработали премию в текущем месяце
-- больше 40000 рублей. Премия рассчитываются по формуле:
-- общая стоимость всех проданных квартир * 15%
--------------------------------------------------------------------

--- 11 --------------------------------------------
-- Вывести количество однокомнатных и двухкомнатных
-- квартир в указанном районе
---------------------------------------------------

--- 12 ------------------------------------------------
-- Определить индекс средней оценки по каждому критерию
-- для указанного объекта недвижимости
-------------------------------------------------------

--- 13 -----------------------------------------------------------------------
-- Создайте функцию, которая формирует статистику по продажам за указанный год
-- вывод: тип, количество продаж, процент от общего количества проданных объектов
-- недвижимости, общая сумма продаж
---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION lab_4_ex13
(
	year smallint
)
RETURNS TABLE
(
	obj_type character varying(32),
	quantity smallint,
	part double precision,
	total_amount double precision
)
AS $$
(SELECT name, COUNT(*) AS "quantity", (COUNT(*)/
(
	SELECT count(*) 
	FROM sales 
	WHERE EXTRACT (YEAR FROM date) = "year"
)::double precision)*100, SUM(cost)
FROM 
(((
	SELECT object_id, date, cost 
	FROM sales
	WHERE EXTRACT (YEAR FROM date) = "year"
) AS "a"
JOIN
(
	SELECT id, type_id
	FROM objects
) AS "b"
ON "a".object_id = "b".id) AS "1"
JOIN 
(SELECT * FROM types) AS "2"
ON "1".type_id = "2".id)
GROUP BY name)
$$
LANGUAGE SQL;

SELECT * FROM lab_4_ex13(2022)
--- 14 --------------------------------------------------
-- Вывести информацию о комнатах для объекта недвижимости
---------------------------------------------------------

--- 15 -----------------------------------------------------------------------------
-- Вывести количество объектов недвижимости по каждому району, общая площадь которых
-- больше 40 м2. Использовать таблицу «Структура объекта недвижимости»
------------------------------------------------------------------------------------

