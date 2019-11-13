/* Properties values prediction */
/* 08/07/2019 */
/* by Group Meeting */

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS property_value;
CREATE SCHEMA property_value;
USE property_value;

#1. Zip-Population table
CREATE TABLE zipcode (
  zip_id INT(6) NOT NULL,
  zip_code INT(5) NOT NULL,
  population INT(8),
  aggpop INT(10),
  PRIMARY KEY (`zip_code`))
ENGINE=InnoDB DEFAULT CHARSET=latin1;

#2. Zillow estimate property values table
CREATE TABLE properties (
  address_id INT(6) NOT NULL,
  address_num INT(5) NOT NULL,
  address VARCHAR(50),
  property_value DECIMAL(10,2) NOT NULL,
  zip_code INT(5) NOT NULL,
  lat DECIMAL(8,6) NOT NULL,
  lon DECIMAL(8,6) NOT NULL,
  PRIMARY KEY (`address_id`),
  Key idx_fk_properties (zip_code),
  CONSTRAINT `dim_properties_fk`
	FOREIGN KEY (zip_code)
    REFERENCES fact_values (zip_code)
    ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

#3. Active business licenses table
CREATE TABLE businesses (
  business_id INT(5) NOT NULL,
  license_id INT(10) NOT NULL,
  zip_code INT(5) NOT NULL,
  lat DECIMAL(8,6) NOT NULL,
  lon DECIMAL(8,6) NOT NULL,
  license_type INT(4) NOT NULL,
  PRIMARY KEY (`business_id`),
  Key idx_fk_businesses (zip_code),
  CONSTRAINT `dim_businesses_fk`
	FOREIGN KEY (zip_code)
    REFERENCES `fact_values` (`zip_code`)
    ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

#4. Grocery stores table
CREATE TABLE groceries (
  grocery_id SMALLINT NOT NULL,
  store_name VARCHAR(50) DEFAULT NULL,
  license_id INT(10) DEFAULT NULL,
  zip_code INT(5) NOT NULL,
  store_sqft INT(12) DEFAULT NULL,
  lat DECIMAL(8,6) NOT NULL,
  lon DECIMAL(8,6) NOT NULL,
  PRIMARY KEY (`grocery_id`),
	KEY idx_fk_groceries (zip_code),
  CONSTRAINT `dim_groceries_fk`
	FOREIGN KEY (`zip_code`)
    REFERENCES `fact_values` (`zip_code`)
    ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

#5. Crimes table
CREATE TABLE crimes (
  crime_id INT(6) NOT NULL,
  lat DECIMAL(8,6) NOT NULL,
  lon DECIMAL(8,6) NOT NULL,
  crime_type VARCHAR(40) DEFAULT NULL,
  zip_code INT(5) NOT NULL,
  PRIMARY KEY (`crime_id`),
-- 	Key idx_fk_crimes (zip_code),
  CONSTRAINT `dim_crimes_fk`
	FOREIGN KEY (`zip_code`)
    REFERENCES `fact_values` (`zip_code`)
    ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

#6. Public schools table
CREATE TABLE schools (         
  school_id SMALLINT(10) NOT NULL,
  school_name VARCHAR(75) DEFAULT NULL,
  school_level CHAR(2) NOT NULL,
  lat DECIMAL(8,6) NOT NULL,
  lon DECIMAL(8,6) NOT NULL,
  zip_code INT(5) NOT NULL,
  rating VARCHAR(20) NOT NULL,
  PRIMARY KEY (`school_id`),
	Key idx_fk_schools (zip_code),
  CONSTRAINT `dim_schools_fk`
	FOREIGN KEY (`zip_code`)
    REFERENCES `fact_values` (`zip_code`)
    ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


#7. Fact table - scores by zip code
CREATE TABLE fact_values (
  zip_code INT(5) NOT NULL,
  predicted_aug_value DECIMAL(12,2) NOT NULL,
  actual_aug_value DECIMAL(12,2) NOT NULL,
  difference DECIMAL(12,2) NOT NULL,
  count_groceries DECIMAL(6,5),
  crime_score DECIMAL(7,5),
  business_score DECIMAL(7,5),
  school_score DECIMAL(6,5),
  PRIMARY KEY  (zip_code),
  Key idx_fk_zip_code (zip_code),
  CONSTRAINT `dim_zip_code_fk`
	FOREIGN KEY (zip_code)
    REFERENCES zipcode (zip_code)
    ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

