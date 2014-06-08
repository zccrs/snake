#include <QtGui/QApplication>
#include <QtGui/QSplashScreen>
#include <QtGui/QPixmap>
#include <QDeclarativeContext>
#include <QDeclarativeView>
#include <QDeclarativeItem>
#include "qmlapplicationviewer.h"
#include "snake.h"
#include "map.h"
#include "settings.h"
#include "level.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication *apps=createApplication(argc, argv);
    QScopedPointer<QApplication> app(apps);

    app->setApplicationName ("snake");
    app->setOrganizationName ("Stars");
    app->setApplicationVersion ("1.0.0");

    QApplication::setDoubleClickInterval(200);

    Settings settings;
    Level level;
    Snake snake(&settings);
    Snake loadSnake(&settings);
    Map map(&snake,&level);
    Map loadMap(&loadSnake,&level);

    QObject::connect (apps,SIGNAL(aboutToQuit ()),&map,SIGNAL(saveGame()));//当程序退出时
    QObject::connect (apps,SIGNAL(aboutToQuit ()),&loadMap,SIGNAL(saveGame()));//当程序退出时
    QmlApplicationViewer viewer;
    viewer.rootContext ()->setContextProperty ("settings",&settings);
    viewer.rootContext ()->setContextProperty ("snake",&snake);
    viewer.rootContext ()->setContextProperty ("map",&map);
    viewer.rootContext ()->setContextProperty ("loadSnake",&loadSnake);
    viewer.rootContext ()->setContextProperty ("loadMap",&loadMap);
    viewer.rootContext ()->setContextProperty ("level",&level);
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);
    viewer.setMainQmlFile(QLatin1String("qml/main.qml"));
    viewer.setFixedSize (854,480);
    viewer.showExpanded();


    return app->exec();
}
