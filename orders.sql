-- Кубик 2: признаки по заказам на уровне customer_id × session_id.
--
-- Исправленная версия: убраны синтаксические погрешности и корректно обработаны NULL.
-- Создаётся таблица orders_features с признаками количества и суммы оплаченных заказов,
-- а также временным признаком первой оплаченной покупки без промо.

DROP TABLE IF EXISTS orders_features;

CREATE TABLE orders_features AS
SELECT
    customer_id,
    session_id,
    SUM(CASE WHEN order_status IN ('paid', 'completed') THEN 1 ELSE 0 END) AS paid_orders_cnt,
    SUM(CASE WHEN order_status IN ('paid', 'completed') AND promo_id IS NULL THEN 1 ELSE 0 END)
        AS paid_orders_without_promo_cnt,
    SUM(CASE WHEN order_status IN ('paid', 'completed') AND promo_id IS NULL THEN order_amount ELSE 0 END)
        AS paid_orders_without_promo_gmv,
    MIN(CASE WHEN order_status IN ('paid', 'completed') AND promo_id IS NULL THEN created_dttm END)
        AS first_paid_order_without_promo_dttm
FROM orders
GROUP BY customer_id, session_id;
