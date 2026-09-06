USE Ventas_Tech_DB;
GO

-- Pre-entrega 4
-- Consultas de negocio de RetailPro


-- Consulta 1: resumen de ventas por mes

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
GO


-- Consulta 2: productos con mayor facturación

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;
GO


-- Consulta 3: clientes que hicieron más de un pedido

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;
GO


-- Consulta 4: comparación de la facturación mensual
-- con el promedio general

WITH ventas_por_mes AS
(
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)

SELECT
    mes,
    total_facturado,
    AVG(total_facturado) OVER () AS promedio_mensual,
    CASE
        WHEN total_facturado >= AVG(total_facturado) OVER ()
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion
FROM ventas_por_mes
ORDER BY mes;
GO


-- Hallazgos:
-- 1. El mes con mayor facturación fue Marzo.
-- 2. El producto que más facturó fue el producto 1.
-- 3. El cliente recurrente que más gastó fue el cliente 1.