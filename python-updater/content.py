# -*- coding: utf-8 -*-

color = {
    'HEADER': '\033[95m',
    'BLUE': '\033[94m',
    'GREEN': '\033[92m',
    'WARNING': '\033[93m',
    'FAIL': '\033[91m',
    'END_C': '\033[0m',
    'BOLD': '\033[1m',
    'UNDERLINE': '\033[4m'
}

url = {
    "base32": "https://www.dropbox.com/s/3twngokihq09v24/Linux%20x86_64.zip?dl=1",
    "base64": "https://www.dropbox.com/s/3twngokihq09v24/Linux%20x86_64.zip?dl=1",

    "test": "https://www.dropbox.com/s/t3a1mdh1g0fiugn/test.zip?dl=1",
    "resources": "https://www.dropbox.com/s/22kg0l0v7d9lcmf/resources.zip?dl=1"
}

es = {
    "separator" : "\n------------------------------------------------------------------------",
    "mild_separator" : "\n...",

    "intro": "Bienvenido al FEMRIS Updater, elaborado en Python 2.7.           \n" \
             "Licencia LGPL v2.1 (ver LICENSE).                                \n" \
             "(c) 2015 Cristian Escudero.                                        ",

    "steps": "Pasos que se seguirán durante la instalación:                    \n" \
             "============================================                     \n" \
             "   1er Paso) Descargar aplicación base (binario).                \n" \
             "   2do Paso) Descargar recursos (scripts y docs).                \n" \
             "   3er Paso) Descomprimir y mover paquetes descargados.          \n" \
             "   4to Paso) Terminar de ajustar configuración del sistema.      \n" \
             "   5to Paso) Remover archivos innecesarios.                      \n" \
             "\n" \
             "El proceso de instalación comenzará a continuación...            \n" \
             "Gracias por elegir FEMRIS.                                         ",

    "architecture" : "(se ha auto-detecado un SO %s de %s bits, ver --help)    \n",

    "step_1" : "1er Paso) Iniciando descarga de la aplicación base...",
    "step_2" : "2do Paso) Iniciando descarga de los recursos...",
    "step_3" : "3er Paso) Descomprimiendo archivos...",
    "step_4" : "4to Paso) Ajustando configuración del sistema...",
    "step_5" : "5to Paso) Removiendo archivos innecesarios...",

    "downloading" : "Descargando: %s [ tamaño: %s MB ]"
}

warning = {
    "os" : "El Sistema Operativo no es compatible con este script. "
           "Disculpe las molestias."
}