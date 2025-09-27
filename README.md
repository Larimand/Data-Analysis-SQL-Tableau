# Magist performance analysis on sales and delivery with SQL and Tableau
 
## 🎯 Project Overview
This project analyses if our sample company for high-end tech products that is planning to expand and conquere the Brazilian market should collaborate with the sample company Magist who is already operating on the Brazilian market and through whose website we would sell our products.
We used SQL to analyse the data provided by Magist and Tableau to visualize the insights.
Their product catalog and revenue didn't meet the expectations. The delivery times and delays were not convincing.
 
## 📊 Dataset &amp; Sources

- Source: Magist dump (https://drive.google.com/file/d/11ukpWaHtG-5LkKHNpDBnwIJnINf0eqmS/view?usp=sharing)
- Size: 9 tables: custumers, geo, order_items, order_payments, orders, order_reviews, sellers, products, product_category_name_translation
- Date of 3 years (not continous, there are missing months)
 
## 🚀 Key Findings &amp; Results
- **Many products, but not many tech products**: Only around 15 % tech products within the database.
- **Cheaper products**: Average sales price is 120 dollars. Ours is 540 dollars.
- **Revenue doesn't meet expectations**: We have a revenue of 14M per year, and the combined revenue of all tech sellers at Magist is at 2.1M within 3 years.
- **Delivery time to long**: 12 days delays, which is too long for high-end products.
There are to many cons to collaborate with this company: the delivery times are wy to long for high-end products and they don't serve our target audience.

## 🛠️ Technologies Used
- Programming languages: SQL, MySQL Workbench
- Tools: Tableau
 
## 📁 Project Structure
In this project you will find the SQL analysis that we executed to get our insights.
 
## 📈 Visualisations
- [Tech sellers vs. Non-tech products at Magist](images/Tech_vs_non_tech_products.png):
  Percentage of tech products and non-tech products
- [Revenue of tech sellers and non-tech sellers at Magist](images/Tech_vs_non_tech_revenue.png):
  Shows the revenue of sellers at Magist
- [Average delivery days per seller distribution](images/Average_delivery_time.png):
  Shows the average delivery time at Magist
- [Sales per state](images/Main_market_state.png):
  Shows the sales performance per state

## 🔗 How to Use This Project
- View the SQL analysis
- Download the database dump
- Open MySQL Workbench (or similar) and run the queries
 
## 🚀 Future Work
*Customer satisfaction*: Evaulate how happy customers are and how the client growth is developing.
*Payments and return*: Check if many people return products and/or if invoices remain unpaid.
 
## 📧 Contact
My email address: larissamanderfeld@hotmail.de
