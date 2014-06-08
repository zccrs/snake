var component
function createMyObjects(pro,x,y,shift)
{

    if(shift==false)
        component = Qt.createComponent("./Food.qml");//食物
    else component = Qt.createComponent("./FixedFood.qml");//食物
    component.createObject(pro,{x:x,y:y});
}
