#!/bin/bash

# Comprueba la conectividad con la puerta de enlace local
# y registra el resultado con fecha y hora.

DIRECTORIO_CODIGO="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIRECTORIO="$(dirname "$DIRECTORIO_CODIGO")"
ARCHIVO_LOG="$DIRECTORIO/logs/ping_report_CURZA-7518.log"

# Detectar automáticamente la puerta de enlace predeterminada.
PUERTA_ENLACE=$(ip -4 route show default | awk '
{
    for (i = 1; i <= NF; i++) {
        if ($i == "via") {
            print $(i + 1)
            exit
        }
    }
}')

# Comprobar que se haya encontrado una puerta de enlace.
if [[ -z "$PUERTA_ENLACE" ]]; then
    echo "Error: no se pudo detectar la puerta de enlace." >&2
    exit 1
fi

# Crear el directorio de registros si no existe.
if ! mkdir -p "$(dirname "$ARCHIVO_LOG")"; then
    echo "Error: no se pudo crear el directorio de registros." >&2
    exit 1
fi

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
