package jp.tp.qlclock.controller.command.startup
{
	import jp.tp.qlclock.controller.constant.AppConstants;
	import jp.tp.qlclock.view.component.ClockWindow;
	import jp.tp.qlclock.view.component.ConfigWindow;
	import jp.tp.qlclock.view.mediator.AppMediator;
	import jp.tp.qlclock.view.mediator.ClockWindowMediator;
	import jp.tp.qlclock.view.mediator.ConfigWindowMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepareViewCommand extends SimpleCommand
	{
		override public function execute(n:INotification):void
		{
			var app:QlClock = QlClock(n.getBody());
			
			facade.registerMediator(new AppMediator(app));
			sendNotification(AppConstants.CREATE_CLOCK_WINDOW, true);
//			facade.registerMediator(new ConfigWindowMediator(new ConfigWindow));
		}
	}
}