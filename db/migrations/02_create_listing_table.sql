CREATE TABLE listings (id SERIAL PRIMARY KEY,
                                         name VARCHAR(30),
                                              description VARCHAR(240),
                                                          price MONEY,
                                                          owner_id INTEGER REFERENCES users(id));