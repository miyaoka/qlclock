package jp.tp.qlclock.view.mediator
{
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Rectangle;
	
	import jp.tp.qlclock.ApplicationFacade;
	import jp.tp.qlclock.controller.constant.AppConstants;
	import jp.tp.qlclock.model.proxy.ClockTimeProxy;
	import jp.tp.qlclock.model.proxy.ConfigProxy;
	import jp.tp.qlclock.view.component.ClockWindow;
	import jp.tp.qlclock.view.event.ClockWindowEvent;
	import jp.tp.qlclock.view.event.FlexNativeWindowEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ClockWindowMediator extends Mediator
	{
		public static const NAME:String = "ClockWindowMediator";
		
		private var clockProxy:ClockTimeProxy;
		private var configProxy:ConfigProxy;
		public function ClockWindowMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void
		{
			//set proxies
			clockProxy = ClockTimeProxy(facade.retrieveProxy(ClockTimeProxy.NAME));
			configProxy = ConfigProxy(facade.retrieveProxy(ConfigProxy.NAME));
			
			//set view data
			updateTime();
			restoreBounds();
			
			//set view events
			view.addEventListener(ClockWindowEvent.FRAME_RESIZE, onFrameResize);
			view.addEventListener(FlexNativeWindowEvent.DRAG_MOVE, onFlexWindowMove);
			
			//set view appearance
			view.clockMC.edit.visible = false;
			
			//show view
			view.activate();
			
			
			return;
			view.clockMC.cover.visible = false;
			view.clockMC.hands.hourHand.filters =
				view.clockMC.hands.minuteHand.filters =
				view.clockMC.hands.secondHand.filters = 
				view.clockMC.cover.filters = [];
			
		}
		override public function onRemove():void
		{
			
		}
		override public function listNotificationInterests():Array
		{
			return [
				ClockTimeProxy.TIME_UPDATED
			];
		}
		override public function handleNotification(n:INotification):void
		{
			switch(n.getName())
			{
				case ClockTimeProxy.TIME_UPDATED:
					updateTime();
					break;
			}
		}		
		/**
		 * 時刻更新時に時計の針を更新する
		 */ 
		private function updateTime():void
		{
			var date:Date = clockProxy.date;
			view.clockMC.hands.hourHand.rotation = (date.hours % 12 + date.minutes / 60 + date.seconds / 3600) * 360 / 12;
			view.clockMC.hands.minuteHand.rotation = (date.minutes + (date.seconds + date.milliseconds / 1000) / 60) * 360 / 60;
			view.clockMC.hands.secondHand.rotation = (date.seconds + date.milliseconds / 1000) * 360 / 60;
		}
		/**
		 * 起動時にboundsを復元する
		 */ 
		private function restoreBounds():void
		{
			view.setBounds(configProxy.bounds || initBounds);
		}
		/**
		 * デフォルトのbounds
		 */
		private function get initBounds():Rectangle
		{
			return new Rectangle(50,50,200,200);
		}
		/**
		 * 位置移動とリサイズ時にboundsを保存する
		 */ 
		private function onFlexWindowMove(e:FlexNativeWindowEvent):void
		{
			saveBounds();
		}
		private function onFrameResize(e:ClockWindowEvent):void
		{
			saveBounds();
		}
		private function saveBounds():void
		{
			sendNotification(AppConstants.SAVE_BOUNDS, view.bounds);
		}
		private function get view():ClockWindow
		{
			return viewComponent as ClockWindow;
		}		
	}
}