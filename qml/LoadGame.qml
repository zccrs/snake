// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
//import QtMobility.sensors 1.2
import "addBar.js" as AddBar
import "addTrap.js" as AddTrap
import "addFood.js" as AddFood
import "addVit.js" as AddVit
Item{
    width: 854;height: 480

    property int count:0
    property int jishi:0
    property bool judge:false
    property int coordx
    property int coordy
    property int inter: loadSnake.inter
    property int remove_count: 0

    property bool running: false

    property bool gameRunning: Qt.application.active
    onGameRunningChanged:
        if(running)
            loadSnake.run=gameRunning
    function begin()
    {
        beginTime.running=true//倒计时开始
    }
    function saveGame()
    {
        settings.setValue("store_level",loadMap.level)//保存是第几关
        settings.setValue("store_direction",loadSnake.direction)//保存蛇的方向
        settings.setValue("store_vit",loadMap.vitality)//保存蛇的血量
        settings.setValue("store_leng",loadSnake.leng)//储存蛇的长度
        settings.setValue("store_jishi",jishi)//保存已用时间
        settings.setValue("store_snakeRun",loadSnake.run)//保存蛇的运行状态
        //settings.setValue("store_foodcoordx",food.x)
        //settings.setValue("store_foodcoordy",food.y)
        //settings.setValue("store_vitcoordx",vitality.x)
        //settings.setValue("store_vitcoordy",vitality.y)
        var temp="stort_body"
        for(var i=0;i<loadSnake.leng;i++)
        {
            settings.setValue(temp+i+"x",returnx(i))
            settings.setValue(temp+i+"y",returny(i))
        }
        loadMap.saveMapData()//保存地图数据
    }
    function loadGame()
    {
        running=true
        loadMap.initializeMap();//初始化地图数据
        loadSnake.initializeData();//初始化蛇的属性
        loadSnake.direction=settings.getValue("store_direction",0)//读取蛇的方向
        loadMap.vitality=settings.getValue("store_vit",0)//读取血量
        loadMap.level=settings.getValue("store_level",0)//读取关卡
        loadSnake.leng=settings.getValue("store_leng",0)//读取蛇的长度
        //food.x=settings.getValue("store_foodcoordx",0)//读取食物的坐标
        //food.y=settings.getValue("store_foodcoordy",0)//同上
        //loadMap.getLoadFoodCoord((food.y-16)/28,(food.x-138)/28)//设置地图里食物的坐标
        //vitality.x=settings.getValue("store_vitcoordx",0)//读取血的坐标
        //vitality.y=settings.getValue("store_vitcoordy",0)//同上
        //loadMap.getLoadVitCoord((vitality.y-16)/28,(vitality.x-138)/28)//设置地图里血瓶的坐标
        var temp="stort_body"
        for(var i=0;i<loadSnake.leng;i++)//读取蛇
        {
            coord(i,settings.getValue(temp+i+"x",0),settings.getValue(temp+i+"y",0))
            loadMap.bodycoord(returny(i)/28,returnx(i)/28)
        }
        loadMap.readLevel(true)//从文件中读取保存地图数据
        loadSnake.run=settings.getValue("store_snakeRun",true)//读取蛇的运行状态
        jishi=settings.getValue("store_jishi",0)//读取已用时间
    }
    function newGame()
    {
        loadMap.level=settings.getValue("store_level",0)//读取关卡
        loadMap.initializeMap();//初始化地图数据
        loadSnake.initializeData();//初始化蛇的属性
        loadMap.vitality=10
        for(var i=0;i<loadSnake.leng;i++)
        {
            coord(i,28*(loadSnake.leng-i-1),0)
            loadMap.bodycoord(0,i)
        }
        loadMap.readLevel()//读取地图此管卡数据
        //loadMap.foodcoord()//产生第一个食物
        //loadMap.vitalitycoord()//产生第一个血瓶
        loadSnake.run=true
        jishi=0
    }
    function xiaohui()
    {
        for(var i=0;i<loadMap.count;i++)
            if(haha.children[i]!=undefined)
            {
                haha.children[i].destroy()
            }
        loadMap.count=0;//令计数变为0
        for(var i=0;i<loadSnake.leng;i++)
            coord(i,-50,-50)
    }
    function coord(n,newx,newy)
    {
        grid.children[n].x=newx
        grid.children[n].y=parseInt(newy)+44
    }
    function returnx(n)
    {
        return grid.children[n].x
    }
    function returny(n)
    {
        return grid.children[n].y-44
    }
    Image {
        anchors.fill: parent
        source: "qrc:/game.png"
        Image {
            x:122;y:16
            source: "qrc:/clapboard.png"
        }
        SnakeBody{id:grid}
    }
    /*RotationSensor{
        id:sensor
        active: settings.getValue("switch",0)&loadSnake.run
        onReadingChanged:{
            loadSnake.sensorxy(reading.x,reading.y)
        }
    }*///重力感应
    MouseArea{
        id:move
        x:138
        y:16
        width: 700
        height: 448
        onPressed: {
            if(loadSnake.run)
            {
                coordx=mouseX
                coordy=mouseY
                judge=true
            }
        }
        onPositionChanged: {
            if(loadSnake.run)
                count++
        }

        onReleased: {
            if(loadSnake.run)
            {
                if(count>2)
                   loadSnake.mousechange(coordx,coordy,mouseX,mouseY)
                else if(judge)
                   loadSnake.coordchange(coordx,coordy)
                count=0
                judge=false
            }
        }

        onDoubleClicked: {
            mouse.accepted=true
            judge=false
            loadSnake.run=false
        }

    }
    Connections{
        target: loadSnake
        onMove: {
            //console.log("coord:"+n+" "+x+" "+y)
            coord(n,x,y)//改变第n节蛇身位置
            if(n==0)
                gps.text="X:"+returnx(0)+"\nY:"+returny(0)
        }
        onGetcoord:loadSnake.setcoord(returnx(n),returny(n))
        onNoclip: loadMap.vitality--;
        onInterChanged: inter=loadSnake.inter
        //onRunChanged :
            //if(loadSnake.run)
                //time.running=loadSnake.run

        onGainsensorxy: if(sensor.active)
                            loadSnake.setchxy(sensor.reading.x,sensor.reading.y)

        onLengChanged:snakeleng.text=loadSnake.leng
    }

    //Vitality{id:vitality}
    //Food{id:food}
    Rectangle{id:haha;width:0;height:0;x:138;y:16}
    Connections{
        target: loadMap
        onVitalityChanged:vit.text=loadMap.vitality
        //onAddVitality: {
            //vitality.x=28*y+138
            //vitality.y=28*x+16
        //}
        //onFoodChanged: {
            //food.x=y*28+138
           // food.y=x*28+16
       // }
        onAddBar:{
            AddBar.createMyObjects(haha,y*28,x*28,true)
            remove_count++
        }
        onAddTrap:{
            AddTrap.createMyObjects(haha,y*28,x*28,true)
            remove_count++
        }
        onAddVitality:{
            AddVit.createMyObjects(haha,y*28,x*28,true)
            remove_count++
        }
        onAddFood:{
            AddFood.createMyObjects(haha,y*28,x*28,true)
            remove_count++
        }
        onRemove_widget:{
            for(var i=0;i<remove_count;i++)
                if(haha.children[i]!=undefined)
                    if(haha.children[i].x==y*28&haha.children[i].y==x*28)
                        haha.children[i].destroy()
        }
        onTo_trap:coord(0,y*28,x*28)
        onSaveGame:
            if(loadSnake.run)
                saveGame()//保存游戏
    }
    Text {
        x: 20
        y: 75
        width: 64
        height: 31
        color: "#ffffff"
        text: "生命值："
        font.pixelSize: 22
        font.family: myFont.name
        verticalAlignment: Text.AlignTop
    }
    Text {
        id:ssssss
        anchors.verticalCenter:parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#ffffff"
        visible: false
        text: "已死亡"
        font.pixelSize: 32
        font.family: myFont.name
        verticalAlignment: Text.AlignTop
        MouseArea{
            anchors.fill: parent
            onPressed:
            {
                ssssss.visible=false
                for(var j=0;j<loadSnake.leng;j++)
                    coord(j,0,-100)
                newGame()
            }
        }
    }
    Text {
        id:pause
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        visible: !loadSnake.run&!ssssss.visible
        text:"已暂停"
        font.pixelSize: 32
        font.family: myFont.name
        MouseArea{
            anchors.fill: parent
            onPressed: loadSnake.run=true
        }
    }
    Text {
        id:vit
        x: 30
        y: 106
        color: "#ffffff"
        text: loadMap.vitality
        font.pixelSize: 28
        font.family: myFont.name
        verticalAlignment: Text.AlignVCenter
        onTextChanged: {
            if(loadMap.vitality==0)
                ssssss.visible=true
        }
    }
    Text {
        x: 20
        y: 20
        color: "#ffffff"
        text:"已用时间:"
        font.pixelSize: 22
        font.family: myFont.name
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }
    Text{
        x:30
        y:45
        color: "#ffffff"
        text:jishi
        font.pixelSize: 28
        font.family: myFont.name
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        x: 20
        y: 151
        color: "#ffffff"
        text: "GPS定位:"
        font.family: myFont.name

        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 22
    }
    Text {
        x: 20
        y: 253
        color: "#ffffff"
        text: "蛇长:"
        font.family: myFont.name
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 22
    }
    Text {
        id:snakeleng
        x: 30
        y: 287
        color: "#ffffff"
        text: loadSnake.leng
        font.family: myFont.name
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 28
    }
    Text {
        id:gps
        x: 30
        y: 188
        color: "#ffffff"
        text: "X:"+returnx(0)+"\nY:"+returny(0)
        font.family: myFont.name
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 28
    }
    Timer{
        id:beginTime
        interval: 500
        running: false
        onTriggered:loadGame()
    }
}
