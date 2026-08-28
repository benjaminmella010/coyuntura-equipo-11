
-- Ultimo dato disponible de cada indicador del monitor.
-- Usada en: analisis de coyuntura y panel de sintesis.
SELECT   t.tema, s.nombre, o.fecha, o.valor, s.unidad
FROM         observaciones AS o
JOIN         series        AS s  ON s.id_serie = o.id_serie
JOIN         temas         AS t  ON t.id_tema  = s.id_tema
ORDER BY o.fecha DESC
LIMIT    20
