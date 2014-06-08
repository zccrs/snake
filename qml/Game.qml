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
    property int inter: snake.inter
    property int remove_count: 0

    property bool running: false

    property bool gameRunning: Qt.application.active
    onGameRunningChanged:
        if(running)
            snake.run=gameRunning
    function begin()
    {
        beginTime.running=true//倒计时开始
    }
    function saveGame()
    {
        settings.setValue("store_level",map.level)//保存是第几关
        settings.setValue("store_direction",snake.direction)//保存蛇的方向
        settings.setValue("store_vit",map.vitality)//保存蛇的血量
        settings.setValue("store_leng",snake.leng)//储存蛇的长度
        settings.setValue("store_jishi",jishi)//保存已用时间
        settings.setValue("store_snakeRun",snake.run)//保存蛇的运行状态
        //settings.setValue("store_foodcoordx",food.x)
        //settings.setValue("store_foodcoordy",food.y)
        //settings.setValue("store_vitcoordx",vitality.x)
        //settings.setValue("store_vitcoordy",vitality.y)
        var temp="stort_body"
        for(var i=0;i<snake.leng;i++)
        {
            settings.setValue(temp+i+"x",returnx(i))
            settings.setValue(temp+i+"y",returny(i))
        }
        map.saveMapData()//保存地图数据
    }
    function newGame()
    {
        running=true
        map.initializeMap();//初始化地图数据
        snake.initializeData();//初始化数据
        map.vitality=10
        for(var i=0;i<snake.leng;i++)
        {
            coord(i,28*(snake.leng-i-1),0)
            map.bodycoord(0,i)
        }
        map.readLevel()
        //map.foodcoord()//产生第一个食物
        //map.vitalitycoord()//产生血瓶
        snake.run=true
        jishi=0
    }
    function xiaohui()
    {
        for(var i=0;i<map.count;i++)
            if(haha.children[i]!=undefined)
                haha.children[i].destroy()
        map.count=0;//令计数变为0
        for(i=0;i<snake.leng;i++)
            coord(i,-50,-50)
    }

    function coord(n,newx,newy)
    {
        grid.children[n].x=newx
        grid.children[n].y=parseInt(newy)+44
    }
    function returnx(x)
    {
        return grid.children[x].x
    }
    function returny(x)
    {
        return grid.children[x].y-44
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
        active: settings.getValue("switch",0)&snake.run
        onReadingChanged:snake.sensorxy(reading.x,reading.y)
    }*///重力感应
    MouseArea{
        id:move
        x:138
        y:16
        width: 700
        height: 448
        onPressed: {
            if(snake.run)
            {
                coordx=mouseX
                coordy=mouseY
                judge=true
            }
        }
        onPositionChanged: {
            if(snake.run)
                count++
        }
        onReleased: {
            if(snake.run)
            {
                if(count>2)
                   snake.mousechange(coordx,coordy,mouseX,mouseY)
                else if(judge)
                   snake.coordchange(coordx,coordy)
                count=0
                judge=false
            }
        }
        onDoubleClicked: {
            mouse.accepted=true
            judge=false
            snake.run=false
            pause.visible=true
        }

    }
    Connections{
        target: snake
        onMove: {
            //console.log("coord:"+n+" "+x+" "+y)
            coord(n,x,y)//改变第n节蛇身位置
            if(n==0)
                gps.text="X:"+returnx(0)+"\nY:"+returny(0)
        }
        onGetcoord:snake.setcoord(returnx(n),returny(n))
        onNoclip: map.vitality--;
        onInterChanged: inter=snake.inter
        //onRunChanged :
            //if(snake.run)
                //time.running=snake.run

        onGainsensorxy: if(sensor.active)
                            snake.setchxy(sensor.reading.x,sensor.reading.y)

        onLengChanged:snakeleng.text=snake.leng
    }

    //Vitality{id:vitality}
    //Food{id:food}
    Rectangle{
        id:haha
        width:0
        height:0
        x:138
        y:16
    }
    Connections{
        target: map
        onVitalityChanged:vit.text=map.vitality
        /*onAddVitality: {
            vitality.x=28*y+138
            vitality.y=28*x+16
        }
        onFoodChanged: {
            food.x=y*28+138
            food.y=x*28+16
        }*/
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

        onTo_trap:{
            coord(0,y*28,x*28)
        }
        onSaveGame:
            if(snake.run)
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
                for(var j=0;j<snake.leng;j++)
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
        visible: false
        text:"已暂停"
        font.pixelSize: 32
        font.family: myFont.name
        MouseArea{
            anchors.fill: parent
            onPressed: {
                pause.visible=false
                snake.run=true
            }
        }
    }
    Text {
        id:vit
        x: 30
        y: 106
        color: "#ffffff"
        text: map.vitality
        font.pixelSize: 28
        font.family: myFont.name
        verticalAlignment: Text.AlignVCenter
        onTextChanged: {
            if(map.vitality==0)
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
        text: snake.leng
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
        onTriggered:newGame()
    }
}
