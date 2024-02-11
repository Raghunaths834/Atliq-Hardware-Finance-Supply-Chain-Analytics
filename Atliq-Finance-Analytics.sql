-- month
-- product name
-- variant
-- sold quantity
-- Gross price per item
-- gross price total
SELECT * FROM gdb0041.fact_sales_monthly where customer_code = 90002002 and year(date) = 2020 
order by date desc;
SELECT YEAR(DATE_ADD(DATE, INTERVAL 4 MONTH));
SELECT * FROM gdb0041.fact_sales_monthly where customer_code = 90002002 and 
YEAR(DATE_ADD(DATE, INTERVAL 4 MONTH)) = 2021
order by date desc;

SELECT * FROM gdb0041.fact_sales_monthly where customer_code = 90002002 and 
get_fisical_year(date) = 2021
order by date asc;

SELECT * FROM gdb0041.fact_sales_monthly 
where customer_code = 90002002 and 
get_fisical_year(date) = 2021 and 
get_fisical_quater(date) = "Q4"
order by date desc;

SELECT * FROM gdb0041.dim_product;

-- sold quantity
SELECT s.date, p.product_code, p.product,p.variant,s.sold_quantity 
FROM gdb0041.fact_sales_monthly s join dim_product p 
on p.product_code = s.product_code
where customer_code = 90002002 and 
get_fisical_year(date) = 2021 and
get_fisical_quater(date) = "Q4"
order by date desc;


-- Gross price per item
SELECT s.date, p.product_code, p.product,p.variant,s.sold_quantity , g.gross_price
FROM gdb0041.fact_sales_monthly s 
join dim_product p 
on p.product_code = s.product_code
join fact_gross_price g 
on
  g.product_code = s.product_code and 
  g.fiscal_year = get_fisical_year(s.date)
where 
customer_code = 90002002  and 
get_fisical_year(date) = 2021 
order by date desc;


-- gross price total
SELECT s.date, p.product_code, p.product,p.variant,s.sold_quantity , g.gross_price, round(g.gross_price*s.sold_quantity) 
as gross_price_total
FROM gdb0041.fact_sales_monthly s 
join dim_product p 
on p.product_code = s.product_code
join fact_gross_price g 
on
  g.product_code = s.product_code and 
  g.fiscal_year = get_fisical_year(s.date)
where 
customer_code = 90002002 and 
get_fisical_year(date) = 2021 
order by date asc;



SELECT * FROM gdb0041.fact_sales_monthly s join fact_gross_price g 
on s.product_code = g.product_code and
g.fiscal_year = get_fisical_year(s.date)
where customer_code = 90002002 
order by s.date asc;

-- monthly sales report 
SELECT s.date, SUM(g.gross_price * s.sold_quantity) as gross_price_total 
FROM gdb0041.fact_sales_monthly s join fact_gross_price g 
on s.product_code = g.product_code and
g.fiscal_year = get_fisical_year(s.date)
where customer_code = 90002002
group by s.date
order by s.date asc;

-- croma yerly gross sale report
SELECT get_fisical_year(s.date) as fiscal_year, SUM(g.gross_price * s.sold_quantity) 
as gross_price_total FROM gdb0041.fact_sales_monthly s join fact_gross_price g 
on s.product_code = g.product_code and
g.fiscal_year = get_fisical_year(s.date)
where customer_code = 90002002
group by get_fisical_year(s.date)
order by fiscal_year;

-- THEN WE CREATED A STORED PROCEDURE FOR MONTHLY SALES REPORT
-- THEN WE CREATED A STORED PROCEDURE FOR yearly SALES REPORT
-- STORED PROCEDURE FOR MARKET BADGE


select market,sum(sold_quantity) as total_quantity from fact_sales_monthly s join dim_customer c
on s.customer_code = c.customer_code 
where get_fisical_year(s.date)=2021 and market = "India"
group by c.market;


