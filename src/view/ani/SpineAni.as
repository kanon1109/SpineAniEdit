package view.ani
{
import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.filesystem.File;
import flash.net.URLLoader;
import flash.net.URLRequest;
import message.Message;
import spine.SkeletonData;
import spine.SkeletonJson;
import spine.animation.Animation;
import spine.animation.AnimationStateData;
import spine.atlas.Atlas;
import spine.attachments.AtlasAttachmentLoader;
import spine.flash.FlashTextureLoader;
import spine.flash.SkeletonAnimation;

/**
 * ...动画对象
 * @author Kanon
 */
public class SpineAni extends Sprite
{
	private var file:File;
	private var textureLoader:Loader = new Loader();
	private var atlasLoader:URLLoader = new URLLoader();
	private var jsonLoader:URLLoader = new URLLoader();
	private var bitmap:Bitmap;
	private var jsonData:*;
	private var atlasData:*;
	private var skeleton:SkeletonAnimation;
	private var _jsonName:String;
	private var _atlasName:String;
	private var _pngName:String;
	private var _pathName:String;
	private var skeletonData:SkeletonData;
	private var stateData:AnimationStateData;
	private var _isLoop:Boolean = true;
	private var _animationName:String;
	private var _animationIndex:int = 0;
	public function SpineAni()
	{
	}
	
	public function load(url:String):void
	{
		this.destroy();
		if (!this.file) this.file = new File(url);
		else this.file.nativePath = url;
		this._pathName = url;
		if (!this.file.isDirectory)
		{
			this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			return;
		}
		var pathList:Array = this.file.getDirectoryListing();
		var length:int = pathList.length;
		var message:String = "----------- loading ----------- \n";
		for (var i:int = 0; i < length; i++)
		{
			var name:String = pathList[i].name;
			var path:String = pathList[i].nativePath;
			var arr:Array = name.split(".");
			message += path + "\n";
			switch (arr[1])
			{
			case "png": 
				this._pngName = name;
				this.textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, textureLoadCompleteHandler);
				this.textureLoader.load(new URLRequest(path));
				break;
			case "atlas": 
				this._atlasName = name;
				this.atlasLoader.addEventListener(Event.COMPLETE, atlasLoadCompleteHandler);
				this.atlasLoader.load(new URLRequest(path));
				break;
			case "json": 
				this._jsonName = name;
				this.jsonLoader.addEventListener(Event.COMPLETE, jsonLoadCompleteHandler);
				this.jsonLoader.load(new URLRequest(path));
				break;
			}
		}
		ApplicationFacade.getInstance().sendNotification(Message.LOAD_MSG, message);
	}
	
	private function jsonLoadCompleteHandler(event:Event):void
	{
		this.jsonLoader.removeEventListener(Event.COMPLETE, jsonLoadCompleteHandler);
		this.jsonData = this.jsonLoader.data;
		this.createSpineAni();
	}
	
	private function atlasLoadCompleteHandler(event:Event):void
	{
		this.atlasLoader.removeEventListener(Event.COMPLETE, atlasLoadCompleteHandler);
		this.atlasData = this.atlasLoader.data;
		this.createSpineAni();
	}
	
	private function textureLoadCompleteHandler(event:Event):void
	{
		this.textureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, textureLoadCompleteHandler);
		this.bitmap = this.textureLoader.content as Bitmap;
		this.createSpineAni();
	}
	
	/**
	 * 加载spine
	 * @param	pngName			图片名称
	 * @param	atlasName		图集名称
	 * @param	jsonName		数据名称
	 * @param	nativePath		路径
	 */
	public function loadSpine(pngName:String, atlasName:String, jsonName:String, nativePath:String):void
	{
		this._pngName = pngName;
		this.textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, textureLoadCompleteHandler);
		this.textureLoader.load(new URLRequest(nativePath + "\\" + pngName));
		
		this._atlasName = atlasName;
		this.atlasLoader.addEventListener(Event.COMPLETE, atlasLoadCompleteHandler);
		this.atlasLoader.load(new URLRequest(nativePath + "\\" + atlasName));
		
		this._jsonName = jsonName;
		this.jsonLoader.addEventListener(Event.COMPLETE, jsonLoadCompleteHandler);
		this.jsonLoader.load(new URLRequest(nativePath + "\\" + jsonName));
	}
	
	/**
	 * 创建骨骼动画
	 */
	private function createSpineAni():void
	{	
		if (!this.bitmap) return;
		if (!this.jsonData) return;
		if (!this.atlasData) return;
		if (this.skeleton) return;
		this.initSpineAni(this.bitmap, this.atlasData, this.jsonData);
		this.dispatchEvent(new Event(Event.COMPLETE));
	}
	
	/**
	 * 初始化动画
	 * @param	bitmap			位图对象
	 * @param	atlasData		图集对象
	 * @param	jsonData		数据对象
	 * @return	骨骼动画数据
	 */
	public function initSpineAni(bitmap:Bitmap, atlasData:*, jsonData:*):void
	{
		this.bitmap = bitmap;
		this.atlasData = atlasData;
		this.jsonData = jsonData;
		var atlas:Atlas = new Atlas(atlasData, new FlashTextureLoader(bitmap));
		var json:SkeletonJson = new SkeletonJson(new AtlasAttachmentLoader(atlas));
		this.skeletonData = json.readSkeletonData(jsonData);
		this.stateData = new AnimationStateData(skeletonData);
		this.skeleton = new SkeletonAnimation(skeletonData, stateData);
		this.addChild(skeleton);
	}
	
	/**
	 * 设置spine的资源名称
	 * @param	pngName		png名称
	 * @param	atlasName	图集名称
	 * @param	jsonName	骨骼数据名称
	 */
	public function setSpineResName(pngName:String, atlasName:String, jsonName:String):void
	{
		this._pngName = pngName;
		this._atlasName = atlasName;
		this._jsonName = jsonName;
	}
	
	public override function get width():Number
	{
		if (!this.skeleton) return this.width;
		return this.skeleton.width;
	}
	
	public override function get height():Number
	{
		if (!this.skeleton) return this.height;
		return this.skeleton.height;
	}
	
	/**
	 * 播放
	 * @param	frame	动画名称
	 */
	public function play(frame:String):void
	{
		if (!this.skeleton) return;
		this.unPause();
		this._animationIndex = this.getAnimationIndexByName(frame);
		this.skeleton.state.setAnimationByName(0, frame, this._isLoop);
	}
	
	/**
	 * 播放默认动画
	 */
	public function playDefault():void
	{
		this.playAni(0, true);
	}
	
	/**
	 * 播放默认动画
	 * @param	frameIndex	帧索引
	 * @param	loop		是否循环
	 */
	public function playAni(animationIndex:int, loop:Boolean = true):void
	{
		if (!this.skeleton) return;
		this.unPause();
		if (animationIndex < 0) animationIndex = 0;
		if (animationIndex > this.skeletonData.animations.length - 1) animationIndex = this.skeletonData.animations.length - 1;
		var ani:Animation = this.skeletonData.animations[animationIndex];
		var frame:String = ani.name;
		this._animationName = frame;
		this._isLoop = loop;
		this._animationIndex = animationIndex;
		this.skeleton.state.setAnimationByName(0, frame, loop);
	}
	
	public function pause():void
	{
		if (!this.skeleton) return;
		this.skeleton.state.timeScale = 0;
	}
	
	public function unPause():void
	{
		if (!this.skeleton) return;
		this.skeleton.state.timeScale = 1;
	}
	
	private function removeBitmap():void
	{
		if (!this.bitmap) return;
		this.bitmap.bitmapData.dispose();
		this.bitmap = null;
	}
	
	/**
	 * 销毁
	 */
	private function destroy():void
	{
		this.jsonData = null;
		this.atlasData = null;
		this.skeletonData = null;
		this.stateData = null;
		this.removeBitmap();
		if (this.skeleton && this.skeleton.parent)
		{
			this.skeleton.parent.removeChild(this.skeleton);
			this.skeleton = null;
		}
	}
	
	/**
	 * 获取所有动画
	 * @return
	 */
	public function getAnimations():Array
	{
		var arr:Array = [];
		var length:int = this.skeletonData.animations.length;
		for (var i:int = 0; i < length; i++) 
		{
			var ani:Animation = this.skeletonData.animations[i];
			arr.push(ani.name);
		}
		return arr;
	}
	
	/**
	 * 根据索引获取动画名称
	 * @param	index	索引
	 * @return
	 */
	public function getAnimationNameByIndex(index:int):String
	{
		if (!this.skeletonData) return null;
		var ani:Animation = this.skeletonData.animations[index];
		if (ani) return ani.name;
		return null;
	}
	
	/**
	 * 根据名字获取动画索引
	 * @param	name		动画名称
	 */
	public function getAnimationIndexByName(name:String):int
	{
		if (!this.skeletonData) return -1;
		var length:int = this.skeletonData.animations.length;
		for (var i:int = 0; i < length; ++i) 
		{
			var ani:Animation = this.skeletonData.animations[i];
			if (ani.name == name)
			{
				return i;
			}
		}
		return -1;
	}
	
	/**
	 * 克隆一个对象
	 * @return
	 */
	public function clone():SpineAni
	{
		var spineAni:SpineAni = new SpineAni();
		spineAni.initSpineAni(this.bitmap, this.atlasData, this.jsonData);
		spineAni.setSpineResName(this._pngName, this._atlasName, this._jsonName);
		spineAni.pathName = this.pathName;
		spineAni.scaleX = this.scaleX;
		spineAni.scaleY = this.scaleY;
		spineAni.rotation = this.rotation;
		spineAni.x = this.x + 30;
		spineAni.y = this.y + 30;
		spineAni.isLoop = this.isLoop;
		spineAni.animationName = this.animationName;
		return spineAni;
	}
	
	public function get jsonName():String {return _jsonName; }
	public function get atlasName():String {return _atlasName; }
	public function get pngName():String {return _pngName; }
	
	public function get pathName():String {return _pathName; }
	public function set pathName(value:String):void 
	{
		_pathName = value;
	}
	/**
	 * 是否循环
	 */
	public function get isLoop():Boolean {return _isLoop; }
	public function set isLoop(value:Boolean):void 
	{
		_isLoop = value;
		this.playAni(this._animationIndex, value);
	}
	
	/**
	 * 当前帧标签
	 */
	public function get animationName():String {return _animationName;}
	public function set animationName(value:String):void 
	{
		_animationName = value;
	}
	
	/**
	 * 动画索引
	 */
	public function get animationIndex():int {return _animationIndex; }

}
}