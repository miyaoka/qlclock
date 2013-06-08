package jp.tp.qlclock.view.component
{
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Rectangle;
	
	import jp.tp.qlclock.assets.Clock;
	import jp.tp.qlclock.view.event.ClockWindowEvent;
	
	[Event(name="frameResize", type="jp.tp.qlclock.view.event.ClockWindowEvent")]
	public class ClockWindow extends FlexNativeWindow
	{
		public var clockComp:ClockContainer;
		public var clockMC:Clock;
		
		
		public function ClockWindow()
		{
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions;
			initOptions.systemChrome = NativeWindowSystemChrome.NONE;
//			initOptions.transparent = true;
//			initOptions.type = NativeWindowType.LIGHTWEIGHT;
			initOptions.type = NativeWindowType.UTILITY;
			
			
			super(initOptions);
			title = "clock";
			
			//UIComponent追加
			clockComp = new ClockContainer;
			//compをwindowと同じ大きさにしてセンターにMCが来るようにする
			clockComp.percentWidth = clockComp.percentHeight = 100;
			addChildControls(clockComp);
			
			//Comp内のMC参照
			clockMC = clockComp.clock;
			
			//drag window
			clockMC.addEventListener(MouseEvent.MOUSE_DOWN, onClockMouseDown);
			
			//resize window
			clockMC.frame.buttonMode = true;
			clockMC.frame.addEventListener(MouseEvent.MOUSE_DOWN, onClockFrameMouseDown);
			
		}
		public function setBounds(b:Rectangle):void
		{
			if(b.equals(bounds)) return;
			
			bounds = b;
			fitMCtoWindow();
		}
		/**
		 * フレーム以外をマウス押下でドラッグ
		 */ 
		private function onClockMouseDown(e:MouseEvent):void
		{
			if(e.target == clockMC.frame) return;
			
			//startmoveだと画面境界でリサイズされる不具合があるので自分で動かす
			startDrag();
		}

		
		/**
		 * フレームをマウス押下でリサイズ開始
		 */ 
		private function onClockFrameMouseDown(e:MouseEvent):void
		{
			//baseスケールを保存
			resizeBaseBounds = bounds.clone();
			resizeBaseScale = clockMC.scaleX;
			resizeBaseRadius = getRadius();
			resizeCenterX = x + clockMC.x;
			resizeCenterY = y + clockMC.y;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		private var resizeBaseBounds:Rectangle;
		private var resizeBaseScale:Number;
		private var resizeBaseRadius:Number;
		private var resizeCenterX:Number;
		private var resizeCenterY:Number;
		/**
		 * リサイズ中
		 */ 
		private function onStageMouseMove(e:MouseEvent):void
		{
			//中心点からのマウス座標で半径を求めサイズ比を算出
			var multiplyScale:Number = getRadius() / resizeBaseRadius;
			
			//初期スケールに現在のサイズ比を適用する
			clockMC.scaleX =
			clockMC.scaleY = resizeBaseScale * multiplyScale;
			
			//MCと同サイズにウィンドウサイズを合わせる
			fitWindowToMC();
		}
		/**
		 * リサイズ終了
		 */ 
		private function onStageMouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			if(resizeBaseBounds.width != bounds.width || resizeBaseBounds.height != bounds.height)
			{
				dispatchEvent(new ClockWindowEvent(ClockWindowEvent.FRAME_RESIZE));
			}
		}
		/**
		 * MCリサイズ時にウィンドウサイズを合わせる
		 */ 
		private function fitWindowToMC():void
		{
			var clockSize:Number = clockMC.width + margin;
			
			bounds = new Rectangle(
				resizeCenterX - clockSize/2, 
				resizeCenterY - clockSize/2, 
				clockSize,
				clockSize
			);
		}
		/**
		 * ウィンドウリサイズ時にMCを合わせる
		 */ 
		private function fitMCtoWindow():void
		{
			var size:Number = width - margin;
			clockMC.width = clockMC.height = size;
		}
		private var margin:Number = 32;
		
		/**
		 * マウス位置からスケールを求める
		 */ 
		private function getRadius():Number
		{
			var mx:Number = stage.mouseX - clockMC.x;
			var my:Number = stage.mouseY - clockMC.y;
			return Math.sqrt(mx*mx + my*my);
			
			return Math.sqrt(clockMC.mouseX * clockMC.mouseX + clockMC.mouseY * clockMC.mouseY);
		}		
	}
}