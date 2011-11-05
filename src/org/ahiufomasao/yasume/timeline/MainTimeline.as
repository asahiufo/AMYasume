package org.ahiufomasao.yasume.timeline 
{
	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import org.ahiufomasao.utility.display.BitmapCanvas;
	import org.ahiufomasao.utility.geom.Vector2D;
	import org.ahiufomasao.utility.MathUtility;
	
	/**
	 * <code>MainTimeline</code> クラスは、複数の <code>ChildTimeline</code> オブジェクトを管理します.
	 * <p>
	 * 子タイムラインとして <code>ChildTimeline</code> を名前を付けて登録します。
	 * <code>setChildTimeline</code> メソッドで <code>MainTimeline</code> オブジェクトを構成することもできますが、 
	 * <code>MainTimelineFactory</code> オブジェクトに<em>設定データ</em>を設定し、 
	 * <code>createMainTimeline</code> メソッドを呼び出すことで、<em>設定データ</em>に則った <code>MainTimeline</code> を生成することができます。
	 * </p>
	 * <p>
	 * <code>gotoFrame</code> メソッドを子タイムラインを登録したフレーム名を指定して呼び出すことで、
	 * 指定したフレーム名のフレームが有効になります。
	 * <code>animate</code> メソッドを呼び出すことで有効なフレームの子タイムラインを更新し、アニメーションを行います。
	 * </p>
	 * <p>
	 * <code>draw</code> メソッドを呼び出すことで、現在有効な子タイムラインのフレームで指定されたグラフィック番号を使って
	 * 指定された <code>TimelineGraphics</code> を参照し、指定された <code>BitmapCanvas</code> への描画を行います。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see ChildTimeline
	 * @see #setChildTimeline()
	 * @see MainTimelineFactory
	 * @see MainTimelineFactory#createMainTimeline()
	 * @see #gotoFrame()
	 * @see #animate()
	 * @see #draw()
	 * @see TimelineGraphics
	 * @see BitmapCanvas
	 */
	public class MainTimeline 
	{
		private var _hitAreaDrawingSetting:HitAreaDrawingSetting; // 当たり判定エリア描画設定
		
		private var _currentFrameName:String;   // 現在のフレームの名前
		private var _childTimelines:Dictionary; // 子タイムラインリスト
		
		private var _point:Point;       // 汎用ポイント
		private var _matrix:Matrix;     // 汎用マトリックス
		private var _vector2D:Vector2D; // 汎用スピード
		
		/**
		 * 当たり判定エリアの描画設定です.
		 */
		public function get hitAreaDrawingSetting():HitAreaDrawingSetting { return _hitAreaDrawingSetting; }
		
		/**
		 * 現在有効になっているフレームの名前です.
		 * 
		 * @throws IllegalOperationError 子タイムラインを 1 件も登録していない場合にスローされます。
		 */
		public function get currentFrameName():String
		{
			// 1件も子タイムラインが登録されていない場合エラー
			if (_currentFrameName == "")
			{
				throw new IllegalOperationError("子タイムラインが1件も登録されていません。");
			}
			return _currentFrameName;
		}
		
		/**
		 * 現在有効になっているフレームに登録されている <code>ChildTimeline</code> オブジェクトです.
		 * 
		 * @throws IllegalOperationError 子タイムラインを 1 件も登録していない場合にスローされます。
		 */
		public function get currentChildTimeline():ChildTimeline
		{
			// 1件も子タイムラインが登録されていない場合エラー
			if (_currentFrameName == "")
			{
				throw new IllegalOperationError("子タイムラインが1件も登録されていません。");
			}
			return ChildTimeline(_childTimelines[_currentFrameName]);
		}
		
		/**
		 * 新しい <code>MainTimeline</code> クラスのインスタンスを生成します.
		 */
		public function MainTimeline() 
		{
			_hitAreaDrawingSetting = new HitAreaDrawingSetting();
			
			_currentFrameName = "";
			_childTimelines   = new Dictionary();
			
			_point    = new Point();
			_matrix   = new Matrix();
			_vector2D = new Vector2D();
		}
		
		/**
		 * 子タイムラインを登録します.
		 * <p>
		 * すでに登録されているフレーム名を指定した場合、上書き登録します。
		 * </p>
		 * 
		 * @param frameName     子タイムラインを登録するフレーム名です。
		 * @param childTimeline 登録する子タイムラインのオブジェクトです。
		 * 
		 * @return 登録した子タイムラインです。
		 * 
		 * @throws IllegalOperationError すでに <code>MainTimeline</code> オブジェクトへ登録された <code>ChildTimeline</code> オブジェクトを登録しようとした場合にスローされます。
		 * @throws IllegalOperationError フレームを 1 件も登録していない <code>ChildTimeline</code> オブジェクトを登録しようとした場合にスローされます。
		 */
		public function setChildTimeline(frameName:String, childTimeline:ChildTimeline):ChildTimeline
		{
			if (childTimeline.parent != null)
			{
				throw new IllegalOperationError("登録済み ChildTimeline クラスを再び登録することはできません。");
			}
			
			if (childTimeline.length == 0)
			{
				throw new IllegalOperationError("フレームを1件も登録せずに MainTimeline クラスへ登録することはできません。");
			}
			
			if (_currentFrameName == "" || _currentFrameName == frameName)
			{
				_currentFrameName = frameName;
				childTimeline.makeItToActive();
			}
			else
			{
				childTimeline.makeItToNonactive();
			}
			
			childTimeline.setParent(this);
			_childTimelines[frameName] = childTimeline;
			
			return childTimeline;
		}
		
		/**
		 * 登録されている子タイムラインを取得します.
		 * 
		 * @param frameName 取得する子タイムライン名です。
		 * 
		 * @return 取得された子タイムラインです。
		 * 
		 * @throws ArgumentError 指定されたフレーム名が存在しない場合にスローされます。
		 */
		public function getChildTimeline(frameName:String):ChildTimeline
		{
			// 指定したフレーム名が存在しない場合エラー
			if (_childTimelines[frameName] == undefined)
			{
				throw new ArgumentError("指定されたフレーム名は存在しません。[frameName = " + frameName + "]");
			}
			
			return ChildTimeline(_childTimelines[frameName]);
		}
		
		/**
		 * 有効なフレームを切り替えます.
		 * 
		 * @param frameName 切り替え先のフレーム名です。
		 * 
		 * @throws ArgumentError 指定されたフレーム名が存在しない場合にスローされます。
		 */
		public function gotoFrame(frameName:String):void
		{
			// 指定したフレーム名が存在しない場合エラー
			if (_childTimelines[frameName] == undefined)
			{
				throw new ArgumentError("指定されたフレーム名は存在しません。[frameName = " + frameName + "]");
			}
			
			// 攻撃グループリセット
			var attackHitArea:AttackHitArea;
			var childTimeline:ChildTimeline = currentChildTimeline;
			var len:uint = childTimeline.length;
			for (var i:uint = 1; i <= len; i++)
			{
				attackHitArea = childTimeline.getAttackHitArea(i);
				if (attackHitArea == null)
				{
					continue;
				}
				if (attackHitArea.attackGroup != null)
				{
					attackHitArea.attackGroup.reset();
				}
			}
			
			currentChildTimeline.makeItToNonactive();
			
			_currentFrameName = frameName;
			
			currentChildTimeline.makeItToActive();
		}
		
		/**
		 * 有効なフレームに登録された子タイムラインをアニメーションさせます.
		 * 
		 * @throws IllegalOperationError 子タイムラインを 1 件も登録していない場合にスローされます。
		 */
		public function animate():void
		{
			// 1件も子タイムラインが登録されていない場合エラー
			if (_currentFrameName == "")
			{
				throw new IllegalOperationError("子タイムラインが1件も登録されていません。");
			}
			
			currentChildTimeline.animate();
		}
		
		// TODO: テスト方法確定後に実施
		/**
		 * フレームの描画を行います.
		 * <p>
		 * <code>frameName</code> パラメータで指定されたフレーム名のグラフィックを指定された <code>TimelineGraphics</code> より取得し、描画します。
		 * <code>frameName</code> パラメータが省略された場合は、
		 * 現在有効なフレームに設定されている <code>ChildTimeline</code> オブジェクトの <code>graphicsFrameName</code> プロパティを使用します。
		 * <code>graphicsFrameName</code> プロパティが設定されていない場合は <code>MainTimeline</code> オブジェクトの現在有効なフレームの名前のグラフィックを使用します。
		 * </p>
		 * 
		 * @param canvas           描画対象のキャンバスです。
		 * @param graphics         描画するグラフィックデータです。
		 * @param timelineDrawable 描画対象のオブジェクトです。
		 * @param frameName        描画するフレーム名です。
		 * 
		 * @see ChildTimeline#graphicsFrameName
		 */
		public function draw(
		    canvas:BitmapCanvas,
		    graphics:TimelineGraphics,
			timelineDrawable:ITimelineDrawable,
			frameName:String = ""
		):void
		{
			// グラフィック表示
			if (frameName == "")
			{
				if (currentChildTimeline.graphicsFrameName != "")
				{
					frameName = currentChildTimeline.graphicsFrameName;
				}
				else
				{
					frameName = _currentFrameName;
				}
			}
			
			var graphicNo:uint       = currentChildTimeline.currentGraphicNo;
			var bmpData:BitmapData   = graphics.getGraphic(frameName, graphicNo);
			var centerPosition:Point = graphics.getCenterPosition(frameName, graphicNo);
			var centerX:Number       = centerPosition.x;
			var centerY:Number       = centerPosition.y;
			var scaleX:Number        = timelineDrawable.drawingScaleX;
			var scaleY:Number        = timelineDrawable.drawingScaleY;
			var rotation:Number      = timelineDrawable.drawingRotation;
			var reversing:Boolean    = timelineDrawable.drawingReversing;
			_point.x                 = timelineDrawable.drawingPositionX;
			_point.y                 = timelineDrawable.drawingPositionY;
			
			// Matrixを使用しない
			if (scaleX == 1 && scaleY == 1 && !reversing && rotation == 0)
			{
				_point.x -= centerX;
				_point.y -= centerY;
				canvas.draw(bmpData, _point);
			}
			// 使用する
			else
			{
				_matrix.identity();
				
				// 中心点調整
				// 角度
				if (rotation != 0)
				{
					_vector2D.x = centerX;
					_vector2D.y = centerY;
					var angle:Number = timelineDrawable.drawingRotation + _vector2D.angle;
					var rad:Number   = MathUtility.calculateRadians(angle);
					var len:Number   = Math.sqrt(centerX * centerX + centerY * centerY);
					centerX = len * Math.cos(rad);
					centerY = len * Math.sin(rad);
				}
				// 反転
				if (reversing)
				{
					centerX   *= -1;
					_matrix.a  = -1;
				}
				// スケール
				if (scaleX != 1 || scaleY != 1)
				{
					centerX *= scaleX;
					centerY *= scaleY;
				}
				
				// Matrix設定
				// スケール
				if (scaleX != 1 || scaleY != 1)
				{
					_matrix.scale(scaleX, scaleY);
				}
				// 角度
				if (rotation != 0)
				{
					rad = MathUtility.calculateRadians(rotation);
					_matrix.rotate(rad);
				}
				// 反転
				if (reversing)
				{
					_matrix.a  = -1;
				}
				
				_point.x -= centerX;
				_point.y -= centerY;
				canvas.draw(bmpData, _point, _matrix);
			}
			
			// エリア表示
			// 表示しないなら終了
			if (!_hitAreaDrawingSetting.drawing)
			{
				return;
			}
			
			_point.x = timelineDrawable.drawingPositionX;
			_point.y = timelineDrawable.drawingPositionY;
			currentChildTimeline.drawHitArea(canvas, _point, reversing);
		}
	}
}
