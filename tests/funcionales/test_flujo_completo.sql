-- =====================================================
-- PRUEBA FUNCIONAL: FLUJO COMPLETO DE VENTA
-- TIENDA DE JUGUETES
-- Responsable: Engel
-- =====================================================

BEGIN;

-- 1. Crear un cliente temporal
INSERT INTO clientes (
    nombres,
    apellidos,
    documento,
    telefono,
    correo,
    direccion
)
VALUES (
    'Cliente',
    'Prueba Funcional',
    '79999999',
    '999999999',
    'cliente.prueba@correo.com',
    'Lima'
);

-- 2. Crear una venta para ese cliente
INSERT INTO ventas (
    id_cliente,
    metodo_pago,
    subtotal,
    igv,
    total
)
VALUES (
    (
        SELECT id_cliente
        FROM clientes
        WHERE documento = '79999999'
    ),
    'YAPE',
    59.90,
    10.78,
    70.68
);

-- 3. Agregar un producto al detalle de venta
INSERT INTO detalle_ventas (
    id_venta,
    id_producto,
    cantidad,
    precio_unitario,
    subtotal
)
VALUES (
    (
        SELECT MAX(id_venta)
        FROM ventas
    ),
    1,
    1,
    59.90,
    59.90
);

-- 4. Consultar el resultado completo
SELECT
    v.id_venta,
    c.nombres,
    c.apellidos,
    c.documento,
    p.nombre AS producto,
    dv.cantidad,
    dv.precio_unitario,
    dv.subtotal,
    v.igv,
    v.total,
    v.metodo_pago,
    v.fecha_venta
FROM ventas v
INNER JOIN clientes c
    ON c.id_cliente = v.id_cliente
INNER JOIN detalle_ventas dv
    ON dv.id_venta = v.id_venta
INNER JOIN productos p
    ON p.id_producto = dv.id_producto
WHERE c.documento = '79999999';

-- 5. Confirmación visual
SELECT
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM ventas v
            INNER JOIN clientes c
                ON c.id_cliente = v.id_cliente
            WHERE c.documento = '79999999'
        )
        THEN 'PRUEBA FUNCIONAL APROBADA'
        ELSE 'PRUEBA FUNCIONAL FALLIDA'
    END AS resultado;

-- 6. Deshacer todos los cambios de prueba
ROLLBACK;