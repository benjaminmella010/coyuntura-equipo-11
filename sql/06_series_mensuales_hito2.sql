-- Promedio mensual de las series diarias.
-- Conservación de los datos que ya son mensuales.
WITH mensual AS (
    SELECT
        o.id_serie,
        strftime('%Y-%m-01', o.fecha) AS fecha,
        AVG(o.valor) AS valor
    FROM observaciones AS o
    JOIN series AS s ON s.id_serie = o.id_serie
    WHERE s.frecuencia = 'D'
    GROUP BY
        o.id_serie,
        strftime('%Y-%m-01', o.fecha)

    UNION ALL

    SELECT
        o.id_serie,
        o.fecha,
        o.valor
    FROM observaciones AS o
    JOIN series AS s ON s.id_serie = o.id_serie
    WHERE s.frecuencia = 'M'
)
SELECT
    m.id_serie,
    s.nombre,
    m.fecha,
    m.valor,
    s.unidad
FROM mensual AS m
JOIN series AS s ON s.id_serie = m.id_serie
ORDER BY m.fecha, s.nombre;