#!/bin/bash

# Cambia el hostname del sistema y actualiza /etc/hosts.

# Comprobar que el script se ejecute como administrador.
if [[ "$EUID" -ne 0 ]]; then
    echo "Error: ejecutá este script con sudo."
    exit 1
fi

# Comprobar que se haya recibido exactamente un argumento.
if [[ $# -ne 1 ]]; then
    echo "Uso: sudo $0 <nuevo_hostname>"
    exit 1
fi

NUEVO_HOSTNAME="$1"

# Validar el formato del hostname solicitado.
if [[ ! "$NUEVO_HOSTNAME" =~ ^curzas-alumno-[a-zA-Z0-9-]+$ ]]; then
    echo "Error: el nombre debe seguir el formato curzas-alumno-[LEGAJO]."
    exit 1
fi

# Obtener el nombre actual del equipo.
HOSTNAME_ANTERIOR=$(cat /etc/hostname)

# Actualizar /etc/hostname.
if ! printf '%s\n' "$NUEVO_HOSTNAME" > /etc/hostname; then
    echo "Error: no se pudo actualizar /etc/hostname."
    exit 1
fi

# Actualizar las referencias al nombre anterior en /etc/hosts.
if grep -qE "(^|[[:space:]])${HOSTNAME_ANTERIOR}([[:space:]]|$)" /etc/hosts; then
    sed -i "s/\b${HOSTNAME_ANTERIOR}\b/${NUEVO_HOSTNAME}/g" /etc/hosts
fi

echo "Hostname actualizado en los archivos de configuración."
echo "Nombre anterior: $HOSTNAME_ANTERIOR"
echo "Nombre nuevo: $NUEVO_HOSTNAME"
echo "Para aplicar el cambio al nombre activo, puede ser necesario reiniciar."
