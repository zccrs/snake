// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "addBar.js" as AddBar
import "addTrap.js" as AddTrap
import "addFood.js" as AddFood
import "addVit.js" as AddVit

Item{
    id:sss
    property int trapCount: 0
    property int barCount: 0
    property int foodCount: 0
    property int vitCount: 0
    function dispose()
    {
        var i
        for(i=0;i<trapCount;i++)
            if(generate_Trap.children[i]!=undefined)
                generate_Trap.children[i].destroy()
        for(i=0;i<barCount;i++)
            if(generate_Bar.children[i]!=undefined)
                generate_Bar.children[i].destroy()
        for(i=0;i<foodCount;i++)
            if(generate_Food.children[i]!=undefined)
                generate_Food.children[i].destroy()
        for(i=0;i<vitCount;i++)
            if(generate_Vit.children[i]!=undefined)
                generate_Vit.children[i].destroy()
    }
    function new_module()
    {
        trapCount=0
        barCount=0
        foodCount=0
        vitCount=0
        generate_Bar.new_Bar()
        generate_Food.new_Food()
        generate_Trap.new_Trap()
        generate_Vit.new_Vit()
    }
    Connections{
        target: level
        onAddVitality:
        {
            generate_Vit.new_Vit();//增加血瓶
            generate_Vit.children[vitCount-1].x=x
            generate_Vit.children[vitCount-1].y=y
        }
        onAddFood:
        {
            generate_Food.new_Food();//增加血瓶
            generate_Food.children[foodCount-1].x=x
            generate_Food.children[foodCount-1].y=y
        }
        onAddTrap:
        {
            generate_Trap.new_Trap();//增加血瓶
            generate_Trap.children[trapCount-1].x=x
            generate_Trap.children[trapCount-1].y=y
        }
        onAddBar:
        {
            generate_Bar.new_Bar();//增加血瓶
            generate_Bar.children[barCount-1].x=x
            generate_Bar.children[barCount-1].y=y
        }

    }
    Rectangle {
        id:edit
        width: 700;height: 448
        x:138;y:16
        color: "#fbd307"
        Grid{
            width: 700
            height: 448
            rows: 16
            Repeater{
                model: 400
                Rectangle{
                    color: "black"
                    width: 28;height: 28
                    border.color: "#05ff3f"
                    border.width: 1
                }
            }
        }
        Rectangle{
            id:generate_Trap
            width:0;
            height:0;
            z:1
            function new_Trap()
            {
                if(prompt.visible)
                    prompt.visible=false
                AddTrap.createMyObjects(generate_Trap,-30,330,false)
                trapCount++
            }
            function remove_trap()
            {
                generate_Trap.children[--trapCount].destroy()
            }
        }
        Rectangle{
            id:generate_Bar
            width:0;
            height:0;
            z:1
            function new_Bar()
            {
                if(prompt.visible)
                    prompt.visible=false
                AddBar.createMyObjects(generate_Bar,-30,265,false)
                barCount++
            }
            function remove_Bar()
            {
                generate_Bar.children[--barCount].destroy()
            }
        }
        Rectangle{
            id:generate_Vit
            width:0;
            height:0;
            z:1
            function new_Vit()
            {
                if(prompt.visible)
                    prompt.visible=false
                AddVit.createMyObjects(generate_Vit,-30,140,false)
                vitCount++
            }
            function remove_Vit()
            {
                generate_Vit.children[--vitCount].destroy()
            }
        }
        Rectangle{
            id:generate_Food
            width:0;
            height:0;
            z:1
            function new_Food()
            {
                if(prompt.visible)
                    prompt.visible=false
                AddFood.createMyObjects(generate_Food,-30,200,false)
                foodCount++
            }
            function remove_Food()
            {
                generate_Food.children[--foodCount].destroy()
            }
        }
        Rectangle{
            color: "yellow"
            radius: 24
            opacity: 0.6
            x:1
            visible: prompt.visible
            width: prompt.width+50
            height: prompt.height+50
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            }
        Text {
            id:prompt
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#ffffff"
            visible: false
            x:1

            font.pixelSize: 32
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            onTextChanged:    prompt.visible=true
        }
    }
    Rectangle{
        width: 100;height: 50
        color: "#fd1e09"
        radius: 25
        x:25;y:399
        Text {
            x: 18
            y: 9
            text:"保存"
            font.family: myFont.name
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 32
            color: "white"
        }
        MouseArea{
            anchors.fill: parent
            onClicked:
            {
                var temp=level.addLevel(parseInt(settings.getValue("level",0))+1)

                if(temp>0)
                {
                    //console.log("hahah")
                    prompt.text="已保存为第"+temp+"关"
                    settings.setValue("level",temp)
                    dispose()//销毁组件
                }
                else if(temp==0)
               {
                    prompt.text="保存失败"
                    dispose()//销毁组件
                }
                else if(temp==-1)
                    prompt.text="不能只有一个井"
           }
        }
    }

}
