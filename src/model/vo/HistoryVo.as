package model.vo 
{
	import flash.geom.Point;
/**
 * ...历史数据
 * @author ...
 */
public class HistoryVo 
{
	public static const DELETE:int = 0;//删除
	public static const COPY:int = 1;//复制
	public static const CREATE:int = 2;//创建
	public static const PROP:int = 3;//属性更新
	public static const CLEAR:int = 4;//舞台清空
	public static const ALL_PROP:int = 5;//整体属性操作
	//操作类型
	public var type:int;
	//操作对象
	public var target:Object;
	//深度
	public var depth:int;
	//显示对象的深度
	public var childIndex:int;
	//坐标
	public var x:Number;
	public var y:Number;
	//缩放
	public var scaleX:Number;
	public var scaleY:Number;
	//角度
	public var rotation:Number;
	//是否循环
	public var isLoop:Boolean;
	//动画名字
	public var animationName:String;
	public var animationIndex:int;
	//名字
	public var name:String;
	//保存下一次数据 用于操作属性
	public var nextVo:HistoryVo;
	//用于保存清空舞台后的数据列表
	public var displayList:Array;
	//保存所有物体的属性操作记录的列表
	public var historyVoList:Array;
	public function HistoryVo() 
	{
		
	}
	
}
}