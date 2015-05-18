# -*- coding: utf-8 -*-

color = {
    'HEADER' : '\033[95m',
    'BLUE' : '\033[94m',
    'GREEN' : '\033[92m',
    'WARNING' : '\033[93m',
    'FAIL' : '\033[91m',
    'END_C' : '\033[0m',
    'BOLD' : '\033[1m',
    'UNDERLINE' : '\033[4m'
}

url = {
    "base64" : "https://www.dropbox.com/s/3twngokihq09v24/Linux%20x86_64.zip?dl=1"
}

es = {
    "separator" : "\n------------------------------------------------------------------------",

    "intro": "Bienvenido al FEMRIS Updater, elaborado en Python 2.7.           \n" \
             "Licencia LGPL v2.1 (ver LICENSE).                                \n" \
             "(c) 2015 Cristian Escudero.                                        ",

    "steps": "Pasos que se seguirán durante la instalación:                    \n" \
             "============================================                     \n" \
             "   1er Paso) Descargar aplicación base (binario).                \n" \
             "   2do Paso) Descargar recursos (scripts y docs).                \n" \
             "   3er Paso) Descomprimir y mover paquetes descargados.          \n" \
             "   4to Paso) Terminar de ajustar configuración del sistema.      \n" \
             "\n" \
             "El proceso de instalación comenzará a continuación...            \n" \
             "Gracias por elegir FEMRIS.                                       \n" \
             "...\n",

    "architecture" : "(se ha auto-detecado una arquitectura de %s bits del SO) \n",

    "step_1" : "1er Paso) Iniciando descarga...",

    "downloading" : "Descargando: %s [ tamaño: %s MB ]"
}