package view.ui
{
import com.bit101.components.CheckBox;
import com.bit101.components.ComboBox;
import com.bit101.components.HBox;
import com.bit101.components.InputText;
import com.bit101.components.Label;
import com.bit101.components.List;
import com.bit101.components.Panel;
import com.bit101.components.PushButton;
import com.bit101.components.Style;
import com.bit101.components.VBox;
import com.senocular.display.TransformTool;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;
import view.ani.SpineAni;
/**
 * ...编辑器UI
 * @author Kanon
 */
public class EditUI extends Sprite
{
	public var list:List;
	public var openBtn:PushButton;
	public var importBtn:PushButton;
	public var importDataBtn:PushButton;
	public var saveBtn:PushButton;
	public var refreshBtn:PushButton;
	public var depthBtn:PushButton;
	public var nextDepthBtn:PushButton;
	public var prevDepthBtn:PushButton;
	public var clearBtn:PushButton;
	public var exportBtn:PushButton;
	public var resetBtn:PushButton;
	public var transfromCb:CheckBox;
	public var transformTool:TransformTool;
	public var scaleXTxt:InputText;
	public var scaleYTxt:InputText;
	public var rotationTxt:InputText;
	public var posXTxt:InputText;
	public var posYTxt:InputText;
	public var aniPanel:Panel;
	public var aniComboBox:ComboBox;
	public var aniCheckBox:CheckBox;
	
	private var aniPanelWidth:int;
	private var aniPanelHeight:int;
	private var ctrlBox:HBox;
	//private var outputLabel:Label;
	private var outputLabel:TextField;
	//中心点位置
	private var _centerPos:Point;
	private var listWidth:Number;
	public function EditUI()
	{
		this.addEventListener(Event.ADDED_TO_STAGE, addToStage);
	}
	
	private function addToStage(event:Event):void
	{
		removeEventListener(Event.ADDED_TO_STAGE, addToStage);
		this.initData();
		this.initSytle();
		this.initUI();
	}
	
	private function initData():void 
	{
		this.listWidth = 220;
		this.aniPanelWidth = this.stage.stageWidth - this.listWidth;
		this.aniPanelHeight = this.stage.stageHeight - 120;
	}
	
	private function initSytle():void
	{
		Style.embedFonts = false;
		Style.fontName = "微软雅黑";
		Style.fontSize = 12;
		Style.setStyle(Style.DARK);
	}

	private function initUI():void
	{
		var rootGroup:VBox = new VBox(this);
		var topGroup:HBox = new HBox(this);
		topGroup.alignment = HBox.MIDDLE;
		var topPanel:Panel = new Panel(rootGroup);
		topPanel.width = this.stage.stageWidth;
		topPanel.height = 30;

		var centerGroup:HBox = new HBox(rootGroup);
		this.aniPanel = new Panel(centerGroup);
		this.aniPanel.width = this.aniPanelWidth;
		this.aniPanel.height = this.aniPanelHeight;

		var ctrlPanel:Panel = new Panel(rootGroup);
		ctrlPanel.width = this.stage.stageWidth;
		ctrlPanel.height = 80;
		
		this.openBtn = new PushButton(topGroup, 0, 0, "资源目录");
		this.refreshBtn = new PushButton(topGroup, 0, 0, "刷新目录");
		this.saveBtn = new PushButton(topGroup, 0, 0, "保存文件");
		this.importDataBtn = new PushButton(topGroup, 0, 0, "打开文件");
		this.exportBtn = new PushButton(topGroup, 0, 0, "导出数据");
		this.importBtn = new PushButton(topGroup, 0, 0, "导入图片");

		this.openBtn.setSize(this.openBtn.width, this.openBtn.height + 8);
		this.saveBtn.setSize(this.openBtn.width, this.openBtn.height);
		this.exportBtn.setSize(this.openBtn.width, this.openBtn.height);
		this.importDataBtn.setSize(this.openBtn.width, this.openBtn.height);
		this.importBtn.setSize(this.openBtn.width, this.openBtn.height);
		this.refreshBtn.setSize(this.openBtn.width, this.openBtn.height);
		
		this.depthBtn = new PushButton(topGroup, 0, 0, "深度最高");
		this.depthBtn.setSize(this.openBtn.width, this.openBtn.height);

		this.nextDepthBtn = new PushButton(topGroup, 0, 0, "下一层");
		this.nextDepthBtn.setSize(this.openBtn.width, this.openBtn.height);
		
		this.prevDepthBtn = new PushButton(topGroup, 0, 0, "上一层");
		this.prevDepthBtn.setSize(this.openBtn.width, this.openBtn.height);
		
		this.list = new List(centerGroup);
		this.list.setSize(this.listWidth, this.aniPanelHeight);
		
		this.transfromCb = new CheckBox(topGroup, 0, 0, "变形工具");
		
		this.transformTool = new TransformTool();
		this.transformTool.registrationEnabled = false;
		this.transformTool.skewEnabled = false;
		this.transformTool.moveEnabled = false;
		this.transformTool.raiseNewTargets = false;
		Layer.EDIT.addChild(this.transformTool);
		
		this.clearBtn = new PushButton(topGroup, 0, 0, "清理");
		this.clearBtn.setSize(this.openBtn.width, this.openBtn.height);
		
		this.ctrlBox = new HBox(ctrlPanel);
		this.ctrlBox.alignment = HBox.MIDDLE;
		var scaleXLabel:Label = new Label(this.ctrlBox, 0, 0, "scaleX");
		this.scaleXTxt = new InputText(this.ctrlBox, 0, 0, "100");
		var scaleYLabel:Label = new Label(this.ctrlBox, 0, 0, "scaleY");
		this.scaleYTxt = new InputText(this.ctrlBox, 0, 0, "100");
		this.scaleXTxt.width = 50;
		this.scaleYTxt.width = this.scaleXTxt.width;
		this.scaleXTxt.height = 20;
		this.scaleYTxt.height = this.scaleXTxt.height;
		this.scaleXTxt.restrict = "0-9";
		this.scaleYTxt.restrict = "0-9";
		this.scaleXTxt.maxChars = 3;
		this.scaleYTxt.maxChars = 3;
		
		var rotationLabel:Label = new Label(this.ctrlBox, 0, 0, "rotation");
		this.rotationTxt = new InputText(this.ctrlBox, 0, 0, "0");
		this.rotationTxt.width = this.scaleYTxt.width;
		this.rotationTxt.height = this.scaleXTxt.height;
		
		var posXLabel:Label = new Label(this.ctrlBox, 0, 0, "x");
		this.posXTxt = new InputText(this.ctrlBox, 0, 0, "0");
		this.posXTxt.width = this.scaleXTxt.width;
		this.posXTxt.height = 20;
		
		var posYLabel:Label = new Label(this.ctrlBox, 0, 0, "y");
		this.posYTxt = new InputText(this.ctrlBox, 0, 0, "0");
		this.posYTxt.width = this.scaleXTxt.width;
		this.posYTxt.height = 20;

		this.resetBtn = new PushButton(this.ctrlBox, 0, 0, "重置");
		this.resetBtn.setSize(this.openBtn.width, this.openBtn.height);
		
		var outPutPanel:Panel = new Panel(ctrlPanel);
		outPutPanel.width = 500;
		outPutPanel.height = ctrlPanel.height;
		outPutPanel.x = ctrlPanel.x + ctrlPanel.width - outPutPanel.width;
		
		this.outputLabel = new TextField();
		this.outputLabel.defaultTextFormat = new TextFormat(Style.fontName, Style.fontSize, Style.LABEL_TEXT);
		this.outputLabel.width = outPutPanel.width;
		this.outputLabel.height = outPutPanel.height;
		this.outputLabel.embedFonts = Style.embedFonts;
		this.outputLabel.multiline = true;
		this.outputLabel.wordWrap = true;

		outPutPanel.addChild(this.outputLabel);
		
		this.aniComboBox = new ComboBox(ctrlBox, 0, 0);
		this.aniComboBox.openPosition = ComboBox.TOP;
		this.aniComboBox.width = 100;
		
		this.aniCheckBox = new CheckBox(ctrlBox, 0, 0, "是否循环");
		this.aniCheckBox.selected = true;
		
		Layer.CANVAS.graphics.lineStyle(1, 0x000000, 1);
		Layer.CANVAS.graphics.moveTo(rootGroup.x, rootGroup.y + topPanel.height + rootGroup.spacing + this.aniPanel.height / 2);
		Layer.CANVAS.graphics.lineTo(rootGroup.x + this.aniPanel.width, rootGroup.y + topPanel.height + rootGroup.spacing + this.aniPanel.height / 2);
		
		Layer.CANVAS.graphics.lineStyle(1, 0x000000, 1);
		Layer.CANVAS.graphics.moveTo(rootGroup.x + this.aniPanel.width / 2, rootGroup.y + topPanel.height + rootGroup.spacing);
		Layer.CANVAS.graphics.lineTo(rootGroup.x + this.aniPanel.width / 2, rootGroup.y + topPanel.height + rootGroup.spacing + this.aniPanel.height);
		
		this._centerPos = new Point(rootGroup.x + this.aniPanel.width / 2, 
									rootGroup.y + topPanel.height + rootGroup.spacing + this.aniPanel.height / 2);
	}
	
	/**
	 * 判断坐标是否在舞台外
	 * @param	x	坐标x
	 * @param	y	坐标y
	 * @return
	 */
	public function isOutSide(x:Number, y:Number):Boolean
	{
		if (!this.aniPanel) return false;
		return this.aniPanel.hitTestPoint(x, y, true);
	}
	
	/**
	 * 是否显示控制面板
	 * @param	flag	是否显示
	 */
	public function showCtrlPanel(flag:Boolean):void
	{
		this.ctrlBox.visible = flag;
	}
	
	/**
	 * 设置控制面板的属性
	 * @param	spt		显示对象
	 */
	public function setCtrlProp(spt:Sprite):void
	{
		if (!spt) return;
		this.scaleXTxt.text = (spt.scaleX * 100).toString();
		this.scaleYTxt.text = (spt.scaleY * 100).toString();
		this.rotationTxt.text = spt.rotation.toString();
		this.posXTxt.text = spt.x.toString();
		this.posYTxt.text = spt.y.toString();
		
		this.aniComboBox.visible = Boolean(spt is SpineAni);
		this.aniCheckBox.visible = this.aniComboBox.visible;
		
		if (spt is SpineAni)
		{
			this.setAniList(SpineAni(spt).getAnimations());
			this.aniCheckBox.selected = SpineAni(spt).isLoop;
			this.aniComboBox.defaultLabel = SpineAni(spt).animationName;
			this.aniComboBox.selectedIndex = SpineAni(spt).animationIndex;
		}
	}
	
	public function get centerPos():Point {return _centerPos; }

	/**
	 * 显示输出
	 * @param	content	内容
	 */
	public function showOutput(content:String):void
	{
		if (this.outputLabel)
		{
			this.outputLabel.appendText(content);
			trace(this.outputLabel.numLines);
			this.outputLabel.scrollV = this.outputLabel.numLines;
		}
	}
	
	/**
	 * 设置动画列表
	 * @param	ary		列表数据
	 */
	public function setAniList(ary:Array):void
	{
		if (!ary) return;
		this.aniComboBox.removeAll();
		var length:int = ary.length;
		for (var i:int = 0; i < length; i++) 
		{
			this.aniComboBox.addItem({"label":ary[i]});
		}
	}
}
}