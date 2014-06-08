#include "level.h"
#include <QFile>
#include <QTextIStream>
#include <QString>
#include <QDebug>
Level::Level(QObject *parent) :
    QObject(parent)
{
    trap_count=0;
    resetLevel();
}
Level::~Level ()
{

}

int Level::addLevel (int n,bool save)
{
    QString a="map",b=".txt",string;
    string=QString("%1%2%3").arg(a).arg(n).arg(b);
    if(save) string="saveMap.txt";//如果是保存进度而不是关卡
    else if(trap_count==1) return -1;//如果是新建管卡并保存的话就判断一下井的数量，不满足条件就不保存
    QFile file(string);
    if(file.exists()) file.remove();//如果文件存在就删除文件
    QTextStream data(&file);
    if(file.open (QIODevice::ReadWrite))
    {
        for(int i=0;i<16;i++)
        {
            for(int j=0;j<25;j++)//读取数组中的数据并保存
                if(newLevel[i][j]!=0)
                    data<<"("<<i<<","<<j<<")"<<"="<<newLevel[i][j]<<" ";
        }
        data<<"\n";
        file.close ();
        resetLevel();//清空数组
        return n;//保存成功返回关卡
    }
    else{
        resetLevel();//清空数组
        return 0;
    }
}
void Level::levelEdit (int x, int y, int n)
{
    if(n==1) trap_count++;
    newLevel[x][y]=n;
}
int Level::readData(int x, int y)
{
    return newLevel[x][y];
}

void Level::resetLevel ()
{
    for(int i=0;i<16;i++)
        for(int j=0;j<25;j++)//初始化数组，使其为空
            newLevel[i][j]=0;
}
bool Level::remove_level(int level)//删除第level关关卡
{
    QString a="map",b=".txt",string;
    string=QString("%1%2%3").arg(a).arg(level).arg(b);
    QFile file(string);
    if(file.exists()) file.remove();//如果文件存在就删除文件
    else return false;
    return true;
}
bool Level::edit_level(int level)
{
    QString a="map",b=".txt",string;
    string=QString("%1%2%3").arg(a).arg(level).arg(b);
    QFile file(string);
    if(!file.exists()) return false;
    QTextStream data(&file);
    if(file.open (QIODevice::ReadOnly))
    {
        string=data.readAll ();
        int a=0,b,c,d=-1;
        while(a!=-1)
        {
            a=string.indexOf ("(",d+1);
            b=string.indexOf(",",d+1);
            c=string.indexOf(")",d+1);
            d=string.indexOf(" ",d+1);
            int p=string.mid (a+1,b-a-1).toInt (),q=string.mid (b+1,c-b-1).toInt ();
            if(string.mid (c+2,d-c-2).toInt ()==1)//如果是井
            {
                newLevel[p][q]=1;
                //qDebug()<<p<<" ,"<<q<<":"<<newLevel[p][q];
                //mcount++;
               // trap_count++;
                emit addTrap (p,q);
            }
            else if(string.mid (c+2,d-c-2).toInt ()==2)//如果是障碍物
            {
                newLevel[p][q]=2;
                //mcount++;
                //qDebug()<<p<<" ,"<<q<<":"<<newLevel[p][q];
                emit addBar (p,q);
            }
            else if(string.mid (c+2,d-c-2).toInt ()==3)//如果是食物
            {
                newLevel[p][q]=3;
                //mcount++;
                //qDebug()<<p<<" ,"<<q<<":"<<newLevel[p][q];
                emit addFood (p,q);
            }
            else if(string.mid (c+2,d-c-2).toInt ()==4)//如果是血
            {
                newLevel[p][q]=4;
                //mcount++;
                //qDebug()<<p<<" ,"<<q<<":"<<newLevel[p][q];
                emit addVitality (p,q);
            }
        }
        file.close ();
        return true;//读取成功
    }
    else return false;//读取失败
}
