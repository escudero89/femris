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

github = {
    'releases': 'https://api.github.com/repos/escudero89/femris/releases',

    'zip': 'https://github.com/escudero89/femris/archive/%s.zip',

    'exe32': 'https://github.com/escudero89/femris/releases/download/%s/setup_x86.exe',
    'exe64': 'https://github.com/escudero89/femris/releases/download/%s/setup_x64.exe',

    'bin32': 'https://github.com/escudero89/femris/releases/download/%s/linux_x86.tar.gz',
    'bin64': 'https://github.com/escudero89/femris/releases/download/%s/linux_x64.tar.gz'
}

url = {
    "base32": "https://www.dropbox.com/s/3twngokihq09v24/Linux%20x86_64.zip?dl=1",
    "base64": "https://www.dropbox.com/s/3twngokihq09v24/Linux%20x86_64.zip?dl=1",

    "test": "https://www.dropbox.com/s/t3a1mdh1g0fiugn/test.zip?dl=1",
    "resources": "https://www.dropbox.com/s/22kg0l0v7d9lcmf/resources.zip?dl=1"
}

es = {
    "separator": "\n------------------------------------------------------------------------",
    "mild_separator": "\n...",

    "intro": "Bienvenido al FEMRIS Updater, elaborado en Python 2.7.           \n" \
             "Licencia LGPL v2.1 (ver LICENSE).                                \n" \
             "(c) 2015 Cristian Escudero.                                        ",

    "steps": "Pasos que se seguirán durante la instalación:                    \n" \
             "============================================                     \n" \
             "(antes de comenzar se verificará que existen actualizaciones)    \n" \
             "   1er Paso) Descargar aplicación base (binario) [si se requiere]\n" \
             "   2do Paso) Descargar recursos (scripts y docs) [si se requiere]\n" \
             "   3er Paso) Descomprimir y mover paquetes descargados.          \n" \
             "   4to Paso) Terminar de ajustar configuración del sistema.      \n" \
             "   5to Paso) Remover archivos innecesarios.                      \n" \
             "\n" \
             "El proceso de instalación comenzará a continuación...            \n" \
             "Gracias por elegir FEMRIS.                                         ",

    "architecture": "(se ha auto-detecado un SO %s de %s bits, ver --help)    \n",

    "step_1": "1er Paso) Iniciando descarga de la aplicación base...",
    "step_1_jmp": "1er Paso) Binario en su última versión. Paso omitido",

    "step_2": "2do Paso) Iniciando descarga de los recursos...",
    "step_2_jmp": "2do Paso) Recursos en su última versión. Paso omitido.",

    "step_3": "3er Paso) Descomprimiendo archivos...",

    "step_4": "4to Paso) Ajustando configuración del sistema...",
    "step_4_win": "4to Paso) Instalador de Windows descargado y descomprimido. "
                  "Por favor, ejecute la instalación de forma manual.\n"
                  "(el ejecutable se encuentra en '\\temp')",

    "step_5": "5to Paso) Removiendo archivos innecesarios...",

    "downloading": "Descargando: %s [ tamaño: %s MB ]",

    "right_location": "Revisaremos el respositorio de femris a continuación, "
                      "para averiguar si se publicaron nuevos cambios.",
    "without_changes": "Posees la versión más actualizada de femris. Finalizando...",

    "update_binary": "Se ha publicado una nueva versión de femris: %s.",
    "update_resources": "Se han publicado nuevos recursos para femris, "
                        "versión %s.",

    "salir": "Presiona una tecla para salir"
}

os = {
    "Linux": {
        "update_binary": "Procederemos a descargar el nuevo binario y a moverlo "
                         "a '/opt/femris'.",
        "update_resources": "Procederemos a descargar los nuevos recursos."
    },
    "Windows": {
        "update_binary": "Recomendamos que descargues la nueva versión y que "
                         "ejecutes el updater una vez que la hayas instalado.",
        "update_resources": "Procederemos a descargar los nuevos recursos."
    }
}

warning = {
    "wrong_folder": "femris-updater no se encuentra en el mismo directorio que "
                    "el archivo ejecutable 'femris'.\n"
                    "Si desea instalarlo, visite escudero89.github.io/femris "
                    "para descargar un instalador adecuado.\n"
                    "Si desea actualizarlo, asegúrese que este directorio se "
                    "encuentre en la misma ubicación que el ejecutable 'femris'.",

    "os": "El Sistema Operativo no es compatible con este script. "
          "Disculpe las molestias.",

    "sudo_password": "Lo sentimos, pero se necesitan permisos de super-usuario "
                     "para continuar."
}

error_codes = {
    'ask_for_sudo': 100,
    'get_os': 101,
    'check_architecture_x64': 102,
    'we_are_in_the_correct_spot': 110
}

online_help = 'Intente nuevamente más tarde.\nSi el problema persiste, ' \
              'solicite ayuda en ' \
              '"https://github.com/escudero89/femris/wiki/Contacto".'

exceptions = {
    'unexpected_online': 'Ha ocurrido un error inesperado. ' + online_help,
    'unavailable': 'La url "%s" no se encuentra disponible. ' + online_help
}
