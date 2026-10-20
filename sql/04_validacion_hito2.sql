-- se hara una Cobertura de los indicadores por cada tema.
--Las lineas de LEFT JOIN mantendran visibles todos los temas incluso si no tienen series
-- y para las series que no tengan observaciones cargadas.

SELECT
    t.tema,
    s.id_serie,
    s.nombre,
    s.fuente,
    s.frecuencia,
    COUNT(o.fecha) AS n_observaciones,
    MIN(o.fecha) AS primera_fecha,
    MAX(o.fecha) AS ultima_fecha
FROM temas AS t
LEFT JOIN series AS s
    ON s.id_tema = t.id_tema
LEFT JOIN observaciones AS o
    ON o.id_serie = s.id_serie
GROUP BY
    t.tema,
    s.id_serie,
    s.nombre,
    s.fuente,
    s.frecuencia
ORDER BY
    t.tema,
    s.nombre;