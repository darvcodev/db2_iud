/* Verificación de la existencia de las tablas en la base de datos jardineria_IUD_staging */
CREATE TABLE IF NOT EXISTS jardineria_IUD_staging.Categoria_producto LIKE jardineria_IUD.Categoria_producto;
CREATE TABLE IF NOT EXISTS jardineria_IUD_staging.cliente LIKE jardineria_IUD.cliente;
CREATE TABLE IF NOT EXISTS jardineria_IUD_staging.detalle_pedido LIKE jardineria_IUD.detalle_pedido;
CREATE TABLE IF NOT EXISTS jardineria_IUD_staging.empleado LIKE jardineria_IUD.empleado;
CREATE TABLE IF NOT EXISTS jardineria_IUD_staging.oficina LIKE jardineria_IUD.oficina;
CREATE TABLE IF NOT EXISTS jardineria_IUD_staging.pago LIKE jardineria_IUD.pago;
CREATE TABLE IF NOT EXISTS jardineria_IUD_staging.pedido LIKE jardineria_IUD.pedido;
CREATE TABLE IF NOT EXISTS jardineria_IUD_staging.producto LIKE jardineria_IUD.producto;

/* Extracción de Datos desde la Base de Datos Origen */
INSERT INTO jardineria_IUD_staging.Categoria_producto SELECT * FROM jardineria_IUD.Categoria_producto;
INSERT INTO jardineria_IUD_staging.cliente SELECT * FROM jardineria_IUD.cliente;
INSERT INTO jardineria_IUD_staging.detalle_pedido SELECT * FROM jardineria_IUD.detalle_pedido;
INSERT INTO jardineria_IUD_staging.empleado SELECT * FROM jardineria_IUD.empleado;
INSERT INTO jardineria_IUD_staging.oficina SELECT * FROM jardineria_IUD.oficina;
INSERT INTO jardineria_IUD_staging.pago SELECT * FROM jardineria_IUD.pago;
INSERT INTO jardineria_IUD_staging.pedido SELECT * FROM jardineria_IUD.pedido;
INSERT INTO jardineria_IUD_staging.producto SELECT * FROM jardineria_IUD.producto;

/* Verifica que los datos se hayan copiado correctamente */
SELECT COUNT(*) FROM jardineria_IUD_staging.Categoria_producto;
SELECT COUNT(*) FROM jardineria_IUD_staging.cliente;
SELECT COUNT(*) FROM jardineria_IUD_staging.producto;
SELECT COUNT(*) FROM jardineria_IUD_staging.pedido;
SELECT COUNT(*) FROM jardineria_IUD_staging.oficina;
SELECT COUNT(*) FROM jardineria_IUD_staging.empleado;

/* Simple transformación de datos */
UPDATE jardineria_IUD_staging.producto
SET nombre = UPPER(nombre);

CREATE TABLE jardineria_IUD_staging.productos_oferta AS
SELECT p.ID_producto, p.nombre, SUM(dp.cantidad * dp.precio_unidad) AS total_oferta
FROM jardineria_IUD_staging.detalle_pedido dp
JOIN jardineria_IUD_staging.producto p ON dp.ID_producto = p.ID_producto
GROUP BY p.ID_producto, p.nombre;

/* Carga de datos en el Data Mart */
CREATE TABLE IF NOT EXISTS DataMart.productos_oferta
(
    ID_producto INT PRIMARY KEY,
    nombre VARCHAR(70),
    total_oferta DECIMAL(15, 2)
);

/* Carga de datos en el Data Mart */
INSERT INTO DataMart.productos_oferta (ID_producto, nombre, total_oferta)
SELECT ID_producto, nombre, total_oferta
FROM jardineria_IUD_staging.productos_oferta;

/* Creación de las tablas en el Data Mart */
CREATE TABLE IF NOT EXISTS DataMart.dim_producto (
    ID_producto INT PRIMARY KEY,
    nombre VARCHAR(70),
    Categoria INT,
    dimensiones VARCHAR(25),
    proveedor VARCHAR(50),
    descripcion TEXT,
    cantidad_en_stock SMALLINT,
    precio_venta DECIMAL(15, 2)
);

CREATE TABLE IF NOT EXISTS DataMart.dim_cliente (
    ID_cliente INT PRIMARY KEY,
    nombre_cliente VARCHAR(50),
    nombre_contacto VARCHAR(30),
    apellido_contacto VARCHAR(30),
    telefono VARCHAR(15),
    fax VARCHAR(15),
    linea_direccion1 VARCHAR(50),
    linea_direccion2 VARCHAR(50),
    ciudad VARCHAR(50),
    region VARCHAR(50),
    pais VARCHAR(50),
    codigo_postal VARCHAR(10),
    ID_empleado_rep_ventas INT,
    limite_credito DECIMAL(15, 2)
);

CREATE TABLE IF NOT EXISTS DataMart.dim_empleado (
    ID_empleado INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido1 VARCHAR(50),
    apellido2 VARCHAR(50),
    extension VARCHAR(10),
    email VARCHAR(100),
    ID_oficina INT,
    ID_jefe INT,
    puesto VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS DataMart.hechos_ventas (
    ID_fact INT AUTO_INCREMENT PRIMARY KEY,
    ID_pedido INT,
    ID_producto INT,
    ID_cliente INT,
    ID_empleado INT,
    fecha_pedido DATE,
    cantidad INT,
    precio_total DECIMAL(15, 2),
    FOREIGN KEY (ID_producto) REFERENCES DataMart.dim_producto(ID_producto),
    FOREIGN KEY (ID_cliente) REFERENCES DataMart.dim_cliente(ID_cliente),
    FOREIGN KEY (ID_empleado) REFERENCES DataMart.dim_empleado(ID_empleado)
);

CREATE TABLE IF NOT EXISTS DataMart.dim_tiempo (
    fecha DATE PRIMARY KEY,
    dia TINYINT,
    mes TINYINT,
    anio SMALLINT,
    trimestre TINYINT
);

/* Carga de datos en las tablas del Data Mart */
INSERT INTO DataMart.dim_producto (ID_producto, nombre, Categoria, dimensiones, proveedor, descripcion, cantidad_en_stock, precio_venta)
SELECT ID_producto, nombre, Categoria, dimensiones, proveedor, descripcion, cantidad_en_stock, precio_venta
FROM jardineria_IUD_staging.producto;

INSERT INTO DataMart.dim_cliente (ID_cliente, nombre_cliente, nombre_contacto, apellido_contacto, telefono, fax, linea_direccion1, linea_direccion2, ciudad, region, pais, codigo_postal, ID_empleado_rep_ventas, limite_credito)
SELECT ID_cliente, nombre_cliente, nombre_contacto, apellido_contacto, telefono, fax, linea_direccion1, linea_direccion2, ciudad, region, pais, codigo_postal, ID_empleado_rep_ventas, limite_credito
FROM jardineria_IUD_staging.cliente;

INSERT INTO DataMart.dim_empleado (ID_empleado, nombre, apellido1, apellido2, extension, email, ID_oficina, ID_jefe, puesto)
SELECT ID_empleado, nombre, apellido1, apellido2, extension, email, ID_oficina, ID_jefe, puesto
FROM jardineria_IUD_staging.empleado;

INSERT INTO DataMart.dim_tiempo (fecha, dia, mes, anio, trimestre)
SELECT fecha_pedido, DAY(fecha_pedido), MONTH(fecha_pedido), YEAR(fecha_pedido),
CASE
    WHEN MONTH(fecha_pedido) IN (1,2,3) THEN 1
    WHEN MONTH(fecha_pedido) IN (4,5,6) THEN 2
    WHEN MONTH(fecha_pedido) IN (7,8,9) THEN 3
    ELSE 4
END
FROM (SELECT DISTINCT fecha_pedido FROM jardineria_IUD_staging.pedido) AS fechas;

INSERT INTO DataMart.hechos_ventas (ID_pedido, ID_producto, ID_cliente, ID_empleado, fecha_pedido, cantidad, precio_total)
SELECT dp.ID_pedido, dp.ID_producto, p.ID_cliente, e.ID_empleado, p.fecha_pedido, dp.cantidad, dp.cantidad * dp.precio_unidad
FROM jardineria_IUD_staging.detalle_pedido dp
JOIN jardineria_IUD_staging.pedido p ON dp.ID_pedido = p.ID_pedido
JOIN jardineria_IUD_staging.empleado e ON p.ID_cliente = e.ID_empleado;

/* Verificación de la carga de datos en el Data Mart */
SELECT COUNT(*) FROM DataMart.dim_producto;
SELECT COUNT(*) FROM DataMart.dim_cliente;
SELECT COUNT(*) FROM DataMart.dim_empleado;
SELECT COUNT(*) FROM DataMart.dim_tiempo;
SELECT COUNT(*) FROM DataMart.hechos_ventas;


/*  Limpieza de Datos (Eliminación de Registros Duplicados) */
DELETE FROM jardineria_IUD_staging.cliente
WHERE ID_cliente IN (
    SELECT ID_cliente
    FROM (
        SELECT ID_cliente, ROW_NUMBER() OVER (PARTITION BY ID_cliente ORDER BY ID_cliente) AS rn
        FROM jardineria_IUD_staging.cliente
    ) t
    WHERE rn > 1
);

/* Normalización de Datos (División de Campos de Texto) */
UPDATE jardineria_IUD_staging.cliente
SET nombre_cliente = LEFT(nombre_cliente, 50);

/* Enriquecimiento de Datos (Agregar Nueva Columna Derivada) */
ALTER TABLE jardineria_IUD_staging.cliente
ADD COLUMN nombre_completo VARCHAR(100);
/* Actualización de la nueva columna */
UPDATE jardineria_IUD_staging.cliente
SET nombre_completo = CONCAT(nombre_cliente, ' ', apellido_contacto);
