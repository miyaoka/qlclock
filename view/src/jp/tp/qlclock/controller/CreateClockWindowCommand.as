package jp.tp.qlclock.controller
{
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
		
	import jp.tp.qlclock.view.component.ClockWindow;
	import jp.tp.qlclock.view.mediator.ClockWindowMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class CreateClockWindowCommand extends SimpleCommand
	{
		public function CreateClockWindowCommand()
		{
		}
		override public function execute(n:INotification):void
		{
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions;
			initOptions.systemChrome = NativeWindowSystemChrome.NONE;
			initOptions.transparent = Boolean(n.getBody());
			initOptions.type = NativeWindowType.LIGHTWEIGHT;
			//			initOptions.type = NativeWindowType.UTILITY;
			
			
			var clw:ClockWindow = new ClockWindow(initOptions);
			facade.registerMediator(new ClockWindowMediator(clw));
		}		
	}
}