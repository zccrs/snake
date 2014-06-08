#include "settings.h"
#include <QSettings>
Settings::Settings(QObject *parent) :
    QObject(parent)
{
    s= new QSettings(this);
}
Settings::~Settings ()
{
    s->deleteLater ();
}

void Settings::setValue (const QString &key, const QVariant &value)
{
    s->setValue (key,value);
}
QVariant Settings::getValue (const QString &key, const QVariant defaultValue)
{
    return s->value (key,defaultValue);
}
