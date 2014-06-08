// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
Rectangle {
    id:trap
    width: 28
    height: 28
    color: "white"
    MouseArea
    {
        anchors.fill: parent
        drag.target: parent
        drag.axis: Drag.XandYAxis
        onPressed:
        {
            trap.x=Math.round(trap.x/28)*28-28*2
            trap.y=Math.round(trap.y/28)*28-28*2
            if(trap.x>=0&trap.y>=0)
            {
                level.levelEdit(trap.y/28,trap.x/28,0)
                generate_Trap.remove_Trap()
            }
        }

        onReleased:
        {
            trap.x=Math.round(trap.x/28)*28
            trap.y=Math.round(trap.y/28)*28
            if(level.readData(trap.y/28,trap.x/28)==0)
            {
                if(trap.x>=0&trap.y>=0)
                {
                    level.levelEdit(trap.y/28,trap.x/28,1)
                    generate_Trap.new_Trap()
                }
                else
                {
                    trap.x=-30
                    trap.y=330
                }
            }
            else
            {
                trap.x=-30
                trap.y=330
            }
        }
    }
}
