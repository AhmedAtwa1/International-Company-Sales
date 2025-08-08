
---- 1. Remove Duplicate Records
WITH DuplicateRows AS (
    SELECT 
        id, 
        ROW_NUMBER() OVER (PARTITION BY first_name, last_name ORDER BY id) AS RowNum
    FROM Users
)
DELETE FROM DuplicateRows WHERE RowNum > 1;


-- 2. Remove left and right Spaces
update Users
set first_name = trim(first_name) , last_name = trim(last_name);


-- 3. Fill Missing Values (NULL Replacement)
update Orders
set shipped_at = coalesce (shipped_at,'UnKnown')
where shipped_at is null;

update Orders
set delivered_at = coalesce (delivered_at,'UnKnown')
where delivered_at is null;

update OrderItems
set shipped_at = coalesce (shipped_at,'UnKnown')
where shipped_at is null;

update OrderItems
set delivered_at = coalesce (delivered_at,'UnKnown')
where delivered_at is null;

update OrderItems
set returned_at = coalesce (returned_at,'UnKnown')
where returned_at is null;

update InventoryItems	
set product_brand = coalesce (product_brand,'UnKnown')
where product_brand is null;


-- 4. Remove Invalid Data (Invalid Email Format)
delete from Users
where email not like '%@%.%'; 



-- 6. Normalize Data (Convert to Uppercase)
update Products
set brand = UPPER(brand);



-- 7. Fill Missing Data Using Averages
update Products
set cost = (select avg(cost) from Products)
where cost is null;

-- Views
create view TotalUsresByGender as
select gender , count(*) as TotalUsers
from Users 
group by gender;


create view Quantity_of_products_in_inventory_by_category as
select product_category , count(product_id) as TotalProducts
from InventoryItems 
group by product_category;


create view Total_products_by_department as
select department , count(*) as TotalProducts
from Products 
group by department;


create view top_5_users_by_ordes as
select top 5 u.first_name + ' ' + u.last_name as "User Name",count (o.order_id) as TotalOrders
from Orders o 
join Users u on o.user_id = u.id
group by u.first_name, u.last_name
order by TotalOrders desc;


create view Top_5_products_sold as
select top 5 name , count(*)as Total_products
from Products 
group by name
order by Total_products desc;


create view Top_5_countries_by_number_of_orders as
select top 5 u.country , count(*) as Total_Orders
from Orders o
join Users u on u.id = o.user_id
group by u.country
order by Total_Orders desc;


create view Top_5_cities_by_number_of_orders as
select top 5 u.city , count(*) as Total_Orders
from Orders o
join Users u on u.id = o.user_id
group by u.city
order by Total_Orders desc;






