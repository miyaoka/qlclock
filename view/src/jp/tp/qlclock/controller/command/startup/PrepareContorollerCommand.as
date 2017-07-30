package jp.tp.qlclock.controller.command.startup
{
	import jp.tp.qlclock.controller.CreateClockWindowCommand;
	import jp.tp.qlclock.controller.RestoreDefaultBoundsCommand;
	import jp.tp.qlclock.controller.SaveBoundsCommand;
	import jp.tp.qlclock.controller.ToggleTransParentCommand;
	import jp.tp.qlclock.controller.constant.AppConstants;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepareContorollerCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.registerCommand(AppConstants.SAVE_BOUNDS, SaveBoundsCommand);
			facade.registerCommand(AppConstants.RESTORE_DEFAULT_BOUNDS, RestoreDefaultBoundsCommand);
			facade.registerCommand(AppConstants.CREATE_CLOCK_WINDOW, CreateClockWindowCommand);
			facade.registerCommand(AppConstants.TOGGLE_TRANSPARENT, ToggleTransParentCommand);
		}
	}
}