import argparse
import sqlite3
import pandas as pd
import config

parser = argparse.ArgumentParser()
parser.add_argument("archivo_sql", nargs="?", default="04_validacion_hito2.sql")
args = parser.parse_args()

consulta = (config.RUTA_SQL / args.archivo_sql).read_text(encoding="utf-8")
uri = config.RUTA_DB.resolve().as_uri() + "?mode=ro"

with sqlite3.connect(uri, uri=True) as conexion:
    resultado = pd.read_sql_query(consulta, conexion)

conexion.close()

print(resultado.tail(12).to_string(index=False))
print(f"\nFilas obtenidas: {len(resultado)}")

if "n_observaciones" in resultado.columns:
    print(f"Total de observaciones: {resultado['n_observaciones'].sum()}")