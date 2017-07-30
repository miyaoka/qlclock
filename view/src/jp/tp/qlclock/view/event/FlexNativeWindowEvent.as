package jp.tp.qlclock.view.event
{
	import flash.events.Event;
	
	public class FlexNativeWindowEvent extends Event
	{
		public static const DRAG_MOVE:String = "dragMove";
		
		public function FlexNativeWindowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}