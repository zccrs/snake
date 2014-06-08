#ifndef SNAKE_H
#define SNAKE_H

#include <QObject>
#include <QTimer>
#include "settings.h"
#define SL 10//一节蛇身所占的像素点
#define UP 1
#define DOWN -1
#define LEFT 2
#define RIGHT -2


class Snake:public QObject
{
    Q_OBJECT
    Q_PROPERTY(int leng READ leng WRITE setleng NOTIFY lengChanged)
    Q_PROPERTY(int inter READ inter WRITE setinter NOTIFY interChanged)
    Q_PROPERTY(bool run READ run WRITE setrun NOTIFY runChanged)
    Q_PROPERTY(int direction READ direction WRITE setdirection)
public:
    QTimer *testTimer;
    Settings *settings;
    int snakex,snakey;//蛇头的橫纵坐标
    int mdirection,addx,addy;//蛇头现在的行走方向
    bool god;//是否让此蛇有超能力（可以穿墙啥的）
    bool snakeauto;//让蛇自己找食吃，，，，测试，，，，
    int minter;
    bool mrun;
    int mleng;
    int SensorSensitivity;//重力感应敏感度
    int chx,chy;//重力感应所用基准x，y值
public:
    Snake(Settings *newsettings,QObject *parent = 0);//x，y是蛇头坐标，lenght是蛇身长度
    int inter();
    bool run();
    int leng();
    int direction();//返回蛇的方向
    void setinter(int newinter);
    void setrun(bool newrun);
    void setleng(int newleng);
    void setdirection(int newdirection);//设置蛇的方向

    ~Snake();//析造函数
signals:
    void noclip();//当蛇穿墙后
    void move(int n,int x,int y);//移动蛇时发射信号
    void getcoord(int n);
    void lengChanged();
    void interChanged();
    void runChanged();
    void gainsensorxy();//获取基准x，y值
    void head(int ,int);//发射蛇头坐标
    void tail(int ,int);//发射蛇尾坐标
public slots:
    void death();//接收蛇死亡的信号
    void coordchange(int chx,int chy);//接收当蛇头的方向改变时的信号，用于点击操作
    void mousechange(int x1, int y1,int x2,int y2);//接收手势操作，用于手势操作
    void setcoord(int x,int y);//接收第n节蛇身坐标
    void snakerun();//运行蛇
    void sensorxy(int x,int y);//接收传感器变化
    void setchxy(int x,int y);//接收传感器基准x,y值
    void initializeData();//初始化数据
};
#endif // SNAKE_H
