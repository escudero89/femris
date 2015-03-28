TEMPLATE = app

QT += qml quick widgets xml webengine

CONFIG += resources_big

SOURCES += \
    src/main.cpp \
    src/fileio.cpp \
    src/processhandler.cpp \
    src/studycase.cpp \
    src/studycasehandler.cpp \
    src/utils.cpp \
    src/studycasestructural.cpp \
    src/configure.cpp \
    src/femrisxmlcontenthandler.cpp \
    src/studycaseheat.cpp

RESOURCES += \
    qml/resources.qrc \
    qml/qml.qrc \
    qml/third-party.qrc \
    qml/docs-resources.qrc \
    qml/docs.qrc \
    qml/qml-content.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

OTHER_FILES += \
    qml/main.qml \
    qml/Style.qml \
    qml/content/PrimaryButton.qml \
    qml/screens/Initial.qml \
    qml/content/AndroidDelegate.qml

HEADERS += \
    src/fileio.h \
    src/processhandler.h \
    src/studycasehandler.h \
    src/configure.h \
    src/studycaseheat.h

RC_ICONS = rc/logo.ico
