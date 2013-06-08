package jp.tp.qlclock.view.mediator
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Rectangle;
	
	import jp.tp.qlclock.ApplicationFacade;
	import jp.tp.qlclock.controller.constant.AppConstants;
	import jp.tp.qlclock.model.proxy.ClockTimeProxy;
	import jp.tp.qlclock.model.proxy.ConfigProxy;
	import jp.tp.qlclock.model.vo.ClockBoundsVO;
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
			
			//set view menu
			initContextMenu();

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
				ClockTimeProxy.TIME_UPDATED,
				ConfigProxy.UPDATE_BOUNDS
			];
		}
		override public function handleNotification(n:INotification):void
		{
			switch(n.getName())
			{
				case ClockTimeProxy.TIME_UPDATED:
					updateTime();
					break;
				case ConfigProxy.UPDATE_BOUNDS:
					onUpdateBounds(ClockBoundsVO(n.getBody()));
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
			view.setBounds(configProxy.bounds);
		}
		/**
		 * modelのboundが変更されたとき
		 */ 
		private function onUpdateBounds(b:ClockBoundsVO):void
		{
			view.setBounds(b)
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
			sendNotification(AppConstants.SAVE_BOUNDS, view.clockBounds);
		}
		private function get view():ClockWindow
		{
			return viewComponent as ClockWindow;
		}		
		public function get transparent():Boolean
		{
			return view.transparent;
		}
		public function close():void
		{
			view.close();
			facade.removeMediator(NAME);
		}
		
		private function initContextMenu():void
		{
			restoreMenu.addEventListener(Event.SELECT, onRestore);
			transparentMenu.addEventListener(Event.SELECT, onTrans);
			quitMenu.addEventListener(Event.SELECT, onQuit);
			
			var iconMenu:NativeMenu = new NativeMenu();
			iconMenu.addItem(transparentMenu);
			iconMenu.addItem(restoreMenu);
			iconMenu.addItem(new NativeMenuItem("", true));//Separator
			iconMenu.addItem(quitMenu);			
			view.clockMC.contextMenu = iconMenu;
		}
		private var quitMenu:NativeMenuItem = new NativeMenuItem("Close");
		private var restoreMenu:NativeMenuItem = new NativeMenuItem("Reset bounds");
		private var transparentMenu:NativeMenuItem = new NativeMenuItem("Toggle transparent");
		private function onRestore(e:Event):void
		{
			sendNotification(AppConstants.RESTORE_DEFAULT_BOUNDS);
		}
		private function onTrans(e:Event):void
		{
			sendNotification(AppConstants.TOGGLE_TRANSPARENT);
		}
		private function onQuit(e:Event):void
		{
			close();
		}		
	}
}