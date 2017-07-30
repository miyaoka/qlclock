package jp.tp.qlclock.view.mediator
{
	import flash.events.NativeWindowBoundsEvent;
	
	import jp.tp.qlclock.view.component.ConfigWindow;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ConfigWindowMediator extends Mediator
	{
		public static const NAME:String = "ConfigWindowMediator";
		
		public function ConfigWindowMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void
		{
//			ConfigWindow(viewComponent).addEventListener(NativeWindowBoundsEvent.MOVE, onMove);
			
		}
		private function onMove(e:NativeWindowBoundsEvent):void
		{
			
		}
		override public function onRemove():void
		{
			
		}
		override public function listNotificationInterests():Array
		{
			return [
			];
		}
		override public function handleNotification(notification:INotification):void
		{
		}
		private function get view():ConfigWindow
		{
			return viewComponent as ConfigWindow;
		}		
	}
}