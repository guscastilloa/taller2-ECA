# Taller 2 - ECA

Este repositorio contiene el código y los datos para el Taller 2 del curso de Econometría Avanzada del Prof. Manuel Fernández Sierra

## Estructura del Directorio

```
taller1-ECA/
│
├── config/              # Archivos de configuración
│   └── stata_config.do  # Configuración de Stata
├── code/               # Códigos de análisis
├── data/              # Datos del proyecto
├── docs/              # Documentación del proyecto
└── output/           # Resultados generados
    ├── figures/      # Gráficos
    └── tablas/       # Tablas
```

## Configuración Local

### Requisitos Previos
- Stata 17 o superior
- Git
- Cuenta de GitHub

### Pasos para Trabajar Localmente

1. Clonar el repositorio:
```bash
git clone https://github.com/usuario/taller2-ECA.git
cd taller2-ECA
```

2. Configurar Stata:
   - Abrir Stata
   - Ejecutar el archivo de configuración:
   ```stata
   do "config/stata_config.do"
   ```
   - El script detectará automáticamente su sistema operativo y configurará las rutas correspondientes

3. Estructura de trabajo:
   - Los datos originales deben colocarse en `data/raw/`
   - Los códigos de análisis se encuentran en `code/`
   - Los resultados se generarán automáticamente en `output/`

## Contribuciones

- Gustavo Castillo (Mac OS)
- Ana María Patrón (Windows)
