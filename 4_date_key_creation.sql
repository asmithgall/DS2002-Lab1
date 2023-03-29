#Add key columns
ALTER TABLE movies_dw.fact_payments
ADD COLUMN payment_date_key int NOT NULL AFTER payment_date,
ADD COLUMN rental_date_key int NOT NULL AFTER rental_date,
ADD COLUMN return_date_key int NOT NULL AFTER return_date;

#Update the key columns to have date key
UPDATE movies_dw.fact_payments AS fp
JOIN movies_dw.dim_date AS dd
ON DATE(fp.payment_date) = dd.full_date
SET fp.payment_date_key = dd.date_key;

UPDATE movies_dw.fact_payments AS fp
JOIN movies_dw.dim_date AS dd
ON DATE(fp.rental_date) = dd.full_date
SET fp.rental_date_key = dd.date_key;

UPDATE movies_dw.fact_payments AS fp
JOIN movies_dw.dim_date AS dd
ON DATE(fp.return_date) = dd.full_date
SET fp.return_date_key = dd.date_key;

#Test
SELECT * FROM fact_payments;

#Drop the legacy date columns
ALTER TABLE movies_dw.fact_payments
DROP COLUMN payment_date,
DROP COLUMN rental_date,
DROP COLUMN return_date;

#Final validation
SELECT * FROM fact_payments;