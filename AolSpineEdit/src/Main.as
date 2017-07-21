package
{
import flash.display.Sprite;
/**
 * ...主程序入口
 * @author Kanon
 */
[SWF(width = "1280", height = "768", frameRate = "60", backgroundColor = "#000000")]
public class Main extends Sprite
{
	public function Main()
	{
		stage.color = 0x000000;
		Layer.initLayer(this);
		ApplicationFacade.getInstance().startup();
	}
}
}