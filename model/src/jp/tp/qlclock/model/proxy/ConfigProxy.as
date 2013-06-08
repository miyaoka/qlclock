package jp.tp.qlclock.model.proxy
{
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ConfigProxy extends Proxy
	{
		//name
		public static const NAME:String = "ConfigProxy";
		//notes
		public static const UPDATE_BOUNDS:String = NAME + "/updateBounds";
		
		private var so:SharedObject;
		private var _bounds:Rectangle;
		
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
				_bounds = new Rectangle(b.x, b.y, b.width, b.height);
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
		public function get bounds():Rectangle
		{
			return _bounds.clone();
		}
		
		public function set bounds(value:Rectangle):void
		{
			_bounds = value;
			so.data.bounds = value;
			save();
			sendNotification(UPDATE_BOUNDS, bounds);
		}
		public function restoreDefaultBounds():void
		{
			bounds = defaultBounds.clone();
		}
		private var defaultBounds:Rectangle = new Rectangle(50,50,200,200);
	}
}