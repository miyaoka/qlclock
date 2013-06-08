package jp.tp.qlclock.model.proxy
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import jp.tp.qlclock.model.vo.DateVO;
	
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ClockTimeProxy extends Proxy
	{
		//name
		public static const NAME:String = "ClockTimeProxy";
		//notes
		public static const TIME_UPDATED:String = NAME + "/timeUpdated";
	
		//props
		private var _timer:Timer;
		private var _date:Date;
		
		public function ClockTimeProxy()
		{
			super(NAME);
		}
		override public function onRegister():void
		{
			updateTime();
			
			//init
			_timer = new Timer(1000/30,0);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_timer.start();
		}
		override public function onRemove():void
		{
			
		}

		public function get date():Date
		{
			return ObjectUtil.clone(_date) as Date;
		}

		public function timerHandler(e:TimerEvent):void
		{
			updateTime();
		}
		private function updateTime():void
		{
			_date = new Date();
			sendNotification(TIME_UPDATED);
		}
	}
}