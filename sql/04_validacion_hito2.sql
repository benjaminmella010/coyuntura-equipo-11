-- Cobertura de los indicadores del hito 2.
SELECT
    s.id_serie,
    s.nombre,
    s.fuente,
    s.frecuencia,
    COUNT(o.fecha) AS n_observaciones,
    MIN(o.fecha) AS primera_fecha,
    MAX(o.fecha) AS ultima_fecha
FROM series AS s
LEFT JOIN observaciones AS o
    ON o.id_serie = s.id_serie
GROUP BY
    s.id_serie,
    s.nombre,
    s.fuente,
    s.frecuencia
ORDER BY s.nombre;