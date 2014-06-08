// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id:set
    height: 480;width: 854
    property int count: 0
    Rectangle{
        id:sensorSwitch
        x:46;y:226
        height: 30;width: 60
        color: settings.getValue("switch",0)==1?"yellow":"white"
        radius: 14
        Rectangle{
            x:settings.getValue("switch",0)*30
            width: 30;height: 30
            radius: 14
            color:"red"
            MouseArea{
                anchors.fill: parent
                onPressed:
                    if(parent.x)
                    {
                        settings.setValue("switch",0)
                        console.log(settings.getValue("switch",0))
                        parent.x=0
                        sensorSwitch.color="white"
                    }
                    else {
                        settings.setValue("switch",1)
                        console.log(settings.getValue("switch",0))
                        parent.x=30
                        sensorSwitch.color="yellow"
                    }
                }
            }
    }
    Rectangle {
        id: rectangle1
        x: 213
        y: 225
        width: 428
        height: 30
        color: "#1aecc9"
        radius: 14
        border.width: 2
        border.color: "#ffffff"
        Text {
            id: text2
            x: 135
            y: 3
            color: "#02000d"
            text: "重力感应灵敏度"
            font.family: myFont.name
            opacity: 0.610
            font.pixelSize: 24
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }


    Rectangle {
        id: rectangle2
        x: parseInt(settings.getValue("sensor",20))*10+113
        y: 206
        width: 28;height: 68
        color: "#f6fd11"
        radius: 13
        border.width: 2
        border.color: "#ffffff"
        MouseArea{
            anchors.fill: parent
            drag.target: rectangle2
            drag.axis: Drag.XAxis
            drag.minimumX: 213
            drag.maximumX: 613
        }
        onXChanged: settings.setValue("sensor",(x-113)/10)
    }

    Rectangle {
        id: rectangle3
        x: 673
        y: 217
        width: 68
        height: 48
        color: "#8bf519"
        radius: 13
        border.width: 3
        border.color: "#ffffff"
        Text {
            color: "#000000"
            text: "+"
            font.pixelSize: 32
            font.family: myFont.name
            anchors.centerIn: parent
        }
        MouseArea{
            id:button3
            anchors.fill: parent
            onPressed:{
                if(rectangle2.x<613)
                      rectangle2.x++
            }
        }
        scale: button3.pressed?1.1:1.0
    }

    Rectangle {
        id: rectangle4
        x: 111
        y: 217
        width: 68
        height: 48
        color: "#88f90e"
        radius: 13
        border.width: 3
        border.color: "#ffffff"
        Text {
            text: "-"
            font.pixelSize: 32
            anchors.centerIn: parent
            font.family: myFont.name
        }
        MouseArea{
            id:button4
            anchors.fill: parent
            onPressed:
            {
                if(rectangle2.x>213)
                       rectangle2.x--
            }
        }
        scale: button4.pressed?1.1:1.0
    }

    Text {
        id: text1
        x: 377
        y: 150
        color: "#ffffff"
        text: (rectangle2.x-113)/10
        opacity: 0.680
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font.pixelSize: 50
        font.family: myFont.name
    }

    Text {
        id: text3
        x: 325
        y: 276
        color: "#fffdfd"
        text: "值越小越灵敏"
        opacity: 0.560
        font.strikeout: false
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        style: Text.Raised
        font.family: myFont.name
        font.pixelSize: 34
    }
    Behavior on x{
        NumberAnimation {duration: 800; easing.type: Easing.InOutQuad }
    }
    Behavior on y{
        NumberAnimation {duration: 800 ; easing.type: Easing.InOutQuad}
    }
}
