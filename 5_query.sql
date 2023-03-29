#This query looks at the average revenue generated per customer and comapres it to the average amount rating of movies rented. The goal of the query is to understand
#If renting more popular movies is correlated with a larger volume of rentals per customer.

select customer.customer_id, customer.first_name, customer.last_name, SUM(fact_payments.amount) as customer_revenue, AVG(inventory.ratings) as average_ratings_per_movie_rented
from fact_payments
Join customer ON fact_payments.customer_id = customer.customer_id
Join inventory ON fact_payments.inventory_id = inventory.inventory_id
group by customer.customer_id;
