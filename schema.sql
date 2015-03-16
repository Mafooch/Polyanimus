DROP TABLE IF EXISTS quotes;

CREATE TABLE quotes (
  id serial PRIMARY KEY,
  title varchar(100),
  thinker varchar(30),
  thought varchar(10000),
  lookedAt BOOLEAN DEFAULT FALSE
);





-- UPDATE quotes
-- SET lookedAt = 'true'
-- WHERE id = (SELECT id
--             FROM quotes
--             WHERE lookedAt = 'false'
--             ORDER BY random()
--             LIMIT 1
--           )
-- RETURNING *;
-- UPDATE quotes
-- SET lookedAt = 'false';
