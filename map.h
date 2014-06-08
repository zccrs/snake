#ifndef MAP_H
#define MAP_H

#include <QObject>
#include <QTime>
#include <QTimer>
#include "snake.h"
#include "level.h"


#define MAXV 10//蛇的最大生命
class Map : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int vitality READ vitality WRITE setvitality NOTIFY vitalityChanged)
    Q_PROPERTY(int level READ level WRITE setLevel NOTIFY levelChanged)
    Q_PROPERTY(int count READ count WRITE setCount)
public:
    QTime ranTime;
    Snake *snake;
    Level *levels;
    int mvitality;//蛇的生命
    explicit Map(Snake *snakes,Level *newlevel,QObject *parent = 0);
    int map[16][25];//1是陷阱，2是障碍，3是食物，4是生命，5是自己的身体
    int vitality();//返回生命值
    void setvitality(int newvitality);//设置生命值
    int mlevel,mcount;//level记录关卡,count记录共动态增加了多少个组件
    void setLevel(int x);//设置关卡
    int level();//读取关卡
    int count();//读取组件个数
    void setCount(int newCount);//设置组件个数
    void randomTrap(int x,int y);//随机从一个陷阱出来
    int trap_count,trap_x[16*25],trap_y[16*25];//用来记录共有多少个陷阱
    void save_trap();//用来保存井的具体数据的函数
    ~Map();
signals:
    void vitalityChanged();//当血液的值改变时发射信号
    //void foodChanged(int x,int y);//当食物坐标改变时
    void addVitality(int x,int y);//增加小血瓶时发射
    void addBar(int x,int y);//增加墙
    void addTrap(int x,int y);//增加陷阱
    void addFood(int x,int y);//增加食物
    void levelChanged(int count);
    void remove_widget(int x,int y);//销毁坐标是x，y的组件
    void to_trap(int x,int y);//设置蛇头的坐标让蛇随机从一个井中出来
    void saveGame();//发射信号让qml中保存游戏进度（此信号在程序退出时被发射）
public slots:
    void headcoord(int x,int y);//接收蛇头所在坐标
    void bodycoord(int x,int y);//接收各个蛇身所在坐标
    void tailcoord(int x,int y);//接收蛇尾坐标
    //void vitalitycoord();//改变小血罐坐标
    //void foodcoord();//改变食物所在坐标
    void initializeMap();//初始化地图
    bool readLevel(bool save=false);//读取地图,读取失败返回fasle
    //void setCount();//初始化计数
    //void getLoadVitCoord(int x,int y);//继续游戏时读取血瓶所在坐标
    //void getLoadFoodCoord(int x,int y);//继续游戏时读取食物所在坐标
    bool saveMapData();//保存地图数据
};

#endif // MAP_H
