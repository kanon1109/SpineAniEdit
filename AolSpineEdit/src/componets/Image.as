package componets 
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.utils.ByteArray;

/**
 * ...图片
 * @author Kanon
 */
public class Image extends Sprite 
{
	private var loader:Loader;
	private var _resName:String;
	private var _pathName:String;
	public function Image() 
	{
		this.loader = new Loader();
		this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
		this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
	}
	
	private function loadErrorHandler(event:IOErrorEvent):void 
	{
		this.dispatchEvent(event);
	}
	
	private function loadCompleteHandler(event:Event):void 
	{
		this.addChild(this.loader.content);
		this.loader.content.x = -this.loader.content.width / 2;
		this.loader.content.y = -this.loader.content.height / 2;
		this.dispatchEvent(event);
	}

	public function loadBytes(bytes:ByteArray):void
	{
		this.loader.loadBytes(bytes);
	}
	
	public function load(url:String):void
	{
		this.loader.load(new URLRequest(url));
	}
	
	/**
	 * 克隆一个图片
	 * @return
	 */
	public function clone():Image
	{
		var image:Image = new Image();
		var bmp:Bitmap = this.getChildAt(0) as Bitmap;
		var newBmp:Bitmap = new Bitmap(bmp.bitmapData);
		newBmp.x = -newBmp.width / 2;
		newBmp.y = -newBmp.height / 2;
		image.addChild(newBmp);
		image.scaleX = this.scaleX;
		image.scaleY = this.scaleY;
		image.rotation = this.rotation;
		image.x = this.x + 30;
		image.y = this.y + 30;
		image.resName = this.resName;
		image.pathName = this.pathName;
		return image;
	}
	
	public function get resName():String {return _resName;}
	public function set resName(value:String):void 
	{
		_resName = value;
	}
	
	public function get pathName():String {return _pathName;}
	public function set pathName(value:String):void 
	{
		_pathName = value;
	}
}
}