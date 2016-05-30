#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QStandardPaths>
#include <QDebug>
#include <QDir>
#include <QQmlEngine>
#include <QQmlContext>
#include <QVariant>

QString getPrivatePath()
{
    QString writablePath = QStandardPaths::
            writableLocation(QStandardPaths::DataLocation);
    qDebug() << "writablePath: " << writablePath;

    QString absolutePath = QDir(writablePath).absolutePath();
    qDebug() << "absoluePath: " << absolutePath;

    absolutePath += ".liu-xiao-guo/photos/";

    // We need to make sure we have the path for storage
    QDir dir(absolutePath);
    if ( dir.mkpath(absolutePath) ) {
        qDebug() << "Successfully created the path!";
    } else {
        qDebug() << "Fails to create the path!";
    }

    qDebug() << "private path: " << absolutePath;

    return absolutePath;
}


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QString path = getPrivatePath();
    qDebug() << "final path: " << path;

    QQuickView view;
    view.setSource(QUrl(QStringLiteral("qrc:///Main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    QQmlEngine* engine = view.engine();
    QQmlContext* context = engine->rootContext();
    context->setContextProperty("path", QVariant::fromValue(path));

    view.show();
    return app.exec();
}

