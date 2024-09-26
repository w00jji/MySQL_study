DROP DATABASE IF EXISTS tradingcomp; # 혹시나 tradingcomp DB가 있으면 이 이름과 동일한 DB를 삭제하는 명령문

CREATE DATABASE tradingcomp DEFAULT CHARSET  utf8mb4 COLLATE  utf8mb4_general_ci;

# DB 선택
USE tradingcomp;

# DDL
CREATE TABLE department(
  dept_no CHAR(2) PRIMARY KEY,
  dept_name VARCHAR(20)
 ) DEFAULT CHARSET=utf8mb4;




CREATE TABLE employee(
  Emp_no CHAR(3) PRIMARY KEY,
  name VARCHAR(20),
  eng_name VARCHAR(20),
  position VARCHAR(10),
  gender CHAR(2),
  birthday DATE,
  date_of_emp DATE,
  address VARCHAR(50),
  city VARCHAR(20),
  area VARCHAR(20),
  telephone VARCHAR(20),
  boss_number CHAR(3),
  Dept_no CHAR(2)
  ) DEFAULT CHARSET=utf8mb4;
  
 


CREATE TABLE customer(
   customer_no CHAR(5) PRIMARY KEY,
   customer_comp_name VARCHAR(30),
   person_in_charge_name VARCHAR(20),
   person_in_charge_pos VARCHAR(20),
   address VARCHAR(50),
   city VARCHAR(20),
   area VARCHAR(20),
   telephone VARCHAR(20),
   mileage INT
  ) DEFAULT CHARSET=utf8mb4;



CREATE TABLE products(
  product_no INT PRIMARY KEY,
  product_name VARCHAR(50),
  packaging VARCHAR(30),
  unit_price INT,
  inventory INT
  ) DEFAULT CHARSET=utf8mb4;




CREATE TABLE orders(
  order_no CHAR(5) PRIMARY KEY,
  customer_no CHAR(5),
  emp_no CHAR(3),
  order_date DATE,
  request_date DATE,
  shipment_date DATE
  ) DEFAULT CHARSET=utf8mb4;




CREATE TABLE order_details(
  order_no CHAR(5),
  product_no INT,
  unit_price INT,
  order_quantity INT,
  discount_rate FLOAT,
  PRIMARY KEY(order_no, product_no)
 ) DEFAULT CHARSET=utf8mb4;



  
CREATE TABLE mileage_level(
  grade_name CHAR(1) PRIMARY KEY,
  lower_mileage INT,
  upper_mileage INT
  ) DEFAULT CHARSET=utf8mb4;