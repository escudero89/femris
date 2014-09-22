TEMPLATE = app

QT += qml quick widgets

SOURCES += \
    src/main.cpp

RESOURCES += \
    qml/resources.qrc \
    qml/docs.qrc \
    qml/qml.qrc

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
