#!/bin/bash

# Descarga un archivo desde una URL en el directorio descargas.

DIRECTORIO_CODIGO="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIRECTORIO="$(dirname "$DIRECTORIO_CODIGO")"
DESTINO="$DIRECTORIO/descargas"

# Verificar que se haya proporcionado una URL.
if [[ $# -ne 1 ]]; then
    echo "Uso: $0 <URL_del_archivo>"
    exit 1
fi

URL="$1"

# Comprobar que la URL use HTTP o HTTPS.
if [[ ! "$URL" =~ ^https?:// ]]; then
    echo "Error: la URL debe comenzar con http:// o https://"
    exit 1
fi

# Crear el directorio de destino si no existe.
if ! mkdir -p "$DESTINO"; then
    echo "Error: no se pudo crear el directorio de descargas."
    exit 1
fi

# Descargar el archivo y guardar el resultado.
if wget -P "$DESTINO" "$URL"; then
    echo "Descarga completada correctamente."
else
    echo "Error: no se pudo descargar el archivo."
    exit 1
fi
