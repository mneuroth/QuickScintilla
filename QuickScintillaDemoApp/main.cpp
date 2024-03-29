#include "ScintillaEditBase.h"

#include <QtQuick/QQuickView>
#include <QGuiApplication>
#include <QFile>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "applicationdata.h"

#ifdef Q_OS_ANDROID
#define _WITH_QDEBUG_REDIRECT
#define _WITH_ADD_TO_LOG
#endif

#include <QDir>

static qint64 g_iLastTimeStamp = 0;

void AddToLog(const QString & msg)
{
#ifdef _WITH_ADD_TO_LOG
    QString sFileName(LOG_NAME);
    //if( !QDir("/sdcard/Texte").exists() )
    //{
    //    sFileName = "mgv_quick_qdebug.log";
    //}
    QFile outFile(sFileName);
    outFile.open(QIODevice::WriteOnly | QIODevice::Append);
    QTextStream ts(&outFile);
    qint64 now = QDateTime::currentMSecsSinceEpoch();
    qint64 delta = now - g_iLastTimeStamp;
    g_iLastTimeStamp = now;
    ts << delta << " ";
    ts << msg << endl;
    qDebug() << delta << " " << msg << endl;
    outFile.flush();
#else
    Q_UNUSED(msg)
#endif
}

#ifdef _WITH_QDEBUG_REDIRECT
#include <QDebug>
void PrivateMessageHandler(QtMsgType type, const QMessageLogContext & context, const QString & msg)
{
    QString txt;
    switch (type) {
    case QtDebugMsg:
        txt = QString("Debug: %1 (%2:%3, %4)").arg(msg).arg(context.file).arg(context.line).arg(context.function);
        break;
    case QtWarningMsg:
        txt = QString("Warning: %1 (%2:%3, %4)").arg(msg).arg(context.file).arg(context.line).arg(context.function);
        break;
    case QtCriticalMsg:
        txt = QString("Critical: %1 (%2:%3, %4)").arg(msg).arg(context.file).arg(context.line).arg(context.function);
        break;
    case QtFatalMsg:
        txt = QString("Fatal: %1 (%2:%3, %4)").arg(msg).arg(context.file).arg(context.line).arg(context.function);
        break;
    case QtInfoMsg:
        txt = QString("Info: %1 (%2:%3, %4)").arg(msg).arg(context.file).arg(context.line).arg(context.function);
        break;
    }
    AddToLog(txt);
}
#endif

//#include "ILexer.h"
#include "Scintilla.h"
//#include "SciLexer.h"
//#include "Lexilla.h"

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
#define URL_FOR_QML "qrc:/app5.qml"
#else
#define URL_FOR_QML "qrc:/app.qml"
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

//TODO    Scintilla_LinkLexers();
    //LexillaSetDefault([](const char *name) {
    //	return CreateLexer(name);
    //});

//    auto pLexer = CreateLexer("cpp");

#ifdef _WITH_QDEBUG_REDIRECT
    qInstallMessageHandler(PrivateMessageHandler);
#endif

    AddToLog("Start QuickScintilla !!!");

    QGuiApplication app(argc, argv);
    app.setOrganizationName("scintilla.org");
    app.setOrganizationDomain("scintilla.org");
    app.setApplicationName("QuickScintillaDemoApp");

    ApplicationData data(0);

    qRegisterMetaType<SCNotification>("SCNotification");
    qmlRegisterType<ScintillaEditBase>("Scintilla", 1, 0, "ScintillaEditBase");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral(URL_FOR_QML));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("applicationData", &data);
    engine.load(url);

    return app.exec();
}
