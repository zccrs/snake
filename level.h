#ifndef LEVEL_H
#define LEVEL_H

#include <QObject>

class Level : public QObject
{
    Q_OBJECT
public:
    explicit Level(QObject *parent = 0);
    ~Level();
    int newLevel[16][25];//用来临时储存关卡编辑过程中的各个位置的组件，值为0代表空，1代表墙，2代表黑洞
    int trap_count;//用来记录地图中陷阱的数量，少于2个不让保存

signals:
    void addVitality(int x,int y);//增加小血瓶时发射
    void addBar(int x,int y);//增加墙
    void addTrap(int x,int y);//增加陷阱
    void addFood(int x,int y);//增加食物
public slots:
    int addLevel(int n,bool save=false);//新增一个关卡，并返回是第几关，如果增加失败则返回0
    void levelEdit(int x,int y,int n);//用来编辑关卡,n用来表示组件的类型
    void resetLevel();//初始化数组
    int readData(int x,int y);//读取数组中的值
    bool remove_level(int level);//删除第level关关卡，保存成功返回true
    bool edit_level(int level);//编辑第level关的关卡，保存成功返回true
};

#endif // LEVEL_H
