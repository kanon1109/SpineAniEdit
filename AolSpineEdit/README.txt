数据格式如下:

type: 			数据的类型 "spine"为动画，"img"为图片
x:				相对于父容器的坐标x
y:				相对于父容器的坐标y
scaleX:			x缩放率
scaleY:			y缩放率
rotation: 		角度
orderZ:			相对于父容器的层级深度

png：			图片的名称 当type=spine时代表 spine图集文件的名称
atlas：			只有在type=spine时才有代表 spine的atlas文件名称
json			只有在type=spine时才有代表 spine的json文件名称
name			图片或者spine动画的名称
animationName 	type=spine时的动画名称
isLoop			type=spine时的动画是否循环


例子：
[{
"png":"HelloWorld.png",
"type":"img",
"y":108,
"scaleX":1,
"rotation":0,
"scaleY":1,
"orderZ":0,
"x":168
"name":"HelloWorld"
},
{
"png":"Spaceship_wake_test_export.png",
"type":"spine",
"y":-24,
"scaleX":1,
"rotation":0,
"atlas":"Spaceship_wake_test_export.atlas",
"orderZ":1,
"json":"skeleton.json",
"scaleY":1,
"x":-129,
"name":"HelloWorld",
"animationName":"ready",
"isLoop":true
}]
