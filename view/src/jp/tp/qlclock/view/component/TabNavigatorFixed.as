package jp.tp.qlclock.view.component
{
	import flash.events.KeyboardEvent;
	
	import mx.containers.TabNavigator;
	
	public class TabNavigatorFixed extends TabNavigator
	{
		public function TabNavigatorFixed()
		{
			super();
		}
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			if (focusManager && focusManager.getFocus() == this)
			{
				// Redispatch the event from the TabBar so that it can handle it.
				tabBar.dispatchEvent(event);
			}
		}
	}
}