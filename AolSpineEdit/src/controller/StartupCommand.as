package controller 
{
import org.puremvc.as3.patterns.command.MacroCommand;
/**
 * ...
 * @author Kanon
 */
public class StartupCommand extends MacroCommand 
{	
	override protected function initializeMacroCommand():void 
	{
		this.addSubCommand(ViewCommand);		
		super.initializeMacroCommand();
	}
}
}