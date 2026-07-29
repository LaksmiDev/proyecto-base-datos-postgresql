-- =====================================================
-- BASE DE DATOS: TIENDA DE JUGUETES
-- Archivo: 01_crear_tablas.sql
-- Responsable: Engel
-- =====================================================

-- Eliminar tablas si existen, respetando el orden
DROP TABLE IF EXISTS detalle_ventas;
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS proveedores;
DROP TABLE IF EXISTS categorias;

-- =====================================================
-- TABLA: categorias
-- Guarda los tipos de juguetes
-- =====================================================

CREATE TABLE categorias (
    id_categoria INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(80) NOT NULL,
    descripcion VARCHAR(250),
    estado BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_categorias
        PRIMARY KEY (id_categoria),

    CONSTRAINT uq_categorias_nombre
        UNIQUE (nombre)
);

-- =====================================================
-- TABLA: proveedores
-- Guarda las empresas que abastecen los juguetes
-- =====================================================

CREATE TABLE proveedores (
    id_proveedor INTEGER GENERATED ALWAYS AS IDENTITY,
    razon_social VARCHAR(120) NOT NULL,
    ruc VARCHAR(11) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(120),
    direccion VARCHAR(200),
    estado BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_proveedores
        PRIMARY KEY (id_proveedor),

    CONSTRAINT uq_proveedores_ruc
        UNIQUE (ruc),

    CONSTRAINT uq_proveedores_correo
        UNIQUE (correo),

    CONSTRAINT ck_proveedores_ruc
        CHECK (ruc ~ '^[0-9]{11}$')
);

-- =====================================================
-- TABLA: clientes
-- Guarda los datos de las personas que compran
-- =====================================================

CREATE TABLE clientes (
    id_cliente INTEGER GENERATED ALWAYS AS IDENTITY,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    documento VARCHAR(12) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(120),
    direccion VARCHAR(200),
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_clientes
        PRIMARY KEY (id_cliente),

    CONSTRAINT uq_clientes_documento
        UNIQUE (documento),

    CONSTRAINT uq_clientes_correo
        UNIQUE (correo),

    CONSTRAINT ck_clientes_documento
        CHECK (documento ~ '^[0-9]{8,12}$')
);

-- =====================================================
-- TABLA: productos
-- Guarda todos los juguetes disponibles
-- =====================================================

CREATE TABLE productos (
    id_producto INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(120) NOT NULL,
    descripcion VARCHAR(250),
    precio NUMERIC(10,2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    edad_recomendada VARCHAR(30),
    marca VARCHAR(80),
    id_categoria INTEGER NOT NULL,
    id_proveedor INTEGER NOT NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_productos
        PRIMARY KEY (id_producto),

    CONSTRAINT ck_productos_precio
        CHECK (precio > 0),

    CONSTRAINT ck_productos_stock
        CHECK (stock >= 0),

    CONSTRAINT fk_productos_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria),

    CONSTRAINT fk_productos_proveedor
        FOREIGN KEY (id_proveedor)
        REFERENCES proveedores(id_proveedor)
);

-- =====================================================
-- TABLA: ventas
-- Guarda la cabecera de cada venta
-- =====================================================

CREATE TABLE ventas (
    id_venta INTEGER GENERATED ALWAYS AS IDENTITY,
    id_cliente INTEGER NOT NULL,
    fecha_venta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metodo_pago VARCHAR(30) NOT NULL,
    subtotal NUMERIC(10,2) NOT NULL DEFAULT 0,
    igv NUMERIC(10,2) NOT NULL DEFAULT 0,
    total NUMERIC(10,2) NOT NULL DEFAULT 0,
    estado VARCHAR(20) NOT NULL DEFAULT 'REGISTRADA',

    CONSTRAINT pk_ventas
        PRIMARY KEY (id_venta),

    CONSTRAINT ck_ventas_metodo_pago
        CHECK (
            metodo_pago IN (
                'EFECTIVO',
                'TARJETA',
                'YAPE',
                'PLIN'
            )
        ),

    CONSTRAINT ck_ventas_subtotal
        CHECK (subtotal >= 0),

    CONSTRAINT ck_ventas_igv
        CHECK (igv >= 0),

    CONSTRAINT ck_ventas_total
        CHECK (total >= 0),

    CONSTRAINT ck_ventas_estado
        CHECK (
            estado IN (
                'REGISTRADA',
                'ANULADA'
            )
        ),

    CONSTRAINT fk_ventas_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
);

-- =====================================================
-- TABLA: detalle_ventas
-- Guarda los productos incluidos en cada venta
-- =====================================================

CREATE TABLE detalle_ventas (
    id_detalle INTEGER GENERATED ALWAYS AS IDENTITY,
    id_venta INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario NUMERIC(10,2) NOT NULL,
    subtotal NUMERIC(10,2) NOT NULL,

    CONSTRAINT pk_detalle_ventas
        PRIMARY KEY (id_detalle),

    CONSTRAINT ck_detalle_cantidad
        CHECK (cantidad > 0),

    CONSTRAINT ck_detalle_precio
        CHECK (precio_unitario > 0),

    CONSTRAINT ck_detalle_subtotal
        CHECK (subtotal > 0),

    CONSTRAINT uq_detalle_venta_producto
        UNIQUE (id_venta, id_producto),

    CONSTRAINT fk_detalle_venta
        FOREIGN KEY (id_venta)
        REFERENCES ventas(id_venta)
        ON DELETE CASCADE,

    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
);

-- Mensaje de comprobación
SELECT 'Las tablas de la tienda de juguetes fueron creadas correctamente'
AS resultado;