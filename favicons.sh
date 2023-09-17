#!/usr/bin/env bash

# ##############################################################################
#
# Este script genera los favicons necesarios a partir de una imagen.
#
#  @author    Óscar Novás
#  @version   v1.0.0
#  @license   GNU/GPL v3+
#
#  @see https://github.com/fariasmateuss/favicon-generator/blob/main/favicon.sh
#  @see https://gist.github.com/sumonst21/66b685707b130f5bd754cf5ea5c78da9
#
#  @see https://imagemagick.org/
# ##############################################################################


################################################################################
# CONFIGURACIÓN DEL SCRIPT.
################################################################################

# Cierro el script en caso de error.
set -e

# Colores.
RESET="\033[0m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN='\033[0;36m'
GREEN="\033[0;32m"

# Control de tiempo de ejecución.
START=$(date +%s)

# Número mínimo de parámetros.
NUM_PARAMS=1

# Ruta actual.
PWD=$(pwd)

# Variables para almacenar los parámetros:
SRC_IMAGE=''


################################################################################
# FUNCIONES AUXILIARES.
################################################################################

# Simplemente imprime una lína por pantalla.
function linea() {
  echo '--------------------------------------------------------------------------------'
}

# Muestra la cabecera de algunas respuestas del script.
function show_header() {
  echo " "
  linea
  echo -e " Generación de favicon y Apple Touch Icons."
  linea
}

# Muestra la ayuda del script.
function show_usage() {
  clear
  show_header
  echo -e "
    Sintaxis del script:
      $0 [argumentos]

    Lista de parámetros/argumentos aceptados:
      ${YELLOW}-i / --image${RESET}                 Para indicar el archivo a procesar.
      ${YELLOW}-h / --help${RESET}                  Muestra la ayuda del script.

    Ejemplos de uso:
      - ${GREEN}$0 -i=file.png${RESET}
      - ${GREEN}$0 --image=file2.png${RESET}

  "
}

# Mensaje de finalización del script.
function show_bye() {
  # Calculo el tiempo de ejecución y muestro mensaje de final del script.
  END=$(date +%s)
  RUNTIME=$((END-START))

  clear
  linea
  echo -e " ${YELLOW}Tiempo de ejecución:${RESET} ${GREEN}${RUNTIME}s${RESET}"
  linea
  echo " "
  exit 0
}

# Verifica que las herramientas necesarias están instaladas en el servidor.
function check_requirements() {
  if ! [ -x "$(command -v convert)" ]; then
    clear
    linea
    echo -e " ${RED}No se ha encontrado la herramienta ImageMagick.${RESET}"
    linea
    exit 1
  fi
}

# Comprueba el número de parámetros.
function check_num_params() {
  if [ $# -ne $NUM_PARAMS ]; then
    show_usage
    exit 2
  fi
}

# Comprueba que el archivo exista y sea válido.
function check_image() {
  if [ ! -f $SRC_IMAGE ]; then
    echo -ne "${RED}La imagen \"$SRC_IMAGE\" no existe. \n${RESET}"
    exit 3
  else
    if [[ $(file "$SRC_IMAGE" | grep -E 'image|bitmap') == "" ]]; then
      linea
      echo -e " ${RED}El archivo \"$SRC_IMAGE\" no es una imagen válida.${RESET}"
      linea
      exit 4
    fi
  fi
}

# Comprueba si se han pasado los parámetros correctos y obtiene sus valores.
function get_params() {
  while [ $# -gt 0 ]; do
    case "$1" in

      --image=* | -i=*)
          SRC_IMAGE="${1#*=}"
          check_image
          ;;

      --help | -h)
        show_usage
        exit 0
        ;;

      *)
        show_usage
        exit 5
    esac
    # Elimino el argumento y paso al siguiente:
    shift
  done
}


################################################################################
# COMPROBACIONES PREVIAS.
################################################################################

check_requirements
check_num_params "$@"

# Obtengo los posibles parámetros:
get_params "$@"


################################################################################
# CUERPO PRINCIPAL DEL SCRIPT.
################################################################################

mkdir -p "${PWD}"/favicons/apple/

echo -ne "${CYAN}Generando archivo base...\n${RESET}"
linea
convert "$SRC_IMAGE" -resize 512x512! -transparent white "${PWD}"/favicons/favicon-512x512.png

echo " "
echo -ne "${CYAN}Generando favicons...\n${RESET}"
linea
convert "${PWD}"/favicons/favicon-512x512.png -resize 16x16 "${PWD}"/favicons/favicon-16x16.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 32x32 "${PWD}"/favicons/favicon-32x32.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 64x64 "${PWD}"/favicons/favicon-64x64.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 96x96 "${PWD}"/favicons/favicon-96x96.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 128x128 "${PWD}"/favicons/favicon-128x128.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 192x192 "${PWD}"/favicons/favicon-192x192.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 256x256 "${PWD}"/favicons/favicon-256x256.png

echo " "
echo -ne "${CYAN}Generando ico...\n${COLORRESET}"
linea
convert "${PWD}"/favicons/favicon-16x16.png \
        "${PWD}"/favicons/favicon-32x32.png \
        "${PWD}"/favicons/favicon-64x64.png \
        "${PWD}"/favicons/favicon-96x96.png -colors 256 "${PWD}"/favicons/favicon.ico

echo " "
echo -ne "${CYAN}Generando Apple Touch icons...\n${RESET}"
linea
convert "${PWD}"/favicons/favicon-512x512.png -resize 60x60 "${PWD}"/favicons/apple/apple-touch-icon-60x60.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 72x72 "${PWD}"/favicons/apple/apple-touch-icon-72x72.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 76x76 "${PWD}"/favicons/apple/apple-touch-icon-76x76.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 114x114 "${PWD}"/favicons/apple/apple-touch-icon-114x114.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 120x120 "${PWD}"/favicons/apple/apple-touch-icon-120x120.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 144x144 "${PWD}"/favicons/apple/apple-touch-icon-144x144.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 152x152 "${PWD}"/favicons/apple/apple-touch-icon-152x152.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 180x180 "${PWD}"/favicons/apple/apple-touch-icon-180x180.png

echo " "
echo -ne "${CYAN}Generando Apple Touch icons (precomposed)...\n${RESET}"
linea
convert "${PWD}"/favicons/favicon-512x512.png -resize 57x57 "${PWD}"/favicons/apple/apple-touch-icon-57x57-precomposed.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 72x72 "${PWD}"/favicons/apple/apple-touch-icon-72x72-precomposed.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 76x76 "${PWD}"/favicons/apple/apple-touch-icon-76x76-precomposed.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 114x114 "${PWD}"/favicons/apple/apple-touch-icon-114x114-precomposed.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 120x120 "${PWD}"/favicons/apple/apple-touch-icon-120x120-precomposed.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 144x144 "${PWD}"/favicons/apple/apple-touch-icon-144x144-precomposed.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 152x152 "${PWD}"/favicons/apple/apple-touch-icon-152x152-precomposed.png
convert "${PWD}"/favicons/favicon-512x512.png -resize 180x180 "${PWD}"/favicons/apple/apple-touch-icon-180x180-precomposed.png

show_bye