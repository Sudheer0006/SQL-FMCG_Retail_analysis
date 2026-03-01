/* Generate a report incremental sold quantity percentage (ISU%) for each category during campaign with ranking */
with campaign_diwali as(select c.campaign_name,e.product_code, e.quantity_sold_before_promo,
e.quantity_sold_after_promo 
from dim_campaigns c
join fact_events e
on c.campaign_id= e.campaign_id
where c.campaign_name='Diwali' ),
category_total as(select  campaign_name,category,
sum(quantity_sold_before_promo) as total_before,
sum(quantity_sold_after_promo) as total_after
 from campaign_diwali d 
join dim_products p 
on d.product_code=p.product_code
group by campaign_name,category)
 select category, round(
                        CASE
                            WHEN total_before = 0 then 0
                            ELSE (total_after-total_before)/total_before * 100 
						END
                        ,2) as ISU_percentage,
				 dense_rank() over(
                            order by
						    (total_after-total_before)
                           / NULLIF(total_before,0 ) DESC
                            ) as rank_order
from category_total

					
	

 