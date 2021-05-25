CREATE TABLE bookings (id SERIAL PRIMARY KEY,
                                         start_date date, listing_id int references listings(id),
                                                                                    user_id int references users(id));