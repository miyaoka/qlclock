package jp.tp.qlclock.controller.command.startup
{
	import jp.tp.qlclock.model.proxy.ClockTimeProxy;
	import jp.tp.qlclock.model.proxy.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepareModelCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var clock:ClockTimeProxy = new ClockTimeProxy();
			var conf:ConfigProxy = new ConfigProxy();
			facade.registerProxy(clock);
			facade.registerProxy(conf);
		}
	}
}