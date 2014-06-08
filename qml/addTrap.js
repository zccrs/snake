var component
function createMyObjects(pro,x,y,shift)
{

    if(shift==false)
        component = Qt.createComponent("./Trap.qml");//陷阱
    else component = Qt.createComponent("./FixedTrap.qml");//陷阱
    component.createObject(pro,{x:x,y:y});
}
