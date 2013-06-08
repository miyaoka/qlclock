package jp.tp.qlclock.model.proxy
{
	import flash.net.SharedObject;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class IOProxy extends Proxy
	{
		public static const NAME:String = "IOProxy";
		
		private var so:SharedObject;
		
		public function IOProxy()
		{
			super(NAME);
		}
		override public function onRegister():void
		{
			so = SharedObject.getLocal("conf");
		}
		override public function onRemove():void
		{
			
		}		
		
		public function restore():void
		{
		}
		public function save():void
		{
//			so.data.x = cw.x;
//			so.data.y = cw.y;
			so.flush();
			
		}
	}
}