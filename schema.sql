-- DROP TABLE IF EXISTS quotes;
--
-- CREATE TABLE quotes (
--   id serial,
--   thinker varchar(30),
--   thought varchar(10000),
--   PRIMARY KEY (q_id)
-- );

-- ALTER TABLE quotes
--   ADD COLUMN lookedAt BOOLEAN DEFAULT FALSE;

-- UPDATE quotes
-- SET lookedAt = 'true'
-- WHERE id = 1;


SELECT id, thinker, lookedAt
FROM quotes;


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
