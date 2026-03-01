/*Generate a report featuring the top 5 products ranked by incremental revenue percentage (IR%)*/
with reveneu as(select p.product_name,p.category,
 round(sum(base_price*quantity_sold_before_promo)/1000000,2) as revenue_before_promo_mln,
round(sum(case
               when e.promo_type='25% OFF'
                   then(e.base_price*0.75) * e.quantity_sold_after_promo
			   when e.promo_type='50% OFF'
                   then(e.base_price*0.50)*e.quantity_sold_after_promo
			   when e.promo_type='BOGOF'
                  then(e.base_price/2)* e.quantity_sold_after_promo
			   when e.promo_type='500 Cashback'
				  then(e.base_price-500)* e.quantity_sold_after_promo
			   else
                    e.base_price*quantity_sold_after_promo
			  end
)/1000000,2) as revenue_after_promo_mln
from fact_events e
join dim_products p 
on e.product_code=p.product_code
group by p.product_name,p.category)
select product_name,category,
round(
      ((revenue_after_promo_mln-revenue_before_promo_mln)/revenue_before_promo_mln) * 100 , 2
	
)as revenue_percentage
 from reveneu
 where revenue_before_promo_mln > 0
 order by revenue_percentage desc
 limit 5