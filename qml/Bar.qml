// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id:bar
    width: 28
    height: 28
    color: "#f90606"
    radius: 6
    border.width: 1
    border.color: "#fbf6f6"
    MouseArea
    {
        anchors.fill: parent
        drag.target: parent
        drag.axis: Drag.XandYAxis
        onPressed:
        {
            bar.x=Math.round(bar.x/28)*28-28*2
            bar.y=Math.round(bar.y/28)*28-28*2
            if(bar.x>=0&bar.y>=0)
            {
                level.levelEdit(bar.y/28,bar.x/28,0)
                generate_Bar.remove_Bar()
            }
        }
        onReleased:
        {
            bar.x=Math.round(bar.x/28)*28
            bar.y=Math.round(bar.y/28)*28
            if(level.readData(bar.y/28,bar.x/28)==0)
            {
                if(bar.x>=0&bar.y>=0&!(bar.y==0&(bar.x==0|bar.x==28|bar.x==28*2)))
                {
                    level.levelEdit(bar.y/28,bar.x/28,2)
                    generate_Bar.new_Bar()
                }
                else
                {
                    bar.x=-30
                    bar.y=265
                }
            }
            else
            {
                bar.x=-30
                bar.y=265
            }
        }
    }
}
