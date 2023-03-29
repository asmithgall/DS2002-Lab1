#Load ratings data from MongoDB call into a separate table, will later be passed into the inventory table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/mongodat.csv'
INTO TABLE `ratings`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ratings;

#Load revenue data from API call into seaprate table, will later be passed into the inventory table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/apidat.csv'
INTO TABLE `revenue`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM revenue;

#Populate customer table directly from Sekia database
INSERT INTO `movies_dw`.`customer`
(`customer_id`,
`store_id`,
`first_name`,
`last_name`,
`email`,
`address_id`,
`active`,
`create_date`,
`last_update`)
SELECT `customer`.`customer_id`,
    `customer`.`store_id`,
    `customer`.`first_name`,
    `customer`.`last_name`,
    `customer`.`email`,
    `customer`.`address_id`,
    `customer`.`active`,
    `customer`.`create_date`,
    `customer`.`last_update`
FROM `sakila`.`customer`;

SELECT * FROM customer;

#Populate staff table directly from sekia database
INSERT INTO `movies_dw`.`staff`
(`staff_id`,
`first_name`,
`last_name`,
`address_id`,
`picture`,
`email`,
`store_id`,
`active`,
`username`,
`password`,
`last_update`)
SELECT `staff`.`staff_id`,
    `staff`.`first_name`,
    `staff`.`last_name`,
    `staff`.`address_id`,
    `staff`.`picture`,
	`staff`.`email`,
	`staff`.`store_id`,
    `staff`.`active`,
    `staff`.`username`,
	`staff`.`password`,
    `staff`.`last_update`
FROM `sakila`.`staff`;

SELECT * FROM staff;

#Populate the fact-payments table using a join between payments and rental data, because payments can exist without a corresponding rental due to overdraft charges
#we did a left outer join to incorporate rental information while leaving payment transactions that didn't have a matching rental id alone
INSERT INTO `movies_dw`.`fact_payments`
(`payment_id`,
`rental_id`,
`inventory_id`,
`customer_id`,
`staff_id`,
`amount`,
`payment_date`,
`rental_date`,
`return_date`,
`last_update`)
SELECT `payment`.`payment_id`,
    `payment`.`rental_id`,
    `rental`.`inventory_id`,
    `payment`.`customer_id`,
    `payment`.`staff_id`,
	`payment`.`amount`,
	`payment`.`payment_date`,
	`rental`.`rental_date`,
	`rental`.`return_date`,
    `payment`.`last_update`
FROM `sakila`.`payment`
LEFT OUTER JOIN `sakila`.`rental`
ON `payment`.`rental_id` = `rental`.`rental_id`;

SELECT * FROM fact_payments;

#Populate the inventory table, this requires bringing in film data with a left outer join, and then incorporating the ratings and revenue tables. Because the ratings and revenue
#data corresponds to real movies and the database only has fake movies, we fabricated matching film ids for the real data in order to join it into the table
INSERT INTO `movies_dw`.`inventory`
(`inventory_id`,
`film_id`,
`title`,
`release_year`,
`rental_rate`,
`store_id`,
`award_wins`,
`rating`,
`revenue`,
`last_update`)
SELECT `inventory`.`inventory_id`,
    `inventory`.`film_id`,
    `film`.`title`,
    `film`.`release_year`,
    `film`.`rental_rate`,
	`inventory`.`store_id`,
    `ratings`.`award_wins`,
    `ratings`.`rating`,
    `revenue`.`revenue`,
    `inventory`.`last_update`
FROM `sakila`.`inventory`
LEFT OUTER JOIN `sakila`.`film`
ON `film`.`film_id` = `inventory`.`film_id`
LEFT OUTER JOIN `movies_dw`.`ratings`
ON `film`.`film_id` = `ratings`.`film_id`
LEFT OUTER JOIN `movies_dw`.`revenue`
ON `film`.`film_id` = `revenue`.`film_id`;

select * from inventory;

