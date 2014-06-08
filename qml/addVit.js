var component
function createMyObjects(pro,x,y,shift)
{

    if(shift==false)
        component = Qt.createComponent("./Vitality.qml");//生命
    else component = Qt.createComponent("./FixedVitality.qml");//生命
    component.createObject(pro,{x:x,y:y});
}
