-- =====================================================================
-- STEP 1 · Create the tables
-- Topics: CREATE TABLE, data types, NOT NULL, DEFAULT, CHECK, PRIMARY KEY,
--         FOREIGN KEY, CREATE INDEX, DESCRIBE, SHOW TABLES
--
-- Two layers:
--   stg_*  staging tables: every column is text, so no row can fail on load
--   final  typed tables with keys and constraints, filled in step 4
-- =====================================================================
USE olist_audit;

-- ---------------------------------------------------------------------
-- 1.1 Staging tables (all VARCHAR, no constraints)
-- ---------------------------------------------------------------------
CREATE TABLE stg_customers (
    customer_id VARCHAR(64), customer_unique_id VARCHAR(64), customer_zip_code_prefix VARCHAR(20),
    customer_city VARCHAR(100), customer_state VARCHAR(20)
);
CREATE TABLE stg_sellers (
    seller_id VARCHAR(64), seller_zip_code_prefix VARCHAR(20), seller_city VARCHAR(100), seller_state VARCHAR(20)
);
CREATE TABLE stg_products (
    product_id VARCHAR(64), product_category_name VARCHAR(100), product_name_lenght VARCHAR(20),
    product_description_lenght VARCHAR(20), product_photos_qty VARCHAR(20), product_weight_g VARCHAR(20),
    product_length_cm VARCHAR(20), product_height_cm VARCHAR(20), product_width_cm VARCHAR(20)
);
CREATE TABLE stg_category_translation (
    product_category_name VARCHAR(100), product_category_name_english VARCHAR(100)
);
CREATE TABLE stg_orders (
    order_id VARCHAR(64), customer_id VARCHAR(64), order_status VARCHAR(30),
    order_purchase_timestamp VARCHAR(30), order_approved_at VARCHAR(30),
    order_delivered_carrier_date VARCHAR(30), order_delivered_customer_date VARCHAR(30),
    order_estimated_delivery_date VARCHAR(30)
);
CREATE TABLE stg_order_items (
    order_id VARCHAR(64), order_item_id VARCHAR(10), product_id VARCHAR(64), seller_id VARCHAR(64),
    shipping_limit_date VARCHAR(30), price VARCHAR(20), freight_value VARCHAR(20)
);
CREATE TABLE stg_order_payments (
    order_id VARCHAR(64), payment_sequential VARCHAR(10), payment_type VARCHAR(30),
    payment_installments VARCHAR(10), payment_value VARCHAR(20)
);

-- ---------------------------------------------------------------------
-- 1.2 Final tables: master data (parents first)
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    customer_id         CHAR(32)     NOT NULL,       -- one id per order
    customer_unique_id  CHAR(32)     NOT NULL,       -- the real person (repeat buyers)
    zip_code_prefix     CHAR(5)      NOT NULL,       -- text: leading zeros restored in step 4
    city                VARCHAR(50)  NOT NULL,
    state               CHAR(2)      NOT NULL,
    PRIMARY KEY (customer_id)
);

CREATE TABLE sellers (
    seller_id        CHAR(32)     NOT NULL,
    zip_code_prefix  CHAR(5)      NOT NULL,
    city             VARCHAR(50)  NOT NULL,
    state            CHAR(2)      NOT NULL,
    PRIMARY KEY (seller_id)
);

CREATE TABLE category_translation (
    category_name     VARCHAR(60)  NOT NULL,         -- Portuguese
    category_name_en  VARCHAR(60)  NOT NULL,         -- English
    PRIMARY KEY (category_name)
);

CREATE TABLE products (
    product_id     CHAR(32)     NOT NULL,
    category_name  VARCHAR(60)  NULL,                -- NULL when not categorised
    photos_qty     SMALLINT     NULL,
    weight_g       INT          NULL,
    length_cm      SMALLINT     NULL,
    height_cm      SMALLINT     NULL,
    width_cm       SMALLINT     NULL,
    PRIMARY KEY (product_id),
    CHECK (weight_g IS NULL OR weight_g >= 0)
);

-- ---------------------------------------------------------------------
-- 1.3 Final tables: transactions (children)
-- ---------------------------------------------------------------------
CREATE TABLE orders (
    order_id                 CHAR(32)     NOT NULL,
    customer_id              CHAR(32)     NOT NULL,
    order_status             VARCHAR(12)  NOT NULL DEFAULT 'created',
    purchase_ts              DATETIME     NOT NULL,
    approved_ts              DATETIME     NULL,
    delivered_carrier_ts     DATETIME     NULL,
    delivered_customer_ts    DATETIME     NULL,
    estimated_delivery_date  DATE         NOT NULL,
    PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    CHECK (order_status IN ('created','approved','invoiced','processing','shipped',
                            'delivered','canceled','unavailable'))
);

CREATE TABLE order_items (
    order_id             CHAR(32)       NOT NULL,
    order_item_id        SMALLINT       NOT NULL,     -- line number within the order
    product_id           CHAR(32)       NOT NULL,
    seller_id            CHAR(32)       NOT NULL,
    shipping_limit_ts    DATETIME       NOT NULL,
    price                DECIMAL(10,2)  NOT NULL,     -- BRL
    freight_value        DECIMAL(10,2)  NOT NULL DEFAULT 0,
    PRIMARY KEY (order_id, order_item_id),
    CONSTRAINT fk_items_order   FOREIGN KEY (order_id)   REFERENCES orders (order_id),
    CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES products (product_id),
    CONSTRAINT fk_items_seller  FOREIGN KEY (seller_id)  REFERENCES sellers (seller_id),
    CHECK (price >= 0 AND freight_value >= 0)
);

CREATE TABLE order_payments (
    order_id              CHAR(32)       NOT NULL,
    payment_sequential    SMALLINT       NOT NULL,    -- 1, 2, … per order
    payment_type          VARCHAR(12)    NOT NULL,
    payment_installments  SMALLINT       NOT NULL DEFAULT 1,
    payment_value         DECIMAL(10,2)  NOT NULL,    -- BRL
    PRIMARY KEY (order_id, payment_sequential),
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders (order_id),
    CHECK (payment_value >= 0)
);

-- ---------------------------------------------------------------------
-- 1.4 Indexes for frequent filters (foreign keys are indexed automatically)
-- ---------------------------------------------------------------------
CREATE INDEX idx_orders_purchase ON orders (purchase_ts);
CREATE INDEX idx_orders_status   ON orders (order_status);
CREATE INDEX idx_customers_uid   ON customers (customer_unique_id);

SHOW TABLES;
DESCRIBE orders;

SELECT 'Step 1 complete: 7 staging + 7 final tables created' AS status;
