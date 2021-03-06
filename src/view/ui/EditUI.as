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
import com.bit101.components.VUISlider;
import com.senocular.display.TransformTool;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
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
	public var highestDepthBtn:PushButton;
	public var lowestDepthBtn:PushButton;
	public var nextDepthBtn:PushButton;
	public var prevDepthBtn:PushButton;
	public var clearBtn:PushButton;
	public var exportBtn:PushButton;
	public var resetBtn:PushButton;
	public var stageBtn:PushButton;
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
	public var flipHBtn:PushButton;
	public var flipVBtn:PushButton;
	private var aniPanelWidth:int;
	private var aniPanelHeight:int;
	private var ctrlBox:VBox;
	private var ctrlBox1:HBox;
	private var ctrlBox2:HBox;
	
	//private var outputLabel:Label;
	private var outputLabel:TextField;
	//中心点位置
	private var _centerPos:Point;
	private var listWidth:Number;
	//舞台位置
	public var stageXTxt:InputText;
	public var stageYTxt:InputText;
	public var vSlider:VUISlider;
	public var resetStagePosBtn:PushButton;
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
		this.openBtn.width = 90;
		
		this.openBtn.setSize(this.openBtn.width, this.openBtn.height + 8);
		this.saveBtn.setSize(this.openBtn.width, this.openBtn.height);
		this.exportBtn.setSize(this.openBtn.width, this.openBtn.height);
		this.importDataBtn.setSize(this.openBtn.width, this.openBtn.height);
		this.importBtn.setSize(this.openBtn.width, this.openBtn.height);
		this.refreshBtn.setSize(this.openBtn.width, this.openBtn.height);
		
		this.highestDepthBtn = new PushButton(topGroup, 0, 0, "深度最高");
		this.lowestDepthBtn = new PushButton(topGroup, 0, 0, "深度最低");
		this.highestDepthBtn.setSize(this.openBtn.width, this.openBtn.height);
		this.lowestDepthBtn.setSize(this.openBtn.width, this.openBtn.height);

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
		
		var stagePosPanel:Panel = new Panel(Layer.EDIT);
		stagePosPanel.width = 105;
		stagePosPanel.height = 50;
		stagePosPanel.x = this.aniPanelWidth - stagePosPanel.width - 2;
		stagePosPanel.y = 37;
		
		var stagePosLabel:Label = new Label(stagePosPanel, 0, 0, "舞台位置");
		stagePosLabel.x = 2;
		
		this.stageXTxt = new InputText(stagePosPanel, 0, 25, "0");
		this.stageXTxt.width = 50;
		this.stageXTxt.height = 20;
		this.stageXTxt.restrict = "0-9\\-";
		
		this.stageYTxt = new InputText(stagePosPanel, 55, 25, "0");
		this.stageYTxt.width = 50;
		this.stageYTxt.height = 20;
		this.stageYTxt.restrict = "0-9\\-";
		
		this.resetStagePosBtn = new PushButton(stagePosPanel, 55, 0, "复位");
		this.resetStagePosBtn.width = 50;
		this.resetStagePosBtn.height = 20;

		this.vSlider = new VUISlider(Layer.EDIT, 0, 0, "舞台缩放比");
		this.vSlider.x = this.aniPanelWidth - 70;
		this.vSlider.y = stagePosPanel.y + stagePosPanel.height;
		this.vSlider.minimum = 0;
		this.vSlider.maximum = 100;
		this.vSlider.value = 100;
		
		this.clearBtn = new PushButton(topGroup, 0, 0, "清理");
		this.clearBtn.setSize(this.openBtn.width, this.openBtn.height);
		
		this.stageBtn = new PushButton(topGroup, 0, 0, "舞台大小");
		this.stageBtn.setSize(this.openBtn.width, this.openBtn.height);
		
		this.ctrlBox = new VBox(ctrlPanel);
		this.ctrlBox1 = new HBox(ctrlBox);
		this.ctrlBox2 = new HBox(ctrlBox);
		
		this.ctrlBox1.alignment = HBox.MIDDLE;
		this.ctrlBox2.alignment = HBox.MIDDLE;
		
		var scaleXLabel:Label = new Label(this.ctrlBox1, 0, 0, "scaleX");
		this.scaleXTxt = new InputText(this.ctrlBox1, 0, 0, "100");
		var scaleYLabel:Label = new Label(this.ctrlBox1, 0, 0, "scaleY");
		this.scaleYTxt = new InputText(this.ctrlBox1, 0, 0, "100");
		this.scaleXTxt.width = 50;
		this.scaleYTxt.width = this.scaleXTxt.width;
		this.scaleXTxt.height = 20;
		this.scaleYTxt.height = this.scaleXTxt.height;
		this.scaleXTxt.restrict = "0-9\\-";
		this.scaleYTxt.restrict = "0-9\\-";
		this.scaleXTxt.maxChars = 5;
		this.scaleYTxt.maxChars = 5;
		
		var rotationLabel:Label = new Label(this.ctrlBox1, 0, 0, "rotation");
		this.rotationTxt = new InputText(this.ctrlBox1, 0, 0, "0");
		this.rotationTxt.width = this.scaleYTxt.width;
		this.rotationTxt.height = this.scaleXTxt.height;
		
		var posXLabel:Label = new Label(this.ctrlBox1, 0, 0, "x");
		this.posXTxt = new InputText(this.ctrlBox1, 0, 0, "0");
		this.posXTxt.restrict = "0-9\\-";
		this.posXTxt.width = this.scaleXTxt.width;
		this.posXTxt.height = 20;
		
		var posYLabel:Label = new Label(this.ctrlBox1, 0, 0, "y");
		this.posYTxt = new InputText(this.ctrlBox1, 0, 0, "0");
		this.posYTxt.restrict = "0-9\\-";
		this.posYTxt.width = this.scaleXTxt.width;
		this.posYTxt.height = 20;
		
		this.flipHBtn = new PushButton(this.ctrlBox2, 0, 0, "水平翻转");
		this.flipHBtn.setSize(this.openBtn.width, this.openBtn.height);

		this.flipVBtn = new PushButton(this.ctrlBox2, 0, 0, "垂直翻转");
		this.flipVBtn.setSize(this.openBtn.width, this.openBtn.height);
		
		this.resetBtn = new PushButton(this.ctrlBox2, 0, 0, "重置");
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
		
		this.aniComboBox = new ComboBox(ctrlBox1, 0, 0);
		this.aniComboBox.openPosition = ComboBox.TOP;
		this.aniComboBox.width = 100;
		
		this.aniCheckBox = new CheckBox(ctrlBox1, 0, 0, "是否循环");
		this.aniCheckBox.selected = true;
		
		this._centerPos = new Point(rootGroup.x + this.aniPanel.width / 2, 
									rootGroup.y + topPanel.height + rootGroup.spacing + this.aniPanel.height / 2);
							
		var mask:Sprite = this.createMask(centerGroup.x, 
										  centerGroup.y, 
										  this.aniPanelWidth, 
										  this.aniPanelHeight);
		Layer.ROOT.addChild(mask);
		Layer.CANVAS.mask = mask;
		
		mask = this.createMask(centerGroup.x, 
							  centerGroup.y, 
							  this.aniPanelWidth, 
							  this.aniPanelHeight);
		Layer.ROOT.addChild(mask);
		Layer.ANI_STAGE.mask = mask;
	}
	
	/**
	 * 创建遮罩							
	 */
	private function createMask(x:Number, y:Number, width:Number, height:Number):Sprite
	{
		var maskSpt:Sprite = new Sprite();
		maskSpt.graphics.beginFill(0xFFFFFF);
		maskSpt.graphics.drawRect(x, y, width, height);
		maskSpt.graphics.endFill();
		return maskSpt;
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
			if (this.aniComboBox.selectedIndex != SpineAni(spt).animationIndex)
				this.aniComboBox.selectedIndex = SpineAni(spt).animationIndex;
			this.aniComboBox.defaultLabel = SpineAni(spt).animationName;
		}
	}
	
	public function get centerPos():Point {return _centerPos; }

	/**
	 * 更新舞台位置
	 * @param	x	x坐标
	 * @param	y	y坐标
	 */
	public function updateStagePos(x:Number, y:Number):void
	{
		this.stageXTxt.text = x.toString();
		this.stageYTxt.text = y.toString();
	}
	
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