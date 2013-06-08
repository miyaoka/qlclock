package jp.tp.qlclock.controller.command.startup
{
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
			
			var clw:ClockWindow = new ClockWindow();
			facade.registerMediator(new AppMediator(app));
			facade.registerMediator(new ClockWindowMediator(clw));
//			facade.registerMediator(new ConfigWindowMediator(new ConfigWindow));
		}
	}
}