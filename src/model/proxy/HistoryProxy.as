package model.proxy 
{
import flash.display.Sprite;
import flash.geom.Point;
import model.vo.HistoryVo;
import org.puremvc.as3.patterns.proxy.Proxy;
import view.ani.SpineAni;
/**
 * ...历史记录数据管理
 * @author ...	Kanon
 */
public class HistoryProxy extends Proxy 
{
	//保存历史列表
	public static const NAME:String = "HistoryProxy";
	private var historyMaxCount:int = 100;
	private var historyAry:Array = [];
	//当前记录索引
	private var curIndex:int = -1;
	public function HistoryProxy(proxyName:String=null, data:Object=null) 
	{
		super(NAME, data);
	}
	
	/**
	 * 添加历史记录
	 * @param	vo	记录数据
	 */
	public function addHistory(vo:HistoryVo):void
	{
		if (!vo) return;
		if (this.curIndex < this.historyAry.length - 1)
			this.historyAry.splice(this.curIndex + 1);
		this.historyAry.push(vo);
		if (this.historyAry.length > this.historyMaxCount)
			this.historyAry.splice(0, 1);
		this.curIndex = this.historyAry.length - 1;
	}
	
	/**
	 * 撤销
	 * @return	记录数据
	 */
	public function prevHistory():HistoryVo
	{
		if (this.historyAry.length == 0) return null;
		if (this.curIndex == -1) return null;
		var index:int = this.curIndex;
		this.curIndex--;
		if (this.curIndex < 0) this.curIndex = -1; 
		return this.historyAry[index];
	}
	
	/**
	 * 恢复撤销
	 * @return	记录数据
	 */
	public function nextHistory():HistoryVo
	{
		if (this.curIndex == this.historyAry.length - 1 || 
			this.historyAry.length == 0) return null;
		this.curIndex++;
		return this.historyAry[this.curIndex];
	}
	
	/**
	 * 清理历史记录
	 */
	public function clear():void
	{
		this.historyAry = [];
	}
	
	
	/**
	 * 保存记录
	 * @param	spt		显示对象
	 * @param	type	保存类型
	 */
	public function saveHistory(spt:Sprite, type:int):HistoryVo
	{
		var hVo:HistoryVo = this.createHistoryVo(spt, type);
		this.addHistory(hVo);
		return hVo;
	}
	
	
	/**
	 * 创建历史记录数据
	 * @param	spt		显示对象
	 * @param	type	保存类型
	 * @return	记录数据
	 */
	private function createHistoryVo(spt:Sprite, type:int):HistoryVo
	{
		var hVo:HistoryVo = new HistoryVo();
		hVo.target = spt;
		hVo.type = type;
		hVo.x = spt.x;
		hVo.y = spt.y;
		hVo.scaleX = spt.scaleX;
		hVo.scaleY = spt.scaleY;
		hVo.rotation = spt.rotation;
		if (spt is SpineAni)
		{
			var ani:SpineAni = spt as SpineAni;
			hVo.animationName = ani.animationName;
			hVo.animationIndex = ani.animationIndex;
			hVo.isLoop = ani.isLoop;
		}
		hVo.childIndex = spt.parent.getChildIndex(spt);
		hVo.name = spt.name;
		return hVo;
	}
	
	/**
	 * 保存属性操作的下一步
	 * @param	spt		显示对象
	 * @return
	 */
	public function saveNextHistory(spt:Sprite):HistoryVo
	{
		return this.createHistoryVo(spt, HistoryVo.PROP);
	}
	
	/**
	 * 保存清空舞台历史记录（用于清空舞台）
	 */
	public function saveAllDisplayHistory():void
	{
		var hVo:HistoryVo = new HistoryVo();
		hVo.type = HistoryVo.CLEAR;
		hVo.displayList = [];
		var count:int = Layer.ANI_STAGE.numChildren;
		for (var i:int = 0; i < count; i++) 
		{
			hVo.displayList.push(Layer.ANI_STAGE.getChildAt(i));
		}
		this.addHistory(hVo);
	}
	
	/**
	 * 保存所有显示对象的属性
	 * @param	isNext	是否保存下一步
	 * @return	历史数据
	 */
	public function saveAllDisplayProp(isNext:Boolean):HistoryVo
	{
		var hVo:HistoryVo = new HistoryVo();
		hVo.type = HistoryVo.ALL_PROP;
		hVo.historyVoList = [];
		var spt:Sprite;
		var count:int = Layer.ANI_STAGE.numChildren;
		for (var i:int = 0; i < count; i++) 
		{
			spt = Layer.ANI_STAGE.getChildAt(i) as Sprite;
			hVo.historyVoList.push(this.createHistoryVo(spt, HistoryVo.PROP));
		}
		if (!isNext) this.addHistory(hVo);
		return hVo;
	}

}
}