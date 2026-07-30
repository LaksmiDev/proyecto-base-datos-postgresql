-- =====================================================
-- CONSULTAS BÁSICAS: TIENDA DE JUGUETES
-- Responsable: Gianluca
-- =====================================================

-- 1. Mostrar todos los productos
SELECT *
FROM productos;

-- 2. Mostrar productos ordenados por precio
SELECT
    id_producto,
    nombre,
    marca,
    precio,
    stock
FROM productos
ORDER BY precio DESC;

-- 3. Mostrar productos con precio mayor a 50
SELECT
    nombre,
    precio,
    stock
FROM productos
WHERE precio > 50
ORDER BY precio DESC;

-- 4. Mostrar productos con poco stock
SELECT
    nombre,
    stock
FROM productos
WHERE stock < 20
ORDER BY stock ASC;

-- 5. Buscar productos de una marca
SELECT
    nombre,
    marca,
    precio
FROM productos
WHERE marca ILIKE '%Hasbro%';

-- 6. Mostrar clientes activos
SELECT
    id_cliente,
    nombres,
    apellidos,
    documento,
    correo
FROM clientes
WHERE estado = TRUE
ORDER BY apellidos, nombres;

-- 7. Contar productos
SELECT COUNT(*) AS total_productos
FROM productos;

-- 8. Precio promedio de los juguetes
SELECT
    ROUND(AVG(precio), 2) AS precio_promedio
FROM productos;

-- 9. Producto más caro y más barato
SELECT
    MAX(precio) AS precio_maximo,
    MIN(precio) AS precio_minimo
FROM productos;

-- 10. Cantidad de productos por categoría
SELECT
    id_categoria,
    COUNT(*) AS cantidad_productos
FROM productos
GROUP BY id_categoria
ORDER BY cantidad_productos DESC;

-- 11. Total vendido por método de pago
SELECT
    metodo_pago,
    COUNT(*) AS cantidad_ventas,
    SUM(total) AS total_vendido
FROM ventas
WHERE estado = 'REGISTRADA'
GROUP BY metodo_pago
ORDER BY total_vendido DESC;

-- 12. Ventas realizadas en una fecha determinada
SELECT
    id_venta,
    id_cliente,
    fecha_venta,
    metodo_pago,
    total
FROM ventas
WHERE fecha_venta::DATE = CURRENT_DATE
ORDER BY fecha_venta DESC;