// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    width: 854;height: 480
    Text {
        id: help
        text: "操作技巧：双击暂停/开始\n          可以点触转向、滑动转向、重力感应转向"
        font.pixelSize: 28
        font.family: myFont.name
        color:"white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
}
