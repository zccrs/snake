var component
function createMyObjects(pro,x,y,shift) {

    if(shift==false)
        component = Qt.createComponent("./Bar.qml");//陷阱
    else component = Qt.createComponent("./FixedBar.qml");//不能活动的陷阱
    component.createObject(pro,{x:x,y:y});
}
