-- -----------------------CLASSIC MODELS----------------------

-- Q1 Prepare a list of offices sorted by country, state, city.
SELECT `territory` as 'Office Location'
FROM offices
ORDER BY `country`, `state`, `city`;

-- Q2 How many employees are there in the company?
select count(distinct employeeNumber) as EmployeeCount from employees;

-- Q3 What is the total of payments received?
select sum(amount) as totalPayment from payments;

-- Q4 List the product lines that contain 'Cars'.
select productLine from productlines
where productLine like '%cars%';

-- Q5 Report total payments for October 28, 2004.
select paymentDate,amount from payments
where paymentDate ='2004-10-28';

-- Q6 Report those payments greater than $100,000.
select amount as paymentMorethan100000 from payments
where amount >='100000';

-- Q8- How many products in each product line?
select productLine, count(distinct productName) as productCount
from products
group by productLine;

-- Q7 -List the products in each product line.
select productLine, productName
from products
order by productLine;

-- Q9 What is the minimum payment received?
select min(amount) as MinAmt 
from payments;

-- Q10 List all payments greater than twice the average payment.
select amount from payments
where amount> 2*(select avg(amount) from payments);

-- Q11 What is the average percentage markup of the MSRP on buyPrice?
select avg(MSRP-buyPrice/MSRP)*100 as AverageMarkUp from products;

-- Q12 How many distinct products does ClassicModels sell?
select distinct(productName) from products
where productLine = "Classic Cars";

-- Q13 Report the name and city of customers who don't have sales representatives?
Select contactFirstName, city, salesRepEmployeeNumber
from customers
where salesRepEmployeeNumber is not null;

-- Q14 What are the names of executives with VP or Manager in their title? 
-- Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
select concat(firstName, lastName) as EmpName, jobTitle from employees
where jobTitle like '%VP%' or jobTitle like '%Manager%'; 

-- Q15 Which orders have a value greater than $5,000?
select orderNumber, sum(quantityOrdered*priceEach) from orderdetails
group by orderNumber
having sum(quantityOrdered*priceEach)> 5000
order by sum(quantityOrdered*priceEach);

-- Q16 Report the account representative for each customer.
select customerName, concat(e.firstName, " ", lastName) as 'Account Representative' from customers
inner join employees e on 
customers.salesRepEmployeeNumber = e.employeeNumber;

-- Q17 Report total payments for Atelier graphique.
select c.customerName, sum(payments.amount) 
from payments
inner join customers c on
payments.customerNumber = c.customerNumber
where c.customerName = "Atelier graphique"
group by c.customerName;

-- Q18 Report the total payments by date
select paymentDate, sum(amount)
from payments
group by paymentDate
order by paymentDate asc;

-- Q19 Report the products that have not been sold.
select * from products
where not exists (select productCode from orderdetails 
				where products.productCode = orderdetails.productCode);
                
-- Q20 List the amount paid by each customer.
select customerName, orders.customerNumber, round(sum(orderdetails.quantityOrdered*orderdetails.priceEach),2) as "Amount Paid"
from customers
inner join orders
on customers.customerNumber = orders.customerNumber
inner join orderdetails
on orders.orderNumber = orderdetails.orderNumber
group by orders.customerNumber, customers.customerName
order by sum(orderdetails.quantityOrdered*orderdetails.priceEach) desc;

-- Q21 How many orders have been placed by Herkku Gifts?
select customerName, sum(quantityOrdered) as 'Quantity ordered'
from customers
inner join orders
on customers.customerNumber = orders.customerNumber
inner join orderdetails
on orders.orderNumber = orderdetails.orderNumber
where customers.customerName = "Herkku Gifts"
group by customers.customerName;

-- Q22 Who are the employees in Boston?
select concat(firstName,' ', lastName) as Name, city
from employees
inner join offices
on employees.officeCode = offices.officeCode
where city = "Boston";

-- Q23 Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first.
select  customers.customerName, sum(amount) as 'Total Payments'
from payments
join customers
on customers.customerNumber = payments.customerNumber
where amount > 100000
group by customers.customerName
order by customers.customerName desc;

-- Q24 List the value of 'On Hold' orders.
select orders.orderNumber, products.productName
from orders
join orderdetails
on orderdetails.orderNumber = orders.orderNumber
join products
on orderdetails.productCode = products.productCode
where orders.status = 'On Hold';

-- Q25 Report the number of orders 'On Hold' for each customer.
select customerName, count(*) as 'on hold order count'
from customers
join orders
on customers.customerNumber = orders.customerNumber
where status = 'On Hold'
group by customerName;



-- -------------------ONE TO MANY RELATIONSHIPS--------------------------------



-- Q1 List products sold by order date.
select products.productName, orders.orderDate from products
join orderdetails
on products.productCode = orderdetails.productCode
join orders 
on orders.orderNumber = orderdetails.orderNumber;

-- Q2 List the order dates in descending order for orders for the 1940 Ford Pickup Truck.
select products.productName, orders.orderDate from products
join orderdetails
on products.productCode = orderdetails.productCode
join orders 
on orders.orderNumber = orderdetails.orderNumber
where products.productName = "1940 Ford Pickup Truck"
order by orders.orderDate desc;

-- Q3 List the names of customers and their corresponding order number 
--    where a particular order from that customer has a value greater than $25,000?
select customers.customerName, orders.orderNumber, sum(orderdetails.quantityOrdered*orderdetails.priceEach) as total_value from customers
join orders on
customers.customerNumber = orders.customerNumber
join orderdetails on
orders.orderNumber = orderdetails.orderNumber
group by customers.customerName, orders.orderNumber
having total_value > 25000
order by customers.customerName;

-- Q5 List the names of products sold at less than 80% of the MSRP.
select products.productName, products.MSRP
from products
JOIN orderdetails on products.productCode = orderdetails.productCode
where orderdetails.priceEach < (0.8*products.MSRP)
order by products.MSRP desc;

-- Q6 Reports those products that have been sold with a markup of 100% or more
select products.productCode, products.productName, products.buyPrice, orderdetails.priceEach
from products
join orderdetails
on products.productCode = orderdetails.productCode
where orderdetails.priceEach > 2*products.buyPrice;

-- Q7 List the products ordered on a Monday.
select products.productName, orders.orderDate, dayname(orders.orderDate) as day from products
join orderdetails
on products.productCode = orderdetails.productCode
join orders 
on orders.orderNumber = orderdetails.orderNumber
where dayname(orders.orderDate) = "Monday";




-- ----------------------MANY TO MANY RELATIONSHIPS---------------------------




-- Q1 Find products containing the name 'Ford'.
select productName from products
where productName like "%Ford%";

-- Q2 List products ending in 'ship'.
select productName from products
where productName like "%ship%";

-- Q3 Report the number of customers in Denmark, Norway, and Sweden.
select customerName, country from customers
where country in("Denmark", "Norway", "Sweden");

-- Q4 What are the products with a product code in the range S700_1000 to S700_1499?
select productCode, productName from products where 
right(productCode,4) between 1000 and  1499
order by right(productCode, 4);

-- Q5 Which customers have a digit in their name?
select customerName from customers
where customerName rlike '[0-9]';

-- Q6 List the names of employees called Dianne or Diane.
select concat(firstName,' ', lastName) as empName
from employees
where concat(firstName,' ', lastName) like "%Dianne%" or  concat(firstName,' ', lastName) like "%Diane%";

-- Q7 List the products containing ship or boat in their product name.
select productName from products
where productName rlike 'ship|boat';

-- Q8 List the products with a product code beginning with S700.
select productCode, productName from products
where productCode like '%S700%';

-- Q9 List the names of employees called Larry or Barry.
select concat(firstName," ", lastName) as EmpName from employees
where concat(firstName," ", lastName) rlike 'Larry|Barry';

-- Q10 List the names of employees with non-alphabetic characters in their names.
select concat(firstName," ", lastName) as EmpName from employees
where concat(firstName," ", lastName) rlike '[0-9%@]';

-- Q11 List the vendors whose name ends in Diecast
select productVendor from products
where productVendor like '%Diecast%';



-- --------------- GENERAL Queries --------------------------




-- Q1 Who is at the top of the organization (i.e.,  reports to no one).
select concat(firstName," ", lastName) as EmpName, reportsTo from employees
where reportsTo is null;

-- Q2 Who reports to William Patterson?
select concat(firstName," ", lastName) as EmpName, reportsTo from employees
where reportsTo = 1088;

-- Q3 List all the products purchased by Herkku Gifts.
select customers.customerName, products.productName from customers
join orders on
customers.customerNumber = orders.customerNumber
join orderdetails on
orders.orderNumber = orderdetails.orderNumber
join products on 
orderdetails.productCode = products.productCode
where customers.customerName = "Herkku Gifts";

-- Q4 Compute the commission for each sales representative, assuming the commission is 5% of the value of an order. 
-- Sort by employee last name and first name.
select employeeNumber, concat(firstName," ", lastName) as EmpName, sum((amount*5)/100) as commission
from employees e
join customers c
on e.employeeNumber = c.salesRepEmployeeNumber
join payments p
on c.customerNumber = p.customerNumber
group by e.employeeNumber;

-- Q5 What is the difference in days between the most recent and oldest order date in the Orders file?
select max(orderDate), min(orderDate), datediff(max(orderDate), min(orderDate)) from orders;

-- Q6 Compute the average time between order date and ship date for each customer ordered by the largest difference.
select customerNumber, avg(datediff(shippedDate, orderDate)) from orders 
group by customerNumber
order by avg(datediff(orderDate, shippedDate)) asc;

-- Q7 What is the value of orders shipped in August 2004?
select format(sum(quantityOrdered*priceEach), 0)
from orderdetails o
join orders
on o.orderNumber = orders.orderNumber
where year(orderDate) = 2004 and month(orderDate) = 8;

-- Q8 Compute the total value ordered, total amount paid, and their difference for each customer 
-- for orders placed in 2004 and payments received in 2004 (Hint; Create views for the total paid and total ordered).
create view pay2004(customerName, payTotal)
as select customerName, sum(amount) from customers
join payments on customers.customerNumber = payments.customerNumber
and year(paymentDate) = 2004 group by customerName;
create view tot2004(customerName, orderTotal)
as select customerName, sum(quantityOrdered*priceEach) from orderdetails o
join orders on o.orderNumber = orders.orderNumber
join customers c on orders.customerNumber = c.customerNumber group by customerName;
select pay2004.customerName as Customer , format(pay2004.payTotal, 0) as Payments , 
format(tot2004.orderTotal, 0) as ValueOrdered, format(orderTotal- payTotal, 0) as Difference
from pay2004 join tot2004
on pay2004.customerName = tot2004.customerName
where abs(orderTotal- payTotal) > 100;

-- Q9 List the employees who report to those employees who report to Diane Murphy. 
-- Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
select concat(firstName, " ", lastName) as EmpName from employees where reportsTo IN
(select employeeNumber from employees where reportsTo = 
(select employeeNumber from employees
where firstName = 'Diane' AND lastName = 'Murphy'));

-- Q13 What is the value of payments received in July 2004?
select sum(amount)
from payments
where year(paymentDate) = 2004 and month(paymentDate) = 7;


-- Q14 What is the ratio of the value of payments made to orders received for each month of 2004?
with
t1 as (select month(paymentDate) as period, sum(amount) as payments from payments
where year(paymentDate) = 2004
group by month(paymentDate)),
t2 as (select month(orderDate) as period, sum(quantityOrdered*priceEach) as orders from orders, orderdetails
where orders.orderNumber = orderdetails.orderNumber
and year(orderDate)= 2004
group by month(orderDate))
select t1.period, format(payments/orders, 2) as Ratio from t1
join t2
on t1.period = t2.period;

-- Q15 What is the difference in the amount received for each month of 2004 compared to 2003?
with 
t1 as (select year(paymentDate) as year, month(paymentDate) as month, sum(amount) as payments2003 from payments
where year(paymentDate) = 2003
group by year(paymentDate) , month(paymentDate)),
t2 as (select year(paymentDate) as year, month(paymentDate) as month,sum(amount) as payments2004 from payments
where year(paymentDate) = 2004
group by year(paymentDate), month(paymentDate))
select t1.month, format((payments2004- payments2003),2) from t1
join t2
on t1.month = t2.month
order by t1.month desc;

-- Q28 Find the customers without payments in 2003.
select distinct customerName from customers
join payments on customers.customerNumber = payments.customerNumber
where customerName not in 
(select customerName from customers
join payments on customers.customerNumber = payments.customerNumber
where year(paymentDate) = 2004);

-- Q27 Find the products sold in 2003 but not 2004.
select productCode from orderdetails o
join orders
on o.orderNumber = orders.orderNumber
where year(orderDate) = 2003
and o.productCode not in 
(select productCode from orderdetails o
join orders
on o.orderNumber = orders.orderNumber
where year(orderDate) = 2004);

-- Q26 Compute the ratio of payments for each customer for 2003 versus 2004.
with 
t2003 as (select customerName, c.customerNumber, sum(amount) as Payments from payments
join customers c on payments.customerNumber = c.customerNumber
where year(paymentDate) = 2003
group by customerNumber),
t2004 as (select customerName,  c.customerNumber, sum(amount) as Payments from payments
join customers c on payments.customerNumber = c.customerNumber
where year(paymentDate) = 2004
group by customerNumber)
select t2003.customerName as Customers, format(t2003.Payments, 0) as Y2003, 
format(t2004.Payments, 0) as Y2004, format(t2004.Payments/t2003.Payments, 2) as Ratio
from t2003 join t2004
on t2003.customerNumber = t2004.customerNumber
order by t2004.Payments/t2003.Payments;

-- Q25 Compute the ratio for each product of sales for 2003 versus 2004.
with
t2003 as (select productName, products.productCode, sum(quantityOrdered*priceEach) as totVal from 
orders 
join orderdetails  on orders.orderNumber = orderdetails.orderNumber
join products on orderdetails.productCode = products.productCode
where year(orderDate) = 2003
group by products.productCode),
t2004 as (select productName, products.productCode, sum(quantityOrdered*priceEach) as totVal from 
orders 
join orderdetails  on orders.orderNumber = orderdetails.orderNumber
join products on orderdetails.productCode = products.productCode
where year(orderDate) = 2004
group by products.productCode)
select t2003.productName, format(t2003.totVal, 0) as Y2003, format(t2004.totVal, 0) as Y2004, format(t2004.totVal/t2003.totVal, 2) as Ratio
from t2003 join t2004 on t2003.productCode = t2004. productCode
order by t2004.totVal/t2003.totVal desc;

-- Q24 Compute the profit generated by each product line, sorted by profit descending.
SELECT productLine AS `Product line`, FORMAT(SUM(quantityOrdered*(priceEach -buyPrice)),0) AS Profit
FROM Products JOIN OrderDetails
ON Products.productCode = OrderDetails.productCode
GROUP BY productLine
ORDER BY SUM(quantityOrdered*(priceEach -buyPrice)) DESC;


