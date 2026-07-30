-- =====================================================
-- PRUEBAS UNITARIAS: TIENDA DE JUGUETES
-- Responsable: Engel
-- =====================================================

-- 1. Verificar que existan las tablas
SELECT
    EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name = 'categorias'
    ) AS existe_categorias,

    EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name = 'proveedores'
    ) AS existe_proveedores,

    EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name = 'clientes'
    ) AS existe_clientes,

    EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name = 'productos'
    ) AS existe_productos,

    EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name = 'ventas'
    ) AS existe_ventas,

    EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name = 'detalle_ventas'
    ) AS existe_detalle_ventas;

-- Resultado esperado: todos deben salir TRUE


-- 2. Verificar cantidad de registros
SELECT COUNT(*) AS cantidad_categorias
FROM categorias;

SELECT COUNT(*) AS cantidad_proveedores
FROM proveedores;

SELECT COUNT(*) AS cantidad_clientes
FROM clientes;

SELECT COUNT(*) AS cantidad_productos
FROM productos;

SELECT COUNT(*) AS cantidad_ventas
FROM ventas;

SELECT COUNT(*) AS cantidad_detalles
FROM detalle_ventas;


-- 3. Probar que no se permita un precio negativo
DO $$
BEGIN
    BEGIN
        INSERT INTO productos (
            nombre,
            precio,
            stock,
            id_categoria,
            id_proveedor
        )
        VALUES (
            'Producto inválido',
            -10,
            5,
            1,
            1
        );

        RAISE EXCEPTION
            'PRUEBA FALLIDA: se permitió precio negativo';

    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE
                'PRUEBA APROBADA: no se permite precio negativo';
    END;
END $$;


-- 4. Probar que no se permita stock negativo
DO $$
BEGIN
    BEGIN
        INSERT INTO productos (
            nombre,
            precio,
            stock,
            id_categoria,
            id_proveedor
        )
        VALUES (
            'Producto inválido',
            20,
            -5,
            1,
            1
        );

        RAISE EXCEPTION
            'PRUEBA FALLIDA: se permitió stock negativo';

    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE
                'PRUEBA APROBADA: no se permite stock negativo';
    END;
END $$;


-- 5. Probar que no se permita una categoría inexistente
DO $$
BEGIN
    BEGIN
        INSERT INTO productos (
            nombre,
            precio,
            stock,
            id_categoria,
            id_proveedor
        )
        VALUES (
            'Producto inválido',
            20,
            5,
            9999,
            1
        );

        RAISE EXCEPTION
            'PRUEBA FALLIDA: se permitió categoría inexistente';

    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE
                'PRUEBA APROBADA: la clave foránea funciona';
    END;
END $$;


-- 6. Probar que no se permita repetir el RUC
DO $$
BEGIN
    BEGIN
        INSERT INTO proveedores (
            razon_social,
            ruc
        )
        VALUES (
            'Proveedor duplicado',
            '20123456789'
        );

        RAISE EXCEPTION
            'PRUEBA FALLIDA: se permitió RUC duplicado';

    EXCEPTION
        WHEN unique_violation THEN
            RAISE NOTICE
                'PRUEBA APROBADA: no se permite RUC duplicado';
    END;
END $$;


-- 7. Probar que no se permita método de pago inválido
DO $$
BEGIN
    BEGIN
        INSERT INTO ventas (
            id_cliente,
            metodo_pago,
            subtotal,
            igv,
            total
        )
        VALUES (
            1,
            'BITCOIN',
            100,
            18,
            118
        );

        RAISE EXCEPTION
            'PRUEBA FALLIDA: se permitió método inválido';

    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE
                'PRUEBA APROBADA: método de pago inválido rechazado';
    END;
END $$;


SELECT 'Pruebas unitarias finalizadas' AS resultado;