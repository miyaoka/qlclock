package jp.tp.qlclock.view.component
{
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Rectangle;
	
	public class ConfigWindow extends FlexNativeWindow
	{
		private var lastX:Number;
		private var lastY:Number;
		public function ConfigWindow()
		{
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions;
	//		initOptions.type = NativeWindowType.UTILITY;
			
			super(initOptions);
			
			title = "conf";
			var cv:ConfigView = new ConfigView;
			addChildControls(cv);
			cv.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
//			addEventListener(NativeWindowBoundsEvent.MOVING, onMove);
			activate();
			
		}
		private function onMouseDown(e:MouseEvent):void
		{
//			startMove();
//			return;
			lastX = stage.mouseX;
			lastY = stage.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		private function onMouseMove(e:MouseEvent):void
		{
			trace(e.stageX, e.stageY, lastX, lastY);
			bounds = new Rectangle(
				x + e.stageX - lastX, 
				y + e.stageY - lastY,
				width, height
			);
//			x += e.stageX - lastX;
//			y += e.stageY - lastY;
//			lastX = e.stageX;
//			lastY = e.stageY;
		}
		private function onMouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
		}
		private function onMove(e:NativeWindowBoundsEvent):void
		{
			if(e.beforeBounds.width != e.afterBounds.width
				|| e.beforeBounds.height != e.afterBounds.height)
			{
				e.preventDefault();
			}
			x = e.afterBounds.x;
			y = e.afterBounds.y;
		}
	}
}