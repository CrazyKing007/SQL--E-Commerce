# E-Commerce Analysis SQL Project

## Project Overview

**Project Title**: E-Commerce Analysis  
**Level**: Advanced  
**Database**: `E-Commerce`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a E_Commerce database**: Create and populate a E-Commerce database with the provided data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `E-Commerce`.
- **Orders Tables Creation**: Table named `Orders` is created to store the Orders data. The table structure includes columns for Order_ID, Order_Date, Customer-ID, Total_Amount.
- **Order Details Table Creation**: Table named `OrderDetails` is created to store the order details data. The Table structure includes columns for Order_ID, Product_Id, Quantity, Price_Per_Unit.
- **Customers Table Creation**: Table named `Customers` is created to store the customers details data. The table struture includes columns for Customer_ID, Customer_Name, Location.
- **Products Table Creation**: Table named `Products` is created to store the Products Details data. The table Struture includes columns for Product_ID, Product_name, Category, Price.

```sql
CREATE DATABASE E-Commerce;

drop table if exists Products;
Create Table Products 
		(
        Product_ID int Primary Key,
		Product_Name varchar(100),
        Category Varchar (50),
        Price int
        );

Drop Table if exists Orderdetails;
Create Table OrderDetails
			(
            Order_ID int,
            Product_ID int,
            Quantity int,
            Price_per_Unit int
            );

drop table if exists Customers;		
Create table Customers
			(
            Customer_Id int Primary key,
            Customer_name varchar (50),
            Location varchar (50)
            );
            
drop table if exists Orders;
Create table Orders
			(
            Order_ID int Primary key,
            Order_date date,
            Customer_id int,
            Total_amount int
            );
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
Select Count(*) from Orders;
Select Count(*) from Products;
Select Count(*) from Orderdetails;
Select Count(*) from Customers;

Select * from Orders
where 
	Order_id is null
    or 
    Order_date is null
    or 
    Customer_ID is null;

delete from Orders
where 
	Order_id is null
    or 
    Order_date is null
    or 
    Customer_ID is null;


Select * from Customers
where 
	Customer_ID is null
    or
    Customer_Name is null
    or 
    Location is null;


delete from Customers
where 
	Order_ID is null
    or
    Product_ID is null
    or 
    Quantity is null;
    
Select * from OrderDetails
where 
	Order_ID is null
    or
    Product_ID is null
    or 
    Quantity is null
    or 
    Price_per_unit is null;


delete from OrderDetails
where 
	Order_ID is null
    or
    Product_ID is null
    or 
    Quantity is null
    or 
    Price_per_unit is null;
	
Select * from Products
where 
	Product_ID is null
    or
    Product_Name is null
    or 
    Category is null
    or 
    Price is null;


delete from Products
where 
	Product_ID is null
    or
    Product_Name is null
    or 
    Category is null
    or 
    Price is null;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **How many customers are there in each location**:
```sql
Select Location, Count(Customer_name) as Customers_Count
from Customers
group by Location
order by Customers_Count desc;
```

2. **Which city has the highest number of customers**:
```sql
Select Location, Count(Customer_ID) as Customer_Count 
From Customers
group by location
order by count(*) desc
limit 1;
```

3. **Which customer has spent the most money**:
```sql
Select O.Customer_ID,C.Customer_Name,  Sum(O.Total_Amount) as Total_Spent
from orders O
Join Customers c
on O.Customer_ID=C.Customer_ID
group by O.Customer_ID, C.Customer_name
order by Total_spent desc
limit 1;
```

4. **Top 10 customers by total purchase amount**:
```sql
Select O.Customer_ID, C.Customer_Name, Sum(Total_Amount) as Total_Purchase
from Orders O
join Customers C
On O.Customer_Id=C.Customer_ID
group by o.Customer_ID, C.Customer_Name
order by Total_Purchase desc
limit 10; 
```

5. **Which location generates the highest revenue**:
```sql
Select C.Location, Sum(Total_Amount) as Total_revenue 
from Orders O
Join Customers C
on O.Customer_ID= C.Customer_Id
group by C.Location
order by Total_Revenue desc
limit 1;
```

6. **How many orders does each customer place**:
```sql
Select O.Customer_ID, C.Customer_Name, Count(Order_ID) as Count_OF_Orders 
from Orders O
Join Customers C
on O.Customer_Id=C.Customer_ID
group by O.Customer_ID, C.Customer_Name
order by Count_OF_Orders Desc;
```

7. **Customer with the highest number of orders**:
```sql
Select O.Customer_ID, C.Customer_Name, Count(Order_ID) as Count_OF_Orders 
from Orders O
Join Customers C
on O.Customer_Id=C.Customer_ID
group by O.Customer_ID, C.Customer_Name
order by Count_OF_Orders Desc
Limit 1;
```

8. **Which product sells the most (by quantity)**:
```sql
Select OI.Product_ID, P.Product_Name, Sum(OI.Quantity) as Quantity 
from OrderDetails OI
Join Products P
on OI.Product_ID= P.Product_ID
group by OI.Product_ID, P.Product_Name
order by Quantity desc
limit 1;
```

9. **Top 5 best-selling products**:
```sql
Select OI.Product_ID, P.Product_Name, Sum(OI.Quantity) as Quantity 
from OrderDetails OI
Join Products P
on OI.Product_ID= P.Product_ID
group by OI.Product_ID, P.Product_Name
order by Quantity desc
limit 5; 
```

10. **Which category sells the most**:
```sql
Select P.Category, Sum(OI.Quantity) as Quantity
from OrderDetails OI
Join Products P
on OI.Product_ID= P.Product_ID
group by P.Category
order by Quantity desc
limit 1; 
```

11. **Which product generates the highest revenue**:
```sql
Select P.Product_ID, P.Product_Name, Sum(OI.Quantity*OI.Price_Per_Unit) as Revenue 
from OrderDetails OI
Join Products P
on OI.Product_ID= P.Product_ID
group by P.Product_ID, P.Product_Name
order by Revenue desc
limit 1; 
```

12. **Least selling product (Low Selling Product)**:
```sql
Select P.Product_ID, P.Product_Name as Least_Selling_Product_Name, Sum(OI.Quantity) as Qunatity
from OrderDetails OI
Join Products P
on OI.Product_ID= P.Product_ID
group by P.Product_ID, P.Product_Name
order by Qunatity asc
limit 1; 
```
13. **Average price of products per category**:
```sql
Select Product_ID, Product_Name, Category, Round(avg(Price) over (partition by Category),2) as Avg_Price 
from Products 
order by Category;

```
14. **Which category has the highest demand**:
```sql
Select P.Product_ID, P.Product_Name as High_Selling_Product_Name, Sum(OI.Quantity) as Qunatity
from OrderDetails OI
Join Products P
on OI.Product_ID= P.Product_ID
group by P.Product_ID, P.Product_Name
order by Qunatity desc
limit 1;
```
15. **Identify products that never sold**:
```sql
Select Product_ID, Product_Name 
from Products 
Where Product_ID not in (Select Distinct Product_ID from OrderDetails);
```
16. **Calculate total company revenue**:
```sql
Select Sum(Total_Amount) as Total_Revenue 
from Orders;
```
17. **Calculate monthly sales trend and the growth rate month over month**:
```sql
With ctc as (Select date_format(Order_date, '%Y-%m') as Month, Sum(Total_Amount) as Sale
from Orders
group by date_format(Order_Date, '%Y-%m')
)
Select *, Lag(Sale) over (order by Month) as Previous_Month_Sales,
Round(
        (
        (Sale - Lag(Sale) over (Order by Month)) /     Lag(Sale) over (Order by Month)
        ) * 100 , 2) as Growth_Rate
from ctc order by month;
```
18. **Best selling product in each category**:
```sql
with ctc as (Select P.Product_ID, P.Product_Name, P.Category,Sum(OI.Quantity) as Sold_Quantity,  dense_rank() over (Partition by P.Category order by sum(OI.Quantity)  desc) as Rnk 
from Products P
join Orderdetails OI
on P.Product_ID=OI.Product_ID
join Orders O
on OI.Order_ID=O.Order_ID
group by P.Product_ID, P.Product_Name, P.Category)
Select Category, Product_ID, Product_name, Sold_Quantity from ctc 
where rnk=1;
```
19. **Revenue per customer location**:
```sql
Select C.Location, Sum(O.Total_amount) as Revenue 
from Customers C
join Orders O
on C.Customer_ID=O.Customer_ID
group by C.location
order by Sum(O.Total_Amount) desc;
```
20. **Top 5 cities generating revenue**:
```sql
Select C.Location, Sum(O.Total_amount) as Revenue 
from Customers C
join Orders O
on C.Customer_ID=O.Customer_ID
group by C.location
order by Sum(O.Total_Amount) desc
limit 5;
```
21. **Customer lifetime value**:
```sql
Select C.Customer_ID, C.Customer_Name, Sum(O.Total_Amount) as Total_spend 
from Customers C
join Orders O
on C.Customer_ID=O.Customer_ID
group by C.Customer_Id, C.Customer_Name
order by C.Customer_id;
```
22. **Category revenue contribution**: 
```sql
SELECT 
P.Category,
SUM(OI.Quantity * OI.Price_Per_Unit) AS Total_Revenue,
ROUND(
    (SUM(OI.Quantity * OI.Price_Per_Unit) /
    (SELECT SUM(Quantity * Price_Per_Unit) FROM OrderDetails)) * 100
,2) AS Contribution_Percent
FROM Products P
JOIN OrderDetails OI
ON P.Product_ID = OI.Product_ID
GROUP BY P.Category
ORDER BY Contribution_Percent DESC;
```



## Findings

- **Customers & Location Insights**:
  The dataset contains multiple customers across different locations.
  A small group of customers contributes a large portion of total revenue, showing a high-value customer segment.
  Certain customers place multiple orders, making them loyal customers.
  Some cities have significantly more customers, indicating strong market presence.
  
- **Sales Performance**:
  Total company revenue was calculated using the orders table.
  Monthly sales analysis revealed fluctuations in revenue, indicating seasonal purchasing behavior.
  Month-over-month growth analysis helped identify periods of high and low sales performance.
  
- **Product Performance**:
  Some products have very high sales quantities, making them top-selling items.
  A few products show very low sales, indicating potential low demand or poor marketing.
  Best-selling products vary by category, showing different customer preferences.
  
- **Customer Insights**:
  Certain product categories generate significantly higher revenue contributions.
  Category revenue analysis shows that a few categories dominate overall sales.

## Business Insights    

- High-value customers should be targeted with loyalty programs.
- Top-selling products should be prioritized for inventory and marketing.
- Low-selling products may require discounts, promotion, or removal.
- High-revenue cities are ideal locations for expanding business operations.

## Conclusion

This analysis demonstrates how SQL can be used to extract meaningful insights from an e-commerce dataset.

**The project covers**:
- Data cleaning and validation
- Customer behavior analysis
- Product performance evaluation
- Revenue trend analysis
- Category contribution analysis



Thank you for your precious time.
