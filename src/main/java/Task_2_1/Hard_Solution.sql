--1 вывести общим списком Всех Заказчиков и поставщиков. Колонки id, имя и тип,
--где тип "Заказчик" или "Поставщик" в зависимости от того, из какой таблицы взята запись
--Отфильтровать и вывести те Записи, по которым в заявках в общей сложности  заказ  больше 5000

SELECT 	c.id AS "id",
          c.name AS "Имя",
          'Заказчик' AS "Тип"
FROM customer c LEFT JOIN  request r ON	c.id  = r.customer
                LEFT JOIN  request_item ri ON r.id  = ri.request_id
                LEFT JOIN  product p 		ON	p.id  = ri.product_id
GROUP BY c.id, c.name, r.id
HAVING sum(p.COST * ri.volume) > 5000.0
UNION ALL
SELECT 	s.id AS "id",
          s.name AS "Имя",
          'Поставщик' AS "Тип"
FROM supplier s LEFT JOIN  request r ON	s.id  = r.supplier
                LEFT JOIN  request_item ri ON r.id  = ri.request_id
                LEFT JOIN  product p ON	p.id  = ri.product_id
GROUP BY s.id, s.name, r.id
HAVING sum(p.COST * ri.volume) > 5000.0;

--result
--6,Anton,Заказчик
--1,Sber,Поставщик

--#################################################################################################

--2 Вывести процентную долю заказов каждого товара по всем заявкам, сгруппировать по городу

WITH tab AS (
    SELECT 	r.id AS request_id,
              c.name AS customer_name,
              c.city AS city,
              p.name AS product_name,
              CAST (count(p.name) OVER (PARTITION BY p.name ) AS DOUBLE PRECISION) 	AS total_product,
              (SELECT count(r.id) FROM request r) AS total_requests,
              ((CAST (count(r.id) OVER (PARTITION BY p.name ) AS DOUBLE PRECISION)/(SELECT count(r.id) FROM request r) )*100.0)::numeric(5,2) AS percentage
    FROM product p LEFT JOIN request_item ri ON p.id = ri.product_id
                   LEFT JOIN request r ON	ri.request_id = r.id
                   LEFT JOIN customer c ON	c.id  = r.customer
    GROUP BY r.id, c.name, c.city, p.name
)
SELECT 	city AS "Город",
          product_name AS "Продукт",
          percentage AS "Процентная доля заказа"
FROM tab
GROUP BY city, product_name,percentage
ORDER BY 1;

--result
--Grozniy,salt,6.67
--Kazan,rice,13.33
--Leningrad,honey,13.33
--Moscow,meat,13.33
--Moscow,bread,13.33
--Sochi,rice,13.33
--Sochi,chicken,13.33
--Sochi,paste,13.33
--Velikiy Novgorod,secret,6.67
--Volgograd,chicken,13.33
--Volgograd,honey,13.33
--Volgograd,meat,13.33
--Volgograd,melon,6.67
--Volgograd,paste,13.33
--,butter,0.00
--,tomatoes,0.00

--#################################################################################################
--3 Вывести  процентную долю заказов Каждого товара по заявке в среднем
WITH tab AS (SELECT p.id AS product_id,
                    p.name AS product_name,
                    ri.id AS request_item_id,
                    r.id AS requset_id,
                    count(ri.id) OVER (PARTITION BY r.id) AS ri_in_req_count,
                    count(ri.id) OVER (PARTITION BY r.id, p.name) prod_ri_in_req_count,
                    CASE
                        WHEN count(ri.id) OVER (PARTITION BY r.id) = 0
                            THEN 0
                        ELSE (count(ri.id) OVER (PARTITION BY r.id, p.name)*100.0 / count(ri.id) OVER (PARTITION BY r.id))::NUMERIC (5,2)
                    END AS percent
    FROM product p LEFT JOIN request_item ri ON p.id = ri.product_id
                    LEFT JOIN request r ON r.id = ri.request_id
),
     percent_prod AS (
         SELECT requset_id,
                product_name,
                percent
         FROM tab
         GROUP BY requset_id, product_name, percent
     )
SELECT 	product_name AS "Продукт",
        AVG(percent) AS "Процентная доля"
FROM percent_prod
GROUP BY product_name;

--result
--tomatoes,0
--honey,100
--chicken,100
--melon,100
--rice,100
--paste,100
--butter,0
--salt,100