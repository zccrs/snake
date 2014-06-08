// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id:vit
    width: 28
    height: 28
    color: "#f70808"
    radius: 25
    border.width: 0
    border.color: "#ffffff"
    MouseArea
    {
        anchors.fill: parent
        drag.target: parent
        drag.axis: Drag.XandYAxis
        onPressed:
        {
            vit.x=Math.round(vit.x/28)*28-28*2
            vit.y=Math.round(vit.y/28)*28-28*2
            if(vit.x>=0&vit.y>=0)
            {
                level.levelEdit(vit.y/28,vit.x/28,0)
                generate_Vit.remove_Vit()
            }
        }

        onReleased:
        {
            vit.x=Math.round(vit.x/28)*28
            vit.y=Math.round(vit.y/28)*28
            if(level.readData(vit.y/28,vit.x/28)==0)
            {
                if(vit.x>=0&vit.y>=0)
                {
                    level.levelEdit(vit.y/28,vit.x/28,4)
                    generate_Vit.new_Vit()
                }
                else
                {
                    vit.x=-30
                    vit.y=140
                }
            }
            else
            {
                vit.x=-30
                vit.y=140
            }
        }
    }
}
