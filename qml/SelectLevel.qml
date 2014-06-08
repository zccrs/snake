// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    width: 854;height: 480
    id:selectlevel

    property int count:0
    property bool loadLevel: false
    onLoadLevelChanged:
    {
        console.log("level is:"+settings.getValue("level",0))
        for(var i=0;i<settings.getValue("level",0);i++)
            model.append({"level":i+1})
    }

    function xiaohuiSelect()
    {
        model.clear()
    }
    LevelEdit{
        id:sss
        x:854
        z:1
        width: 854;height: 480
        Rectangle{
            width: 100;height: 50
            color: "#fd1e09"
            radius: 25
            x:25;y:35
            Text {
                text:"返回"
                font.family: myFont.name
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 32
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onClicked:
                {
                    selectlevel.x=0
                    sss.dispose()
                    //xiaohuiSelect()
                    //newSelect()
                    if(list.count<settings.getValue("level",0))
                        model.append({"level":parseInt(list.count)+1})
                }

            }
        }
    }
    Rectangle {
        id: rectangle5
        x: 327
        y: 41
        z:1
        width: 200
        height: 66
        color: "#fdf902"
        radius: 33
        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: "新建关卡"
            font.pixelSize: 32
            font.family: myFont.name
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        MouseArea{
            anchors.fill: parent
            onClicked:
            {
                sss.new_module()
                selectlevel.x=-854
            }
        }
    }
    ListModel{id:model}
    Component{
        id:delegate
        Item {
            y:200
            width: childrenRect.width+5
            height: 480
            Text {
               // property int jishi: 0;//用来计时，计算关卡选项被按下的时间
                text: level
                font.pixelSize: 48
                color: "white"
                opacity: 0.8
                font.family: myFont.name
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        parent.focus=true
                    }
                }
                onFocusChanged:
                {
                    if(focus)
                    {
                        opacity=1
                        scale=1.5
                        count=text
                    }
                    else
                    {
                        opacity=0.7
                        scale=1
                        count=0

                    }
                }
            }
        }
    }
    ListView{
        id:list
        clip: true
        width: 854;height: 480
        snapMode: ListView.SnapToItem
        maximumFlickVelocity: 5000
        model: model
        delegate: delegate
        orientation: ListView.Horizontal
        opacity: 30
        cacheBuffer: 0
    }
    Rectangle{
        radius: 8
        height: 40;width: 100
        color: "yellow"
        z:1
        anchors.horizontalCenter: parent.horizontalCenter
        y:360
        Text{
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: "开始"
            font.pixelSize: 28
            font.family: myFont.name
            color: "black"
        }
        MouseArea{
            anchors.fill: parent
            onClicked:
            {
                if(count!=0)
                {
                    selectlevel.y=0
                    map.level=count
                    game.begin()
                }
            }
        }
    }
    Game{
        id:game
        y:-selectlevel.height
        Text {
            text: "返回"
            x:20;y:430
            color:"white"
            font.pixelSize: 28
            font.family: myFont.name
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    game.running=false
                    snake.run=false
                    selectlevel.y=-480
                    game.saveGame()//保存进度
                    game.xiaohui()
                }
            }
        }
    }
    Behavior on x{
        NumberAnimation {duration: 800; easing.type: Easing.InOutQuad }
    }
    Behavior on y{
        NumberAnimation {duration: 800 ; easing.type: Easing.InOutQuad}
    }
}
