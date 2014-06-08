// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id:food
    width: 28
    height: 28
    color: "#8af318"
    radius: 25
    MouseArea
    {
        anchors.fill: parent
        drag.target: parent
        drag.axis: Drag.XandYAxis
        onPressed:
        {
            food.x=Math.round(food.x/28)*28-28*2
            food.y=Math.round(food.y/28)*28-28*2
            if(food.x>=0&food.y>=0)
            {
                level.levelEdit(food.y/28,food.x/28,0)
                generate_Food.remove_Food()
            }
        }

        onReleased:
        {
            food.x=Math.round(food.x/28)*28
            food.y=Math.round(food.y/28)*28
            if(level.readData(food.y/28,food.x/28)==0)
            {
                if(food.x>=0&food.y>=0)
                {
                    level.levelEdit(food.y/28,food.x/28,3)
                    generate_Food.new_Food()
                }
                else
                {
                    food.x=-30
                    food.y=200
                }
            }
            else
            {
                food.x=-30
                food.y=200
            }
        }
    }
}
