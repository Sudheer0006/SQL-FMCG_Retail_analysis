 /*Businees Request 1
  Products with base price > 500 and BOGOF(buy one get one freee) promo
*/

SELECT product_name,base_price,promo_type FROM retail_events_db.dim_products p 
join fact_events e
on p.product_code=e.product_code
where promo_type='BOGOF' and base_price>500