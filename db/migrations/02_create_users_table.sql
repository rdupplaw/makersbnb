CREATE TABLE users ( id SERIAL PRIMARY KEY,
                                       email VARCHAR(30) UNIQUE,
                                                         password VARCHAR(30));