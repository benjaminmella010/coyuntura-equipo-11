# Precio del cobre y actividad económica en Chile

**Ciencia de Datos para Economía / Portafolio**

## Objetivo 

Nuestro objetivo es estudiar la relación entre las variaciones del precio del cobre y la actividad económica chilena, medida mediante el Imacec total y sus componentes minero y no minero.

La investigación busca analizar si incorporar información del cobre nos permite mejorar los pronósticos de la variación interanual del Imacec a doce meses.

## Avance del hito 2

Implementamos una base de datos relacional en SQLite con 12 series económicas: diez del Banco Central de Chile y dos de FRED.

La extracción muestra el período solicitado desde enero de 2010 hasta agosto de 2026. Desarrollamos consultas SQL para poder revisar la cobertura, obtener los últimos datos y trabajar con una frecuencia mensual común.

El cuaderno `notebooks/03_analisis_hito2.ipynb` muestra gráficos, un análisis inicial de coyuntura y correlaciones entre el cobre y la actividad económica con distintos rezagos.

Los resultados por el momento son preliminares. La construcción de modelos y la evaluación de pronósticos se veran en etapas posteriores.

## Procedencia

Para el proyecto usaremos como base el kit de inicio que nos dio el profesor al inicio de semestre. El avance del portafolio incluye la adaptación del catálogo y la extracción, las consultas SQL propias, el validador y el cuaderno de análisis del hito 2.

## Estructura del repositorio

Los principales archivos que usaremos en el hito 2 son:

```text
kit-inicio-coyuntura/
├── README.md
├── requirements.txt
├── .env.example
├── .gitignore
├── src/
│   ├── config.py
│   ├── extraccion.py
│   ├── carga_db.py
│   └── validar_db.py
├── sql/
│   ├── 01_esquema.sql
│   ├── 04_validacion_hito2.sql
│   ├── 05_ultimos_datos_hito2.sql
│   └── 06_series_mensuales_hito2.sql
├── notebooks/
│   └── 03_analisis_hito2.ipynb
├── figuras/
│   ├── imacec_cobre_interanual.png
│   ├── imacec_sectores_cobre.png
│   └── correlaciones_cobre_rezagos.png
└── data/
    └── coyuntura_hito2.db
```

### Función de los archivos

- `src/config.py`: contiene el catálogo de series y las rutas del proyecto.
- `src/extraccion.py`: descarga los datos desde las APIs.
- `src/carga_db.py`: crea el esquema y carga las observaciones en SQLite.
- `src/validar_db.py`: ejecuta las consultas SQL de revisión en modo de solo lectura.
- `sql/04_validacion_hito2.sql`: revisa la cantidad de observaciones y la cobertura de cada serie.
- `sql/05_ultimos_datos_hito2.sql`: obtiene la última observación disponible de cada indicador.
- `sql/06_series_mensuales_hito2.sql`: reúne las series en una frecuencia mensual común.
- `notebooks/03_analisis_hito2.ipynb`: contiene el análisis propio del hito 2.
- `figuras/`: contiene los gráficos generados por el cuaderno.

El repositorio también conserva ejemplos del kit y cuadernos de clases proporcionados por el profesor.

La base de datos se genera localmente mediante el proceso de carga y no se incluye en Git.

## Reproducción del hito 2 en Windows

Los comandos se ejecutan en PowerShell desde la carpeta `kit-inicio-coyuntura`.

### 1. Preparar el entorno

Para una instalación nueva, se necesita Python 3.13. Crear el entorno e instalar las dependencias:

```powershell
py -3.13 -m venv venv
.\venv\Scripts\python.exe -m pip install -r requirements.txt
```

### 2. Configurar las credenciales

En una instalación nueva, copiar la plantilla:

```powershell
Copy-Item .env.example .env
```

Editar `.env` y completar las credenciales propias:

```dotenv
BCCH_PASSWORD=TU_TOKEN_DEL_BCCH
FRED_API_KEY=TU_CLAVE_DE_FRED
```

En la implementación actual, `BCCH_PASSWORD` almacena el token de la API del Banco Central de Chile. Aunque conserva ese nombre, no corresponde a la contraseña de inicio de sesión.

El archivo `.env` es local y no debe subirse en Git.

### 3. Crear y poblar la base de datos

```powershell
.\venv\Scripts\python.exe -B src/carga_db.py --desde 2010-01-01 --hasta 2026-08-31
```

La base se guarda en `data/coyuntura_hito2.db`.

Comprobar que las doce series aparezcan con `[OK]`. El proceso continúa cuando alguna serie falla, por lo que también se deben revisar los mensajes `[ERROR]`.

Las fechas fijan el período solicitado. Las fuentes pueden revisar valores históricos, por lo que una extracción posterior podría obtener datos distintos.

### 4. Ejecutar las consultas SQL

Revisar cantidad de observaciones y cobertura:

```powershell
.\venv\Scripts\python.exe -B src/validar_db.py 04_validacion_hito2.sql
```

Obtener la última observación de cada indicador:

```powershell
.\venv\Scripts\python.exe -B src/validar_db.py 05_ultimos_datos_hito2.sql
```

Consultar las series con frecuencia mensual común:

```powershell
.\venv\Scripts\python.exe -B src/validar_db.py 06_series_mensuales_hito2.sql
```

El validador abre la base en modo de solo lectura.

### 5. Ejecutar el análisis

Registrar el entorno como kernel de Jupyter:

```powershell
.\venv\Scripts\python.exe -B -m ipykernel install --user --name coyuntura-hito2 --display-name "Python (Hito 2 - venv)"
```

Abrir `notebooks/03_analisis_hito2.ipynb` en VS Code, seleccionar el kernel `Python (Hito 2 - venv)` y ejecutar sus celdas en orden.

El cuaderno consulta la base, calcula los indicadores y genera los gráficos en la carpeta `figuras/`.

## Datos y metodología

La base utilizada en el hito 2 contiene doce series y 10.287 observaciones originales.

El esquema relacional organiza la información en tres tablas: `temas`, `series` y `observaciones`.

Para el análisis se aplican los siguientes criterios:

- El tipo de cambio y la TPM se convierten a frecuencia mensual mediante el promedio de las observaciones diarias disponibles.
- Las demás series conservan sus valores mensuales originales.
- Las variaciones interanuales del Imacec y del cobre comparan cada valor con el mismo mes del año anterior.
- El IPC utilizado ya corresponde a una variación interanual y se incorpora directamente.
- La tasa de desocupación corresponde a un trimestre móvil.
- Los datos faltantes se mantienen como faltantes, sin reemplazarlos por cero.

La consulta mensual entrega 2.386 observaciones. Al organizar los datos por indicador, se obtiene un calendario de 200 meses y doce series.

En ese calendario faltan los primeros doce meses del IPC y los primeros dos meses de la desocupación. Estas diferencias de cobertura se consideran en el análisis.

Las correlaciones con rezagos del cobre de cero a doce meses utilizan una muestra común de 176 meses. Son resultados exploratorios y no demuestran causalidad ni capacidad predictiva.

## Credenciales y archivos locales

El archivo `.env` contiene credenciales propias y no se incluye en Git. La plantilla `.env.example` debe contener únicamente valores de ejemplo.

La base de datos y el entorno `venv` se generan localmente. El README documenta los pasos necesarios para reconstruir el entorno y cargar los datos.

## Estado del trabajo

- [x] Catálogo de doce series económicas.
- [x] Extracción desde APIs y carga en SQLite.
- [x] Consultas SQL de validación, últimos datos y mensualización.
- [x] Análisis inicial de coyuntura y relaciones con rezagos.
- [x] Documentación del procedimiento en el README.
- [x] Incorporar los archivos del avance al control de versiones.
- [ ] Estimar modelos y evaluar pronósticos fuera de muestra.
- [ ] Construir el monitor en Power BI.
- [ ] Preparar el informe final y la presentación.


