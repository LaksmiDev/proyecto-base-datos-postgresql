-- =====================================================
-- PRUEBAS UNITARIAS DE CONSULTAS
-- Responsable: Gianluca
-- =====================================================

-- 1. Deben existir productos
DO $$
DECLARE
    cantidad INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO cantidad
    FROM productos;

    IF cantidad > 0 THEN
        RAISE NOTICE
            'PRUEBA APROBADA: existen % productos',
            cantidad;
    ELSE
        RAISE EXCEPTION
            'PRUEBA FALLIDA: no existen productos';
    END IF;
END $$;

-- 2. Los productos deben tener categorías válidas
DO $$
DECLARE
    cantidad_invalidos INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO cantidad_invalidos
    FROM productos p
    LEFT JOIN categorias c
        ON c.id_categoria = p.id_categoria
    WHERE c.id_categoria IS NULL;

    IF cantidad_invalidos = 0 THEN
        RAISE NOTICE
            'PRUEBA APROBADA: todos los productos tienen categoría';
    ELSE
        RAISE EXCEPTION
            'PRUEBA FALLIDA: hay % productos sin categoría',
            cantidad_invalidos;
    END IF;
END $$;

-- 3. Los productos deben tener proveedores válidos
DO $$
DECLARE
    cantidad_invalidos INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO cantidad_invalidos
    FROM productos p
    LEFT JOIN proveedores pr
        ON pr.id_proveedor = p.id_proveedor
    WHERE pr.id_proveedor IS NULL;

    IF cantidad_invalidos = 0 THEN
        RAISE NOTICE
            'PRUEBA APROBADA: todos los productos tienen proveedor';
    ELSE
        RAISE EXCEPTION
            'PRUEBA FALLIDA: hay % productos sin proveedor',
            cantidad_invalidos;
    END IF;
END $$;

-- 4. El total comprado por clientes no debe ser negativo
DO $$
DECLARE
    cantidad_invalidos INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO cantidad_invalidos
    FROM (
        SELECT
            c.id_cliente,
            COALESCE(SUM(v.total), 0) AS total_comprado
        FROM clientes c
        LEFT JOIN ventas v
            ON v.id_cliente = c.id_cliente
        GROUP BY c.id_cliente
    ) resultado
    WHERE total_comprado < 0;

    IF cantidad_invalidos = 0 THEN
        RAISE NOTICE
            'PRUEBA APROBADA: ningún cliente tiene total negativo';
    ELSE
        RAISE EXCEPTION
            'PRUEBA FALLIDA: existen totales negativos';
    END IF;
END $$;

-- 5. El subtotal del detalle debe coincidir con cantidad por precio
DO $$
DECLARE
    cantidad_incorrectos INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO cantidad_incorrectos
    FROM detalle_ventas
    WHERE subtotal <> cantidad * precio_unitario;

    IF cantidad_incorrectos = 0 THEN
        RAISE NOTICE
            'PRUEBA APROBADA: subtotales correctos';
    ELSE
        RAISE EXCEPTION
            'PRUEBA FALLIDA: hay % subtotales incorrectos',
            cantidad_incorrectos;
    END IF;
END $$;

SELECT 'Pruebas de consultas finalizadas' AS resultado;