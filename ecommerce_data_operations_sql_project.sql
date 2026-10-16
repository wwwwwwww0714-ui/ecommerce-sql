/*
项目名称：电商经营分析与异常诊断 SQL 项目
数据库：MySQL 8.0+
用途：面试作品集演示，所有数据均为合成模拟数据，不代表真实企业。
运行方式：在 MySQL Workbench / DBeaver 中执行本脚本。
*/

CREATE DATABASE IF NOT EXISTS ecommerce_ops
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE ecommerce_ops;

-- 1. 建表：用户、商品、订单、订单明细、渠道日流量
DROP TABLE IF EXISTS traffic_daily;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id BIGINT PRIMARY KEY,
    register_date DATE NOT NULL,
    user_city VARCHAR(50),
    user_type VARCHAR(20) DEFAULT '普通用户'
);

CREATE TABLE products (
    product_id BIGINT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,
    list_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    order_time DATETIME NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    pay_amount DECIMAL(12,2) DEFAULT 0,
    refund_amount DECIMAL(12,2) DEFAULT 0,
    channel VARCHAR(30),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items (
    item_id BIGINT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    item_paid_amount DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE traffic_daily (
    stat_date DATE NOT NULL,
    channel VARCHAR(30) NOT NULL,
    sessions INT NOT NULL,
    product_detail_views INT NOT NULL,
    add_to_cart_users INT NOT NULL,
    paid_orders INT NOT NULL,
    ad_spend DECIMAL(12,2) DEFAULT 0,
    attributed_revenue DECIMAL(12,2) DEFAULT 0,
    PRIMARY KEY (stat_date, channel)
);

-- 2. 模拟数据：用户
INSERT INTO users (user_id, register_date, user_city, user_type) VALUES
(1001,'2026-09-01','广州','新客'),
(1002,'2026-09-02','深圳','新客'),
(1003,'2026-09-05','佛山','新客'),
(1004,'2026-08-15','广州','老客'),
(1005,'2026-07-20','东莞','老客'),
(1006,'2026-06-11','深圳','老客'),
(1007,'2026-09-10','珠海','新客'),
(1008,'2026-05-03','广州','老客');

-- 模拟数据：商品
INSERT INTO products (product_id, product_name, category, unit_cost, list_price) VALUES
(2001,'运动鞋 A','鞋服',180.00,399.00),
(2002,'运动外套 B','鞋服',220.00,499.00),
(2003,'无线耳机 C','数码',120.00,299.00),
(2004,'智能手表 D','数码',450.00,799.00),
(2005,'双肩包 E','箱包',70.00,199.00);

-- 模拟数据：订单。订单状态示例：paid、completed、refunded、cancelled
INSERT INTO orders
(order_id, user_id, order_time, order_status, pay_amount, refund_amount, channel) VALUES
(3001,1001,'2026-10-01 09:20:00','paid',399.00,0,'自然流量'),
(3002,1002,'2026-10-01 10:10:00','paid',299.00,0,'付费广告'),
(3003,1004,'2026-10-01 12:35:00','completed',499.00,0,'自然流量'),
(3004,1005,'2026-10-02 13:15:00','paid',199.00,0,'达人推广'),
(3005,1001,'2026-10-02 18:20:00','paid',299.00,0,'自然流量'),
(3006,1003,'2026-10-03 11:00:00','refunded',399.00,399.00,'付费广告'),
(3007,1006,'2026-10-03 14:40:00','completed',799.00,0,'自然流量'),
(3008,1002,'2026-10-04 15:30:00','paid',499.00,0,'达人推广'),
(3009,1007,'2026-10-04 17:10:00','paid',199.00,0,'付费广告'),
(3010,1004,'2026-10-05 10:00:00','paid',399.00,0,'自然流量'),
(3011,1005,'2026-10-05 11:20:00','cancelled',0,0,'付费广告'),
(3012,1008,'2026-10-06 12:00:00','completed',799.00,100.00,'自然流量'),
(3013,1003,'2026-10-06 16:10:00','paid',299.00,0,'达人推广'),
(3014,1001,'2026-10-07 09:45:00','paid',499.00,0,'自然流量'),
(3015,1006,'2026-10-07 20:15:00','paid',199.00,0,'付费广告'),
(3016,1007,'2026-10-08 10:30:00','paid',799.00,0,'自然流量'),
(3017,1002,'2026-10-08 13:00:00','refunded',299.00,299.00,'达人推广'),
(3018,1008,'2026-10-09 18:20:00','completed',499.00,0,'自然流量'),
(3019,1003,'2026-10-09 19:00:00','paid',199.00,0,'付费广告'),
(3020,1004,'2026-10-10 11:10:00','paid',799.00,0,'自然流量');

-- 模拟数据：订单商品明细
INSERT INTO order_items (item_id, order_id, product_id, quantity, item_paid_amount) VALUES
(1,3001,2001,1,399.00),(2,3002,2003,1,299.00),(3,3003,2002,1,499.00),
(4,3004,2005,1,199.00),(5,3005,2003,1,299.00),(6,3006,2001,1,399.00),
(7,3007,2004,1,799.00),(8,3008,2002,1,499.00),(9,3009,2005,1,199.00),
(10,3010,2001,1,399.00),(11,3012,2004,1,799.00),(12,3013,2003,1,299.00),
(13,3014,2002,1,499.00),(14,3015,2005,1,199.00),(15,3016,2004,1,799.00),
(16,3017,2003,1,299.00),(17,3018,2002,1,499.00),(18,3019,2005,1,199.00),
(19,3020,2004,1,799.00);

-- 模拟数据：渠道每日漏斗与广告数据
INSERT INTO traffic_daily
(stat_date, channel, sessions, product_detail_views, add_to_cart_users, paid_orders, ad_spend, attributed_revenue) VALUES
('2026-10-01','自然流量',1200,720,180,35,0,12000),
('2026-10-01','付费广告',900,500,100,20,1800,6500),
('2026-10-01','达人推广',700,420,95,18,900,5200),
('2026-10-02','自然流量',1250,740,190,38,0,13200),
('2026-10-02','付费广告',950,510,105,21,1950,6600),
('2026-10-02','达人推广',760,450,100,19,950,5400),
('2026-10-03','自然流量',1300,780,200,40,0,14000),
('2026-10-03','付费广告',1000,520,110,22,2100,6800),
('2026-10-03','达人推广',780,460,105,20,1000,5600),
('2026-10-04','自然流量',1280,760,195,39,0,13700),
('2026-10-04','付费广告',1050,540,112,22,2500,6200),
('2026-10-04','达人推广',800,470,108,20,1100,5500),
('2026-10-05','自然流量',1000,570,120,20,0,7000),
('2026-10-05','付费广告',1100,550,100,15,3200,4200),
('2026-10-05','达人推广',810,460,95,16,1300,4300),
('2026-10-06','自然流量',980,550,115,19,0,6800),
('2026-10-06','付费广告',1120,560,95,14,3400,3900),
('2026-10-06','达人推广',830,470,90,15,1400,4100),
('2026-10-07','自然流量',1020,580,118,20,0,7100),
('2026-10-07','付费广告',1150,570,92,13,3600,3700),
('2026-10-07','达人推广',850,480,88,14,1500,4000),
('2026-10-08','自然流量',1050,600,125,22,0,7600),
('2026-10-08','付费广告',1180,580,90,12,3800,3500),
('2026-10-08','达人推广',900,500,85,13,1700,3600),
('2026-10-09','自然流量',1080,620,130,23,0,8000),
('2026-10-09','付费广告',1200,590,88,12,4000,3400),
('2026-10-09','达人推广',920,510,82,12,1800,3300),
('2026-10-10','自然流量',1100,640,135,24,0,8300),
('2026-10-10','付费广告',1250,600,85,11,4200,3200),
('2026-10-10','达人推广',950,520,80,12,1900,3100);

-- ============================================================
-- 分析查询 1：整体经营总览（日维度）
-- 口径：只统计 paid / completed 订单；销售额按支付金额扣除退款金额计算。
-- ============================================================
SELECT
    DATE(order_time) AS stat_date,
    COUNT(DISTINCT CASE WHEN order_status IN ('paid','completed') THEN order_id END) AS valid_orders,
    SUM(CASE WHEN order_status IN ('paid','completed')
             THEN pay_amount - refund_amount ELSE 0 END) AS net_revenue,
    COUNT(DISTINCT CASE WHEN order_status IN ('paid','completed') THEN user_id END) AS buyers,
    ROUND(
      SUM(CASE WHEN order_status IN ('paid','completed') THEN pay_amount - refund_amount ELSE 0 END)
      / NULLIF(COUNT(DISTINCT CASE WHEN order_status IN ('paid','completed') THEN order_id END),0), 2
    ) AS avg_order_value
FROM orders
GROUP BY DATE(order_time)
ORDER BY stat_date;

-- ============================================================
-- 分析查询 2：销售额环比与异常波动初筛（MySQL 8.0 窗口函数）
-- 说明：大幅下降只代表排查线索，不直接证明原因。
-- ============================================================
WITH daily_sales AS (
    SELECT DATE(order_time) AS stat_date,
           SUM(CASE WHEN order_status IN ('paid','completed')
                    THEN pay_amount - refund_amount ELSE 0 END) AS net_revenue
    FROM orders
    GROUP BY DATE(order_time)
),
trend AS (
    SELECT stat_date, net_revenue,
           LAG(net_revenue) OVER (ORDER BY stat_date) AS previous_day_revenue
    FROM daily_sales
)
SELECT stat_date, net_revenue, previous_day_revenue,
       ROUND((net_revenue - previous_day_revenue) / NULLIF(previous_day_revenue,0) * 100, 2) AS mom_change_pct,
       CASE
         WHEN previous_day_revenue IS NULL THEN '首日，无可比数据'
         WHEN (net_revenue - previous_day_revenue) / NULLIF(previous_day_revenue,0) <= -0.20
           THEN '销售额下降超过20%，建议排查'
         ELSE '继续监测'
       END AS diagnostic_flag
FROM trend
ORDER BY stat_date;

-- ============================================================
-- 分析查询 3：渠道漏斗分析
-- ============================================================
SELECT
    channel,
    SUM(sessions) AS sessions,
    SUM(product_detail_views) AS detail_views,
    SUM(add_to_cart_users) AS add_to_cart_users,
    SUM(paid_orders) AS paid_orders,
    ROUND(SUM(product_detail_views) / NULLIF(SUM(sessions),0) * 100, 2) AS detail_view_rate_pct,
    ROUND(SUM(add_to_cart_users) / NULLIF(SUM(product_detail_views),0) * 100, 2) AS detail_to_cart_pct,
    ROUND(SUM(paid_orders) / NULLIF(SUM(sessions),0) * 100, 2) AS session_to_order_pct
FROM traffic_daily
GROUP BY channel
ORDER BY session_to_order_pct DESC;

-- ============================================================
-- 分析查询 4：广告 ROAS 与渠道效率
-- ROAS = 归因销售额 / 广告花费；自然流量无广告花费时返回 NULL。
-- ============================================================
SELECT
    channel,
    SUM(sessions) AS sessions,
    SUM(ad_spend) AS total_ad_spend,
    SUM(attributed_revenue) AS attributed_revenue,
    ROUND(SUM(attributed_revenue) / NULLIF(SUM(ad_spend),0), 2) AS roas
FROM traffic_daily
GROUP BY channel
ORDER BY roas DESC;

-- ============================================================
-- 分析查询 5：商品销售与估算毛利分析
-- 注意：此处商品毛利为简化估算，未计入平台佣金、履约成本等。
-- ============================================================
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.item_paid_amount) AS item_revenue,
    SUM(oi.quantity * p.unit_cost) AS estimated_cost,
    SUM(oi.item_paid_amount) - SUM(oi.quantity * p.unit_cost) AS estimated_gross_profit,
    ROUND(
      (SUM(oi.item_paid_amount) - SUM(oi.quantity * p.unit_cost))
      / NULLIF(SUM(oi.item_paid_amount),0) * 100, 2
    ) AS estimated_gross_margin_pct
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('paid','completed')
GROUP BY p.product_id, p.product_name, p.category
ORDER BY estimated_gross_profit DESC;

-- ============================================================
-- 分析查询 6：用户复购分析
-- 复购用户：统计期内至少有 2 笔有效订单的用户。
-- ============================================================
WITH user_orders AS (
    SELECT user_id,
           COUNT(DISTINCT order_id) AS valid_order_count,
           SUM(pay_amount - refund_amount) AS net_revenue
    FROM orders
    WHERE order_status IN ('paid','completed')
    GROUP BY user_id
)
SELECT
    COUNT(*) AS purchasing_users,
    SUM(CASE WHEN valid_order_count >= 2 THEN 1 ELSE 0 END) AS repeat_buyers,
    ROUND(
      SUM(CASE WHEN valid_order_count >= 2 THEN 1 ELSE 0 END)
      / NULLIF(COUNT(*),0) * 100, 2
    ) AS repeat_purchase_user_rate_pct,
    ROUND(AVG(valid_order_count),2) AS avg_orders_per_buyer
FROM user_orders;

-- ============================================================
-- 分析查询 7：退款风险商品初筛
-- 说明：该示例按订单退款金额关联商品会有多商品分摊问题。
-- 若要精确到商品级退货率，需要商品明细级退款数据。
-- ============================================================
SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS valid_order_count,
    SUM(CASE WHEN o.refund_amount > 0 THEN 1 ELSE 0 END) AS orders_with_refund,
    ROUND(
      SUM(CASE WHEN o.refund_amount > 0 THEN 1 ELSE 0 END)
      / NULLIF(COUNT(DISTINCT o.order_id),0) * 100, 2
    ) AS order_refund_incidence_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('paid','completed','refunded')
GROUP BY p.category
ORDER BY order_refund_incidence_pct DESC;

-- ============================================================
-- 面试讲述建议：
-- 1) 先明确统计口径，再编写 SQL；
-- 2) 使用 JOIN 关联订单、商品和用户；
-- 3) 使用 GROUP BY 聚合，CASE WHEN 分组计算；
-- 4) 使用 CTE + LAG 做日环比与异常初筛；
-- 5) 将发现转化为排查动作，而不是仅凭相关性认定因果。
-- 所有数据均为模拟数据，请勿描述为真实企业业绩。
-- ============================================================
