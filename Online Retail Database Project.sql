Create database Store;

use Store;

create table customers(Customer_id INT PRIMARY KEY auto_increment,User_id VARCHAR(20)NOT NULL,Password VARCHAR(120)NOT NULL);

create table customer_accounts(Customer_account_id INT PRIMARY KEY auto_increment,Bank_account_number varchar(20)NOT NULL,Bank_name VARCHAR(20)NOT NULL,Customer_id INT,FOREIGN KEY(Customer_id)REFERENCES customers(Customer_id));

create table customer_orders(Customer_order_id INT PRIMARY KEY auto_increment,Customer_id INT,FOREIGN KEY(Customer_id)REFERENCES Customers(Customer_id),Total_price DECIMAL(10,2)NOT NULL,Customer_account_id INT,FOREIGN KEY(Customer_account_id)REFERENCES customer_accounts(Customer_account_id));

create table items(Item_id INT PRIMARY KEY auto_increment,Name VARCHAR(50)NOT NULL);

create table class(Class_id INT PRIMARY KEY auto_increment,Item_id INT,FOREIGN KEY(Item_id)REFERENCES items(Item_id),Max_price DECIMAL(10,2)NOT NULL,Class_type ENUM('A','B','C'));

create table suppliers(Supplier_id INT PRIMARY KEY auto_increment,Name VARCHAR(50)NOT NULL);

create table order_items(Order_item_id INT PRIMARY KEY auto_increment,Customer_order_id INT,FOREIGN KEY(Customer_order_id)REFERENCES customer_orders(Customer_order_id),Quantity INT NOT NULL,Price DECIMAL(10,2)NOT NULL,Supplier_id INT,FOREIGN KEY(Supplier_id)REFERENCES suppliers(Supplier_id),Class_id INT,FOREIGN KEY(Class_id)REFERENCES class(Class_id),Item_id INT,FOREIGN KEY(Item_id)REFERENCES items(Item_id));

create table supplier_items(Supplier_item_id INT PRIMARY KEY auto_increment,Supplier_id INT,FOREIGN KEY(Supplier_id)REFERENCES suppliers(Supplier_id),Commission INT NOT NULL,Class_id INT,FOREIGN KEY(Class_id)REFERENCES class(Class_id),Discount INT,Stock INT DEFAULT 0,Review DECIMAL(10,4),Number_reviews INT DEFAULT 0,Item_id INT,FOREIGN KEY(Item_id)REFERENCES items(Item_id));

create table preference_index(Preference_index_id INT PRIMARY KEY auto_increment,Supplier_item_id INT,FOREIGN KEY(Supplier_item_id)REFERENCES supplier_items(Supplier_item_id),index_val DECIMAL(10,5));

CREATE FUNCTION Calculate_preference_index(Commission INT,Review DECIMAL(10,4),Discount INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
RETURN 1/(1+exp((-1*1.0*Commission)+(-1*1.0*Review)+(-1*Discount)));

CREATE TRIGGER update_commission AFTER UPDATE ON supplier_items FOR EACH ROW 

UPDATE preference_index set index_val =Calculate_preference_index(new.Commission,new.Review,new.Discount);

insert into customers values(01,'USER_1','CSR1');
insert into customers values(02,'USER_2','CSR2');
insert into customers values(03,'USER_3','CSR3');
insert into customers values(04,'USER_4','CSR4');
insert into customers values(05,'USER_5','CSR5');
insert into customers values(06,'USER_6','CSR6');

select*from customers;

insert into customer_accounts values(01,'ACC_1','BNK1',01);
insert into customer_accounts values(02,'ACC_2','BNK2',02);
insert into customer_accounts values(03,'ACC_3','BNK3',03);
insert into customer_accounts values(04,'ACC_4','BNK4',04);
insert into customer_accounts values(05,'ACC_5','BNK5',05);
insert into customer_accounts values(06,'ACC_6','BNK6',06);

select*from customer_accounts;

insert into customer_orders values(1,1,1,1);
insert into customer_orders values(2,2,2,2);
insert into customer_orders values(3,3,3,3);
insert into customer_orders values(4,4,4,4);
insert into customer_orders values(5,5,5,5);
insert into customer_orders values(6,6,6,6);

select*from customer_orders;

insert into items values(1,'ITEM1');
insert into items values(2,'ITEM2');
insert into items values(3,'ITEM3');
insert into items values(4,'ITEM4');
insert into items values(5,'ITEM5');
insert into items values(6,'ITEM6');

select*from items;

insert into class values(1,1,1,'A');
insert into class values(2,2,2,'A');
insert into class values(3,3,3,'B');
insert into class values(4,4,4,'A');
insert into class values(5,5,5,'C');
insert into class values(6,6,6,'C');

select*from class;

insert into suppliers values(1,'supplier1');
insert into suppliers values(2,'supplier2');
insert into suppliers values(3,'supplier3');
insert into suppliers values(4,'supplier4');
insert into suppliers values(5,'supplier5');
insert into suppliers values(6,'supplier6');

select*from suppliers;

insert into order_items values(1,1,1,1,1,1,1);
insert into order_items values(2,2,2,2,2,2,2);
insert into order_items values(3,3,3,3,3,3,3);
insert into order_items values(4,4,4,4,4,4,4);
insert into order_items values(5,5,5,5,5,5,1);
insert into order_items values(6,6,6,6,6,6,2);

select*from order_items;

insert into supplier_items values(1,1,1,1,1,1,1,1,1);
insert into supplier_items values(2,2,2,2,2,2,2,2,2);
insert into supplier_items values(3,3,3,3,3,3,3,3,3);
insert into supplier_items values(4,4,4,4,4,4,4,4,4);
insert into supplier_items values(5,5,5,5,5,5,5,5,5);
insert into supplier_items values(6,6,6,6,6,6,6,6,6);

select*from supplier_items;

insert into preference_index values(1,1,1);
insert into preference_index values(2,2,2);
insert into preference_index values(3,3,3);
insert into preference_index values(4,4,4);
insert into preference_index values(5,5,5);
insert into preference_index values(6,6,6);

select*from preference_index;

/*ALL THE SELLERS FOR A GIVEN ITEM OF A GIVEN CLASS*/
select Name from suppliers where Supplier_id in (
select Supplier_id from supplier_items
where Class_id=1 and Item_id=1
);

/*BILL DETAILS*/
select customers.User_id,customer_accounts.Bank_account_number,Total_price
from customer_orders
join customers on customers.Customer_id=customer_orders.customer_id
join customer_accounts on customer_accounts.Customer_account_id=customer_orders.Customer_account_id
where Customer_order_id=1;

/*BILL ORDER DETAILS*/
select items.Name,Class_type,Price,suppliers.Name
from order_items
join class on order_items.item_id=class.Item_id
join suppliers on suppliers.Supplier_id=order_items.Supplier_id
join items on items.Item_id=order_items.Item_id
where customer_order_id=1;

/*Customer Details*/
select*from customer_accounts where Customer_id=1;

/*Stock of certain items with its seller nameand its class*/
select items.Name,class.Class_type,stock
from supplier_items
join items on items.Item_id=supplier_items.Item_id
join class on class.Class_id=supplier_items.Class_id
where supplier_items.Item_id=1;

/*All the products of a seller*/
select items.Name from items
join supplier_items on supplier_items.Item_id=items.Item_id
where supplier_id=1;

/*Commission details of all the sellers for a particular product*/
select suppliers.Name,commission
from suppliers

join supplier_items on supplier_items.Supplier_id=suppliers.Supplier_id
where item_id=1;