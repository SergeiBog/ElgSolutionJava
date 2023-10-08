-- 1 Вывести id всех заявок, в которых суммарная стоимость заказа превышает 1000

SELECT r.id AS id
FROM customer c INNER JOIN request r on c.id = r.customer
                INNER JOIN supplier s on s.id = r.supplier
                INNER JOIN request_item ri on r.id = ri.request_id
                INNER JOIN product p on p.id = ri.product_id
WHERE p.cost * ri.volume > 1000;

--Result
--
-----id
-------
-----2|
-----3|
-----6|
-----8|
-----9|
----11|
----12|
----13|
----14|
--#########################################################################

--2 Нужно определить, какой товар каждый заказчиков заказывал по всем своим заявкам чаще всего
--Вывести таблицу  id заказчика, имя заказчика, название товаров, количество раз

WITH tab AS (
    SELECT 	c.id AS id,
              c.name AS customer,
              c.city,
              p.name AS product,
              count(p.name) AS product_requests,
              DENSE_RANK() OVER (
                  PARTITION BY c.name
                  ORDER BY count(p.name) DESC
                  ) as RES
    FROM customer c
             LEFT  JOIN request r ON c.id = r.customer
             LEFT JOIN supplier s ON s.id = r.supplier
             LEFT JOIN request_item ri ON r.id = ri.request_id
             LEFT JOIN product p ON ri.product_id = p.id
    GROUP BY c.id, c.name, c.city, p.name
)
SELECT 	id AS "ID заказчика",
          customer AS "Имя заказчика",
          CASE
              WHEN product IS NOT NULL
                  THEN product
              ELSE 'Нет заказа'
              END AS "Название товаров",
          product_requests AS "Количество раз"
FROM tab
WHERE RES = 1
ORDER BY 1;

--Result
--1,Ivan,bread,1
--1,Ivan,meat,1
--2,Petr,honey,1
--3,Masha,melon,1
--3,Masha,chicken,1
--3,Masha,paste,1
--3,Masha,honey,1
--3,Masha,meat,1
--4,Anderey,rice,1
--4,Anderey,paste,1
--4,Anderey,chicken,1
--5,Varya,bread,1
--6,Anton,secret,1
--7,Magomed,salt,1
--8,Rasul,rice,1
--9,Sergey,Нет заказа,0
--10,Elena,Нет заказа,0

--#########################################################################
--3 Вывести имя заказчика, который принес больше всего прибыли по каждому из поставщиков
--Результирующая по запросу таблица: ID и имя поставщика в формате "[ID:1] Иванов",
--ID и имя заказчика в таком же формате

WITH tab AS (
    SELECT
        s.id AS supplier_id,
        s.name AS supplier_name,
        c.id AS customer_id,
        c.name AS customer_name,
        sum(p.COST * ri.volume) AS total,
        DENSE_RANK() OVER (
            PARTITION BY s.id
            ORDER BY sum(p.COST * ri.volume) DESC)  AS RES
    FROM supplier s
             LEFT JOIN request r ON s.id = r.supplier
             LEFT JOIN customer c ON c.id = r.customer
             LEFT JOIN request_item ri ON r.id = ri.request_id
             LEFT JOIN product p ON ri.product_id = p.id
    GROUP BY s.id, s.name, c.id, c.name
)
SELECT 	supplier_id AS "ID поставщика",
          supplier_name AS "Поставщик",
          customer_id AS "ID заказчика",
          CASE
              WHEN customer_name IS NULL
                  THEN 'нет заказа'
              ELSE customer_name
              END AS "Заказчик, принесший макс прибыль"
FROM tab
WHERE RES = 1;

--Result
--1,Sber,6,Anton
--2,Delievery,4,Anderey
--3,Yandex,1,Ivan
--4,Samokat,3,Masha


