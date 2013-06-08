package jp.tp.qlclock.view.component
{
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import jp.tp.qlclock.assets.Clock;
	import jp.tp.qlclock.model.vo.ClockBoundsVO;
	import jp.tp.qlclock.view.event.ClockWindowEvent;
	
	[Event(name="frameResize", type="jp.tp.qlclock.view.event.ClockWindowEvent")]
	public class ClockWindow extends FlexNativeWindow
	{
		public var clockComp:ClockContainer;
		public var clockMC:Clock;
		
		private var resizeBeforeBounds:ClockBoundsVO;
		private var resizeBeforeRadius:Number;
		
		//時計MCサイズとウィンドウのマージン（MC.width + margin = window.width）
		private var windowMargin:Number = 20;		
		
		//リサイズ拡大時に一度に拡大するウィンドウサイズ
		private var windowExpandSize:Number = 200;
		
		public function ClockWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
			
			//UIComponent追加
			clockComp = new ClockContainer;
			addChildControls(clockComp);
			
			//Comp内のMC参照
			clockMC = clockComp.clock;
			
			//drag window
			clockMC.addEventListener(MouseEvent.MOUSE_DOWN, onClockMouseDown);
			
			//resize window
			clockMC.frame.buttonMode = true;
			clockMC.frame.addEventListener(MouseEvent.MOUSE_DOWN, onClockFrameMouseDown);
			
			addEventListener(NativeWindowBoundsEvent.RESIZE, onWindowResize);
			
		}
		public function setBounds(b:ClockBoundsVO):void
		{
			clockMC.width = clockMC.height = b.size;
			fitWindowToMC(b);
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
			resizeBeforeBounds = clockBounds;
			resizeBeforeRadius = getRadius();
			resizeBeforeBounds.x = Math.ceil(resizeBeforeBounds.x);
			resizeBeforeBounds.y = Math.ceil(resizeBeforeBounds.y);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
			//一時的にリサイズハンドラ解除
			removeEventListener(NativeWindowBoundsEvent.RESIZE, onWindowResize);
		}
		

		
		/**
		 * リサイズ中
		 */ 
		private function onStageMouseMove(e:MouseEvent):void
		{
			//中心点からのマウス座標で半径を求めサイズ比を算出
			var multiplyScale:Number = getRadius() / resizeBeforeRadius;
			var clockSize:Number = resizeBeforeBounds.size * multiplyScale;
			
			//時計MCサイズを変える
			clockMC.width = clockMC.height = clockSize;
			
			//ドラッグ中は現在のウィンドウより大きい場合のみリサイズ
			//（transparentだとリサイズ時に一瞬MCも影響を受けるので動的なリサイズ回数を極力減らす）
			if(width < clockSize + windowMargin)
			{
				//拡大時には200pxずつ加算する
				fitWindowToMC(new ClockBoundsVO(resizeBeforeBounds.x, resizeBeforeBounds.y, clockSize + windowExpandSize));
			}
		}
		/**
		 * リサイズ確定
		 */ 
		private function onStageMouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
			//確定したMCサイズに合わせてウィンドウを合わせる
			fitWindowToMC(new ClockBoundsVO(resizeBeforeBounds.x, resizeBeforeBounds.y, clockMC.width));
			
			//リサイズハンドラを戻す
			addEventListener(NativeWindowBoundsEvent.RESIZE, onWindowResize);
			
			//サイズが更新されていれば通知
			var b:ClockBoundsVO = clockBounds;
			if(resizeBeforeBounds.x != b.x || resizeBeforeBounds.y != b.y || resizeBeforeBounds.size != b.size)
			{
				dispatchEvent(new ClockWindowEvent(ClockWindowEvent.FRAME_RESIZE));
			}
		}
		public function get clockBounds():ClockBoundsVO
		{
			var center:Point = globalToScreen(new Point(clockMC.x, clockMC.y));
			return new ClockBoundsVO(center.x, center.y, clockMC.width);
		}
		/**
		 * MCリサイズ時にウィンドウサイズを合わせる
		 */ 
		private function fitWindowToMC(b:ClockBoundsVO):void
		{
			var winSize:Number = b.size + windowMargin;
			var w:Number = Math.ceil((minSize.x > winSize) ? minSize.x : winSize);
			var h:Number = Math.ceil((minSize.y > winSize) ? minSize.y : winSize);
			
			bounds = new Rectangle(
				b.x - w/2, 
				b.y - h/2, 
				w,
				h
			);
			
			clockMC.x = b.x - x;
			clockMC.y = b.y - y;
		}
		private function onWindowResize(e:NativeWindowBoundsEvent):void
		{
			fitMCtoWindow();
		}
		/**
		 * ウィンドウリサイズ時にMCを合わせる
		 * 
		 * 起動時、最大化時、フルスクリーン時対応
		 */ 
		private function fitMCtoWindow():void
		{
			var size:Number = Math.min(width, height) - windowMargin;
			clockMC.width = clockMC.height = size;
			clockMC.x = Math.floor(width / 2);
			clockMC.y = Math.floor(height / 2);
		}
		
		/**
		 * マウス位置からスケールを求める
		 */ 
		private function getRadius():Number
		{
			var mx:Number = stage.mouseX - clockMC.x;
			var my:Number = stage.mouseY - clockMC.y;
				
			return Math.sqrt(mx*mx + my*my);
		}		
	}
}