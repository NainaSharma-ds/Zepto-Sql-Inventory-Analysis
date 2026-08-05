-- ==========================================
-- CREATING TABLE*--------
-- ==========================================

CREATE DATABASE zepto_sql_project;
use zepto_sql_project;
create table zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);
-- ==========================================
-- ---------*CLEANING THE DATASET*-----------
-- ==========================================
-- --*Total Records*----
SELECT COUNT(*) AS total_records
FROM zepto;
-- ==========================================
-- --*CHECKING FOR NULL VALUES*----------
-- ==========================================
SELECT *
FROM zepto
WHERE
    sku_id IS NULL
    OR category IS NULL
    OR name IS NULL
    OR mrp IS NULL
    OR discountPercent IS NULL
    OR availableQuantity IS NULL
    OR discountedSellingPrice IS NULL
    OR weightInGms IS NULL
    OR outOfStock IS NULL
    OR quantity IS NULL;
-- ==========================================
-- -----*Check Duplicate SKU IDs*-----
-- ==========================================
SELECT
sku_id,
COUNT(*)
FROM zepto
GROUP BY sku_id
HAVING COUNT(*) > 1;
-- ==========================================
-- --------*Check Invalid Prices*--------
-- ==========================================
SELECT *
FROM zepto
WHERE mrp <= 0
OR discountedSellingPrice <= 0;
-- ----------ONE product with MRP = 0 where sku_id is 3718---------
DELETE FROM zepto
WHERE sku_id = 3718;
-- ---------------------------------------------
-- ------*Check Selling Price > MRP*---------------
SELECT *
FROM zepto
WHERE discountedSellingPrice > mrp;
-- --------------------------------------------
-- ------*convert Paise into Rupees*-----------
SELECT
sku_id,
name,
mrp,
discountedSellingPrice
FROM zepto
LIMIT 5;
-- -------------------------
SET SQL_SAFE_UPDATES = 0;
UPDATE zepto
SET
    mrp = mrp / 100,
    discountedSellingPrice = discountedSellingPrice / 100;
SET SQL_SAFE_UPDATES = 1;
-- --checking if they converted?------
SELECT
sku_id,
name,
mrp,
discountedSellingPrice
FROM zepto
LIMIT 5;

-- ==========================================
-- ------ *Check Negative Values*-----------------
-- ==========================================
SELECT *
FROM zepto
WHERE
availableQuantity < 0
OR quantity < 0
OR weightInGms < 0;

-- ------------------------------------------------------

-- ---------*Exploratory Data Analysis (EDA)*--------
-- -------*TOTAL PRODUCT*--------------
SELECT COUNT(*) FROM zepto;

-- ------*Number of Categories*-------
SELECT COUNT(DISTINCT category) FROM zepto;

-- ---------*Products in Each Category*---------
SELECT category, COUNT(*) AS total_products
FROM zepto
GROUP BY category
ORDER BY total_products DESC;

-- ------*Out-of-Stock Products*--------
SELECT COUNT(*)
FROM zepto
WHERE outOfStock = TRUE;
-- ------------------------------------------------------

-- ---------*ANSWERING SOME BUSINESS PROBLEMS*-------------

-- ----*Which products have the highest discounts?*-------
SELECT
name,
category,
discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- ----(Helps marketing identify the most aggressively discounted products._---


-- ----*Which categories generate the highest estimated revenue?*-----------
SELECT
category,
SUM(discountedSellingPrice * quantity) AS revenue
FROM zepto
GROUP BY category
ORDER BY revenue DESC;
-- ----(Helps marketing identify the most aggressively discounted products.)---

-- -----*Which products are expensive but have low discounts?*-----
SELECT
name,
mrp,
discountPercent
FROM zepto
WHERE mrp > 500
AND discountPercent < 10
ORDER BY mrp DESC;

-- (Potential opportunities for promotional campaigns.)--


-- ---* INVENTORY DISTRIBUTION*-------
SELECT
CASE
WHEN weightInGms < 500 THEN 'Small'
WHEN weightInGms < 2000 THEN 'Medium'
ELSE 'Bulk'
END AS weight_category,
COUNT(*) AS products
FROM zepto
GROUP BY weight_category;


-- --*Top 10 Most Expensive Products*------
SELECT
name,
mrp
FROM zepto
ORDER BY mrp DESC
LIMIT 10;
-- --------------------------------------------------
