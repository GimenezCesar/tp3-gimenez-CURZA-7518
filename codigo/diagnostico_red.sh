#!/bin/bash

# Comprueba la conectividad con la puerta de enlace local
# y registra el resultado con fecha y hora.

DIRECTORIO="/home/gimenezcesar/tp3-gimenez-CURZA-7518"
ARCHIVO_LOG="$DIRECTORIO/logs/ping_report_CURZA-7518.log"
PUERTA_ENLACE="10.0.2.2"

FECHA_HORA=$(date '+%Y-%m-%d %H:%M:%S')

# Comprobar si la puerta de enlace responde a un paquete ping.
if ping -c 1 -W 3 "$PUERTA_ENLACE" > /dev/null 2>&1; then
    RESULTADO="CONECTIVIDAD OK"
else
    RESULTADO="SIN RESPUESTA"
fi

# Registrar el resultado sin borrar los registros anteriores.
if ! printf '%s | Puerta de enlace: %s | %s\n' \
    "$FECHA_HORA" "$PUERTA_ENLACE" "$RESULTADO" >> "$ARCHIVO_LOG"; then
    echo "Error: no se pudo escribir en el archivo de registro." >&2
    exit 1
fi

# Mostrar el resultado también en la salida del script.
echo "$FECHA_HORA | Puerta de enlace: $PUERTA_ENLACE | $RESULTADO"
