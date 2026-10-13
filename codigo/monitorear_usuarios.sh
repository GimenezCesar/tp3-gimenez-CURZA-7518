#!/bin/bash

# Registra la fecha, hora y cantidad de sesiones de usuario activas.

# Directorio principal del trabajo práctico.
DIRECTORIO="/home/gimenezcesar/tp3-gimenez-CURZA-7518"

# Archivo donde se acumulan los registros.
ARCHIVO_LOG="$DIRECTORIO/logs/usuarios_activos_CURZA-7518.log"

# Datos de identificación del alumno.
LEGAJO="CURZA-7518"
TOKEN="CURZA-75184625"

# Obtener la fecha y hora actuales.
FECHA_HORA=$(date '+%Y-%m-%d %H:%M:%S')

# Contar las sesiones de usuario registradas.
USUARIOS_ACTIVOS=$(who | wc -l)

# Crear el encabezado únicamente si el archivo no existe
# o está vacío.
if [[ ! -s "$ARCHIVO_LOG" ]]; then
    if ! printf 'Legajo: %s\nToken: %s\n' "$LEGAJO" "$TOKEN" > "$ARCHIVO_LOG"; then
        echo "Error: no se pudo escribir el encabezado del log." >&2
        exit 1
    fi
fi

# Anexar el registro sin borrar los anteriores.
if ! printf '%s | Usuarios activos: %s\n' \
    "$FECHA_HORA" "$USUARIOS_ACTIVOS" >> "$ARCHIVO_LOG"; then
    echo "Error: no se pudo registrar la información." >&2
    exit 1
fi
