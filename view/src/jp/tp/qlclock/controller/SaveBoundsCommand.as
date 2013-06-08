package jp.tp.qlclock.controller
{
	import flash.geom.Rectangle;
	
	import jp.tp.qlclock.model.proxy.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SaveBoundsCommand extends SimpleCommand
	{
		public function SaveBoundsCommand()
		{
			super();
		}
		override public function execute(n:INotification):void
		{
			var proxy:ConfigProxy = ConfigProxy(facade.retrieveProxy(ConfigProxy.NAME));
			proxy.bounds = Rectangle(n.getBody());
		}
	}
}