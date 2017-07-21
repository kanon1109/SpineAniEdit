package componets 
{
import com.bit101.components.Label;
import com.bit101.components.Window;
import flash.events.Event;
/**
 * ...
 * @author Kanon
 */
public class Alert 
{
	private static var alert:Window;
	private static var contentTxt:Label;
	/**
	 * 显示
	 * @param	title		标题
	 * @param	content		内容
	 */
	public static function show(title:String, content:String):void
	{
		if (!alert)
		{
			var alertWidth:int = 200;
			var alertHeight:int = 100;
			alert = new Window(Layer.SYSTEM, Layer.STAGE.stageWidth / 2 - alertWidth / 2, Layer.STAGE.stageHeight / 2 - alertHeight / 2, title); 
			alert.width = alertWidth;
			alert.height = alertHeight;
			alert.hasCloseButton = true;
			alert.addEventListener(Event.CLOSE, closeHandler);
			contentTxt = new Label(alert);
		}
		if (content != "")
		{
			contentTxt.textField.multiline = true;
			contentTxt.text = content;
			contentTxt.x = 10;
			contentTxt.y = 20;
		}
	}
	
	static private function closeHandler(event:Event):void 
	{
		contentTxt.parent.removeChild(contentTxt);
		contentTxt = null;
		alert.removeEventListener(Event.CLOSE, closeHandler);
		alert.parent.removeChild(alert);
		alert = null;
	}
	
}
}