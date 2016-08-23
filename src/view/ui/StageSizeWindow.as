package view.ui 
{
import com.bit101.components.HBox;
import com.bit101.components.InputText;
import com.bit101.components.Label;
import com.bit101.components.PushButton;
import com.bit101.components.Window;
import flash.display.Sprite;
import flash.events.Event;

/**
 * ...舞台大小窗口
 * @author Kanon
 */
public class StageSizeWindow extends Sprite 
{
	private var alert:Window;
	private var widthLabel:Label;
	private var heightLabel:Label;
	public var widthTxt:InputText;
	public var heightTxt:InputText;
	public var confirmBtn:PushButton;
	public var resetBtn:PushButton;

	public function StageSizeWindow() 
	{
		this.alert = new Window(this, 0, 0, "舞台大小");
		this.alert.width = 230;
		this.alert.height = 120;
		this.alert.hasCloseButton = true;
		this.alert.addEventListener(Event.CLOSE, closeHandler);
		
		var hBox:HBox = new HBox(this.alert, 0, 10);
		this.widthLabel = new Label(hBox, 0, 0, "宽:");
		this.widthTxt = new InputText(hBox, 0, 0, "0");
		this.heightLabel = new Label(hBox, 0, 0, "高:");
		this.heightTxt = new InputText(hBox, 0, 0, "0");
		this.widthTxt.width = 70;
		this.widthTxt.height = 20;
		this.heightTxt.width = this.widthTxt.width;
		this.heightTxt.height = this.widthTxt.height;
		this.widthTxt.restrict = "0-9";
		this.heightTxt.restrict = "0-9";
		this.widthTxt.maxChars = 4;
		this.heightTxt.maxChars = 4;
		hBox.x = 10;
		
		hBox = new HBox(this.alert, 0, 70);
		this.resetBtn = new PushButton(hBox, 0 , 0, "重置");
		this.confirmBtn = new PushButton(hBox, 0 , 0, "确定");
		
		hBox.x = this.alert.width / 2 - hBox.width / 2;
	}
	
	/**
	 * 更新高宽
	 * @param	w	宽
	 * @param	h	高
	 */
	public function updateStageSize(w:Number, h:Number):void
	{
		this.widthTxt.text = w.toString();
		this.heightTxt.text = h.toString();
	}
	
	private function closeHandler(event:Event):void 
	{
		this.close();
	}
	
	/**
	 * 关闭
	 */
	public function close():void
	{
		this.dispatchEvent(new Event(Event.CLOSE));
		if (this.widthLabel.parent)
			this.widthLabel.parent.removeChild(this.widthLabel);
		this.widthLabel = null;
		if (this.heightLabel.parent)
			this.heightLabel.parent.removeChild(this.heightLabel);
		this.heightLabel = null;
		this.confirmBtn.parent.removeChild(this.confirmBtn);
		this.alert.removeEventListener(Event.CLOSE, closeHandler);
		if (this.alert.parent)
			this.alert.parent.removeChild(this.alert);
		this.alert = null;
		this.parent.removeChild(this);
	}
	
}
}