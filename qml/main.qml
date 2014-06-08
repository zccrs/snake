// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    width:854
    height:480
    FontLoader { id: myFont; source: "fzmw.ttf" }
    Image {
        id: starry
        source: "qrc:/movie.png"
        property bool movie_start: true//用来记录当前动画是在运动还是暂停
        property bool biaozhi: true
        width:854
        height:480

        //clip: true
        anchors.centerIn: parent
        PropertyAnimation {id:amplify;target: starry;properties: "scale";from:1;to:2.5;duration: 20000
            onCompleted:
            {
                if(starry.movie_start)
                    lessen.start()
                //console.log("1:"+main.movie_start+" "+amplify.running+" "+lessen.running)
            }
        }
        PropertyAnimation {id:lessen;target: starry;properties:  "scale";from:2.5;to:1;duration: 20000
           onCompleted:
           {
               if(starry.movie_start)
                   amplify.start()
               //console.log("2:"+main.movie_start+" "+amplify.running+" "+lessen.running)
           }
       }

        function off_on()//用来暂定/继续动画的函数
        {
            //console.log("3:"+main.movie_start+" "+amplify.running+" "+lessen.running)
            if(starry.movie_start)
            {
                starry.movie_start=false
                if(amplify.running)
                    amplify.pause()
                else lessen.pause()
            }
            else
            {
                starry.movie_start=true
                if(amplify.running)
                    amplify.resume()
                else lessen.resume()
            }

        }
    }
    Timer{
        running: true
        interval:100
        onTriggered: {
            amplify.start()
            start.scale=1
            start.opacity=1
            newgame.loadLevel=true//载入关卡
        }
    }
    Item{
        id:main
        z:2
        property int main_xy: 0
        NumberAnimation {id:main_coordx;duration: 800;target: main;properties: "x"; to:main.main_xy;easing.type: Easing.InBack}
        NumberAnimation {id:main_coordy;duration: 800;target: main;properties: "y"; to:main.main_xy;easing.type: Easing.InBack}
        NumberAnimation {id:main_go_x;duration: 500;target: main;properties: "x"; to:main.main_xy}
        NumberAnimation {id:main_go_y;duration: 500;target: main;properties: "y"; to:main.main_xy}
        width: 854
        height: 480
        MouseArea{
            id:yidong
            anchors.fill: parent
            z:2
            property int xx: 0
            property int yy: 0
            property bool mutual_x: true//互斥
            property bool mutual_y: true//互斥
            onPressed:
            {
                xx=mouseX
                yy=mouseY
            }
            onDoubleClicked:
            {
                loadgame.opacity=1
                start.visible=false
                yidong.enabled=false
                loadgame.begin()
            }

            onMouseXChanged:
            {
                var temp=xx-mouseX
                if(yidong.mutual_x&(temp>25|temp<-25))
                {
                    mutual_y=false
                    main.x=temp/2
                    if(temp>260)
                    {
                        yidong.mutual_x=false
                        main.main_xy=854
                        main_go_x.start()
                        //starry.off_on()
                    }
                    else if(temp<-260)
                    {
                        yidong.mutual_x=false
                        main.main_xy=-854
                        main_go_x.start()
                        //starry.off_on()
                    }
                    //console.log("xxx:"+temp)
                }
            }
            onMouseYChanged:
            {
                var temp=yy-mouseY
                if(yidong.mutual_y&(temp>25|temp<-25))
                {
                    mutual_x=false
                    main.y=temp/2
                    if(temp>200)
                    {
                        main.main_xy=480
                        yidong.mutual_y=false
                        main_go_y.start()
                        //starry.off_on()
                    }
                    else if(temp<-200)
                    {
                        main.main_xy=-480
                        yidong.mutual_y=false
                        main_go_y.start()
                        //starry.off_on()
                    }

                    //console.log("yyy:"+temp)
                }
            }
            onReleased: {
                if(main.x!=0&main.x!=854&main.x!=-854)
                {
                    main.main_xy=0
                    main_go_x.start()
                }
                else if(main.y!=0&main.y!=480&main.y!=-480)
                {
                    main.main_xy=0
                    main_go_y.start()
                }
                mutual_x=true
                mutual_y=true
            }
        }
        Image {
            id: start
            anchors.centerIn: parent
            source: "qrc:/main.png"
            opacity: 0
            scale:0
            Behavior on scale{
               PropertyAnimation {duration: 1500}
            }
            Behavior on opacity{
               PropertyAnimation {duration: 2500}
            }
        }
        LoadGame{
            id:loadgame
            anchors.fill: parent
            z:1
            opacity: 0
            Behavior on opacity{
               PropertyAnimation {duration: 800}
            }
            Text {
                text: "返回"
                x:20;y:430
                color:"white"
                font.family: myFont.name
                font.pixelSize: 32
                z:1
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        loadgame.running=false
                        loadgame.opacity=0
                        loadSnake.run=false
                        loadgame.saveGame()//保存进度
                        loadgame.xiaohui()
                        //starry.off_on()//改变动画状态
                        start.visible=true
                        yidong.enabled=true
                    }
                }
            }
        }
        SelectLevel{
            id:newgame
            y:-main.height
            z:1
            Text {
                text: "返回"
                font.family: myFont.name
                x:20;y:430
                color:"white"
                font.pixelSize: 28
                z:1
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        snake.run=false
                        //main.y=0
                        main.main_xy=0
                        main_coordy.start()
                        //starry.off_on()//改变动画状态
                        //newgame.xiaohuiSelect()
                    }
                }
            }
        }
        Help{
            id:help
            x:-main.width
            z:1
            Text {
                text: "返回"
                x:20;y:430
                color:"white"

                font.family: myFont.name
                font.pixelSize: 28
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        //main.x=0
                        main.main_xy=0
                        main_coordx.start()
                        //starry.off_on()//改变动画状态
                    }
                }
            }
        }
        Set{
            id:set
            x:main.width
            z:1
            //opacity:0
            Text {
                text: "返回"
                font.family: myFont.name
                x:20;y:430
                color:"white"
                font.pixelSize: 28
                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        //main.x=0
                        main.main_xy=0
                        main_coordx.start()
                        //starry.off_on()//改变动画状态
                    }
                }
            }
        }
        About{
            id:about
            y:main.height
            z:1
            Text {
                text: "返回"
                x:20;y:430
                color:"white"
                font.family: myFont.name
                font.pixelSize: 28
                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        //main.y=0
                        main.main_xy=0
                        main_coordy.start()
                        //starry.off_on()//改变动画状态
                    }
                }
            }
        }
    }
}
