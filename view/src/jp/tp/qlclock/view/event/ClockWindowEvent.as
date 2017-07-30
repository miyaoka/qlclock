package jp.tp.qlclock.view.event
{
	import flash.events.Event;
	
	public class ClockWindowEvent extends Event
	{
		public static const FRAME_RESIZE:String = "frameResize";
		public function ClockWindowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}