package 
{
import controller.StartupCommand;
import org.puremvc.as3.patterns.facade.Facade;

/**
 * ...
 * @author Kanon
 */
public class ApplicationFacade extends Facade 
{
	public static const STARTUP:String = "startup";  
	public function ApplicationFacade() 
	{
		super();
	}
	
	public static function getInstance():ApplicationFacade
	{
		if (instance == null)
			instance = new ApplicationFacade();
		return instance as ApplicationFacade;
	}
	
	override protected function initializeController():void 
	{
		trace("initializeController");
		super.initializeController();
		this.registerCommand(STARTUP, StartupCommand);
	}
	
	/**
	 * 开启
	 */
	public function startup():void
	{
		this.sendNotification(STARTUP);
		this.removeCommand(STARTUP);
	}
}
}