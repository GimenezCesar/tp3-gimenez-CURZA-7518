#!/bin/bash

# Filtra errores del syslog y genera un informe organizado.

# Detectar automáticamente el directorio del proyecto.
DIRECTORIO_CODIGO="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIRECTORIO="$(dirname "$DIRECTORIO_CODIGO")"

ARCHIVO_ENTRADA="$DIRECTORIO/recursos/syslog_prueba.txt"
ARCHIVO_SALIDA="$DIRECTORIO/logs/reporte_errores_CURZA-7518.txt"

# Verificar que exista el archivo de entrada.
if [[ ! -f "$ARCHIVO_ENTRADA" ]]; then
    echo "Error: no existe el archivo $ARCHIVO_ENTRADA" >&2
    exit 1
fi

# Verificar que exista el directorio de registros.
if ! mkdir -p "$(dirname "$ARCHIVO_SALIDA")"; then
    echo "Error: no se pudo crear el directorio de registros." >&2
    exit 1
fi

# Generar el informe con awk.
if ! awk '
BEGIN {
    IGNORECASE = 1
    printf "%-6s %-8s %-18s %s\n", "FECHA", "HORA", "PROCESO", "MENSAJE"
    printf "%-6s %-8s %-18s %s\n", "------", "--------", "------------------", "----------------------------------------"
}

tolower($0) ~ /error|fail|critical/ {
    mes_dia = $1 " " $2
    hora = $3
    proceso = $4

    sub(/:$/, "", proceso)
    sub(/\[[0-9]+\]$/, "", proceso)

    mensaje = ""
    for (i = 5; i <= NF; i++) {
        mensaje = mensaje (i == 5 ? "" : " ") $i
    }

    mensaje = substr(mensaje, 1, 50)

    printf "%-6s %-8s %-18s %s\n", mes_dia, hora, proceso, mensaje
}
' "$ARCHIVO_ENTRADA" > "$ARCHIVO_SALIDA"; then
    echo "Error: no se pudo generar el informe." >&2
    exit 1
fi

echo "Informe generado en: $ARCHIVO_SALIDA"
