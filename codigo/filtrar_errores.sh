#!/bin/bash

# Filtra errores del syslog y genera un informe organizado.

DIRECTORIO="/home/gimenezcesar/tp3-gimenez-CURZA-7518"
ARCHIVO_ENTRADA="$DIRECTORIO/recursos/syslog_prueba.txt"
ARCHIVO_SALIDA="$DIRECTORIO/logs/reporte_errores_CURZA-7518.txt"

# Verificar que exista el archivo de entrada.
if [[ ! -f "$ARCHIVO_ENTRADA" ]]; then
    echo "Error: no existe el archivo $ARCHIVO_ENTRADA" >&2
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

    # Eliminar los dos puntos finales del nombre del proceso.
    sub(/:$/, "", proceso)

    # Eliminar el PID numérico entre corchetes.
    sub(/\[[0-9]+\]$/, "", proceso)

    # Reconstruir el mensaje a partir del quinto campo.
    mensaje = ""
    for (i = 5; i <= NF; i++) {
        mensaje = mensaje (i == 5 ? "" : " ") $i
    }

    # Limitar el mensaje a 50 caracteres.
    mensaje = substr(mensaje, 1, 50)

    printf "%-6s %-8s %-18s %s\n", mes_dia, hora, proceso, mensaje
}
' "$ARCHIVO_ENTRADA" > "$ARCHIVO_SALIDA"; then
    echo "Error: no se pudo generar el informe." >&2
    exit 1
fi

echo "Informe generado en: $ARCHIVO_SALIDA"
