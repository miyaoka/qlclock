package jp.tp.qlclock.view.component
{
	import flash.events.FocusEvent;
	import spark.components.Scroller;
	public class ScrollerFixed extends Scroller
	{
		public function ScrollerFixed()
		{
			super();
		}
		
		override protected function focusInHandler(event:FocusEvent):void
		{
			if(focusManager != null) {
				super.focusInHandler(event);
			}
		}
	}
}