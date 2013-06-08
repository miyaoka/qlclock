package jp.tp.qlclock.view.mediator
{
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import jp.tp.qlclock.controller.constant.AppConstants;
	
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
			
			initIcon();
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
		private function get view():QlClock
		{
			return viewComponent as QlClock;
		}
		private function onExiting(e:Event):void
		{
			trace("exiting");
		}
		/**
		 * タスクトレイ/Dockの設定
		 */ 
		private function initIcon():void
		{
			//MacDock
			if(NativeApplication.supportsDockIcon)
			{
				var dockIcon:DockIcon = NativeApplication.nativeApplication.icon as DockIcon;
				dockIcon.menu = createIconMenu();
			}
			//WinSystemTray
			else if (NativeApplication.supportsSystemTrayIcon)
			{
				var sysTrayIcon:SystemTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
				sysTrayIcon.tooltip = "おもち";
				sysTrayIcon.menu = createIconMenu();
			}
			loadIcons();
			//MacAppMenu
			if (NativeApplication.supportsMenu) { 
//				view.nativeApplication.menu = createIconMenu();
			} 			
			
		}
		/**
		 * タスクトレイ/Dockのメニュー作成
		 */ 
		private function createIconMenu():NativeMenu
		{
			restoreMenu.addEventListener(Event.SELECT, onRestore);
			transparentMenu.addEventListener(Event.SELECT, onTrans);
			quitMenu.addEventListener(Event.SELECT, onQuit);
			
			var iconMenu:NativeMenu = new NativeMenu();
			iconMenu.addItem(transparentMenu);
			iconMenu.addItem(restoreMenu);
			iconMenu.addItem(new NativeMenuItem("", true));//Separator
			iconMenu.addItem(quitMenu);
			
			/*
			if(NativeApplication.supportsSystemTrayIcon){
				iconMenu.addItem(showCommand);
				showCommand.addEventListener(Event.SELECT, undock);
				iconMenu.addItem(new NativeMenuItem("", true));//Separator
				var exitCommand: NativeMenuItem = iconMenu.addItem(new NativeMenuItem("Exit"));
				exitCommand.addEventListener(Event.SELECT, exit);
			}
			iconMenu.addItem(new NativeMenuItem("", true));//Separator
			iconMenu.addSubmenu(createSourceCodeMenu(), "Source code");
			iconMenu.addEventListener(Event.DISPLAYING, setMenuCommandStates);
			*/
			return iconMenu;
		}
		private function loadIcons():void
		{
			var bmds:Array = [];
			var sizes:Array = [16, 32, 48, 128];
			loadIcon(sizes, bmds);
		}
		private function loadIcon(sizes:Array, bmds:Array):void
		{
			if(sizes.length == 0)
			{
				NativeApplication.nativeApplication.icon.bitmaps = bmds;
				return;
			}
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				var li:LoaderInfo = LoaderInfo(e.target);
				li.removeEventListener(Event.COMPLETE, arguments.callee);
				bmds.push(Bitmap(li.content).bitmapData);
				loadIcon(sizes, bmds);
			});
			loader.load(new URLRequest("assets/icons/icon" + sizes.shift() + ".png"));
		}
	
		private var quitMenu:NativeMenuItem = new NativeMenuItem("quit");
		private var restoreMenu:NativeMenuItem = new NativeMenuItem("restore bounds");
		private var transparentMenu:NativeMenuItem = new NativeMenuItem("toggle transparent");
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
			view.nativeApplication.exit();
		}
	}
}