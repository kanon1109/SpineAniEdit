package controller 
{
import view.mediator.EditUIMediator;
import message.Message;
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;
/**
 * ...
 * @author Kanon
 */
public class ViewCommand extends SimpleCommand 
{
	public function ViewCommand() 
	{
		super();
	}
	
	override public function execute(notification:INotification):void 
	{
		trace("ViewCommand execute");
		this.facade.registerMediator(new EditUIMediator());
		this.sendNotification(Message.START);
	}
}
}