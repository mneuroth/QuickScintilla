QT += quick quickcontrols2 widgets printsupport

CONFIG += c++1z

HEADERS += applicationdata.h\
           ../scintilla/lexilla/src/Lexilla.h
SOURCES += applicationdata.cpp\
           ../scintilla/lexilla/src/Lexilla.cxx\
           main.cpp

INCLUDEPATH += ../scintilla/qt/ScintillaEdit ../scintilla/qt/ScintillaEditBase ../scintilla/include ../scintilla/lexilla/src ../scintilla/lexlib

LIBS += ../scintilla/bin/ScintillaEditBase.lib
#LIBS += ../scintilla/bin/libScintillaEditBase.a

RESOURCES += quickscintillademoapp.qrc

#DESTPATH = $$[QT_INSTALL_EXAMPLES]/qml/tutorials/extending-qml/chapter1-basics
#target.path = $$DESTPATH

#qml.files = *.qml
#qml.path = $$DESTPATH

#INSTALLS += target qml

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
