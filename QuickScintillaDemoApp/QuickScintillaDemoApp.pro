QT += quick quickcontrols2 widgets printsupport

CONFIG += c++1z

HEADERS += applicationdata.h
SOURCES += applicationdata.cpp\
           main.cpp

INCLUDEPATH += ../scintilla/qt/ScintillaEdit ../scintilla/qt/ScintillaEditBase ../scintilla/include

LIBS += ../scintilla/bin/ScintillaEditBase.lib
#LIBS += ../scintilla/bin/libScintillaEdit.a

RESOURCES += quickscintillademoapp.qrc

#DESTPATH = $$[QT_INSTALL_EXAMPLES]/qml/tutorials/extending-qml/chapter1-basics
#target.path = $$DESTPATH

#qml.files = *.qml
#qml.path = $$DESTPATH

#INSTALLS += target qml
