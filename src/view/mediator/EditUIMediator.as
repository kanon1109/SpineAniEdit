package view.mediator
{
	import com.bit101.components.List;
	import com.bit101.components.ListItem;
	import com.senocular.display.TransformTool;
	import componets.Alert;
	import componets.Image;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	import message.Message;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import utils.AdvanceColorUtil;
	import utils.Cookie;
	import view.ani.SpineAni;
	import view.ui.EditUI;
	import view.ui.StageSizeWindow;
	
	/**
	 * ...TODO
	 * [十字位置对准]
	 * [scale rotation 编辑输入]
	 * [遍历动画找到合适的一针]
	 * [复制粘贴]
	 * [异常处理]
	 * [导入图片]
	 * @author Kanon
	 */
	public class EditUIMediator extends Mediator
	{
		public static const NAME:String = "EditUIMediator";
		private var resFile:File;
		private var imageFile:File;
		private var saveFile:File;
		private var importFile:File;
		private var dataFile:File;
		private var resPath:String = "res"
		private var editUI:EditUI;
		private var stageSizeWin:StageSizeWindow;
		private var pathList:Array;
		private var curSpt:Sprite;
		private var dataLoader:URLLoader;
		private var imageFilter:FileFilter;
		private var dataFilter:FileFilter;
		private var saveDataStr:String;
		private var stageWidth:Number = 550;
		private var stageHeight:Number = 600;
		private var isOnSpaceKey:Boolean;
		public function EditUIMediator()
		{
			super(NAME);
		}
		
		override public function listNotificationInterests():Array
		{
			return [Message.START, Message.SELECT, Message.DELETE, Message.LOAD_MSG];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
			case Message.START: 
				this.initEvent();
				this.initRes();
				this.updateStage();
				Layer.ANI_STAGE.x = this.editUI.centerPos.x;
				Layer.ANI_STAGE.y = this.editUI.centerPos.y;
				break;
			case Message.SELECT: 
				this.editUI.showCtrlPanel(true);
				this.editUI.setCtrlProp(this.curSpt);
				break;
			case Message.DELETE: 
				this.editUI.showCtrlPanel(false);
				break;
			case Message.LOAD_MSG: 
				this.editUI.showOutput(String(notification.getBody()));
				break;
			}
		}
		
		private function aniStageMouseUp(event:MouseEvent):void 
		{
			Layer.ANI_STAGE.stopDrag();
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		private function aniStageMouseDown(event:MouseEvent):void 
		{
			if (this.isOnSpaceKey) 
			{
				Mouse.cursor = MouseCursor.HAND;
				Layer.ANI_STAGE.startDrag();
			}
		}
		
		private function aniStageMiddleDown(event:MouseEvent):void 
		{
			Layer.ANI_STAGE.startDrag();
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function updateStage():void 
		{
			Layer.CANVAS_STAGE.graphics.clear();
			Layer.CANVAS_STAGE.graphics.lineStyle(1, 0xFFFFFF, 1);
			Layer.CANVAS_STAGE.graphics.beginFill(0xFFFFFF, .3);
			Layer.CANVAS_STAGE.graphics.moveTo(this.editUI.centerPos.x - this.stageWidth / 2, this.editUI.centerPos.y - this.stageHeight / 2);
			Layer.CANVAS_STAGE.graphics.lineTo(this.editUI.centerPos.x + this.stageWidth / 2, this.editUI.centerPos.y - this.stageHeight / 2);
			Layer.CANVAS_STAGE.graphics.lineTo(this.editUI.centerPos.x + this.stageWidth / 2, this.editUI.centerPos.y + this.stageHeight / 2);
			Layer.CANVAS_STAGE.graphics.lineTo(this.editUI.centerPos.x - this.stageWidth / 2, this.editUI.centerPos.y + this.stageHeight / 2);
			Layer.CANVAS_STAGE.graphics.endFill();
		}
		
		/**
		 * 初始化UI
		 */
		private function initEvent():void
		{
			this.editUI = new EditUI();
			Layer.UI.addChild(this.editUI);
			this.editUI.openBtn.addEventListener(MouseEvent.CLICK, openBtnHandler);
			this.editUI.importBtn.addEventListener(MouseEvent.CLICK, importBtnHandler);
			this.editUI.importDataBtn.addEventListener(MouseEvent.CLICK, importDataBtnHandler);
			this.editUI.refreshBtn.addEventListener(MouseEvent.CLICK, refreshBtnHandler);
			this.editUI.saveBtn.addEventListener(MouseEvent.CLICK, saveBtnHandler);
			this.editUI.exportBtn.addEventListener(MouseEvent.CLICK, exportBtnHandler);
			this.editUI.depthBtn.addEventListener(MouseEvent.CLICK, depthBtnHandler);
			this.editUI.nextDepthBtn.addEventListener(MouseEvent.CLICK, nextDepthBtnHandler);
			this.editUI.prevDepthBtn.addEventListener(MouseEvent.CLICK, prevDepthBtnHandler);
			this.editUI.list.addEventListener(Event.SELECT, selectListItemHandler);
			this.editUI.transfromCb.addEventListener(MouseEvent.CLICK, transfromCbClickHandler);
			this.editUI.clearBtn.addEventListener(MouseEvent.CLICK, clearBtnHandler);
			this.editUI.resetBtn.addEventListener(MouseEvent.CLICK, resetBtnHandler);
			this.editUI.stageBtn.addEventListener(MouseEvent.CLICK, stageBtnHandler);
			
			this.editUI.scaleXTxt.addEventListener(FocusEvent.FOCUS_OUT, scaleXTxtfocusOutHandler);
			this.editUI.posXTxt.addEventListener(FocusEvent.FOCUS_OUT, posXTxtfocusOutHandler);
			this.editUI.posYTxt.addEventListener(FocusEvent.FOCUS_OUT, posYTxtfocusOutHandler);
			this.editUI.scaleYTxt.addEventListener(FocusEvent.FOCUS_OUT, scaleYTxtfocusOutHandler);
			this.editUI.rotationTxt.addEventListener(FocusEvent.FOCUS_OUT, rotationTxtfocusOutHandler);
			this.editUI.transformTool.addEventListener(TransformTool.CONTROL_TRANSFORM_TOOL, transformToolMoveHandler);
			this.editUI.aniComboBox.addEventListener(Event.SELECT, aniComboBoxSelectHandler);
			this.editUI.aniCheckBox.addEventListener(MouseEvent.CLICK, aniCheckBoxClickHandler);
			this.editUI.aniPanel.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
			
			this.editUI.showCtrlPanel(false);
			
			Layer.STAGE.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
			Layer.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			
			Layer.ANI_STAGE.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, aniStageMiddleDown);
			Layer.ANI_STAGE.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, aniStageMouseUp);
			Layer.ANI_STAGE.addEventListener(MouseEvent.MOUSE_DOWN, aniStageMouseDown);
			Layer.ANI_STAGE.addEventListener(MouseEvent.MOUSE_UP, aniStageMouseUp);
		}
		
		private function stageBtnHandler(event:MouseEvent):void 
		{
			if (!this.stageSizeWin)
			{
				this.stageSizeWin = new StageSizeWindow();
				this.stageSizeWin.updateStageSize(this.stageWidth, this.stageHeight);
				this.stageSizeWin.x = this.editUI.centerPos.x;
				this.stageSizeWin.y = this.editUI.centerPos.y;
				this.stageSizeWin.addEventListener(Event.CLOSE, stageSizeWinCloseHandler);
				this.stageSizeWin.confirmBtn.addEventListener(MouseEvent.CLICK, stageSizeWinConfirmBtnClickHandler);
				this.stageSizeWin.resetBtn.addEventListener(MouseEvent.CLICK, stageSizeWinResetBtnClickHandler);
				Layer.WINDOWS.addChild(this.stageSizeWin);
			}
		}
		
		private function stageSizeWinResetBtnClickHandler(event:MouseEvent):void 
		{
			this.stageWidth = 550;
			this.stageHeight = 600;
			this.stageSizeWin.updateStageSize(this.stageWidth, this.stageHeight);
			this.updateStage();
		}
		
		private function stageSizeWinConfirmBtnClickHandler(event:Event):void 
		{
			this.stageWidth = Number(this.stageSizeWin.widthTxt.text);
			this.stageHeight = Number(this.stageSizeWin.heightTxt.text);
			this.stageSizeWin.close();
			this.updateStage();
		}
		
		private function stageSizeWinCloseHandler(event:Event):void 
		{
			if (this.stageSizeWin && 
				this.stageSizeWin.parent)
			{
				this.stageSizeWin.confirmBtn.removeEventListener(MouseEvent.CLICK, stageSizeWinConfirmBtnClickHandler);
				this.stageSizeWin.removeEventListener(Event.CLOSE, stageSizeWinCloseHandler);
				this.stageSizeWin = null;
			}
		}
		
		private function stageMouseDownHandler(event:MouseEvent):void
		{
			this.selectSpAni(null);
		}
		
		private function aniCheckBoxClickHandler(event:Event):void
		{
			if (this.curSpt && this.curSpt is SpineAni)
				SpineAni(this.curSpt).isLoop = this.editUI.aniCheckBox.selected;
		}
		
		private function aniComboBoxSelectHandler(event:Event):void
		{
			trace("aniComboBoxSelectHandler");
			if (this.curSpt && this.curSpt is SpineAni)
			{
				SpineAni(this.curSpt).playAni(this.editUI.aniComboBox.selectedIndex, SpineAni(this.curSpt).isLoop);
			}
		}
		
		private function resetBtnHandler(event:MouseEvent):void
		{
			if (this.curSpt)
			{
				this.curSpt.scaleX = 1;
				this.curSpt.scaleY = 1;
				this.curSpt.rotation = 0;
				this.editUI.setCtrlProp(this.curSpt);
				this.checkTransformTool();
			}
		}
		
		private function exportBtnHandler(event:MouseEvent):void
		{
			this.save(true);
		}
		
		private function clearBtnHandler(event:MouseEvent):void
		{
			this.clearAll();
			this.editUI.showCtrlPanel(false);
		}
		
		private function transformToolMoveHandler(event:Event):void
		{
			this.editUI.setCtrlProp(this.curSpt);
		}
		
		private function rotationTxtfocusOutHandler(event:FocusEvent):void
		{
			this.updateSptProp();
		}
		
		private function scaleXTxtfocusOutHandler(event:FocusEvent):void
		{
			this.updateSptProp();
		}
		
		private function scaleYTxtfocusOutHandler(event:FocusEvent):void
		{
			this.updateSptProp();
		}
		
		private function posYTxtfocusOutHandler(event:FocusEvent):void
		{
			this.updateSptProp();
		}
		
		private function posXTxtfocusOutHandler(event:FocusEvent):void
		{
			this.updateSptProp();
		
		}
		
		/**
		 * 初始化资源
		 */
		private function initRes():void
		{
			if (Cookie.read("path") != null)
			{
				var path:String = Cookie.read("path");
				this.resFile = new File(path);
				this.updateResDirList();
			}
		}
		
		/**
		 * 选择目录
		 */
		private function selectResDir():void
		{
			if (!this.resFile) this.resFile = File.desktopDirectory;
			this.resFile.browseForDirectory("选择spine目录");
			this.resFile.addEventListener(Event.SELECT, selectHandler);
		}
		
		private function selectHandler(event:Event):void
		{
			this.resFile = event.target as File;
			Cookie.save("path", this.resFile.nativePath);
			this.updateResDirList();
		}
		
		/**
		 * 选择图片
		 */
		private function selectImage():void
		{
			if (!this.imageFile)
			{
				this.imageFilter = new FileFilter("Image", "*.jpg;*.png");
				this.imageFile = new File();
				this.imageFile.addEventListener(Event.SELECT, selectImageFileHandler);
			}
			this.imageFile.browse([this.imageFilter]);
		}
		
		private function selectImageFileHandler(event:Event):void
		{
			this.imageFile.addEventListener(Event.COMPLETE, imageFileLoadComplete);
			this.imageFile.load();
		}
		
		private function imageFileLoadComplete(event:Event):void
		{
			this.imageFile.removeEventListener(Event.COMPLETE, imageFileLoadComplete);
			var image:Image = new Image();
			image.addEventListener(ErrorEvent.ERROR, loadImageErrorHandler);
			image.loadBytes(this.imageFile.data);
			trace("this.imageFile.name", this.imageFile.name);
			image.resName = this.imageFile.name;
			image.pathName = this.imageFile.nativePath;
			Layer.ANI_STAGE.addChild(image);
			image.addEventListener(MouseEvent.MOUSE_DOWN, sptOnMouseDownHandler);
		}
		
		private function loadImageErrorHandler(event:ErrorEvent):void
		{
			Alert.show("错误", "图片不存在");
		}
		
		private function selectData():void
		{
			if (!this.dataFile)
			{
				this.dataFilter = new FileFilter("data", "*.json");
				this.dataFile = new File();
				this.dataFile.addEventListener(Event.SELECT, selectDataFileHandler);
			}
			this.dataFile.browse([this.dataFilter]);
		}
		
		private function selectDataFileHandler(event:Event):void
		{
			this.dataFile.addEventListener(Event.COMPLETE, dataFileLoadComplete);
			this.dataFile.load();
		}
		
		private function dataFileLoadComplete(event:Event):void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(this.dataFile, FileMode.READ);
			var dataStr:String = fileStream.readMultiByte(fileStream.bytesAvailable, File.systemCharset);
			this.parsing(dataStr);
		}
		
		/**
		 * 更新目录列表
		 */
		private function updateResDirList():void
		{
			if (!this.resFile) return;
			this.editUI.list.removeAll();
			trace(this.resFile.name, this.resFile.nativePath);
			if(!this.resFile.isDirectory) return;
			this.pathList = this.resFile.getDirectoryListing();
			var length:int = this.pathList.length;
			for (var i:int = 0; i < length; i++)
			{
				this.editUI.list.addItem(this.pathList[i].name);
			}
		}
		
		private function drawBound(spt:Sprite):void
		{
			if (this.curSpt) this.curSpt.transform.colorTransform = AdvanceColorUtil.setColorInitialize();
			if (spt) spt.transform.colorTransform = AdvanceColorUtil.setRGBMixTransform(0x00, 0xCC, 0xFF, 40);
		}
		
		private function selectListItemHandler(event:Event):void
		{
			var list:List = event.currentTarget as List;
			var listItem:ListItem = list.selectedItem as ListItem;
			var path:String = this.pathList[list.selectedIndex].nativePath;
			
			var spAni:SpineAni = new SpineAni();
			spAni.addEventListener(Event.COMPLETE, spAniLoadCompleteHandler);
			spAni.addEventListener(ErrorEvent.ERROR, spAniLoadErrorCompleteHandler);
			spAni.addEventListener(MouseEvent.MOUSE_DOWN, sptOnMouseDownHandler);
			spAni.load(path);
			Layer.ANI_STAGE.addChild(spAni);
		}
		
		private function spAniLoadErrorCompleteHandler(event:ErrorEvent):void
		{
			var spAni:SpineAni = event.currentTarget as SpineAni;
			spAni.removeEventListener(Event.COMPLETE, spAniLoadCompleteHandler);
			spAni.removeEventListener(ErrorEvent.ERROR, spAniLoadErrorCompleteHandler);
			spAni.removeEventListener(MouseEvent.MOUSE_DOWN, sptOnMouseDownHandler);
			Alert.show("错误", "spine的数据文件目录不存在");
		}
		
		private function stageOnMouseUpHandler(event:MouseEvent):void
		{
			Layer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, stageOnMouseUpHandler);
			Layer.STAGE.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			if (this.curSpt)
			{
				this.curSpt.stopDrag();
				this.checkTransformTool();
				this.editUI.setCtrlProp(this.curSpt);
				/*if (!this.editUI.isOutSide(Layer.ANI_STAGE.mouseX, Layer.ANI_STAGE.mouseY))
				   this.removeCurSpt();*/
			}
		}
		
		private function sptOnMouseDownHandler(event:MouseEvent):void
		{
			Layer.STAGE.addEventListener(MouseEvent.MOUSE_UP, stageOnMouseUpHandler);
			Layer.STAGE.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			var spAni:Sprite = event.currentTarget as Sprite;
			spAni.startDrag();
			this.selectSpAni(spAni);
			this.sendNotification(Message.SELECT);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			if (this.editUI)
				this.editUI.setCtrlProp(this.curSpt);
		}
		
		private function spAniLoadCompleteHandler(event:Event):void
		{
			var spAni:SpineAni = event.currentTarget as SpineAni;
			spAni.removeEventListener(Event.COMPLETE, spAniLoadCompleteHandler);
			//第一次加载 使用默认第一帧动画
			if (!spAni.animationName) spAni.animationName = spAni.getAnimationNameByIndex(spAni.animationIndex);
			spAni.play(spAni.animationName);
		}
		
		private function importBtnHandler(event:MouseEvent):void
		{
			this.selectImage();
		}
		
		private function importDataBtnHandler(event:MouseEvent):void
		{
			this.selectData();
		}
		
		private function transfromCbClickHandler(event:MouseEvent):void
		{
			this.checkTransformTool();
		}
		
		private function prevDepthBtnHandler(event:MouseEvent):void
		{
			this.swapDepth(false);
		}
		
		private function nextDepthBtnHandler(event:MouseEvent):void
		{
			this.swapDepth(true);
		}
		
		private function onKeyUpHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.DELETE)
			{
				this.removeCurSpt();
			}
			else if (event.keyCode == Keyboard.SPACE)
			{
				this.isOnSpaceKey = false;
				Mouse.cursor = MouseCursor.ARROW;
			}
		}
		
		private function onKeyDownHandler(event:KeyboardEvent):void
		{
			if (event.ctrlKey && event.keyCode == Keyboard.D)
				this.copy(this.curSpt);
			else if (event.keyCode == Keyboard.ENTER)
				this.updateSptProp();
			else if (event.keyCode == Keyboard.SPACE)
			{
				this.isOnSpaceKey = true;
				Mouse.cursor = MouseCursor.HAND;
			}
		}
		
		private function refreshBtnHandler(event:MouseEvent):void
		{
			this.updateResDirList();
		}
		
		private function openBtnHandler(event:MouseEvent):void
		{
			this.selectResDir();
		}
		
		private function depthBtnHandler(event:MouseEvent):void
		{
			if (this.curSpt)
				this.curSpt.parent.addChild(this.curSpt);
		}
		
		/**
		 * 交换深度
		 * @param	next	是否向下交换
		 */
		private function swapDepth(next:Boolean):void
		{
			if (this.curSpt)
			{
				var index:int = this.curSpt.parent.getChildIndex(this.curSpt);
				if (!next) index++;
				else index--;
				if (index < 0) index = 0;
				if (index > this.curSpt.parent.numChildren - 1) index = this.curSpt.parent.numChildren - 1;
				this.curSpt.parent.setChildIndex(this.curSpt, index);
			}
		}
		
		private function checkTransformTool():void
		{
			this.editUI.transformTool.target = null;
			if (this.editUI.transfromCb.selected)
			{
				if (this.curSpt)
				{
					if (this.curSpt is SpineAni) SpineAni(this.curSpt).pause();
					this.editUI.transformTool.target = this.curSpt;
				}
			}
			else
			{
				if (this.curSpt && this.curSpt is SpineAni) SpineAni(this.curSpt).unPause();
			}
		}
		
		/**
		 * 删除当前动画
		 */
		private function removeCurSpt():void
		{
			if (this.editUI && this.editUI.transformTool && this.editUI.transformTool.target == this.curSpt)
				this.editUI.transformTool.target = null;
			
			if (this.curSpt && this.curSpt.parent)
				this.curSpt.parent.removeChild(this.curSpt);
			this.curSpt = null;
			this.sendNotification(Message.DELETE);
		}
		
		/**
		 * 复制一个显示对象
		 * @param	o		显示对象源
		 */
		private function copy(o:DisplayObject):void
		{
			if (!o) return;
			if (o is SpineAni)
			{
				var spAni:SpineAni = SpineAni(o).clone();
				spAni.addEventListener(MouseEvent.MOUSE_DOWN, sptOnMouseDownHandler);
				Layer.ANI_STAGE.addChild(spAni);
				spAni.play(spAni.animationName);
				this.drawBound(spAni);
				this.curSpt = spAni;
			}
			else
			{
				var image:Image = Image(o).clone();
				image.addEventListener(MouseEvent.MOUSE_DOWN, sptOnMouseDownHandler);
				Layer.ANI_STAGE.addChild(image);
				this.drawBound(image);
				this.curSpt = image;
			}
		}
		
		/**
		 * 更新当前选中的显示对象的属性
		 */
		private function updateSptProp():void
		{
			if (!this.curSpt) return;
			this.curSpt.scaleX = Number(this.editUI.scaleXTxt.text) / 100;
			this.curSpt.scaleY = Number(this.editUI.scaleYTxt.text) / 100;
			this.curSpt.rotation = Number(this.editUI.rotationTxt.text);
			this.curSpt.x = Number(this.editUI.posXTxt.text);
			this.curSpt.y = Number(this.editUI.posYTxt.text);
		}
		
		private function saveBtnHandler(event:MouseEvent):void
		{
			this.save(false);
		}
		
		/**
		 * 保存
		 * @param	export	是否是导出数据（false为保存文件）
		 */
		private function save(isExport:Boolean):void
		{
			var num:int = Layer.ANI_STAGE.numChildren;
			var arr:Array = [];
			var dict:Dictionary = new Dictionary();
			var dp:DisplayObject;
			var name:String;
			var jsonName:String;
			var resName:String;
			var node:Object = {};
			node.type = "stage";
			node.stageWidth = this.stageWidth;
			node.stageHeight = this.stageHeight;
			arr.push(node);
			for (var i:int = 0; i < num; i++)
			{
				var type:String;
				dp = Layer.ANI_STAGE.getChildAt(i);
				if (DisplayObjectContainer(dp).numChildren == 0) continue;
				if (dp is SpineAni)
				{
					type = "spine";
					jsonName = SpineAni(dp).jsonName;
					name = jsonName.split(".")[0];
					dp.name = name;
					if (!dict[name + type])
						dict[name + type] = 1;
					else
						dict[name + type]++;
					dp.name = name + "_" + dict[name + type];
				}
				else
				{
					type = "img";
					resName = Image(dp).resName;
					name = resName.split(".")[0];
					dp.name = name;
					if (!dict[name + type])
						dict[name + type] = 1;
					else
						dict[name + type]++;
					dp.name = name + "_" + dict[name + type];
				}
			}
			
			for (i = 0; i < num; i++)
			{
				dp = Layer.ANI_STAGE.getChildAt(i);
				if (DisplayObjectContainer(dp).numChildren == 0) continue;
				var node:Object = {};
				if (dp is SpineAni)
				{
					node.type = "spine";
					node.png = SpineAni(dp).pngName;
					node.atlas = SpineAni(dp).atlasName;
					node.json = SpineAni(dp).jsonName;
					jsonName = String(node.json);
					node.animationName = SpineAni(dp).animationName;
					node.isLoop = SpineAni(dp).isLoop;
					name = jsonName.split(".")[0];
					if (!isExport) node.path = SpineAni(dp).pathName;
					if (dict[name + node.type] > 1)
						node.name = dp.name;
					else
						node.name = name;
				}
				else
				{
					node.type = "img";
					node.png = Image(dp).resName;
					resName = Image(dp).resName;
					name = resName.split(".")[0];
					if (!isExport) node.path = Image(dp).pathName;
					if (dict[name + node.type] > 1)
						node.name = dp.name;
					else
						node.name = name;
				}
				node.x = dp.x;
				node.y = dp.y;
				trace("node.x , node.y", node.x, node.y);
				if (node.y < 0) node.y = Math.abs(node.y);
				else node.y = -Math.abs(node.y);
				node.scaleX = dp.scaleX;
				node.scaleY = dp.scaleY;
				node.rotation = dp.rotation;
				node.orderZ = Layer.ANI_STAGE.getChildIndex(dp);
				arr.push(node);
			}
			this.saveDataStr = JSON.stringify(arr);
			trace(this.saveDataStr);
			if (!isExport)
			{
				if (!this.saveFile)
				{
					this.saveFile = File.desktopDirectory;
					this.saveFile.addEventListener(Event.SELECT, selectSaveFileHandler);
					this.saveFile.url += ".json"; //确认后缀名
				}
				this.saveFile.browseForSave("保存数据");
			}
			else
			{
				if (!this.importFile)
				{
					this.importFile = File.desktopDirectory;
					this.importFile.addEventListener(Event.SELECT, selectSaveFileHandler);
					this.importFile.url += ".json"; //确认后缀名
				}
				this.importFile.browseForSave("导出数据");
			}
		}
		
		private function selectSaveFileHandler(event:Event):void
		{
			var file:File = event.currentTarget as File;
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(this.saveDataStr);
			stream.close();
		}
		
		/**
		 * 选中动画
		 * @param	spAni	选中动画
		 */
		private function selectSpAni(spAni:Sprite):void
		{
			this.drawBound(spAni);
			if (this.curSpt && this.curSpt is SpineAni) SpineAni(this.curSpt).unPause();
			this.curSpt = spAni;
			this.checkTransformTool();
			this.editUI.setCtrlProp(this.curSpt);
			this.editUI.showCtrlPanel(spAni != null);
		}
		
		/**
		 * 清空
		 */
		private function clearAll():void
		{
			var num:int = Layer.ANI_STAGE.numChildren - 1;
			for (var i:int = num; i >= 0; --i)
			{
				Layer.ANI_STAGE.removeChildAt(i);
			}
			
			if (this.editUI && this.editUI.transformTool && this.editUI.transformTool.target == this.curSpt)
				this.editUI.transformTool.target = null;
			this.curSpt = null;
		}
		
		/**
		 * 解析
		 * @param	dataStr	数据
		 */
		private function parsing(dataStr:String):void
		{
			var arr:Array = JSON.parse(dataStr) as Array;
			var num:int = arr.length;
			arr.sortOn("orderZ", Array.NUMERIC);
			for (var i:int = 0; i < num; i++)
			{
				var data:Object = arr[i];
				if (data.type != "stage")
				{
					var x:Number = data.x;
					var y:Number = data.y;
					var scaleX:Number = data.scaleX;
					var scaleY:Number = data.scaleY;
					var rotation:Number = data.rotation;
					var depth:int = data.orderZ;
					if (y > 0) y = -Math.abs(y);
					else y = Math.abs(y);
					if (data.type == "spine")
					{
						var spAni:SpineAni = new SpineAni();
						spAni.addEventListener(Event.COMPLETE, spAniLoadCompleteHandler);
						spAni.addEventListener(ErrorEvent.ERROR, spAniLoadErrorCompleteHandler);
						spAni.addEventListener(MouseEvent.MOUSE_DOWN, sptOnMouseDownHandler);
						spAni.loadSpine(data.png, data.atlas, data.json, data.path);
						spAni.pathName = data.path;
						spAni.scaleX = scaleX;
						spAni.scaleY = scaleY;
						spAni.rotation = rotation;
						spAni.x = x;
						spAni.y = y;
						spAni.animationName = data.animationName;
						spAni.isLoop = data.isLoop;
						Layer.ANI_STAGE.addChild(spAni);
					}
					else if (data.type == "img")
					{
						var image:Image = new Image();
						image.resName = data.png;
						image.pathName = data.path;
						image.load(data.path);
						image.x = x;
						image.y = y;
						image.scaleX = scaleX;
						image.scaleY = scaleY;
						image.rotation = rotation;
						Layer.ANI_STAGE.addChild(image);
						image.addEventListener(MouseEvent.MOUSE_DOWN, sptOnMouseDownHandler);
						image.addEventListener(IOErrorEvent.IO_ERROR, loadImageErrorHandler);
					}
				}
				else
				{
					this.stageWidth = data.stageWidth;
					this.stageHeight = data.stageHeight;
					this.updateStage();
				}
			}
		}
	}
}