-- Última observación disponible de cada indicador.
WITH datos_ordenados AS (
    SELECT
        id_serie,
        fecha,
        valor,
        ROW_NUMBER() OVER (
            PARTITION BY id_serie
            ORDER BY fecha DESC
        ) AS posicion
    FROM observaciones
)
SELECT
    t.tema,
    s.nombre,
    s.frecuencia,
    d.fecha,
    d.valor,
    s.unidad
FROM datos_ordenados AS d
JOIN series AS s
    ON s.id_serie = d.id_serie
JOIN temas AS t
    ON t.id_tema = s.id_tema
WHERE d.posicion = 1
ORDER BY t.tema, s.nombre;