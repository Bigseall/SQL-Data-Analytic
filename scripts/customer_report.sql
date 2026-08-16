/* =========================================================
   Customer Summary Report
   ---------------------------------------------------------
   Create a customer-level report for B2C customers that
   summarizes purchase behavior and customer value.

   Metrics include:
   - Customer name and country
   - Customer rank based on lifespan and total revenue
   - Total revenue and total orders
   - Average order value
   - Average monthly spend
   - First and last order dates
   - Customer lifespan in months
   ========================================================= */

create view Sales.vCustomerSummaryReport as
with Customers as (select 
	sc.CustomerID,
	pp.FirstName +' '+ pp.LastName as Full_Name,
	st.Name as Ter,
	sum(sh.Subtotal) as Total_revenue,
	count(distinct sh.SalesOrderID) as Total_Orders,
	cast(min(sh.OrderDate) AS date) as First_Order_Date,
    cast(max(sh.OrderDate) AS date) as Last_Order_Date,
	datediff(month, min(sh.OrderDate),max(sh.OrderDate)) as life_span
from Person.Person as pp
left join Sales.Customer sc
ON sc.PersonID = pp.BusinessEntityID
inner join Sales.SalesOrderHeader as sh
on sc.CustomerID = sh.CustomerID
left join Sales.SalesTerritory as st 
on sc.TerritoryID = st.TerritoryID
where sc.StoreID is null 
group by sc.CustomerID, pp.FirstName, pp.LastName,st.Name)
select 
	CustomerID,
	Full_Name,
	case 
		when Ter in ('Northwest','Northeast','Central','Southwest','Southeast') then 'United States'
		else Ter end as Country,
	case when life_span < 12 then 'New Customer'
		 when life_span >= 12 and Total_revenue > 10000 then 'Platinum'
		 when life_span >= 12 and Total_revenue > 5000 then 'Gold'
		 when life_span >= 12 and Total_revenue > 1000 then 'Silver'
		 else 'Bronze' end as Customer_rank,
	Total_revenue,
	Total_Orders,
	round(Total_revenue / Total_Orders, 2) as Avg_Order_Value,
	case when life_span = 0 then Total_revenue
		 else round(Total_revenue/life_span,2) end as Avg_Monthly_Spend,
	First_Order_Date,
	Last_Order_Date,
	life_span
from Customers;

select * 
from Sales.vCustomerSummaryReport;