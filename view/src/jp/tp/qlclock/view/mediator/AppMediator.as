package jp.tp.qlclock.view.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AppMediator extends Mediator
	{
		public static const NAME:String = "AppMediator";
		
		public function AppMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void
		{
			view.nativeApplication.addEventListener(Event.EXITING, onExiting);
			
		}
		override public function onRemove():void
		{
			trace("remove");
			
		}
		override public function listNotificationInterests():Array
		{
			return [
				];
		}
		override public function handleNotification(notification:INotification):void
		{
			
		}
		private function onExiting(e:Event):void
		{
			trace("closing");
		}
		private function get view():QlClock
		{
			return viewComponent as QlClock;
		}
	}
}