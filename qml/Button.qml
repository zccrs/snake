// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Text
{
    property string label
    signal buttonclicked()
    id:button
    text:label
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    opacity: mouse.pressed?0.7:1
    color:"white"
    font.family: myFont.name
    scale: mouse.pressed?1.1:1
    width: 150
    height: 40
    font.pixelSize: 34
    Behavior on scale{NumberAnimation {duration: 100; easing.type: Easing.InOutQuad }}
    Behavior on opacity{NumberAnimation {duration: 300; easing.type: Easing.InOutQuad }}
    Behavior on x{NumberAnimation {duration: 1000; easing.type: Easing.InOutQuad }}
    Behavior on y{NumberAnimation {duration: 1000; easing.type: Easing.InOutQuad }}
    MouseArea{
        id:mouse
        anchors.fill: parent
        onClicked: buttonclicked()
    }
}
