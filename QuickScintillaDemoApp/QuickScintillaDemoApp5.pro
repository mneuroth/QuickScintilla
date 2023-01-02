QT += quick quickcontrols2 widgets printsupport

CONFIG += c++1z

HEADERS += applicationdata.h
           #../scintilla/lexilla/src/Lexilla.h
SOURCES += applicationdata.cpp\
           #../scintilla/lexilla/src/Lexilla.cxx\
           main.cpp

ARCH_PATH = x86

android {
    # message("hello android !")

    equals(ANDROID_TARGET_ARCH, arm64-v8a) {
        ARCH_PATH = arm64
    }
    equals(ANDROID_TARGET_ARCH, armeabi-v7a) {
        ARCH_PATH = arm
    }
    equals(ANDROID_TARGET_ARCH, armeabi) {
        ARCH_PATH = arm
    }
    equals(ANDROID_TARGET_ARCH, x86)  {
        ARCH_PATH = x86
    }
    equals(ANDROID_TARGET_ARCH, x86_64)  {
        ARCH_PATH = x64
    }
    equals(ANDROID_TARGET_ARCH, mips)  {
        ARCH_PATH = mips
    }
    equals(ANDROID_TARGET_ARCH, mips64)  {
        ARCH_PATH = mips64
    }
}

INCLUDEPATH += ../scintilla/qt/ScintillaEdit ../scintilla/qt/ScintillaEditBase ../scintilla/include ../scintilla/lexilla/src ../scintilla/lexlib ../scintilla/src

LIBS += -L$$OUT_PWD/../scintilla/bin-$${ARCH_PATH}/ -lScintillaEditBase
#LIBS += ../scintilla/bin-$${ARCH_PATH}/ScintillaEditBase.lib
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
