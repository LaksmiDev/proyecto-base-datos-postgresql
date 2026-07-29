-- =====================================================
-- DATOS DE PRUEBA: TIENDA DE JUGUETES
-- =====================================================

-- CATEGORÍAS
INSERT INTO categorias (nombre, descripcion) VALUES
('Muñecas', 'Muñecas, accesorios y casas de juguete'),
('Vehículos', 'Autos, camiones y vehículos a escala'),
('Juegos de mesa', 'Juegos para compartir en familia'),
('Peluches', 'Peluches de distintos tamaños'),
('Educativos', 'Juguetes para aprendizaje y desarrollo');

-- PROVEEDORES
INSERT INTO proveedores
(razon_social, ruc, telefono, correo, direccion)
VALUES
('Distribuidora Mundo Kids SAC', '20123456789', '987654321',
 'ventas@mundokids.com', 'Av. Los Juguetes 120, Lima'),

('Importaciones Happy Toys SAC', '20987654321', '956123789',
 'contacto@happytoys.com', 'Jr. Diversión 450, Lima'),

('Comercial Pequeños Sueños EIRL', '20456789123', '934567812',
 'pedidos@pequenossuenos.com', 'Av. Infantil 800, Lima');

-- CLIENTES
INSERT INTO clientes
(nombres, apellidos, documento, telefono, correo, direccion)
VALUES
('Ana', 'Torres López', '74581236', '987111222',
 'ana.torres@gmail.com', 'Los Olivos, Lima'),

('Carlos', 'Ramírez Soto', '70234567', '986222333',
 'carlos.ramirez@gmail.com', 'San Martín de Porres, Lima'),

('María', 'Gómez Díaz', '76890123', '985333444',
 'maria.gomez@gmail.com', 'Comas, Lima'),

('Luis', 'Fernández Rojas', '71567890', '984444555',
 'luis.fernandez@gmail.com', 'Independencia, Lima');

-- PRODUCTOS
INSERT INTO productos
(nombre, descripcion, precio, stock, edad_recomendada, marca,
 id_categoria, id_proveedor)
VALUES
('Muñeca Princesa', 'Muñeca con vestido y accesorios', 59.90, 20,
 '3 a 8 años', 'Dream Girl', 1, 1),

('Auto de carreras', 'Auto deportivo a escala', 35.50, 30,
 '4 a 10 años', 'Speed Kids', 2, 2),

('Monopoly Junior', 'Juego de mesa para niños', 89.90, 15,
 '5 a 12 años', 'Hasbro', 3, 2),

('Oso de peluche grande', 'Peluche suave de 60 cm', 75.00, 12,
 '3 años a más', 'Soft Friends', 4, 3),

('Rompecabezas del alfabeto', 'Rompecabezas educativo de madera', 42.90, 25,
 '3 a 6 años', 'EduPlay', 5, 1),

('Camión volquete', 'Camión resistente de plástico', 49.90, 18,
 '3 a 9 años', 'Truck Fun', 2, 3);

-- VENTAS
INSERT INTO ventas
(id_cliente, metodo_pago, subtotal, igv, total)
VALUES
(1, 'YAPE', 95.40, 17.17, 112.57),
(2, 'TARJETA', 89.90, 16.18, 106.08),
(3, 'EFECTIVO', 117.90, 21.22, 139.12);

-- DETALLE DE VENTAS
INSERT INTO detalle_ventas
(id_venta, id_producto, cantidad, precio_unitario, subtotal)
VALUES
(1, 1, 1, 59.90, 59.90),
(1, 2, 1, 35.50, 35.50),

(2, 3, 1, 89.90, 89.90),

(3, 4, 1, 75.00, 75.00),
(3, 5, 1, 42.90, 42.90);

SELECT 'Datos de prueba insertados correctamente' AS resultado;