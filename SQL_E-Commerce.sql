USE E_Commerce;

-- Create the tables:

-- Product table
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
            
Select Count(*) from Orders;
Select Count(*) from Products;
Select Count(*) from Orderdetails;
Select Count(*) from Customers;

Select count(distinct customer_ID) from Orders;
Select Count(Distinct Category) from Products;
-- - **Null Value Check**: Check for any null values in the dataset and delete records with missing data.         
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

-- How many customers are there in each location?
Select Location, Count(Customer_name) as Customers_Count
from Customers
group by Location
order by Customers_Count desc;

-- Which city has the highest number of customers?
Select Location, Count(Customer_ID) as Customer_Count 
From Customers
group by location
order by count(*) desc
limit 1;

-- Which customer has spent the most money? 
Select O.Customer_ID,C.Customer_Name,  Sum(O.Total_Amount) as Total_Spent
from orders O
Join Customers c
on O.Customer_ID=C.Customer_ID
group by O.Customer_ID, C.Customer_name
order by Total_spent desc
limit 1;

-- Top 10 customers by total purchase amount?
Select O.Customer_ID, C.Customer_Name, Sum(Total_Amount) as Total_Purchase
from Orders O
join Customers C
On O.Customer_Id=C.Customer_ID
group by o.Customer_ID, C.Customer_Name
order by Total_Purchase desc
limit 10; 

-- Which location generates the highest revenue?
Select C.Location, Sum(Total_Amount) as Total_revenue 
from Orders O
Join Customers C
on O.Customer_ID= C.Customer_Id
group by C.Location
order by Total_Revenue desc
limit 1;

-- How many orders does each customer place?
Select O.Customer_ID, C.Customer_Name, Count(Order_ID) as Count_OF_Orders 
from Orders O
Join Customers C
on O.Customer_Id=C.Customer_ID
group by O.Customer_ID, C.Customer_Name
order by Count_OF_Orders Desc;
 
-- Customer with the highest number of orders?
Select O.Customer_ID, C.Customer_Name, Count(Order_ID) as Count_OF_Orders 
from Orders O
Join Customers C
on O.Customer_Id=C.Customer_ID
group by O.Customer_ID, C.Customer_Name
order by Count_OF_Orders Desc
Limit 1;

-- Which product sells the most (by quantity)?
Select OI.Product_ID, P.Product_Name, Sum(OI.Quantity) as Quantity 
from OrderDetails OI
Join Products P
on OI.Product_ID= P.Product_ID
group by OI.Product_ID, P.Product_Name
order by Quantity desc
limit 1;

-- Top 5 best-selling products?
Select OI.Product_ID, P.Product_Name, Sum(OI.Quantity) as Quantity 
from OrderDetails OI
Join Products P
on OI.Product_ID= P.Product_ID
group by OI.Product_ID, P.Product_Name
order by Quantity desc
limit 5; 

-- Which category sells the most?
Select P.Category, Sum(OI.Quantity) as Quantity
from OrderDetails OI
Join Products P
on OI.Product_ID= P.Product_ID
group by P.Category
order by Quantity desc
limit 1; 

-- Which product generates the highest revenue?
Select P.Product_ID, P.Product_Name, Sum(OI.Quantity*OI.Price_Per_Unit) as Revenue 
from OrderDetails OI
Join Products P
on OI.Product_ID= P.Product_ID
group by P.Product_ID, P.Product_Name
order by Revenue desc
limit 1; 

-- Least selling product (Low Selling Product) 
Select P.Product_ID, P.Product_Name as Least_Selling_Product_Name, Sum(OI.Quantity) as Qunatity
from OrderDetails OI
Join Products P
on OI.Product_ID= P.Product_ID
group by P.Product_ID, P.Product_Name
order by Qunatity asc
limit 1; 

-- Average price of products per category
Select Product_ID, Product_Name, Category, Round(avg(Price) over (partition by Category),2) as Avg_Price 
from Products 
order by Category;

-- Which category has the highest demand?
Select P.Product_ID, P.Product_Name as High_Selling_Product_Name, Sum(OI.Quantity) as Qunatity
from OrderDetails OI
Join Products P
on OI.Product_ID= P.Product_ID
group by P.Product_ID, P.Product_Name
order by Qunatity desc
limit 1; 

-- Identify products that never sold?
Select Product_ID, Product_Name 
from Products 
Where Product_ID not in (Select Distinct Product_ID from OrderDetails);

-- Calculate total company revenue?
Select Sum(Total_Amount) as Total_Revenue 
from Orders;

-- Calculate monthly sales trend and the growth rate month over month?
With ctc as (Select date_format(Order_date, '%Y-%m') as Month, Sum(Total_Amount) as Sale
from Orders
group by date_format(Order_Date, '%Y-%m')
)
Select *, Lag(Sale) over (order by Month) as Previous_Month_Sales, Round(((Sale-Lag(Sale) over (Order by Month))/Lag(Sale) over (Order by Month))*100,2) as Growth_Rate
from ctc order by month;

-- Best selling product in each category?
with ctc as (Select P.Product_ID, P.Product_Name, P.Category,Sum(OI.Quantity) as Sold_Quantity,  dense_rank() over (Partition by P.Category order by sum(OI.Quantity)  desc) as Rnk 
from Products P
join Orderdetails OI
on P.Product_ID=OI.Product_ID
join Orders O
on OI.Order_ID=O.Order_ID
group by P.Product_ID, P.Product_Name, P.Category)
Select Category, Product_ID, Product_name, Sold_Quantity from ctc 
where rnk=1;

-- Revenue per customer location
Select C.Location, Sum(O.Total_amount) as Revenue 
from Customers C
join Orders O
on C.Customer_ID=O.Customer_ID
group by C.location
order by Sum(O.Total_Amount) desc;

-- Top 5 cities generating revenue
Select C.Location, Sum(O.Total_amount) as Revenue 
from Customers C
join Orders O
on C.Customer_ID=O.Customer_ID
group by C.location
order by Sum(O.Total_Amount) desc
limit 5;

-- Customer lifetime value
Select C.Customer_ID, C.Customer_Name, Sum(O.Total_Amount) as Total_spend 
from Customers C
join Orders O
on C.Customer_ID=O.Customer_ID
group by C.Customer_Id, C.Customer_Name
order by C.Customer_id;

-- Category revenue contribution
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