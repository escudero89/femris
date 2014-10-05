TEMPLATE = app

# Armadillo, LAPACK and BLAS is already installed. Just remember to link
# to these. In Qt Creator, just add the following line to your .pro file:
# In Windows, you need to define ARMADILL_ROOT as system's variable
INCLUDEPATH += $(ARMADILLO_ROOT)/include
INCLUDEPATH += $(ARMADILLO_ROOT)/examples/lib_win32

LIBS += -llapack -lblas -larmadillo

QT += qml quick widgets webkit webkit-private

SOURCES += \
    src/main.cpp \
    src/fileio.cpp \
    src/processhandler.cpp \
    src/studycase.cpp \
    src/studycasehandler.cpp \
    src/utils.cpp \
    src/studycasestructural.cpp

RESOURCES += \
    qml/resources.qrc \
    qml/qml.qrc \
    qml/MathJax.qrc \
    qml/third-party.qrc \
    qml/docs-resources.qrc \
    qml/docs.qrc

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
    src/studycasehandler.h
