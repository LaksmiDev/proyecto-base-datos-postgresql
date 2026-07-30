-- =====================================================
-- CONSULTAS CON JOIN: TIENDA DE JUGUETES
-- Responsable: Gianluca
-- =====================================================

-- 1. Productos con su categoría
SELECT
    p.id_producto,
    p.nombre AS producto,
    c.nombre AS categoria,
    p.precio,
    p.stock
FROM productos p
INNER JOIN categorias c
    ON c.id_categoria = p.id_categoria
ORDER BY c.nombre, p.nombre;

-- 2. Productos con categoría y proveedor
SELECT
    p.nombre AS producto,
    p.marca,
    c.nombre AS categoria,
    pr.razon_social AS proveedor,
    p.precio,
    p.stock
FROM productos p
INNER JOIN categorias c
    ON c.id_categoria = p.id_categoria
INNER JOIN proveedores pr
    ON pr.id_proveedor = p.id_proveedor
ORDER BY p.nombre;

-- 3. Ventas con los datos del cliente
SELECT
    v.id_venta,
    c.nombres,
    c.apellidos,
    c.documento,
    v.fecha_venta,
    v.metodo_pago,
    v.total,
    v.estado
FROM ventas v
INNER JOIN clientes c
    ON c.id_cliente = v.id_cliente
ORDER BY v.fecha_venta DESC;

-- 4. Detalle completo de cada venta
SELECT
    v.id_venta,
    v.fecha_venta,
    c.nombres || ' ' || c.apellidos AS cliente,
    p.nombre AS producto,
    dv.cantidad,
    dv.precio_unitario,
    dv.subtotal,
    v.metodo_pago,
    v.total
FROM ventas v
INNER JOIN clientes c
    ON c.id_cliente = v.id_cliente
INNER JOIN detalle_ventas dv
    ON dv.id_venta = v.id_venta
INNER JOIN productos p
    ON p.id_producto = dv.id_producto
ORDER BY v.id_venta, p.nombre;

-- 5. Total comprado por cliente
SELECT
    c.id_cliente,
    c.nombres || ' ' || c.apellidos AS cliente,
    COUNT(v.id_venta) AS cantidad_ventas,
    COALESCE(SUM(v.total), 0) AS total_comprado
FROM clientes c
LEFT JOIN ventas v
    ON v.id_cliente = c.id_cliente
   AND v.estado = 'REGISTRADA'
GROUP BY
    c.id_cliente,
    c.nombres,
    c.apellidos
ORDER BY total_comprado DESC;

-- 6. Cantidad vendida por producto
SELECT
    p.id_producto,
    p.nombre AS producto,
    COALESCE(SUM(dv.cantidad), 0) AS unidades_vendidas,
    COALESCE(SUM(dv.subtotal), 0) AS importe_vendido
FROM productos p
LEFT JOIN detalle_ventas dv
    ON dv.id_producto = p.id_producto
GROUP BY
    p.id_producto,
    p.nombre
ORDER BY unidades_vendidas DESC;

-- 7. Producto más vendido
SELECT
    p.nombre AS producto,
    SUM(dv.cantidad) AS unidades_vendidas
FROM detalle_ventas dv
INNER JOIN productos p
    ON p.id_producto = dv.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY unidades_vendidas DESC
LIMIT 1;

-- 8. Categorías con valor total de inventario
SELECT
    c.nombre AS categoria,
    COUNT(p.id_producto) AS cantidad_productos,
    COALESCE(SUM(p.precio * p.stock), 0) AS valor_inventario
FROM categorias c
LEFT JOIN productos p
    ON p.id_categoria = c.id_categoria
GROUP BY c.id_categoria, c.nombre
ORDER BY valor_inventario DESC;