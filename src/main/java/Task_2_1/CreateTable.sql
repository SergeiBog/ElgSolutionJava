CREATE TABLE IF NOT EXISTS Customer(
                                       id  BIGINT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY ,
                                       name varchar(100) NOT NULL ,
                                       city varchar(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Product(
                                      id BIGINT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY ,
                                      name VARCHAR(100) NOT NULL ,
                                      cost DOUBLE PRECISION NOT NULL
);


CREATE TABLE IF NOT EXISTS Request_Item(
                                           id BIGINT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY ,
                                           product_id BIGINT NOT NULL ,
                                           volume DOUBLE PRECISION NOT NULL,
                                           request_id BIGINT NOT NULL,
                                           CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES Product(id) ON DELETE CASCADE ,
                                           CONSTRAINT fk_request FOREIGN KEY (request_id) REFERENCES Request(id) ON DELETE CASCADE
);



CREATE TABLE IF NOT EXISTS Request(
                                      id BIGINT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY ,
                                      customer BIGINT NOT NULL ,
                                      supplier BIGINT NOT NULL,
                                      CONSTRAINT fk_customer FOREIGN KEY (customer) REFERENCES Customer(id) ON DELETE CASCADE ,
                                      CONSTRAINT fk_supplier FOREIGN KEY (supplier) REFERENCES Supplier(id) ON DELETE CASCADE
);



CREATE TABLE IF NOT EXISTS Supplier(
                                       id BIGINT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY ,
                                       name VARCHAR(100) NOT NULL
);
INSERT INTO Customer (name, city) VALUES('Ivan', 'Moscow'),
                                        ('Petr','Leningrad'),
                                        ('Masha', 'Volgograd'),
                                        ('Anderey','Sochi'),
                                        ('Varya','Moscow'),
                                        ('Anton','Velikiy Novgorod'),
                                        ('Magomed','Grozniy'),
                                        ('Rasul','Kazan'),
                                        ('Sergey','Vitebsk'),
                                        ('Elena', 'Vladivostok');

INSERT INTO Supplier(name) VALUES ('Sber'),
                                  ('Delievery'),
                                  ('Yandex'),
                                  ('Samokat');

INSERT INTO Product (name, cost) VALUES ('honey',323.56),
                                        ('bread', 45.22),
                                        ('rice',180.12),
                                        ('meat',456.12),
                                        ('paste',56.98),
                                        ('melon',274.54),
                                        ('tomatoes',56.2),
                                        ('chicken',432.21),
                                        ('butter',543),
                                        ('salt',3.21),
                                        ('secret',999.99);

INSERT INTO Request_Item(product_id, volume, request_id) VALUES
                                                             (2,4.0,1),
                                                             (1,4.0,2),
                                                             (4,10.0,3),
                                                             (5,7.0,4),
                                                             (2,10.0,5),
                                                             (3,10.0,6),
                                                             (5,10.0,7),
                                                             (8,3.0,8),
                                                             (11,10,9),
                                                             (10,15.0,10),
                                                             (3,10.0,11),
                                                             (4,10.0,12),
                                                             (8,5.0,13),
                                                             (6,12.0,14),
                                                             (1,2.0,15);
INSERT INTO Request(customer, supplier) VALUES (1,2),
                                               (2,3),
                                               (3,1),
                                               (4,2),
                                               (5,3),
                                               (8,2),
                                               (3,2),
                                               (4,4),
                                               (6,1),
                                               (7,1),
                                               (4,2),
                                               (1,3),
                                               (3,4),
                                               (3,3),
                                               (3,2);