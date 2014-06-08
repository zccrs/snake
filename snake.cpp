#include "snake.h"

Snake::Snake(Settings *newsettings,QObject *parent) :
    QObject(parent)
{
    settings=newsettings;
    testTimer=new QTimer(this);
    connect (testTimer,SIGNAL(timeout()),this,SLOT(snakerun()));
    initializeData ();//初始化数据
    setrun (false);//初始化
}

void Snake::initializeData ()
{
    mdirection=RIGHT;
    god=1;
    snakeauto=0;
    addx=28;
    addy=0;
    setleng (10);
    setinter (400);
}
int Snake::direction ()
{
    return mdirection;
}

int Snake::inter ()
{
    return minter;
}
bool Snake::run ()
{
    return mrun;
}

int Snake::leng ()
{
    return mleng;
}
void Snake::setdirection (int newdirection)
{
    if(mdirection!=newdirection)
    {
        mdirection=newdirection;
        switch(mdirection)
        {
        case RIGHT:
            addx=28;
            addy=0;
            break;
        case LEFT:
            addx=-28;
            addy=0;
            break;
        case DOWN:
            addx=0;
            addy=28;
            break;
        case UP:
            addx=0;
            addy=-28;
            break;
        }
    }
}

void Snake::setleng (int newleng)
{
    if(mleng!=newleng)
    {
        mleng=newleng;
        emit lengChanged ();
    }
}

void Snake::setinter (int newinter)
{
    if(minter!=newinter)
    {
        minter=newinter;
        emit interChanged ();
        testTimer->setInterval (minter);
    }
}
void Snake::setrun (bool newrun)
{
    if(mrun!=newrun)
    {
        mrun=newrun;
        emit runChanged ();
    }
    if(mrun)
    {
        testTimer->start (minter);
        SensorSensitivity=settings->getValue ("sensor",20).toInt ();
        emit gainsensorxy();
    }
    else
        testTimer->stop();
}

Snake::~Snake ()
{
    testTimer->deleteLater ();
}

void Snake::setcoord (int x, int y)
{
    snakex=x;
    snakey=y;
}

void Snake::death ()
{
    setrun (false);
}


void Snake::snakerun ()
{
    emit getcoord (0);
    int tempx=snakex,tempy=snakey;
    if(god==1)
    {
        if(snakex+addx>672)
        {
            emit move(0,0,snakey+addy);
            emit head((snakey+addy)/28,0);
            emit noclip ();
        }
        else if(snakex+addx<0)
        {
            emit move(0,672,snakey+addy);
            emit head ((snakey+addy)/28,24);
            emit noclip ();
        }
        else if(snakey+addy>420)
        {
            emit move(0,snakex+addx,0);
            emit head (0,(snakex+addx)/28);
            emit noclip ();
        }
        else if(snakey+addy<0)
        {
            emit move(0,snakex+addx,420);
            emit head (15,(snakex+addx)/28);
            emit noclip ();
        }
        else
        {
            emit move(0,snakex+addx,snakey+addy);
            emit head ((snakey+addy)/28,(snakex+addx)/28);
        }
    }
    else
    {
        emit move(0,snakex+addx,snakey+addy);
        emit head ((snakey+addy)/28,(snakex+addx)/28);
    }
    for(int i=1;i<mleng;i++)
    {
        emit getcoord (i);
        emit move(i,tempx,tempy);
        tempx=snakex;
        tempy=snakey;
    }
    emit tail (tempy/28,tempx/28);
}

void Snake::coordchange(int chx,int chy)//点触操作
{
    emit getcoord (0);
    if(mdirection==UP||mdirection==DOWN)
    {
        if(chx>snakex)
        {
            mdirection=RIGHT;
            addx=28;
            addy=0;
            emit gainsensorxy();
        }
        else {
            mdirection=LEFT;
            addx=-28;
            addy=0;
            emit gainsensorxy();
        }
    }
    else
    {
        if(chy>snakey)
        {
            mdirection=DOWN;
            addx=0;
            addy=28;
            emit gainsensorxy();
        }
        else {
            mdirection=UP;
            addx=0;
            addy=-28;
            emit gainsensorxy();
        }
    }

}
void Snake::mousechange (int x1, int y1,int x2,int y2)//滑动手势操作
{

        if(mdirection==UP||mdirection==DOWN)
        {
            if(x2-x1>60)
            {
                mdirection=RIGHT;
                addx=28;
                addy=0;
                emit gainsensorxy();
            }
            else if(x2-x1<-60)
            {
                mdirection=LEFT;
                addx=-28;
                addy=0;
                emit gainsensorxy();
            }
        }
        else
        {
            if(y2-y1>60)
            {
                mdirection=DOWN;
                addx=0;
                addy=28;
                emit gainsensorxy();
            }
            else if(y2-y1<-60)
            {
                mdirection=UP;
                addx=0;
                addy=-28;
                emit gainsensorxy();
            }
        }
}

void Snake::setchxy (int x, int y)
{
    chx=x;
    chy=y;
}

void Snake::sensorxy (int x, int y)//重力感应操作
{
    if(mdirection==UP||mdirection==DOWN)
    {
        if(x-chx>SensorSensitivity)
        {
            mdirection=RIGHT;
            addx=28;
            addy=0;
            emit gainsensorxy();
        }
        else if(chx-x>SensorSensitivity)
        {
            mdirection=LEFT;
            addx=-28;
            addy=0;
            emit gainsensorxy();
        }
    }
    else
    {
        if(chy-y>SensorSensitivity)
        {
            mdirection=DOWN;
            addx=0;
            addy=28;
            emit gainsensorxy();
        }
        else if(y-chy>SensorSensitivity)
        {
            mdirection=UP;
            addx=0;
            addy=-28;
            emit gainsensorxy();
        }
    }
}
