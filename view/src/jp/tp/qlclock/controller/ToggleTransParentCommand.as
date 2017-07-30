package jp.tp.qlclock.controller
{
	import jp.tp.qlclock.controller.constant.AppConstants;
	import jp.tp.qlclock.view.mediator.ClockWindowMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ToggleTransParentCommand extends SimpleCommand
	{
		public function ToggleTransParentCommand()
		{
			super();
		}
		override public function execute(n:INotification):void
		{
			var clock:ClockWindowMediator = ClockWindowMediator(facade.retrieveMediator(ClockWindowMediator.NAME));
			var trans:Boolean = clock.transparent;
			clock.close();
			sendNotification(AppConstants.CREATE_CLOCK_WINDOW, !trans);
		}
	}
}