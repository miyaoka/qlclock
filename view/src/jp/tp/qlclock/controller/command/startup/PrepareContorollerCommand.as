package jp.tp.qlclock.controller.command.startup
{
	import jp.tp.qlclock.controller.SaveCommand;
	import jp.tp.qlclock.controller.constant.AppConstants;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepareContorollerCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.registerCommand(AppConstants.SAVE_BOUNDS, SaveCommand);
		}
	}
}