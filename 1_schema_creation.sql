#Data Warehouse Design
#We wanted to look at what factors impact rental sales at a movie rental company. To do so, we used the Sekia database as our foundation.
#We chose payments as our fact table which covers whenever someone rented a movie. In order to link this table to what specific movies were rented, we also
#joined with the rentals table to add inventory id. Other related dimension tables included the customers that purchased and the staff of the business. Finally,
#the most important dimension table was inventory which included the movies rented as well as a join with the film table to include more specific information about the movies.
#We also added information on movie ratings and amount of awards won from the sample_mflix collection on mongodb as well as revenue data from the TMDB API.
#Because this database contained fake movies that did not correspond with our real world data, we randomly assigned the ratings and revenue data to movie ids which was then
#joined into the inventory table.

#Our sql scripts include the original schema, the populating script, the date dimension creation and population scripts, and the query script.
#You will also find the scripts we used to call and clean our csvs, as well as the cleaned csvs and the data sources.

DROP DATABASE IF EXISTS `movies_dw`;
CREATE DATABASE `movies_dw` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE movies_dw;

#This is the first dimension table on customers, coming straight out of the Sekia database
CREATE TABLE `customer` (
  `customer_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `store_id` tinyint unsigned NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `address_id` smallint unsigned NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `create_date` datetime NOT NULL,
  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  KEY `store_id` (`store_id`),
  KEY `address_id` (`address_id`),
  KEY `last_name` (`last_name`)
) ENGINE=InnoDB AUTO_INCREMENT=600 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

#This is the second dimension table on staff, this comes straight from the Sekia database as well
CREATE TABLE `staff` (
  `staff_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `address_id` smallint unsigned NOT NULL,
  `picture` blob,
  `email` varchar(50) DEFAULT NULL,
  `store_id` tinyint unsigned NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `username` varchar(16) NOT NULL,
  `password` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`staff_id`),
  KEY `store_id` (`store_id`),
  KEY `address_id` (`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

#This will be the inventory table, combining information from inventory and film tables from Sekia as well as adding more data for each movie from an API call (revenue)
#And a mongodb call (ratings)
CREATE TABLE `inventory` (
  `inventory_id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `film_id` smallint unsigned NOT NULL,
  `title` varchar(128) NOT NULL,
  `release_year` year DEFAULT NULL,
  `rental_rate` decimal(4,2) NOT NULL DEFAULT '4.99',
  `store_id` tinyint unsigned NOT NULL,
  `award_wins` int,
  `rating` float,
  `revenue` bigint,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inventory_id`),
  KEY `film_id` (`film_id`),
  KEY `store_id_film_id` (`store_id`,`film_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4582 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


#This is our fact table because it models the business transactions of the movie rental business. This table will incorporate info from the payments table as well as the rental
#table which is neccesary becuase the rental table will link the transactions to the inventory and the specific movies that we want to look at
CREATE TABLE `fact_payments` (
  `payment_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `rental_id` int DEFAULT NULL,
  `inventory_id` mediumint unsigned NOT NULL,
  `customer_id` smallint unsigned NOT NULL,
  `staff_id` tinyint unsigned NOT NULL,
  `amount` decimal(5,2) NOT NULL,
  `payment_date` datetime NOT NULL,
  `rental_date` datetime NOT NULL,
  `return_date` datetime NULL,
  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `staff_id` (`staff_id`),
  KEY `customer_id` (`customer_id`),
  KEY `inventory_id` (`inventory_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16050 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

TRUNCATE TABLE `movies_dw`.`fact_payments`;

#Create tables which will be used to load in the API and MongoDb data. These could have been loaded into the Sekia database instead because they are not apart of the schema
#In a real database these tables could be dropped after the data is transferred to the inventory table

CREATE TABLE `ratings` (
	`id` INT,
    `title` VARCHAR(255),
    `award_wins` INT,
    `rating` FLOAT,
    `film_id` INT
);

CREATE TABLE `revenue` (
	`id` INT,
    `title` VARCHAR(255),
    `revenue` BIGINT,
    `film_id` INT
);












