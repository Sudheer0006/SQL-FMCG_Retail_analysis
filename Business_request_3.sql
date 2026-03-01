/*Generate a report that displays each campaign along with the total revenue generated before and after the campaign 
 Note: all values are in Millions*/
select campaign_name,
 round(sum(base_price*quantity_sold_before_promo)/1000000,2) as total_revenue_before_promo_mln,
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
)/1000000,2) as total_revenue_after_promo_millions

from dim_campaigns c
join fact_events e
on c.campaign_id=e.campaign_id
group by c.campaign_name
order by total_revenue_after_promo_millions