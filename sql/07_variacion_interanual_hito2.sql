-- Variación interanual de la actividad económica y del precio del cobre.
-- Las series diarias se transforman a promedio mensual antes de aplicar LAG.

WITH mensual AS (
    SELECT
        o.id_serie,
        strftime('%Y-%m-01', o.fecha) AS fecha,
        AVG(o.valor) AS valor
    FROM observaciones AS o
    JOIN series AS s
        ON s.id_serie = o.id_serie
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
    JOIN series AS s
        ON s.id_serie = o.id_serie
    WHERE s.frecuencia = 'M'
),

variaciones AS (
    SELECT
        id_serie,
        fecha,
        valor,
        LAG(valor, 12) OVER (
            PARTITION BY id_serie
            ORDER BY fecha
        ) AS valor_hace_12
    FROM mensual
)

SELECT
    t.tema,
    s.id_serie,
    s.nombre,
    v.fecha,
    v.valor,
    v.valor_hace_12,
    100.0 * (v.valor / v.valor_hace_12 - 1) AS variacion_interanual,
    '% interanual' AS unidad
FROM variaciones AS v
JOIN series AS s
    ON s.id_serie = v.id_serie
JOIN temas AS t
    ON t.id_tema = s.id_tema
WHERE v.id_serie IN (
    'F032.IMC.IND.Z.Z.EP18.Z.Z.0.M',
    'F032.IMC.IND.Z.Z.EP18.03.Z.0.M',
    'F032.IMC.IND.Z.Z.EP18.N03.Z.0.M',
    'F019.PPB.PRE.40.M'
)
ORDER BY v.fecha, s.nombre;