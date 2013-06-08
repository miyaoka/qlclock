package jp.tp.qlclock
{
	import jp.tp.qlclock.controller.command.startup.StartupCommand;
	import jp.tp.qlclock.controller.constant.AppConstants;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade
	{
		public static function getInstance():ApplicationFacade
		{
			if(!instance) instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		public function startup(app:QlClock):void
		{
			registerCommand(AppConstants.STARTUP, StartupCommand);
			sendNotification(AppConstants.STARTUP, app);
		}
	}
}