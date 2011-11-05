package org.ahiufomasao.yasume.timeline
{
	import flash.display.Shape;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.ahiufomasao.utility.display.BitmapCanvas;
	import org.ahiufomasao.utility.display.GraphicsDrawer;
	
	/**
	 * <code>ChildTimeline</code> クラスは、アニメーションデータを管理します.
	 * <p>
	 * <code>ChildTimeline</code> クラスは <code>MainTimeline</code> クラスの <code>setChildTimeline</code> メソッドにより 
	 * <code>MainTimeline</code> オブジェクトへ登録して使用します。
	 * </p>
	 * <p>
	 * <code>addFrame</code> メソッドを呼び出すことでグラフィック番号を設定したフレームを登録します。
	 * <code>animate</code> メソッドを呼び出すことでフレームを進行させ、アニメーションデータを更新します。
	 * </p>
	 * <p>
	 * <code>MainTimeline</code> オブジェクトへ登録されていない、
	 * または <code>MainTimeline</code> オブジェクトへ登録されていてもアクティブになっていない場合、
	 * <code>ChildTimeline</code> クラスは無効状態となります。
	 * 無効状態である <code>ChildTimeline</code> クラスは、<code>gotoAndStop</code>、<code>gotoAndPlay</code>、<code>animate</code> メソッドや、
	 * <code>currentFrame</code>、<code>currentGraphicNo</code>、<code>currentFrameLabel</code>、
	 * <code>currentStageHitArea</code>、<code>currentPushHitArea</code>、<code>currentDamageHitArea</code>、<code>currentAttackHitArea</code> プロパティにアクセスすることはできません。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see MainTimeline#setChildTimeline()
	 * @see #addFrame()
	 * @see #animate()
	 * @see #gotoAndStop()
	 * @see #gotoAndPlay()
	 * @see #currentFrame
	 * @see #currentGraphicNo
	 * @see #currentFrameLabel
	 * @see #currentStageHitArea
	 * @see #currentPushHitArea
	 * @see #currentDamageHitArea
	 * @see #currentAttackHitArea
	 */
	public class ChildTimeline
	{
		private var _parent:MainTimeline;            // メインタイムライン
		
		private var _currentFrame:uint;              // 現在のフレーム番号
		
		private var _play:Boolean;                   // 再生するならtrue
		private var _repeat:Boolean;                 // リピート再生するならtrue
		
		private var _graphicsFrameName:String;       // 描画の際参照するフレーム名
		private var _frameGraphicNos:Vector.<uint>;  // フレームグラフィック番号リスト（インデックス0から登録）
		
		private var _frameLabels:Dictionary;         // フレームラベルリスト     [frameLabel: frameNo   ]
		private var _frameActions:Dictionary;        // フレームアクションリスト [frameNo   : frameAction]
		
		private var _stageHitAreas:Dictionary;       // ステージ当たり判定エリアリスト [frameNo   : stageHitArea ]
		private var _pushHitAreas:Dictionary;        // 押し当たり判定エリアリスト     [frameNo   : pushHitArea  ]
		private var _damageHitAreas:Dictionary;      // ダメージ当たり判定エリアリスト [frameNo   : damageHitArea]
		private var _attackHitAreas:Dictionary;      // 攻撃当たり判定エリアリスト     [frameNo   : attackHitArea]
		
		/**
		 * 親となる <code>MainTimeline</code> オブジェクトです.
		 * <p>
		 * <code>MainTimeline</code> オブジェクトへ登録されていない場合は <code>null</code> が設定されます。
		 * </p>
		 */
		public function get parent():MainTimeline { return _parent; }
		/**
		 * @private
		 * 親となる <code>MainTimeline</code> クラスを設定します.
		 * <p>
		 * <code>MainTimeline</code> クラスの <code>setChildTimeline</code> メソッドからしか呼ばれません。
		 * </p>
		 */
		internal function setParent(value:MainTimeline):void { _parent = value; }
		
		/**
		 * 登録されているフレーム数です.
		 */
		public function get length():uint { return _frameGraphicNos.length; }
		
		/**
		 * 現在有効なフレームの番号です.
		 * 
		 * @throws IllegalOperationError タイムラインが無効状態の時にアクセスした場合スローされます。
		 */
		public function get currentFrame():uint
		{
			if (_currentFrame == 0)
			{
				throw new IllegalOperationError("タイムラインが無効状態の場合アクセスできません。");
			}
			return _currentFrame;
		}
		
		/**
		 * 現在有効なフレームに設定されているグラフィック番号です.
		 * 
		 * @throws IllegalOperationError タイムラインが無効状態の時にアクセスした場合スローされます。
		 */
		public function get currentGraphicNo():uint
		{
			if (_currentFrame == 0)
			{
				throw new IllegalOperationError("タイムラインが無効状態の場合アクセスできません。");
			}
			return _frameGraphicNos[_currentFrame - 1];
		}
		
		/**
		 * <code>true</code> が設定されている場合、アニメーションがループします.
		 * <p>
		 * <code>ture</code> が設定されている状態で現在有効なフレームがタイムラインの末尾である場合に <code>animate</code> メソッドを呼び出すと
		 * 有効なフレームがタイムラインの先頭へ切り替わります。
		 * </p>
		 * @see #animate()
		 */
		public function get repeat():Boolean { return _repeat; }
		/**
		 * @private
		 */
		public function set repeat(value:Boolean):void { _repeat = value; }
		
		/**
		 * 現在有効なフレームに設定されているフレームラベルです.
		 * <p>
		 * フレームラベルが設定されていない場合、空の文字列が設定されます。
		 * </p>
		 * 
		 * @throws IllegalOperationError タイムラインが無効状態の時にアクセスした場合スローされます。
		 */
		public function get currentFrameLabel():String
		{
			if (_currentFrame == 0)
			{
				throw new IllegalOperationError("タイムラインが無効状態の場合アクセスできません。");
			}
			
			return getFrameLabel(_currentFrame);
		}
		
		/**
		 * グラフィックを描画する際に参照する <code>TimelineGraphics</code> オブジェクトのフレーム名です.
		 * <p>
		 * 未設定の場合、<code>ChildTimeline</code> オブジェクトが登録されている <code>MainTimeline</code> オブジェクトのフレーム名のグラフィックを参照します。
		 * </p>
		 * 
		 * @see TimelineGraphics
		 * @see MainTimeline#draw()
		 */
		public function get graphicsFrameName():String { return _graphicsFrameName; }
		/** @private */
		public function set graphicsFrameName(value:String):void { _graphicsFrameName = value; }
		
		/**
		 * 現在有効なフレームのステージ当たり判定エリアを取得します.
		 * <p>
		 * 登録されていなければ <code>null</code> です。
		 * </p>
		 * 
		 * @throws IllegalOperationError タイムラインが無効状態の時に呼び出した場合スローされます。
		 */
		public function get currentStageHitArea():StageHitArea
		{
			if (_currentFrame == 0)
			{
				throw new IllegalOperationError("タイムラインが無効状態の場合アクセスできません。");
			}
			return getStageHitArea(_currentFrame);
		}
		
		/**
		 * 現在有効なフレームの押し当たり判定エリアを取得します.
		 * <p>
		 * 登録されていなければ <code>null</code> です。
		 * </p>
		 * 
		 * @throws IllegalOperationError タイムラインが無効状態の時に呼び出した場合スローされます。
		 */
		public function get currentPushHitArea():PushHitArea
		{
			if (_currentFrame == 0)
			{
				throw new IllegalOperationError("タイムラインが無効状態の場合アクセスできません。");
			}
			return getPushHitArea(_currentFrame);
		}
		
		/**
		 * 現在有効なフレームのダメージ当たり判定エリアを取得します.
		 * <p>
		 * 登録されていなければ <code>null</code> です。
		 * </p>
		 * 
		 * @throws IllegalOperationError タイムラインが無効状態の時に呼び出した場合スローされます。
		 */
		public function get currentDamageHitArea():DamageHitArea
		{
			if (_currentFrame == 0)
			{
				throw new IllegalOperationError("タイムラインが無効状態の場合アクセスできません。");
			}
			return getDamageHitArea(_currentFrame);
		}
		
		/**
		 * 現在有効なフレームの攻撃当たり判定エリアを取得します.
		 * <p>
		 * 登録されていなければ <code>null</code> です。
		 * </p>
		 * 
		 * @throws IllegalOperationError タイムラインが無効状態の時に呼び出した場合スローされます。
		 */
		public function get currentAttackHitArea():AttackHitArea
		{
			if (_currentFrame == 0)
			{
				throw new IllegalOperationError("タイムラインが無効状態の場合アクセスできません。");
			}
			return getAttackHitArea(_currentFrame);
		}
		
		/**
		 * 新しい <code>ChildTimeline</code> クラスのインスタンスを生成します.
		 */
		public function ChildTimeline()
		{
			_parent            = null;
			_currentFrame      = 0;
			_play              = true;
			_repeat            = true;
			_graphicsFrameName = "";
			_frameGraphicNos   = new Vector.<uint>();
			_frameLabels       = new Dictionary();
			_frameActions      = new Dictionary();
			
			_stageHitAreas     = new Dictionary();
			_pushHitAreas      = new Dictionary();
			_damageHitAreas    = new Dictionary();
			_attackHitAreas    = new Dictionary();
			
			makeItToNonactive();
		}
		
		/**
		 * タイムラインに新しいフレームを追加します.
		 * 
		 * @param graphicNo フレームに設定するグラフィック番号です。
		 * 
		 * @return 追加されたフレームの番号です。
		 */
		public function addFrame(graphicNo:uint):uint
		{
			return _frameGraphicNos.push(graphicNo);
		}
		
		/**
		 * フレームに設定されたグラフィック番号を取得します.
		 * 
		 * @param frame グラフィック番号を取得するフレームの番号もしくはラベルです。
		 * 
		 * @return 設定したグラフィック番号です。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		public function setGraphicNo(frame:*, graphicNo:uint):uint
		{
			var frameNo:uint = _getFrameNo(frame);
			
			_frameGraphicNos[frameNo - 1] = graphicNo;
			
			return graphicNo;
		}
		
		/**
		 * フレームに設定されたグラフィック番号を取得します.
		 * 
		 * @param frame グラフィック番号を取得するフレームの番号もしくはラベルです。
		 * 
		 * @return フレームに設定されたグラフィック番号です。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		public function getGraphicNo(frame:*):uint
		{
			var frameNo:uint = _getFrameNo(frame);
			
			return _frameGraphicNos[frameNo - 1];
		}
		
		/**
		 * フレームラベルを設定します.
		 * <p>
		 * ラベルを指定して <code>gotoAndStop</code> メソッドまたは <code>gotoAndPlay</code> メソッドを呼び出すことで
		 * ラベルが設定されたフレームへジャンプすることができます。
		 * </p>
		 * 
		 * @param frame      ラベルを設定するフレームの番号です。
		 * @param frameLabel フレームに設定するラベルの文字列です。
		 * 
		 * @return 設定したラベルです。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合スローされます。
		 * 
		 * @see #gotoAndStop()
		 * @see #gotoAndPlay()
		 */
		public function setFrameLabel(frame:uint, frameLabel:String):String
		{
			if (!(1 <= frame && frame <= length))
			{
				throw new ArgumentError("指定されたフレーム番号は存在しません。[frame = " + frame + "]");
			}
			
			_frameLabels[frameLabel] = frame;
			
			return frameLabel;
		}
		
		/**
		 * フレームラベルを取得します.
		 * 
		 * @param frame ラベルを取得するフレームの番号です。
		 * 
		 * @return 取得したフレームラベルです。設定されていない場合空文字列 <code>""</code> が返ります。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合スローされます。
		 */
		public function getFrameLabel(frame:uint):String
		{
			if (!(1 <= frame && frame <= length))
			{
				throw new ArgumentError("指定されたフレーム番号は存在しません。[frame = " + frame + "]");
			}
			
			var dictionary:Dictionary = new Dictionary();
			var frameLabels:Dictionary = _frameLabels;
			for (var label:String in frameLabels)
			{
				dictionary[String(frameLabels[label])] = label;
			}
			if (dictionary[String(frame)] == undefined)
			{
				return "";
			}
			return String(dictionary[String(frame)]);
		}
		
		/**
		 * フレームアクションを設定します.
		 * <p>
		 * 設定したフレームがアクティブになる度、設定したメソッドが呼び出されます。
		 * </p>
		 * 
		 * @param frame       フレームアクションを設定する設フレームの番号もしくはラベルです。
		 * @param frameAction フレームに設定するフレームアクションのメソッドです。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		public function setFrameAction(frame:*, frameAction:Function):Function
		{
			var frameNo:uint = _getFrameNo(frame);
			
			_frameActions[frameNo] = frameAction;
			
			return frameAction;
		}
		
		/**
		 * @private
		 * 指定されたフレームの番号を返します.
		 * 
		 * @param frame フレームの番号もしくはラベルです。
		 * 
		 * @return フレーム番号です。
		 */
		private function _getFrameNo(frame:*):uint
		{
			var frameNo:uint = 0; // 設定するフレーム番号
			
			// フレーム番号指定の場合
			if (frame is uint)
			{
				if (!(1 <= uint(frame) && uint(frame) <= length))
				{
					throw new ArgumentError("指定されたフレーム番号は存在しません。[frame = " + uint(frame) + "]");
				}
				frameNo = frame;
			}
			// フレームラベル指定の場合
			else if (frame is String)
			{
				// フレーム名が存在しない場合
				if (_frameLabels[String(frame)] == undefined)
				{
					throw new ArgumentError("指定されたフレームラベルは存在しません。[frame = " + String(frame) + "]");
				}
				frameNo = _frameLabels[frame];
			}
			// 移動先フレームの指定が不正ならエラー
			else
			{
				throw new ArgumentError("フレームの指定が不正です。[frame = " + frame + "]");
			}
			
			return frameNo;
		}
		
		/**
		 * ステージ当たり判定エリアを設定します.
		 * 
		 * @param frame   当たり判定エリアを設定するフレームの番号もしくはラベルです。
		 * @param hitArea 設定する <code>StageHitArea</code> オブジェクトです。
		 * 
		 * @return 設定した <code>StageHitArea</code> オブジェクトです。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		public function setStageHitArea(frame:*, hitArea:StageHitArea):StageHitArea
		{
			var frameNo:uint = _getFrameNo(frame);
			
			_stageHitAreas[frameNo] = hitArea;
			
			return hitArea;
		}
		
		/**
		 * 押し当たり判定エリアを設定します.
		 * 
		 * @param frame   当たり判定エリアを設定するフレームの番号もしくはラベルです。
		 * @param hitArea 設定する <code>PushHitArea</code> オブジェクトです。
		 * 
		 * @return 設定した <code>PushHitArea</code> オブジェクトです。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		public function setPushHitArea(frame:*, hitArea:PushHitArea):PushHitArea
		{
			var frameNo:uint = _getFrameNo(frame);
			
			_pushHitAreas[frameNo] = hitArea;
			
			return hitArea;
		}
		
		/**
		 * ダメージ当たり判定エリアを設定します.
		 * 
		 * @param frame   当たり判定エリアを設定するフレームの番号もしくはラベルです。
		 * @param hitArea 設定する <code>DamageHitArea</code> オブジェクトです。
		 * 
		 * @return 設定した <code>DamageHitArea</code> オブジェクトです。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		public function setDamageHitArea(frame:*, hitArea:DamageHitArea):DamageHitArea
		{
			var frameNo:uint = _getFrameNo(frame);
			
			_damageHitAreas[frameNo] = hitArea;
			
			return hitArea;
		}
		
		/**
		 * 攻撃当たり判定エリアを設定します.
		 * 
		 * @param frame   当たり判定エリアを設定するフレームの番号もしくはラベルです。
		 * @param hitArea 設定する <code>AttackHitArea</code> オブジェクトです。
		 * 
		 * @return 設定した <code>AttackHitArea</code> オブジェクトです。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		public function setAttackHitArea(frame:*, hitArea:AttackHitArea):AttackHitArea
		{
			var frameNo:uint = _getFrameNo(frame);
			
			_attackHitAreas[frameNo] = hitArea;
			
			return hitArea;
		}
		
		/**
		 * ステージ当たり判定エリアを取得します.
		 * 
		 * @param frame ステージ当たり判定エリアを取得するフレームの番号もしくはラベルです。
		 * 
		 * @return ステージ当たり判定エリアです。設定されていない場合 <code>null</code> です。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		public function getStageHitArea(frame:*):StageHitArea
		{
			var frameNo:uint = _getFrameNo(frame);
			
			if (_stageHitAreas[frameNo] == undefined)
			{
				return null;
			}
			
			return StageHitArea(_stageHitAreas[frameNo]);
		}
		
		/**
		 * 押し当たり判定エリアを取得します.
		 * 
		 * @param frame 押し当たり判定エリアを取得するフレームの番号もしくはラベルです。
		 * 
		 * @return 押し当たり判定エリアです。設定されていない場合 <code>null</code> です。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		public function getPushHitArea(frame:*):PushHitArea
		{
			var frameNo:uint = _getFrameNo(frame);
			
			if (_pushHitAreas[frameNo] == undefined)
			{
				return null;
			}
			
			return PushHitArea(_pushHitAreas[frameNo]);
		}
		
		/**
		 * ダメージ当たり判定エリアを取得します.
		 * 
		 * @param frame ダメージ当たり判定エリアを取得するフレームの番号もしくはラベルです。
		 * 
		 * @return ダメージ当たり判定エリアです。設定されていない場合 <code>null</code> です。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		public function getDamageHitArea(frame:*):DamageHitArea
		{
			var frameNo:uint = _getFrameNo(frame);
			
			if (_damageHitAreas[frameNo] == undefined)
			{
				return null;
			}
			
			return DamageHitArea(_damageHitAreas[frameNo]);
		}
		
		/**
		 * 攻撃当たり判定エリアを取得します.
		 * 
		 * @param frame 攻撃当たり判定エリアを取得するフレームの番号もしくはラベルです。
		 * 
		 * @return 攻撃当たり判定エリアです。設定されていない場合 <code>null</code> です。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		public function getAttackHitArea(frame:*):AttackHitArea
		{
			var frameNo:uint = _getFrameNo(frame);
			
			if (_attackHitAreas[frameNo] == undefined)
			{
				return null;
			}
			
			return AttackHitArea(_attackHitAreas[frameNo]);
		}
		
		/**
		 * @private
		 * フレーム移動共通
		 * 
		 * @param frame      移動先フレーム
		 * @param waitActive フレームを有効状態にする場合はtrueを指定（通常使用しない）
		 * 
		 * @throws IllegalOperationError タイムラインが無効状態である場合にスローされます。
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		private function _gotoAndAction(frame:*, waitActive:Boolean = false):void
		{
			// このフレームが無効なら終了、フレームを有効状態にする作業ならエラーにならない
			if (_currentFrame == 0 && !waitActive)
			{
				throw new IllegalOperationError("タイムラインが無効状態である場合、フレーム移動はできません。");
			}
			
			var frameNo:uint = _getFrameNo(frame);
			
			// MainTimeline クラスへ登録されているかつ、フレーム移動がある場合
			if (_parent != null && frameNo != _currentFrame)
			{
				// フレームアクション実行
				if (_frameActions[frameNo] != undefined)
				{
					var frameAction:Function = _frameActions[frameNo];
					frameAction.call(this);
				}
			}
			
			_currentFrame = frameNo;
		}
		
		/**
		 * フレーム移動をしてからアニメーションの再生を停止します.
		 * 
		 * @param frame 移動先のフレーム番号もしくはラベルです。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		public function gotoAndStop(frame:*):void
		{
			_gotoAndAction(frame);
			stop();
		}
		
		/**
		 * フレーム移動をしてからアニメーションの再生できる状態にします.
		 * 
		 * @param frame 移動先のフレーム番号もしくはラベルです。
		 * 
		 * @throws ArgumentError 指定されたフレーム番号が存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたフレームラベルが存在しない場合にスローされます。
		 * @throws ArgumentError 移動先フレームを <code>uint</code>、<code>String</code> 型以外で指定した場合にスローされます。
		 */
		public function gotoAndPlay(frame:*):void
		{
			_gotoAndAction(frame);
			play();
		}
		
		/**
		 * フレームを進行させ、アニメーションデータを更新します.
		 * 
		 * @throws IllegalOperationError タイムラインが無効状態である場合にスローされます。
		 */
		public function animate():void
		{
			// タイムラインが無効状態なら終了
			if (_currentFrame == 0)
			{
				throw new IllegalOperationError("フレームは無効状態です。");
			}
			
			// 再生停止中なら終了
			if (!_play)
			{
				return;
			}
			
			var frameNo:uint = _currentFrame;
			
			frameNo++;
			
			// 最後のフレームを超えていない場合
			if (frameNo <= length)
			{
				_gotoAndAction(frameNo);
			}
			// 最後のフレームを超えた場合
			else
			{
				// リピート再生するなら
				if (_repeat)
				{
					_gotoAndAction(1);
				}
				else
				{
					_currentFrame = length; // 最後のフレームにする
				}
			}
		}
		
		/**
		 * アニメーションを再生できる状態にします.
		 */
		public function play():void
		{
			_play = true;
		}
		/**
		 * アニメーションの再生を停止します.
		 */
		public function stop():void
		{
			_play = false;
		}
		
		/**
		 * @private
		 * フレームを有効にします.
		 */
		internal function makeItToActive():void
		{
			_gotoAndAction(1, true);
		}
		
		/**
		 * @private
		 * フレームを無効にします.
		 */
		internal function makeItToNonactive():void
		{
			_currentFrame = 0;
		}
		
		/**
		 * 当たり判定エリアを描画します.
		 * 
		 * @param canvas       当たり判定エリアを描画するキャンバスです。
		 * @param drawingPoint 当たり判定エリアを描画する座標です。
		 * @param reverse      <code>true</code> を指定すると当たり判定エリアを反転描画します。
		 */
		public function drawHitArea(canvas:BitmapCanvas, drawingPoint:Point, reverse:Boolean = false):void
		{
			// 描画しない設定になっている場合
			if (!_parent.hitAreaDrawingSetting.drawing)
			{
				// 描画処理をしない
				return;
			}
			
			var i:uint                = 0;
			var lineColor:uint        = 0x000000;
			var drawer:GraphicsDrawer = new GraphicsDrawer();
			var shape:Shape           = new Shape();
			var point:Point           = new Point();
			
			var rect:Rectangle = null;
			
			// ステージ当たり判定エリア
			var stageHitArea:StageHitArea = getStageHitArea(_currentFrame);
			if (stageHitArea != null)
			{
				rect = stageHitArea.rectangle;
				lineColor = _parent.hitAreaDrawingSetting.stageHitAreaColor;
				drawer.reset(lineColor, 0, 1, true, false);
				shape.graphics.clear();
				drawer.drawRectangle(shape.graphics, 0, 0, rect.width, rect.height);
				// 反転描画設定
				point.x = reverse ? drawingPoint.x - rect.x - rect.width : drawingPoint.x + rect.x;
				point.y = drawingPoint.y + rect.y;
				canvas.draw(shape, point);
			}
			// 押し当たり判定エリア
			var pushHitArea:PushHitArea = getPushHitArea(_currentFrame);
			if (pushHitArea != null)
			{
				rect = pushHitArea.rectangle;
				lineColor = _parent.hitAreaDrawingSetting.pushHitAreaColor;
				drawer.reset(lineColor, 0, 1, true, false);
				shape.graphics.clear();
				drawer.drawRectangle(shape.graphics, 0, 0, rect.width, rect.height);
				// 反転描画設定
				point.x = reverse ? drawingPoint.x - rect.x - rect.width : drawingPoint.x + rect.x;
				point.y = drawingPoint.y + rect.y;
				canvas.draw(shape, point);
			}
			// ダメージ当たり判定エリア
			var damageHitArea:DamageHitArea = getDamageHitArea(_currentFrame);
			if (damageHitArea != null)
			{
				lineColor = _parent.hitAreaDrawingSetting.damageHitAreaColor;
				drawer.reset(lineColor, 0, 1, true, false);
				for each (rect in damageHitArea.rectangles)
				{
					shape.graphics.clear();
					drawer.drawRectangle(shape.graphics, 0, 0, rect.width, rect.height);
					// 反転描画設定
					point.x = reverse ? drawingPoint.x - rect.x - rect.width : drawingPoint.x + rect.x;
					point.y = drawingPoint.y + rect.y;
					canvas.draw(shape, point);
				}
			}
			// 攻撃当たり判定エリア
			var attackHitArea:AttackHitArea = getAttackHitArea(_currentFrame);
			if (attackHitArea != null)
			{
				lineColor = _parent.hitAreaDrawingSetting.attackHitAreaColor;
				drawer.reset(lineColor, 0, 1, true, false);
				for each (rect in attackHitArea.rectangles)
				{
					shape.graphics.clear();
					drawer.drawRectangle(shape.graphics, 0, 0, rect.width, rect.height);
					// 反転描画設定
					point.x = reverse ? drawingPoint.x - rect.x - rect.width : drawingPoint.x + rect.x;
					point.y = drawingPoint.y + rect.y;
					canvas.draw(shape, point);
				}
			}
		}
	}
}
