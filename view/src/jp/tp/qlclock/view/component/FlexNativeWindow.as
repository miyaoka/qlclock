package jp.tp.qlclock.view.component
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import jp.tp.qlclock.view.event.FlexNativeWindowEvent;
	
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.WindowedSystemManager;
	import mx.states.AddChild;
	
	[Event(name="dragMove", type="jp.tp.qlclock.view.event.FlexNativeWindowEvent")]
	public class FlexNativeWindow extends NativeWindow
	{
		public function FlexNativeWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
			addEventListener(Event.ACTIVATE, windowActivateHandler);
		}
		
		private var _systemManager:WindowedSystemManager;
		private var _content:IUIComponent;
		
		
		//* Custom function to allow the content to be passed into the window
		public function addChildControls(control:IUIComponent):void
		{
			_content = control;
		}
		
		//* This handler actually adds the content to the NativeWindow
		private function windowActivateHandler(event:Event):void
		{
			//* Process the event
			event.preventDefault();
			event.stopImmediatePropagation();
			removeEventListener(Event.ACTIVATE, windowActivateHandler);
			
			//* Create the children and add an event listener for re-sizing the window
			if(stage)
			{
				//* create a WindowedSystemManager to hold the content
				if(!_systemManager)
				{
					//*    Create a system manager
					_systemManager = new WindowedSystemManager(_content);
				}
				
				//* Add the content to the stage
				stage.addChild(_systemManager);
				
				//* Dispatch a creation complete event
				dispatchEvent(new FlexEvent(FlexEvent.CREATION_COMPLETE));
				
				//* Add in a resize event listener
				stage.addEventListener(Event.RESIZE, windowResizeHandler);
			}
		}
		
		//* Resizes the content in response to a change in size
		private function windowResizeHandler(event:Event):void
		{
			_content.width = stage.stageWidth;
			_content.height = stage.stageHeight;
		}
		
		
		/**
		 * stageのマウス位置差分でwindowを動かす
		 * 
		 * startMoveだと画面境界で勝手にリサイズされる不具合があるため独自に実装
		 */ 
		public function startDrag():void
		{
			dragBaseBounds = bounds.clone();
			dragBaseX = stage.mouseX;
			dragBaseY = stage.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseDragMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseDragUp);
		}
		private function onMouseDragMove(e:MouseEvent):void
		{
			bounds = new Rectangle(
				x + e.stageX - dragBaseX, 
				y + e.stageY - dragBaseY,
				width, height
			);
		}
		private function onMouseDragUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseDragMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseDragUp);
			if(dragBaseBounds.x != bounds.x || dragBaseBounds.y != bounds.y)
			{
				dispatchEvent(new FlexNativeWindowEvent(FlexNativeWindowEvent.DRAG_MOVE));
			}
		}		
		private var dragBaseX:Number;
		private var dragBaseY:Number;
		private var dragBaseBounds:Rectangle;
	}
}