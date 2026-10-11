#!/bin/bash

#Creado por: Alexis Yahir Alvarez Leon el dia 11/101/2026
# Nombre del Script: practica_usuarios.sh
# Propósito: Automatizar la creación de usuarios, validar su existencia
# y generar una estructura de directorios (TC, T, P) en su carpeta HOME



# 1. Validación de privilegios administrativos
# $EUID es una variable especial que contiene el ID del usuario actual.
# Si es diferente de 0 (root), significa que no tiene permisos de admin.
if [ "$EUID" -ne 0 ]; then
  echo "ERROR: Este script debe ejecutarse con privilegios de root "
  exit 1
fi


# 2. Solicitar o recibir el nombre del usuario
# $1 representa el primer parámetro pasado al script.
# Si no se pasa ningún parámetro, se solicita interactivamente.
if [ -z "$1" ]; then
  read -p "Ingresa el nombre del nuevo usuario: " USERNAME
else
  USERNAME="$1"
fi

# Validación de seguridad: el nombre no puede estar vacío
if [ -z "$USERNAME" ]; then
  echo "ERROR: El nombre de usuario no puede estar vacío."
  exit 1
fi

# 3. Creación del usuario en el sistema

echo "Creando usuario $USERNAME..."
# -m: Crea el directorio home automáticamente
# -s: Asigna /bin/bash como shell por defecto
useradd -m -s /bin/bash "$USERNAME"


# 4. Validación de la existencia del usuario

# El comando 'id' verifica si el usuario existe. 
# '&>/dev/null' oculta la salida del comando para que no se ensucie la pantalla.
if id "$USERNAME" &>/dev/null; then
  echo "ÉXITO: El usuario $USERNAME ha sido creado correctamente."
else
  echo "ERROR: Falló la creación del usuario $USERNAME."
  exit 1
fi


# 5. Creación de la estructura de directorios en el HOME

# Definimos la ruta del home del usuario
HOME_DIR="/home/$USERNAME"

echo "Creando carpetas TC, T, P en $HOME_DIR..."
# mkdir -p: Crea los directorios y evita errores si ya existen
mkdir -p "$HOME_DIR/TC" "$HOME_DIR/T" "$HOME_DIR/P"


# 6. Verificación de la creación de las carpetas

# La bandera -d verifica si es un directorio y existe.
if [ -d "$HOME_DIR/TC" ] && [ -d "$HOME_DIR/T" ] && [ -d "$HOME_DIR/P" ]; then
  echo "ÉXITO: Las carpetas TC, T y P fueron creadas correctamente."
else
  echo "ERROR: No se pudieron crear todas las carpetas."
  exit 1
fi

# 7. Mostrar resumen final y evidencias

echo "==="
echo "Proceso finalizado con éxito."
echo "Usuario: $USERNAME"
echo "Directorio Home: $HOME_DIR"
echo "Contenido del HOME:"
ls -l "$HOME_DIR"
echo "==="
