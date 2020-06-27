#include "ScintillaEditBase.h"

#include <QtQuick/QQuickView>
#include <QGuiApplication>
#include <QFile>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "applicationdata.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName("scintilla.org");
    app.setOrganizationDomain("scintilla.org");
    app.setApplicationName("QuickScintillaDemoApp");

    ApplicationData data(0);

    qmlRegisterType<ScintillaEditBase>("Scintilla", 1, 0, "ScintillaEditBase");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/app.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("applicationData", &data);
    engine.load(url);

    return app.exec();
}
