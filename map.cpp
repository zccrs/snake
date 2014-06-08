#include "map.h"
#include <QFile>
#include <QTextStream>
#include <QString>
#include <QDebug>

Map::Map(Snake *snakes,Level *newlevel,QObject *parent) :
    QObject(parent)
{
    snake=snakes;
    levels=newlevel;
    connect (snake,SIGNAL(head(int,int)),this,SLOT(headcoord(int,int)));//蛇头
    connect (snake,SIGNAL(tail(int,int)),this,SLOT(tailcoord(int,int)));//蛇尾
    initializeMap ();//初始化地图
    setvitality (MAXV);//设置最大生命
    trap_count=mlevel=0;
}
void Map::initializeMap ()
{
    for(int i=0;i<16;i++)
        for(int j=0;j<25;j++)
            map[i][j]=0;
     mcount=0;//初始化计数
}

int Map::vitality ()
{
    return mvitality;
}
void Map::setvitality (int newvitality)
{
    mvitality=newvitality;
    emit vitalityChanged ();
    if(mvitality==0)
        snake->death ();
}
void Map::save_trap()
{
    int jishu=0;
    for(int i=0;i<16;i++)
        for(int j=0;j<25;j++)
            if(map[i][j]==1)
            {
                qDebug()<<"i:"<<i<<",j:"<<j;
                trap_x[jishu]=i;
                trap_y[jishu++]=j;
            }
}

void Map::randomTrap(int x,int y)
{
    while(1)
    {
        ranTime=QTime::currentTime();
        qsrand(ranTime.msec()+ranTime.second()*1000);
        int q=qrand()%trap_count;
        qDebug()<<"q:"<<q;
        int m=trap_x[q],n=trap_y[q];
        if(q<trap_count&&(m!=x||n!=y))
        {
            emit to_trap(m,n);
            qDebug()<<"m:"<<m<<",n:"<<n;
            qDebug()<<"map[x][y]:"<<map[x][y];
            break;
        }
    }
}
void Map::headcoord (int x, int y)//trap,bar,food,vitality,body;分别是陷阱，障碍，食物，生命，自己的身体
{
    //qDebug()<<"map("<<x<<","<<y<<"):"<<map[x][y];
    switch(map[x][y])
    {
    case 0:
        map[x][y]=5;
        break;
    case 1:
        //qDebug()<<"("<<x<<","<<y<<")";
        randomTrap(x,y);//让蛇随机从另一个井出来
        qDebug()<<"map[x][y]:"<<map[x][y];
        break;
    case 3://是否吃到食物
        snake->setleng (snake->mleng+1);
        map[x][y]=5;
        remove_widget(x,y);//销毁这个食物组件
        //foodcoord ();
        break;
    case 4://是否加血
        setvitality (mvitality+1);
        map[x][y]=5;
        remove_widget(x,y);//销毁这个血瓶组件
        //vitalitycoord ();
        break;
    default:
        setvitality (0);
        break;
    }
    //qDebug()<<"map[x][y]:"<<map[x][y];
}

void Map::tailcoord (int x, int y)
{
    if(map[x][y]==5)
        map[x][y]=0;
}

void Map::bodycoord (int x, int y)
{
    map[x][y]=5;
}

/*void Map::foodcoord ()
{
    qsrand(QTime::currentTime().msec()+QTime::currentTime().second()*1000);
    int x=qrand()%16,y=qrand()%25;
    a:
    if(map[x][y]>0)
    {
        qsrand(QTime::currentTime().msec());
        x=qrand()%16,y=qrand()%25;
        goto a;
    }
    else
    {
        emit foodChanged (x,y);
        map[x][y]=3;
    }
}
void Map::vitalitycoord ()
{
    qsrand(QTime::currentTime().msec()+QTime::currentTime().second()*1000);
    int x=qrand()%16,y=qrand()%25;
    a:
    if(map[x][y]>0)
    {
        qsrand(QTime::currentTime().msec());
        x=qrand()%16,y=qrand()%25;
        goto a;
    }
    else
    {
        emit addVitality (x,y);
        map[x][y]=4;
    }
}*/


bool Map::readLevel (bool save)
{
    QString a="map",b=".txt",string;
    string=QString("%1%2%3").arg(a).arg(mlevel).arg(b);
    if(save) string="saveMap.txt";
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
                map[p][q]=1;
                //qDebug()<<p<<" ,"<<q<<":"<<map[p][q];
                mcount++;
                trap_count++;
                emit addTrap (p,q);
            }
            else if(string.mid (c+2,d-c-2).toInt ()==2)//如果是障碍物
            {
                map[p][q]=2;
                mcount++;
                //qDebug()<<p<<" ,"<<q<<":"<<map[p][q];
                emit addBar (p,q);
            }
            else if(string.mid (c+2,d-c-2).toInt ()==3)//如果是食物
            {
                map[p][q]=3;
                mcount++;
                //qDebug()<<p<<" ,"<<q<<":"<<map[p][q];
                emit addFood (p,q);
            }
            else if(string.mid (c+2,d-c-2).toInt ()==4)//如果是血
            {
                map[p][q]=4;
                mcount++;
                //qDebug()<<p<<" ,"<<q<<":"<<map[p][q];
                emit addVitality (p,q);
            }
        }
        save_trap();//保存所有井的数据
        file.close ();
        return true;//读取成功
    }
    else return false;//读取失败
}
bool Map::saveMapData()
{
    for(int i=0;i<16;i++)
        for(int j=0;j<25;j++)
            levels->levelEdit(i,j,map[i][j]);
    return (bool)levels->addLevel(0,true);//保存数据
}

int Map::level ()
{
    return mlevel;
}

void Map::setLevel (int x)
{
    if(x!=mlevel)
    {
        mlevel=x;
        emit levelChanged (mcount);
    }
}
int Map::count()
{
    return mcount;
}

void Map::setCount(int newCount)
{
    mcount=newCount;
}

/*void Map::getLoadFoodCoord (int x, int y)
{
    map[x][y]=3;//设置为食物
}
void Map::getLoadVitCoord (int x, int y)
{
    map[x][y]=4;//设置为血瓶
}*/
Map::~Map ()
{

}
