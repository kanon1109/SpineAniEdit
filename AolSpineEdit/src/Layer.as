package
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	/**
	 * ...层
	 * @author Kanon
	 */
	public class Layer
	{
		public static var STAGE:Stage;
		public static var UI:Sprite;
		public static var ANI_STAGE:Sprite;
		public static var EDIT:Sprite;
		public static var SYSTEM:Sprite;
		public static var CANVAS:Sprite;
		public static var CANVAS_STAGE:Sprite;
		public static var CANVAS_CENTER_POS:Sprite;
		public static var WINDOWS:Sprite;
		
		public static function initLayer(root:DisplayObjectContainer):void
		{
			STAGE = root.stage;
			
			UI = new Sprite();
			root.addChild(UI);
			
			CANVAS = new Sprite();
			CANVAS.mouseChildren = false;
			CANVAS.mouseEnabled = false;
			root.addChild(CANVAS);
			
			CANVAS_STAGE = new Sprite();
			CANVAS.addChild(CANVAS_STAGE);
			
			CANVAS_CENTER_POS = new Sprite();
			CANVAS.addChild(CANVAS_CENTER_POS);
			
			ANI_STAGE = new Sprite();
			root.addChild(ANI_STAGE);
			
			EDIT = new Sprite();
			root.addChild(EDIT);
			
			WINDOWS = new Sprite();
			root.addChild(WINDOWS);
			
			SYSTEM = new Sprite();
			root.addChild(SYSTEM);
		}
	}
}