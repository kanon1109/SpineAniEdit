package controller 
{
import model.proxy.HistoryProxy;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

/**
 * ...数据
 * @author ...
 */
public class ModelCommand extends SimpleCommand 
{
	public function ModelCommand() 
	{
		super();
	}
	
	
	override public function execute(notification:INotification):void 
	{
		this.facade.registerProxy(new HistoryProxy());
	}
}
}