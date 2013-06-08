package jp.tp.qlclock.model.proxy
{
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	
	import jp.tp.qlclock.model.vo.ClockBoundsVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ConfigProxy extends Proxy
	{
		//name
		public static const NAME:String = "ConfigProxy";
		//notes
		public static const UPDATE_BOUNDS:String = NAME + "/updateBounds";
		
		private var so:SharedObject;
		private var _bounds:ClockBoundsVO;
		
		public function ConfigProxy()
		{
			super(NAME);
		}
		override public function onRegister():void
		{
			so = SharedObject.getLocal("conf");
			
			var b:Object = so.data.bounds;
			if(b)
			{
				_bounds = new ClockBoundsVO(b.x, b.y, b.size)
			}
			else
			{
				restoreDefaultBounds();
			}
		}
		override public function onRemove():void
		{
			
		}
		public function save():void
		{
			so.flush();
		}		
		public function get bounds():ClockBoundsVO
		{
			return _bounds;
		}
		
		public function set bounds(value:ClockBoundsVO):void
		{
			_bounds = value;
			so.data.bounds = value;
			save();
			sendNotification(UPDATE_BOUNDS, bounds);
		}
		public function restoreDefaultBounds():void
		{
			bounds = defaultBounds;
		}
		private var defaultBounds:ClockBoundsVO = new ClockBoundsVO(200, 200, 200);
	}
}