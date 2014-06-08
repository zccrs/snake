// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Grid
{
    x:138
    y:-28
    width: 700
    height: 448
    rows: 1
    Repeater{
        id:cell
        model:80
        Rectangle{
            width: 25;height: 25
            color: "red"
            radius: 5
            //border.width: 1
            //border.color: "#f3e40e"
        }
    }
}
