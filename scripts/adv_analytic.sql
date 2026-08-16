/* =========================================================
   1. Monthly Revenue & Month-over-Month (MoM) Growth
   ---------------------------------------------------------
   Calculate the total revenue for each month and compare
   monthly revenue with the previous month.
   ========================================================= */

with Monthlysales as ( 
	select  
		cast(datetrunc(month, OrderDate) as date) as Order_Date, 
		sum(SubTotal) AS Monthly_Revenue 
	from Sales.SalesOrderHeader 
	group by cast(datetrunc(month, OrderDate) as date)), 
Previous_m_sales as( 
	select  
		Order_Date, 
		Monthly_Revenue,  
		lag(Monthly_Revenue,1)over(order by Order_Date) as Previous_Month_Sales 
	from Monthlysales) 
select 
	Order_Date, 
	Monthly_Revenue, 
	Previous_Month_Sales, 
	round((Monthly_Revenue-Previous_Month_Sales)/Previous_Month_Sales*100,2) as MoM_Growth_Percent 
from Previous_m_sales; 


/* =========================================================
   2. Yearly Sales vs. Average Sales by Product
   ---------------------------------------------------------
   Compare each product's yearly total sales against its
   average yearly sales to identify above/below average years.
   ========================================================= */

with yearly_sales as ( 
select 
	year(sh.OrderDate) as Order_year, 
	p.Name as Product_Name, 
	sum(so.LineTotal) as Total_sales 
from Sales.SalesOrderHeader as sh 
left join Sales.SalesOrderDetail as so 
on  so.SalesOrderDetailID = sh.SalesOrderID 
left join Production.Product as p 
on so.ProductID = p.ProductID 
group by year(OrderDate),p.Name  
) 
select  
	Order_year, 
	Product_Name, 
	Total_sales, 
	avg(Total_sales) over(partition by Product_Name) Avg_Price, 
	Total_sales- avg(Total_sales) over(partition by Product_Name) diff_avg, 
	case when Total_sales- avg(Total_sales) over(partition by Product_Name) < 0 then 'Below Average' 
		 when Total_sales- avg(Total_sales) over(partition by Product_Name) > 0 then 'Above Average' 
		 else 'Average' end as change 
from yearly_sales; 


/* =========================================================
   3. Yearly Sales, Running Total & Moving Average
   ---------------------------------------------------------
   Calculate yearly total sales, cumulative running sales,
   and the average sales across years.
   ========================================================= */

with sales as (select  
	cast(datetrunc(year, OrderDate) as date) as Order_Date, 
	sum(SubTotal) as Total_Sales, 
	avg(SubTotal) as Avg_Price 
from Sales.SalesOrderHeader 
group by cast(datetrunc(year, OrderDate) as date)) 
select  
	Order_Date, 
	Total_Sales, 
	sum(Total_Sales)over(order by Order_Date) as Running_Total, 
	avg(Avg_Price)over(order by Order_Date) as Moving_Average 
from sales; 


/* =========================================================
   4. Total Sales by Product Category
   ---------------------------------------------------------
   Calculate total sales for each product category and
   determine each category's percentage contribution
   to overall sales.
   ========================================================= */

with cat_sale as (select pc.Name,sum(s.LineTotal) as Total_sales 
from Production.ProductCategory as pc 
left join Production.ProductSubcategory as ps 
on pc.ProductCategoryID = ps.ProductCategoryID 
left join Production.Product as p 
on ps.ProductSubcategoryID = p.ProductSubcategoryID 
left join Sales.SalesOrderDetail as s 
on s.ProductID = p.ProductID 
group by pc.Name) 
 
select  
	Name, 
	Total_sales, 
	sum(Total_sales)over() as overall_sales, 
	cast((Total_sales/sum(Total_sales)over())*100 as decimal(10,2)) percentage_of_totalsales 
from cat_sale  
order by percentage_of_totalsales desc; 


/* =========================================================
   5. Product Segmentation by Sales Performance
   ---------------------------------------------------------
   Segment products into three tiers based on total revenue:
   
   - High Value: >= 650K
   - Mid Value:  >= 120K
   - Low Value:  < 120K
   
   Then count the number of products in each tier.
   ========================================================= */

with Product_revenue as (select  
	p.ProductID, 
	p.Name, 
	pc.Name Category, 
	sum(s.LineTotal) as Total_revenue 
from Production.ProductCategory as pc 
left join Production.ProductSubcategory as ps 
on pc.ProductCategoryID = ps.ProductCategoryID 
left join Production.Product as p 
on ps.ProductSubcategoryID = p.ProductSubcategoryID 
inner join Sales.SalesOrderDetail as s 
on s.ProductID = p.ProductID 
group by p.ProductID,p.Name,pc.Name 
), 
ranks as (select  
	ProductID, 
	Name, 
	Category, 
	Total_revenue, 
	case WHEN Total_revenue >= 650000 THEN 'High_Value_Product'     
    WHEN Total_revenue >= 120000 THEN 'Mid_Value_Product'      
    ELSE 'Low_Value_Product'  end as Tier_of_Product 
from Product_revenue) 
 
select  
	Tier_of_Product, 
	count(ProductID) total_product 
from ranks 
group by Tier_of_Product; 


/* =========================================================
   6. B2C Customer Segmentation by Revenue & Lifespan
   ---------------------------------------------------------
   Segment B2C customers based on customer lifespan and
   total spending:
   
   - Platinum: >= 12 months and spending > 10,000
   - Gold:     >= 12 months and spending > 5,000
   - Silver:   >= 12 months and spending > 1,000
   - Bronze:   >= 12 months and spending <= 1,000
   - New:      < 12 months
   
   Then count the total number of customers in each group.
   ========================================================= */

with customer as (select  
	sc.CustomerID, 
	sum(sh.Subtotal) as Total_revenue,  
	datediff(MONTH, min(sh.OrderDate),max(sh.OrderDate)) as life_span 
from Sales.Customer sc 
inner join Sales.SalesOrderHeader as sh 
on sc.CustomerID = sh.CustomerID 
where sc.StoreID is null 
group by sc.CustomerID), 
 
customer_r as (select  
	CustomerID, 
	Total_revenue, 
	life_span, 
	case when life_span < 12 then 'New Customer' 
		 when life_span >= 12 and Total_revenue > 10000 then 'Platinum' 
		 when life_span >= 12 and Total_revenue > 5000 then 'Gold' 
		 when life_span >= 12 and Total_revenue > 1000 then 'Silver' 
		 else 'Bronze' end as Customer_rank 
from customer) 
 
select 
	Customer_rank, 
	count(Customer_rank) total_customer 
from customer_r 
group by Customer_rank 
order by total_customer desc;