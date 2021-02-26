# Universidad EAFIT
# Curso ST1800 Almacenamiento y Recuperación de Información - 2021-1
# Profesor: Edwin Montoya M. – emontoya@eafit.edu.co
#
-- Scripts de HIVE
#

-- datos de conexión:

Mysql en Amazon
host: X.X.X.X
Database: retail_db
Username: retail_dba
Password: retail_dba

-- crear la base de datos retail_db

** por interfaz web (HUE:8888):

    DROP DATABASE IF EXISTS username_retail_db CASCADE;
    CREATE DATABASE IF NOT EXISTS username_retail_db;


# conectarse al nodo master:
## si es en AWS EMR, en la consola de administración aparece el archivo clave y el hostname
# si es en AWS EMR con el usuario 'hadoop', usuario por defecto

** importar datos via sqoop por Terminal:

-- la primera vez para crear las tablas e importar

$ sqoop import-all-tables --connect jdbc:mysql://X.X.X.X:3306/retail_db --username retail_dba --password retail_dba --hive-database username_retail_db --create-hive-table --hive-import

-- despues de la primera vez, para importar nuevos datos y sobre escribir:
$ sqoop import-all-tables --connect jdbc:mysql://X.X.X.X:3306/retail_db --username retail_dba --password retail_dba --hive-database username_retail_db --hive-import --hive-overwrite

** importar datos via sqoop por Terminal:

-- la primera vez para crear las tablas e importar

$ sqoop import-all-tables --connect jdbc:mysql://X.X.X.X:3306/retail_db --username retail_dba --password retail_dba --hive-database username_retail_db --create-hive-table --hive-import

-- despues de la primera vez, para importar nuevos datos y sobre escribir:
$ sqoop import-all-tables --connect jdbc:mysql://X.X.X.X:3306/retail_db --username retail_dba --password retail_dba --hive-database username_retail_db --hive-import --hive-overwrite

-- importar datos via sqoop por HUE (NO COLOCA LA PALABRA 'sqoop' y utilice los mismos comandos anteriores) - via web no corre en el DCA.

-- CATEGORIAS MÁS POPULARES DE PRODUCTOS (via HUE o DSA)

USE username_retail_db;
SELECT c.category_name, count(order_item_quantity) as count
FROM order_items oi
inner join products p on oi.order_item_product_id = p.product_id
inner join categories c on c.category_id = p.product_category_id
group by c.category_name
order by count desc
limit 10;

-- top 10 de productos que generan ganancias

USE username_retail_db;
SELECT p.product_id, p.product_name, r.revenue
FROM products p inner join
(select oi.order_item_product_id, sum(cast(oi.order_item_subtotal as float)) as revenue
from order_items oi inner join orders o
on oi.order_item_order_id = o.order_id
where o.order_status <> 'CANCELED'
and o.order_status <> 'SUSPECTED_FRAUD'
group by order_item_product_id) r
on p.product_id = r.order_item_product_id
order by r.revenue desc
limit 10;