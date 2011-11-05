package org.ahiufomasao.yasume.timeline 
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.ahiufomasao.utility.net.StringLoader;
	import org.ahiufomasao.utility.StringUtility;
	import org.ahiufomasao.utility.Validator;
	import org.ahiufomasao.yasume.effects.IEffectFactory;
	import org.ahiufomasao.yasume.media.ISoundEffectCollection;
	import org.ahiufomasao.yasume.utils.IValidator;
	
	/**
	 * <code>setSettingByXMLFile</code> メソッドを呼び出した後、データを受信したときに送出されます.
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 * 
	 * @see #setSettingByXMLFile()
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * <code>setSettingByXMLFile</code> メソッドを呼び出した後、ロードが完了した時に送出されます.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 * 
	 * @see #setSettingByXMLFile()
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	// TODO: frame.loop のテスト
	/**
	 * <code>MainTimelineFactory</code> クラスは、<em>設定データ</em>に基づいた <code>MainTimeline</code> オブジェクトを生成します.
	 * <p>
	 * <em>設定データ</em>を設定し、<code>createMainTimeline</code> メソッドを呼び出すことで、
	 * <em>設定データ</em>に基づいた <code>MainTimeline</code> オブジェクトを生成します。
	 * </p>
	 * <p>
	 * <em>設定データ</em>の設定は、<code>XML</code> オブジェクトや外部 XML ファイルを読み込むことにより行うことができます。
	 * <code>XML</code> オブジェクトからの設定は <code>setSetting</code> メソッドを、
	 * 外部 XML ファイルからの設定は <code>setSettingByXMLFile</code> メソッドを使用します。
	 * </p>
	 * @example 次のコードは<em>設定データ</em>の設定に使用する XML データの例です。
	 * <listing version="3.0">
	 * &lt;data&gt;
	 *     &lt;hitAreaDrawingSetting&gt;
	 *         &lt;drawing&gt;true&lt;/drawing&gt;
	 *         &lt;color&gt;
	 *             &lt;stageHitArea&gt;0x00AA00&lt;/stageHitArea&gt;
	 *             &lt;pushHitArea&gt;0xBBBB00&lt;/pushHitArea&gt;
	 *             &lt;damageHitArea&gt;0x0000CC&lt;/damageHitArea&gt;
	 *             &lt;attackHitArea&gt;0xDD0000&lt;/attackHitArea&gt;
	 *         &lt;/color&gt;
	 *     &lt;/hitAreaDrawingSetting&gt;
	 *     
	 *     &lt;attackGroup id="1"&gt;
	 *         &lt;revival&gt;true&lt;/revival&gt;
	 *     &lt;/attackGroup&gt;
	 *     &lt;attackGroup id="2"&gt;
	 *         &lt;revival&gt;false&lt;/revival&gt;
	 *     &lt;/attackGroup&gt;
	 *     &lt;attackGroup id="3"&gt;
	 *         &lt;revival&gt;false&lt;/revival&gt;
	 *     &lt;/attackGroup&gt;
	 *     
	 *     &lt;frame name="standby"&gt;
	 *         &lt;graphicsFrameName&gt;walk&lt;/graphicsFrameName&gt;
	 *         &lt;graphic&gt;1,2,3,4,5,6&lt;/graphic&gt;
	 *         &lt;loop&gt;true&lt;/loop&gt;
	 *         &lt;stageHitArea targetFrame="1,2"&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;1111&lt;/x&gt;
	 *                 &lt;y&gt;1112&lt;/y&gt;
	 *                 &lt;width&gt;1113&lt;/width&gt;
	 *                 &lt;height&gt;1114&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *         &lt;/stageHitArea&gt;
	 *         &lt;pushHitArea targetFrame="2,3,4"&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;1211&lt;/x&gt;
	 *                 &lt;y&gt;1212&lt;/y&gt;
	 *                 &lt;width&gt;1213&lt;/width&gt;
	 *                 &lt;height&gt;1214&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;hard&gt;false&lt;/hard&gt;
	 *             &lt;throughDown&gt;false&lt;/throughDown&gt;
	 *             &lt;rightHittable&gt;true&lt;/rightHittable&gt;
	 *             &lt;leftHittable&gt;false&lt;/leftHittable&gt;
	 *             &lt;topHittable&gt;true&lt;/topHittable&gt;
	 *             &lt;bottomHittable&gt;false&lt;/bottomHittable&gt;
	 *         &lt;/pushHitArea&gt;
	 *         &lt;damageHitArea targetFrame="2,4,6"&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;1311&lt;/x&gt;
	 *                 &lt;y&gt;1312&lt;/y&gt;
	 *                 &lt;width&gt;1313&lt;/width&gt;
	 *                 &lt;height&gt;1314&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;1321&lt;/x&gt;
	 *                 &lt;y&gt;1322&lt;/y&gt;
	 *                 &lt;width&gt;1323&lt;/width&gt;
	 *                 &lt;height&gt;1324&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;strongAttribute&gt;FIRE,WATER&lt;/strongAttribute&gt;
	 *             &lt;weakAttribute&gt;WOOD,GROUND,DARK&lt;/weakAttribute&gt;
	 *             &lt;damageSoundEffect&gt;METAL&lt;/damageSoundEffect&gt;
	 *         &lt;/damageHitArea&gt;
	 *         &lt;attackHitArea targetFrame="1,2,3,4,5"&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;1411&lt;/x&gt;
	 *                 &lt;y&gt;1412&lt;/y&gt;
	 *                 &lt;width&gt;1413&lt;/width&gt;
	 *                 &lt;height&gt;1414&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;1421&lt;/x&gt;
	 *                 &lt;y&gt;1422&lt;/y&gt;
	 *                 &lt;width&gt;1423&lt;/width&gt;
	 *                 &lt;height&gt;1424&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;1431&lt;/x&gt;
	 *                 &lt;y&gt;1432&lt;/y&gt;
	 *                 &lt;width&gt;1433&lt;/width&gt;
	 *                 &lt;height&gt;1434&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;target&gt;FRIEND,ENEMY,FRIEND_SIDE_OBJECT,ENEMY_SIDE_OBJECT,ANOTHER_SIDE_OBJECT&lt;/target&gt;
	 *             &lt;attackGroup&gt;1&lt;/attackGroup&gt;
	 *             &lt;power&gt;
	 *                 &lt;multiplication&gt;12&lt;/multiplication&gt;
	 *                 &lt;addition&gt;13&lt;/addition&gt;
	 *             &lt;/power&gt;
	 *             &lt;angle&gt;14&lt;/angle&gt;
	 *             &lt;damageKeepTime&gt;15&lt;/damageKeepTime&gt;
	 *             &lt;flySpeed&gt;
	 *                 &lt;x&gt;
	 *                     &lt;multiplication&gt;16&lt;/multiplication&gt;
	 *                     &lt;addition&gt;17&lt;/addition&gt;
	 *                 &lt;/x&gt;
	 *                 &lt;y&gt;
	 *                     &lt;multiplication&gt;18&lt;/multiplication&gt;
	 *                     &lt;addition&gt;19&lt;/addition&gt;
	 *                 &lt;/y&gt;
	 *             &lt;/flySpeed&gt;
	 *             &lt;defensible&gt;false&lt;/defensible&gt;
	 *             &lt;impact&gt;true&lt;/impact&gt;
	 *             &lt;counterbalance&gt;true&lt;/counterbalance&gt;
	 *             &lt;hitStopTime&gt;20&lt;/hitStopTime&gt;
	 *             &lt;attribute&gt;FIRE&lt;/attribute&gt;
	 *             &lt;effect&gt;BLOW&lt;/effect&gt;
	 *             &lt;soundEffect&gt;SPARK&lt;/soundEffect&gt;
	 *         &lt;/attackHitArea&gt;
	 *     &lt;/frame&gt;
	 *     
	 *     &lt;frame name="jump"&gt;
	 *         &lt;graphicsFrameName&gt;air&lt;/graphicsFrameName&gt;
	 *         &lt;graphic&gt;1,1,2,3,3,4,5,6,6,1&lt;/graphic&gt;
	 *         &lt;loop&gt;false&lt;/loop&gt;
	 *         &lt;stageHitArea targetFrame="2,3"&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;2111&lt;/x&gt;
	 *                 &lt;y&gt;2112&lt;/y&gt;
	 *                 &lt;width&gt;2113&lt;/width&gt;
	 *                 &lt;height&gt;2114&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *         &lt;/stageHitArea&gt;
	 *         &lt;stageHitArea targetFrame="5,7"&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;2211&lt;/x&gt;
	 *                 &lt;y&gt;2212&lt;/y&gt;
	 *                 &lt;width&gt;2213&lt;/width&gt;
	 *                 &lt;height&gt;2214&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *         &lt;/stageHitArea&gt;
	 *         &lt;pushHitArea targetFrame="6,8"&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;2311&lt;/x&gt;
	 *                 &lt;y&gt;2312&lt;/y&gt;
	 *                 &lt;width&gt;2313&lt;/width&gt;
	 *                 &lt;height&gt;2314&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;hard&gt;true&lt;/hard&gt;
	 *             &lt;throughDown&gt;true&lt;/throughDown&gt;
	 *             &lt;rightHittable&gt;true&lt;/rightHittable&gt;
	 *             &lt;leftHittable&gt;true&lt;/leftHittable&gt;
	 *             &lt;topHittable&gt;true&lt;/topHittable&gt;
	 *             &lt;bottomHittable&gt;true&lt;/bottomHittable&gt;
	 *         &lt;/pushHitArea&gt;
	 *         &lt;pushHitArea targetFrame="1"&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;2411&lt;/x&gt;
	 *                 &lt;y&gt;2412&lt;/y&gt;
	 *                 &lt;width&gt;2413&lt;/width&gt;
	 *                 &lt;height&gt;2414&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;hard&gt;false&lt;/hard&gt;
	 *             &lt;throughDown&gt;false&lt;/throughDown&gt;
	 *             &lt;rightHittable&gt;false&lt;/rightHittable&gt;
	 *             &lt;leftHittable&gt;false&lt;/leftHittable&gt;
	 *             &lt;topHittable&gt;false&lt;/topHittable&gt;
	 *             &lt;bottomHittable&gt;false&lt;/bottomHittable&gt;
	 *         &lt;/pushHitArea&gt;
	 *         &lt;damageHitArea targetFrame="2,6"&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;2511&lt;/x&gt;
	 *                 &lt;y&gt;2512&lt;/y&gt;
	 *                 &lt;width&gt;2513&lt;/width&gt;
	 *                 &lt;height&gt;2514&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;strongAttribute&gt;GROUND,DARK&lt;/strongAttribute&gt;
	 *             &lt;weakAttribute&gt;WOOD&lt;/weakAttribute&gt;
	 *             &lt;damageSoundEffect&gt;SPARK&lt;/damageSoundEffect&gt;
	 *         &lt;/damageHitArea&gt;
	 *         &lt;damageHitArea targetFrame="3,5,7"&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;2611&lt;/x&gt;
	 *                 &lt;y&gt;2612&lt;/y&gt;
	 *                 &lt;width&gt;2613&lt;/width&gt;
	 *                 &lt;height&gt;2614&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;2621&lt;/x&gt;
	 *                 &lt;y&gt;2622&lt;/y&gt;
	 *                 &lt;width&gt;2623&lt;/width&gt;
	 *                 &lt;height&gt;2624&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;strongAttribute&gt;WATER&lt;/strongAttribute&gt;
	 *             &lt;weakAttribute&gt;WOOD,DARK&lt;/weakAttribute&gt;
	 *             &lt;damageSoundEffect&gt;SPARK&lt;/damageSoundEffect&gt;
	 *         &lt;/damageHitArea&gt;
	 *         &lt;attackHitArea targetFrame="7,8"&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;2711&lt;/x&gt;
	 *                 &lt;y&gt;2712&lt;/y&gt;
	 *                 &lt;width&gt;2713&lt;/width&gt;
	 *                 &lt;height&gt;2714&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;target&gt;ENEMY,ENEMY_SIDE_OBJECT,ANOTHER_SIDE_OBJECT&lt;/target&gt;
	 *             &lt;attackGroup&gt;2&lt;/attackGroup&gt;
	 *             &lt;power&gt;
	 *                 &lt;multiplication&gt;112&lt;/multiplication&gt;
	 *                 &lt;addition&gt;113&lt;/addition&gt;
	 *             &lt;/power&gt;
	 *             &lt;angle&gt;114&lt;/angle&gt;
	 *             &lt;damageKeepTime&gt;115&lt;/damageKeepTime&gt;
	 *             &lt;flySpeed&gt;
	 *                 &lt;x&gt;
	 *                     &lt;multiplication&gt;116&lt;/multiplication&gt;
	 *                     &lt;addition&gt;117&lt;/addition&gt;
	 *                 &lt;/x&gt;
	 *                 &lt;y&gt;
	 *                     &lt;multiplication&gt;118&lt;/multiplication&gt;
	 *                     &lt;addition&gt;119&lt;/addition&gt;
	 *                 &lt;/y&gt;
	 *             &lt;/flySpeed&gt;
	 *             &lt;defensible&gt;true&lt;/defensible&gt;
	 *             &lt;impact&gt;true&lt;/impact&gt;
	 *             &lt;counterbalance&gt;true&lt;/counterbalance&gt;
	 *             &lt;hitStopTime&gt;120&lt;/hitStopTime&gt;
	 *             &lt;attribute&gt;WOOD&lt;/attribute&gt;
	 *             &lt;effect&gt;EXPLOSION&lt;/effect&gt;
	 *             &lt;soundEffect&gt;METAL&lt;/soundEffect&gt;
	 *         &lt;/attackHitArea&gt;
	 *         &lt;attackHitArea targetFrame="3,4"&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;2811&lt;/x&gt;
	 *                 &lt;y&gt;2812&lt;/y&gt;
	 *                 &lt;width&gt;2813&lt;/width&gt;
	 *                 &lt;height&gt;2814&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;2821&lt;/x&gt;
	 *                 &lt;y&gt;2822&lt;/y&gt;
	 *                 &lt;width&gt;2823&lt;/width&gt;
	 *                 &lt;height&gt;2824&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;target&gt;ANOTHER_SIDE_OBJECT&lt;/target&gt;
	 *             &lt;attackGroup&gt;2&lt;/attackGroup&gt;
	 *             &lt;power&gt;
	 *                 &lt;multiplication&gt;212&lt;/multiplication&gt;
	 *                 &lt;addition&gt;213&lt;/addition&gt;
	 *             &lt;/power&gt;
	 *             &lt;angle&gt;214&lt;/angle&gt;
	 *             &lt;damageKeepTime&gt;215&lt;/damageKeepTime&gt;
	 *             &lt;flySpeed&gt;
	 *                 &lt;x&gt;
	 *                     &lt;multiplication&gt;216&lt;/multiplication&gt;
	 *                     &lt;addition&gt;217&lt;/addition&gt;
	 *                 &lt;/x&gt;
	 *                 &lt;y&gt;
	 *                     &lt;multiplication&gt;218&lt;/multiplication&gt;
	 *                     &lt;addition&gt;219&lt;/addition&gt;
	 *                 &lt;/y&gt;
	 *             &lt;/flySpeed&gt;
	 *             &lt;defensible&gt;false&lt;/defensible&gt;
	 *             &lt;impact&gt;false&lt;/impact&gt;
	 *             &lt;counterbalance&gt;false&lt;/counterbalance&gt;
	 *             &lt;hitStopTime&gt;220&lt;/hitStopTime&gt;
	 *             &lt;attribute&gt;WATER&lt;/attribute&gt;
	 *             &lt;effect&gt;BLOW&lt;/effect&gt;
	 *             &lt;soundEffect&gt;SPARK&lt;/soundEffect&gt;
	 *         &lt;/attackHitArea&gt;
	 *         &lt;attackHitArea targetFrame="5"&gt;
	 *             &lt;rectangle&gt;
	 *                 &lt;x&gt;2811&lt;/x&gt;
	 *                 &lt;y&gt;2812&lt;/y&gt;
	 *                 &lt;width&gt;2813&lt;/width&gt;
	 *                 &lt;height&gt;2814&lt;/height&gt;
	 *             &lt;/rectangle&gt;
	 *             &lt;target&gt;FRIEND,FRIEND_SIDE_OBJECT&lt;/target&gt;
	 *             &lt;attackGroup&gt;3&lt;/attackGroup&gt;
	 *             &lt;power&gt;
	 *                 &lt;multiplication&gt;312&lt;/multiplication&gt;
	 *                 &lt;addition&gt;313&lt;/addition&gt;
	 *             &lt;/power&gt;
	 *             &lt;angle&gt;314&lt;/angle&gt;
	 *             &lt;damageKeepTime&gt;315&lt;/damageKeepTime&gt;
	 *             &lt;flySpeed&gt;
	 *                 &lt;x&gt;
	 *                     &lt;multiplication&gt;316&lt;/multiplication&gt;
	 *                     &lt;addition&gt;317&lt;/addition&gt;
	 *                 &lt;/x&gt;
	 *                 &lt;y&gt;
	 *                     &lt;multiplication&gt;318&lt;/multiplication&gt;
	 *                     &lt;addition&gt;319&lt;/addition&gt;
	 *                 &lt;/y&gt;
	 *             &lt;/flySpeed&gt;
	 *             &lt;defensible&gt;false&lt;/defensible&gt;
	 *             &lt;impact&gt;false&lt;/impact&gt;
	 *             &lt;counterbalance&gt;false&lt;/counterbalance&gt;
	 *             &lt;hitStopTime&gt;320&lt;/hitStopTime&gt;
	 *             &lt;attribute&gt;DARK&lt;/attribute&gt;
	 *             &lt;effect&gt;BLOW&lt;/effect&gt;
	 *             &lt;soundEffect&gt;METAL&lt;/soundEffect&gt;
	 *         &lt;/attackHitArea&gt;
	 *     &lt;/frame&gt;
	 * &lt;/data&gt;</listing>
	 * 
	 * @author asahiufo/AM902
	 * @see MainTimeline
	 * @see #createMainTimeline()
	 * @see #setSetting()
	 * @see #setSettingByXMLFile()
	 */
	public class MainTimelineFactory extends EventDispatcher
	{
		private var _settingXML:XML;             // 設定XML
		private var _settingLoader:StringLoader; // 設定ローダー
		
		/**
		 * <em>設定データ</em>ファイルのロードされたバイト数です.
		 * 
		 * @see #setSettingByXMLFile()
		 */
		public function get settingBytesLoaded():uint { return (_settingLoader == null ? 0 : _settingLoader.bytesLoaded); }
		/**
		 * <em>設定データ</em>ファイルのロードプロセスが成功した場合にロードされるバイトの総数です.
		 * <p>
		 * <code>setSettingByXMLFile</code> メソッドが実行されるまでは常に 0 です。
		 * </p>
		 * 
		 * @see #setSettingByXMLFile()
		 */
		public function get settingBytesTotal():uint { return (_settingLoader == null ? 0 : _settingLoader.bytesTotal); }
		/**
		 * <em>設定データ</em>ファイルのロードが完了したタイミングで <code>true</code> が設定されます.
		 * 
		 * @see #setSettingByXMLFile()
		 */
		public function get settingLoadComplete():Boolean { return (_settingLoader == null ? false : _settingLoader.complete); }
		
		/**
		 * 新しい <code>MainTimelineFactory</code> クラスのインスタンスを生成します.
		 */
		public function MainTimelineFactory() 
		{
			super();
			
			_settingXML    = null;
			_settingLoader = null;
		}
		
		/**
		 * <code>XML</code> オブジェクトにより<em>設定データ</em>の設定を行います.
		 * <p>
		 * 各バリデータオブジェクトを省略または <code>null</code> を指定した場合、<em>設定データ</em>の各項目の形式チェックは行われません。
		 * </p>
		 * 
		 * @param data                     設定するデータを定義した XML です。
		 * @param attackAttributeValidator 攻撃属性の形式チェックを行うバリデータオブジェクトです。
		 * @param effectValidator          効果の形式チェックを行うバリデータオブジェクトです。
		 * @param soundEffectValidator     効果音の形式チェックを行うバリデータオブジェクトです。
		 * 
		 * @throws ArgumentError <em>設定データ</em>の記述形式にエラーがある場合にスローされます。
		 */
		public function setSetting(
		    data:XML,
		    attackAttributeValidator:IValidator = null,
		    effectValidator:IValidator = null,
		    soundEffectValidator:IValidator = null
		):void
		{
			var errorMessage:String = "";
			
			// hitAreaDrawingSetting
			if (data.hitAreaDrawingSetting != undefined)
			{
				var hitAreaDrawingSettingXML:XML = XML(data.hitAreaDrawingSetting);
				// drawing
				if (hitAreaDrawingSettingXML.drawing == undefined)
				{
					errorMessage += "\"hitAreaDrawingSetting.drawing\" タグを設定してください。\n";
				}
				else if (!Validator.validateBoolean(String(hitAreaDrawingSettingXML.drawing)))
				{
					errorMessage += "\"hitAreaDrawingSetting.drawing\" タグには \"true\" または \"false\" を設定します。\n";
				}
				// color
				if (hitAreaDrawingSettingXML.color == undefined)
				{
					errorMessage += "\"hitAreaDrawingSetting.color\" タグを設定してください。\n";
				}
				else
				{
					var colorXML:XML = XML(hitAreaDrawingSettingXML.color);
					// stageHitArea
					if (colorXML.stageHitArea == undefined)
					{
						errorMessage += "\"hitAreaDrawingSetting.color.stageHitArea\" タグを設定してください。\n";
					}
					else if (!Validator.validateUint(String(colorXML.stageHitArea)))
					{
						errorMessage += "\"hitAreaDrawingSetting.color.stageHitArea\" タグには正の整数を設定します。\n";
					}
					// pushHitArea
					if (colorXML.pushHitArea == undefined)
					{
						errorMessage += "\"hitAreaDrawingSetting.color.pushHitArea\" タグを設定してください。\n";
					}
					else if (!Validator.validateUint(String(colorXML.pushHitArea)))
					{
						errorMessage += "\"hitAreaDrawingSetting.color.pushHitArea\" タグには正の整数を設定します。\n";
					}
					// damageHitArea
					if (colorXML.damageHitArea == undefined)
					{
						errorMessage += "\"hitAreaDrawingSetting.color.damageHitArea\" タグを設定してください。\n";
					}
					else if (!Validator.validateUint(String(colorXML.damageHitArea)))
					{
						errorMessage += "\"hitAreaDrawingSetting.color.damageHitArea\" タグには正の整数を設定します。\n";
					}
					// attackHitArea
					if (colorXML.attackHitArea == undefined)
					{
						errorMessage += "\"hitAreaDrawingSetting.color.attackHitArea\" タグを設定してください。\n";
					}
					else if (!Validator.validateUint(String(colorXML.attackHitArea)))
					{
						errorMessage += "\"hitAreaDrawingSetting.color.attackHitArea\" タグには正の整数を設定します。\n";
					}
				}
			}
			
			// attackGroup
			if (data.attackGroup != undefined)
			{
				for each (var attackGroupXML:XML in data.attackGroup)
				{
					// @id
					if (attackGroupXML.@id == undefined)
					{
						errorMessage += "\"attackGroup\" タグには \"@id\" 属性を設定します。\n";
					}
					else
					{
						var attackGroupIdlist:XML = XML(data.attackGroup.(@id == String(attackGroupXML.@id)));
						if (attackGroupIdlist.length() >= 2)
						{
							errorMessage += "複数の \"attackGroup\" タグにはそれぞれ異なる \"@id\" 属性を設定してください。\n";
						}
					}
					// revival
					if (attackGroupXML.revival == undefined)
					{
						errorMessage += "\"attackGroup.revival\" タグを設定してください。\n";
					}
					else if (!Validator.validateBoolean(String(attackGroupXML.revival)))
					{
						errorMessage += "\"attackGroup.revival\" タグには \"true\" または \"false\" を設定します。\n";
					}
				}
			}
			
			// frame
			if (data.frame == undefined)
			{
				errorMessage += "\"frame\" タグを 1 件以上設定してください。\n";
			}
			else
			{
				for each (var frameXML:XML in data.frame)
				{
					// @name
					if (frameXML.@name == undefined)
					{
						errorMessage += "\"frame\" タグには \"@name\" 属性を設定します。\n";
					}
					else
					{
						var frameNamelist:XML = XML(data.frame.(@name == String(frameXML.@name)));
						if (frameNamelist.length() >= 2)
						{
							errorMessage += "複数の \"frame\" タグにはそれぞれ異なる \"@name\" 属性を設定してください。\n";
						}
					}
					
					// graphicsFrameName
					if (frameXML.graphicsFrameName == undefined)
					{
						errorMessage += "\"frame.graphicsFrameName\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
					}
					// graphic
					if (frameXML.graphic == undefined)
					{
						errorMessage += "\"frame.graphic\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
					}
					else
					{
						var graphics:Vector.<String> = StringUtility.convertFromCSVToVector(String(frameXML.graphic))[0];
						for each (var graphicNo:String in graphics)
						{
							if (!Validator.validateUint(graphicNo))
							{
								errorMessage += "\"frame.graphic\" タグには正の整数で構成されたカンマ区切りのCSV形式の文字列を設定します。[@name=" + String(frameXML.@name) + "]\n";
								break;
							}
						}
					}
					// loop
					if (frameXML.loop == undefined)
					{
						errorMessage += "\"frame.loop\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
					}
					else
					{
						if (!Validator.validateBoolean(String(frameXML.loop)))
						{
							errorMessage += "\"frame.loop\" タグには \"true\" または \"false\" を設定します。[@name=" + String(frameXML.@name) + "]\n";
						}
					}
					
					// stageHitArea
					if (frameXML.stageHitArea != undefined)
					{
						for each (var stageHitAreaXML:XML in frameXML.stageHitArea)
						{
							// @targetFrame
							if (stageHitAreaXML.@targetFrame == undefined)
							{
								errorMessage += "\"frame.stageHitArea\" タグには \"@targetFrame\" 属性を設定します。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (stageHitAreaXML.@targetFrame != "all")
							{
								var stageHitAreaTargetFrames:Vector.<String> = StringUtility.convertFromCSVToVector(String(stageHitAreaXML.@targetFrame))[0];
								for each (var stageHitAreaTargetFrame:String in stageHitAreaTargetFrames)
								{
									if (!Validator.validateUint(stageHitAreaTargetFrame))
									{
										errorMessage += "\"frame.stageHitArea\" タグの \"@targetFrame\" 属性には \"all\" または正の整数で構成されたカンマ区切りのCSV形式の文字列を設定します。[@name=" + String(frameXML.@name) + "]\n";
										break;
									}
								}
							}
							
							// rectangle
							if (stageHitAreaXML.rectangle == undefined)
							{
								errorMessage += "\"frame.stageHitArea.rectangle\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else
							{
								// x
								if (stageHitAreaXML.rectangle.x == undefined)
								{
									errorMessage += "\"frame.stageHitArea.rectangle.x\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
								}
								else if (!Validator.validateNumber(String(stageHitAreaXML.rectangle.x)))
								{
									errorMessage += "\"frame.stageHitArea.rectangle.x\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
								}
								// y
								if (stageHitAreaXML.rectangle.y == undefined)
								{
									errorMessage += "\"frame.stageHitArea.rectangle.y\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
								}
								else if (!Validator.validateNumber(String(stageHitAreaXML.rectangle.y)))
								{
									errorMessage += "\"frame.stageHitArea.rectangle.y\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
								}
								// width
								if (stageHitAreaXML.rectangle.width == undefined)
								{
									errorMessage += "\"frame.stageHitArea.rectangle.width\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
								}
								else if (!Validator.validatePositiveNumber(String(stageHitAreaXML.rectangle.width)))
								{
									errorMessage += "\"frame.stageHitArea.rectangle.width\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
								}
								// height
								if (stageHitAreaXML.rectangle.height == undefined)
								{
									errorMessage += "\"frame.stageHitArea.rectangle.height\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
								}
								else if (!Validator.validatePositiveNumber(String(stageHitAreaXML.rectangle.height)))
								{
									errorMessage += "\"frame.stageHitArea.rectangle.height\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
								}
							}
						}
					}
					
					// pushHitArea
					if (frameXML.pushHitArea != undefined)
					{
						for each (var pushHitAreaXML:XML in frameXML.pushHitArea)
						{
							// @targetFrame
							if (pushHitAreaXML.@targetFrame == undefined)
							{
								errorMessage += "\"frame.pushHitArea\" タグには \"@targetFrame\" 属性を設定します。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (pushHitAreaXML.@targetFrame != "all")
							{
								var pushHitAreaTargetFrames:Vector.<String> = StringUtility.convertFromCSVToVector(String(pushHitAreaXML.@targetFrame))[0];
								for each (var pushHitAreaTargetFrame:String in pushHitAreaTargetFrames)
								{
									if (!Validator.validateUint(pushHitAreaTargetFrame))
									{
										errorMessage += "\"frame.pushHitArea\" タグの \"@targetFrame\" 属性には \"all\" または正の整数で構成されたカンマ区切りのCSV形式の文字列を設定します。[@name=" + String(frameXML.@name) + "]\n";
										break;
									}
								}
							}
							
							// rectangle
							if (pushHitAreaXML.rectangle == undefined)
							{
								errorMessage += "\"frame.pushHitArea.rectangle\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else
							{
								// x
								if (pushHitAreaXML.rectangle.x == undefined)
								{
									errorMessage += "\"frame.pushHitArea.rectangle.x\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
								}
								else if (!Validator.validateNumber(String(pushHitAreaXML.rectangle.x)))
								{
									errorMessage += "\"frame.pushHitArea.rectangle.x\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
								}
								// y
								if (pushHitAreaXML.rectangle.y == undefined)
								{
									errorMessage += "\"frame.pushHitArea.rectangle.y\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
								}
								else if (!Validator.validateNumber(String(pushHitAreaXML.rectangle.y)))
								{
									errorMessage += "\"frame.pushHitArea.rectangle.y\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
								}
								// width
								if (pushHitAreaXML.rectangle.width == undefined)
								{
									errorMessage += "\"frame.pushHitArea.rectangle.width\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
								}
								else if (!Validator.validatePositiveNumber(String(pushHitAreaXML.rectangle.width)))
								{
									errorMessage += "\"frame.pushHitArea.rectangle.width\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
								}
								// height
								if (pushHitAreaXML.rectangle.height == undefined)
								{
									errorMessage += "\"frame.pushHitArea.rectangle.height\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
								}
								else if (!Validator.validatePositiveNumber(String(pushHitAreaXML.rectangle.height)))
								{
									errorMessage += "\"frame.pushHitArea.rectangle.height\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
								}
							}
						}
					}
					
					// damageHitArea
					if (frameXML.damageHitArea != undefined)
					{
						for each (var damageHitAreaXML:XML in frameXML.damageHitArea)
						{
							// @targetFrame
							if (damageHitAreaXML.@targetFrame == undefined)
							{
								errorMessage += "\"frame.damageHitArea\" タグには \"@targetFrame\" 属性を設定します。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (damageHitAreaXML.@targetFrame != "all")
							{
								var damageHitAreaTargetFrames:Vector.<String> = StringUtility.convertFromCSVToVector(String(damageHitAreaXML.@targetFrame))[0];
								for each (var damageHitAreaTargetFrame:String in damageHitAreaTargetFrames)
								{
									if (!Validator.validateUint(damageHitAreaTargetFrame))
									{
										errorMessage += "\"frame.damageHitArea\" タグの \"@targetFrame\" 属性には \"all\" または正の整数で構成されたカンマ区切りのCSV形式の文字列を設定します。[@name=" + String(frameXML.@name) + "]\n";
										break;
									}
								}
							}
							
							// rectangle
							if (damageHitAreaXML.rectangle == undefined)
							{
								errorMessage += "\"frame.damageHitArea.rectangle\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else
							{
								for each (var damageHitAreaRectXML:XML in damageHitAreaXML.rectangle)
								{
									// x
									if (damageHitAreaRectXML.x == undefined)
									{
										errorMessage += "\"frame.damageHitArea.rectangle.x\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
									}
									else if (!Validator.validateNumber(String(damageHitAreaRectXML.x)))
									{
										errorMessage += "\"frame.damageHitArea.rectangle.x\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
									}
									// y
									if (damageHitAreaRectXML.y == undefined)
									{
										errorMessage += "\"frame.damageHitArea.rectangle.y\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
									}
									else if (!Validator.validateNumber(String(damageHitAreaRectXML.y)))
									{
										errorMessage += "\"frame.damageHitArea.rectangle.y\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
									}
									// width
									if (damageHitAreaRectXML.width == undefined)
									{
										errorMessage += "\"frame.damageHitArea.rectangle.width\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
									}
									else if (!Validator.validatePositiveNumber(String(damageHitAreaRectXML.width)))
									{
										errorMessage += "\"frame.damageHitArea.rectangle.width\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
									}
									// height
									if (damageHitAreaRectXML.height == undefined)
									{
										errorMessage += "\"frame.damageHitArea.rectangle.height\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
									}
									else if (!Validator.validatePositiveNumber(String(damageHitAreaRectXML.height)))
									{
										errorMessage += "\"frame.damageHitArea.rectangle.height\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
									}
								}
							}
							
							// strongAttribute
							if (damageHitAreaXML.strongAttribute == undefined)
							{
								errorMessage += "\"frame.damageHitArea.strongAttribute\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (attackAttributeValidator != null)
							{
								var strongAttributes:Vector.<String> = StringUtility.convertFromCSVToVector(String(damageHitAreaXML.strongAttribute))[0];
								for each (var strongAttribute:String in strongAttributes)
								{
									if (!attackAttributeValidator.validate(strongAttribute))
									{
										errorMessage += "\"frame.damageHitArea.strongAttribute\" タグには攻撃属性を表す文字列で構成されたカンマ区切りのCSV形式の文字列を設定します。[@name=" + String(frameXML.@name) + "]\n";
										break;
									}
								}
							}
							
							// weakAttribute
							if (damageHitAreaXML.weakAttribute == undefined)
							{
								errorMessage += "\"frame.damageHitArea.weakAttribute\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (attackAttributeValidator != null)
							{
								var weakAttributes:Vector.<String> = StringUtility.convertFromCSVToVector(String(damageHitAreaXML.weakAttribute))[0];
								for each (var weakAttribute:String in weakAttributes)
								{
									if (!attackAttributeValidator.validate(weakAttribute))
									{
										errorMessage += "\"frame.damageHitArea.weakAttribute\" タグには攻撃属性を表す文字列で構成されたカンマ区切りのCSV形式の文字列を設定します。[@name=" + String(frameXML.@name) + "]\n";
										break;
									}
								}
							}
							
							// damageSoundEffect
							if (damageHitAreaXML.damageSoundEffect == undefined)
							{
								errorMessage += "\"frame.damageHitArea.damageSoundEffect\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (soundEffectValidator != null)
							{
								if (!soundEffectValidator.validate(String(damageHitAreaXML.damageSoundEffect)))
								{
									errorMessage += "\"frame.damageHitArea.damageSoundEffect\" タグには効果音を表す文字列を設定します。[@name=" + String(frameXML.@name) + "]\n";
								}
							}
						}
					}
					
					// attackHitArea
					if (frameXML.attackHitArea != undefined)
					{
						for each (var attackHitAreaXML:XML in frameXML.attackHitArea)
						{
							// @targetFrame
							if (attackHitAreaXML.@targetFrame == undefined)
							{
								errorMessage += "\"frame.attackHitArea\" タグには \"@targetFrame\" 属性を設定します。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (attackHitAreaXML.@targetFrame != "all")
							{
								var attackHitAreaTargetFrames:Vector.<String> = StringUtility.convertFromCSVToVector(String(attackHitAreaXML.@targetFrame))[0];
								for each (var attackHitAreaTargetFrame:String in attackHitAreaTargetFrames)
								{
									if (!Validator.validateUint(attackHitAreaTargetFrame))
									{
										errorMessage += "\"frame.attackHitArea\" タグの \"@targetFrame\" 属性には \"all\" または正の整数で構成されたカンマ区切りのCSV形式の文字列を設定します。[@name=" + String(frameXML.@name) + "]\n";
										break;
									}
								}
							}
							
							// rectangle
							if (attackHitAreaXML.rectangle == undefined)
							{
								errorMessage += "\"frame.attackHitArea.rectangle\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else
							{
								for each (var attackHitAreaRectXML:XML in attackHitAreaXML.rectangle)
								{
									// x
									if (attackHitAreaRectXML.x == undefined)
									{
										errorMessage += "\"frame.attackHitArea.rectangle.x\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
									}
									else if (!Validator.validateNumber(String(attackHitAreaRectXML.x)))
									{
										errorMessage += "\"frame.attackHitArea.rectangle.x\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
									}
									// y
									if (attackHitAreaRectXML.y == undefined)
									{
										errorMessage += "\"frame.attackHitArea.rectangle.y\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
									}
									else if (!Validator.validateNumber(String(attackHitAreaRectXML.y)))
									{
										errorMessage += "\"frame.attackHitArea.rectangle.y\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
									}
									// width
									if (attackHitAreaRectXML.width == undefined)
									{
										errorMessage += "\"frame.attackHitArea.rectangle.width\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
									}
									else if (!Validator.validatePositiveNumber(String(attackHitAreaRectXML.width)))
									{
										errorMessage += "\"frame.attackHitArea.rectangle.width\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
									}
									// height
									if (attackHitAreaRectXML.height == undefined)
									{
										errorMessage += "\"frame.attackHitArea.rectangle.height\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
									}
									else if (!Validator.validatePositiveNumber(String(attackHitAreaRectXML.height)))
									{
										errorMessage += "\"frame.attackHitArea.rectangle.height\" タグには正の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
									}
								}
							}
							
							// target
							if (attackHitAreaXML.target == undefined)
							{
								errorMessage += "\"frame.attackHitArea.target\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (String(attackHitAreaXML.target) == "")
							{
								errorMessage += "\"frame.attackHitArea.target\" タグには 1要素以上の \"FRIEND\"、\"ENEMY\"、\"ANOTHER\"、\"FRIEND_SIDE_OBJECT\"、\"ENEMY_SIDE_OBJECT\"、\"ANOTHER_SIDE_OBJECT\" で構成されたカンマ区切りのCSV形式の文字列を設定します。[@name=" + String(frameXML.@name) + "]\n";
							}
							else
							{
								var attackTargets:Vector.<String> = StringUtility.convertFromCSVToVector(String(attackHitAreaXML.target))[0];
								for each (var attackTarget:String in attackTargets)
								{
									if (!AttackTarget.validate(attackTarget))
									{
										errorMessage += "\"frame.attackHitArea.target\" タグには \"FRIEND\"、\"ENEMY\"、\"ANOTHER\"、\"FRIEND_SIDE_OBJECT\"、\"ENEMY_SIDE_OBJECT\"、\"ANOTHER_SIDE_OBJECT\" で構成されたカンマ区切りのCSV形式の文字列を設定します。[@name=" + String(frameXML.@name) + "]\n";
										break;
									}
								}
							}
							
							// power
							if (attackHitAreaXML.power == undefined)
							{
								errorMessage += "\"frame.attackHitArea.power\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else
							{
								// multiplication
								if (attackHitAreaXML.power.multiplication == undefined)
								{
									errorMessage += "\"frame.attackHitArea.power.multiplication\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
								}
								else if (!Validator.validateNumber(String(attackHitAreaXML.power.multiplication)))
								{
									errorMessage += "\"frame.attackHitArea.power.multiplication\" タグには数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
								}
								// addition
								if (attackHitAreaXML.power.addition == undefined)
								{
									errorMessage += "\"frame.attackHitArea.power.addition\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
								}
								else if (!Validator.validateNumber(String(attackHitAreaXML.power.addition)))
								{
									errorMessage += "\"frame.attackHitArea.power.addition\" タグには数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
								}
							}
							
							// angle
							if (attackHitAreaXML.angle == undefined)
							{
								errorMessage += "\"frame.attackHitArea.angle\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (!Validator.validateNumber(String(attackHitAreaXML.angle)))
							{
								errorMessage += "\"frame.attackHitArea.angle\" タグには0以上360未満の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (!(0 <= Number(attackHitAreaXML.angle) && Number(attackHitAreaXML.angle) < 360))
							{
								errorMessage += "\"frame.attackHitArea.angle\" タグには0以上360未満の数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
							}
							
							// damageKeepTime
							if (attackHitAreaXML.damageKeepTime == undefined)
							{
								errorMessage += "\"frame.attackHitArea.damageKeepTime\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (!Validator.validateUint(String(attackHitAreaXML.damageKeepTime)))
							{
								errorMessage += "\"frame.attackHitArea.damageKeepTime\" タグには数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
							}
							
							// flySpeed
							if (attackHitAreaXML.flySpeed == undefined)
							{
								errorMessage += "\"frame.attackHitArea.flySpeed\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else
							{
								// x
								if (attackHitAreaXML.flySpeed.x == undefined)
								{
									errorMessage += "\"frame.attackHitArea.flySpeed.x\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
								}
								else
								{
									// multiplication
									if (attackHitAreaXML.flySpeed.x.multiplication == undefined)
									{
										errorMessage += "\"frame.attackHitArea.flySpeed.x.multiplication\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
									}
									else if (!Validator.validateNumber(String(attackHitAreaXML.flySpeed.x.multiplication)))
									{
										errorMessage += "\"frame.attackHitArea.flySpeed.x.multiplication\" タグには数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
									}
									// addition
									if (attackHitAreaXML.flySpeed.x.addition == undefined)
									{
										errorMessage += "\"frame.attackHitArea.flySpeed.x.addition\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
									}
									else if (!Validator.validateNumber(String(attackHitAreaXML.flySpeed.x.addition)))
									{
										errorMessage += "\"frame.attackHitArea.flySpeed.x.addition\" タグには数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
									}
								}
								// y
								if (attackHitAreaXML.flySpeed.y == undefined)
								{
									errorMessage += "\"frame.attackHitArea.flySpeed.y\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
								}
								else
								{
									// multiplication
									if (attackHitAreaXML.flySpeed.y.multiplication == undefined)
									{
										errorMessage += "\"frame.attackHitArea.flySpeed.y.multiplication\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
									}
									else if (!Validator.validateNumber(String(attackHitAreaXML.flySpeed.y.multiplication)))
									{
										errorMessage += "\"frame.attackHitArea.flySpeed.y.multiplication\" タグには数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
									}
									// addition
									if (attackHitAreaXML.flySpeed.y.addition == undefined)
									{
										errorMessage += "\"frame.attackHitArea.flySpeed.y.addition\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
									}
									else if (!Validator.validateNumber(String(attackHitAreaXML.flySpeed.y.addition)))
									{
										errorMessage += "\"frame.attackHitArea.flySpeed.y.addition\" タグには数値を設定します。[@name=" + String(frameXML.@name) + "]\n";
									}
								}
							}
							
							// defensible
							if (attackHitAreaXML.defensible == undefined)
							{
								errorMessage += "\"frame.attackHitArea.defensible\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (!Validator.validateBoolean(String(attackHitAreaXML.defensible)))
							{
								errorMessage += "\"frame.attackHitArea.defensible\" タグには \"true\" または \"false\" を設定します。[@name=" + String(frameXML.@name) + "]\n";
							}
							
							// impact
							if (attackHitAreaXML.impact == undefined)
							{
								errorMessage += "\"frame.attackHitArea.impact\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (!Validator.validateBoolean(String(attackHitAreaXML.impact)))
							{
								errorMessage += "\"frame.attackHitArea.impact\" タグには \"true\" または \"false\" を設定します。[@name=" + String(frameXML.@name) + "]\n";
							}
							
							// counterbalance
							if (attackHitAreaXML.counterbalance == undefined)
							{
								errorMessage += "\"frame.attackHitArea.counterbalance\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (!Validator.validateBoolean(String(attackHitAreaXML.counterbalance)))
							{
								errorMessage += "\"frame.attackHitArea.counterbalance\" タグには \"true\" または \"false\" を設定します。[@name=" + String(frameXML.@name) + "]\n";
							}
							
							// hitStopTime
							if (attackHitAreaXML.hitStopTime == undefined)
							{
								errorMessage += "\"frame.attackHitArea.hitStopTime\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (!Validator.validateUint(String(attackHitAreaXML.hitStopTime)))
							{
								errorMessage += "\"frame.attackHitArea.hitStopTime\" タグには正の整数を設定します。[@name=" + String(frameXML.@name) + "]\n";
							}
							
							// attribute
							if (attackHitAreaXML.attribute == undefined)
							{
								errorMessage += "\"frame.attackHitArea.attribute\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (attackAttributeValidator != null)
							{
								if (!attackAttributeValidator.validate(String(attackHitAreaXML.attribute)))
								{
									errorMessage += "\"frame.attackHitArea.attribute\" タグには攻撃属性を表す文字列を設定します。[@name=" + String(frameXML.@name) + "]\n";
									break;
								}
							}
							
							// effect
							if (attackHitAreaXML.effect == undefined)
							{
								errorMessage += "\"attackHitAreaXML.effect\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (effectValidator != null)
							{
								if (!effectValidator.validate(String(attackHitAreaXML.effect)))
								{
									errorMessage += "\"frame.attackHitArea.effect\" タグには攻撃効果を表す文字列を設定します。[@name=" + String(frameXML.@name) + "]\n";
									break;
								}
							}
							
							// soundEffect
							if (attackHitAreaXML.soundEffect == undefined)
							{
								errorMessage += "\"attackHitAreaXML.soundEffect\" タグを設定してください。[@name=" + String(frameXML.@name) + "]\n";
							}
							else if (soundEffectValidator != null)
							{
								if (!soundEffectValidator.validate(String(attackHitAreaXML.soundEffect)))
								{
									errorMessage += "\"frame.attackHitArea.soundEffect\" タグには効果音を表す文字列を設定します。[@name=" + String(frameXML.@name) + "]\n";
									break;
								}
							}
						}
					}
				}
			}
			
			// 書式エラーがある場合
			if (errorMessage.length != 0)
			{
				throw new ArgumentError(errorMessage);
			}
			
			_settingXML = data;
		}
		
		/**
		 * XML ファイルを読み込み、読み込んだデータから<em>設定データ</em>の設定を行います.
		 * <p>
		 * <code>setSettingByXMLFile</code> を呼び出した後、ファイルのロード状況は 
		 * <code>settingBytesLoaded</code>、
		 * <code>settingBytesTotal</code>、
		 * <code>settingLoadComplete</code> プロパティにより取得できます。
		 * </p>
		 * 
		 * @param URL <em>設定データ</em>を定義した XML ファイルの URL です。
		 * 
		 * @throws IllegalOperationError ファイル読み込み中に重複して setSettingByXMLFile メソッドを呼び出した場合にスローされます。
		 * 
		 * @see #settingBytesLoaded
		 * @see #settingBytesTotal
		 * @see #settingLoadComplete
		 */
		public function setSettingByXMLFile(URL:String):void
		{
			if (_settingLoader != null)
			{
				if (!_settingLoader.complete)
				{
					throw new IllegalOperationError("ファイル読み込み中に重複して setSettingByXMLFile メソッドを呼び出すことはできません。");
				}
			}
			_settingLoader = new StringLoader(URL);
			_settingLoader.addEventListener(ProgressEvent.PROGRESS, _onProgress);
			_settingLoader.addEventListener(Event.COMPLETE, _onSettingLoadComplete);
			_settingLoader.load();
		}
		
		/**
		 * @private
		 * プログレスイベントハンドラ
		 * 
		 * @param event イベント
		 */
		private function _onProgress(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		/**
		 * @private
		 * XML ファイル読み込み完了イベントハンドラ
		 * 
		 * @param event イベント
		 */
		private function _onSettingLoadComplete(event:Event):void
		{
			var data:XML = new XML(String(_settingLoader.data));
			setSetting(data);
			
			dispatchEvent(event);
			_settingLoader.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
			_settingLoader.removeEventListener(Event.COMPLETE, _onSettingLoadComplete);
		}
		
		/**
		 * <em>設定データ</em>から <code>MainTimeline</code> オブジェクトを生成します.
		 * 
		 * @param attackAttribute       攻撃属性オブジェクトです。<em>設定データ</em>に攻撃属性を指定している場合、省略できません。
		 * @param effectFactory         効果生成オブジェクトです。<em>設定データ</em>に効果を指定している場合、省略できません。
		 * @param soundEffectCollection 効果音です。<em>設定データ</em>に効果音を指定している場合、省略できません。
		 * 
		 * @return 生成された <code>MainTimeline</code> オブジェクトです。
		 * 
		 * @throws ArgumentError <em>設定データ</em>に攻撃属性を指定している時に <code>attackAttribute</code> パラメータが指定されていない場合にスローされます。
		 * @throws ArgumentError <em>設定データ</em>に効果を指定している時に <code>effectFactory</code> パラメータが指定されていない場合にスローされます。
		 * @throws ArgumentError <em>設定データ</em>に効果音を指定している時に <code>soundEffectCollection</code> パラメータが指定されていない場合にスローされます。
		 * @throws ArgumentError "frame.attackHitArea.attackGroup" タグに指定された ID が定義されていない攻撃グループを指している場合にスローされます。
		 */
		public function createMainTimeline(attackAttribute:IAttackAttribute = null, effectFactory:IEffectFactory = null, soundEffectCollection:ISoundEffectCollection = null):MainTimeline
		{
			if (_settingXML == null)
			{
				throw new IllegalOperationError("設定データを設定してから実行してください。");
			}
			
			var mainTimeline:MainTimeline = new MainTimeline();
			
			var data:XML = _settingXML;
			
			// hitAreaDrawingSetting
			if (data.hitAreaDrawingSetting != undefined)
			{
				var hitAreaDrawingSetting:HitAreaDrawingSetting = mainTimeline.hitAreaDrawingSetting;
				
				var hitAreaDrawingSettingXML:XML = XML(data.hitAreaDrawingSetting);
				hitAreaDrawingSetting.drawing = StringUtility.convertStringToBoolean(String(hitAreaDrawingSettingXML.drawing));
				
				var colorXML:XML = XML(hitAreaDrawingSettingXML.color);
				hitAreaDrawingSetting.stageHitAreaColor  = uint(colorXML.stageHitArea);
				hitAreaDrawingSetting.pushHitAreaColor   = uint(colorXML.pushHitArea);
				hitAreaDrawingSetting.damageHitAreaColor = uint(colorXML.damageHitArea);
				hitAreaDrawingSetting.attackHitAreaColor = uint(colorXML.attackHitArea);
			}
			
			var attackGroups:Dictionary = new Dictionary();
			
			// attackGroup
			if (data.attackGroup != undefined)
			{
				for each (var attackGroupXML:XML in data.attackGroup)
				{
					var attackGroup:AttackGroup = new AttackGroup(StringUtility.convertStringToBoolean(String(attackGroupXML.revival)));
					attackGroups[String(attackGroupXML.@id)] = attackGroup;
				}
			}
			
			// frame
			for each (var frameXML:XML in data.frame)
			{
				var childTimeline:ChildTimeline = new ChildTimeline();
				childTimeline.graphicsFrameName = String(frameXML.graphicsFrameName);
				
				var graphics:Vector.<String> = StringUtility.convertFromCSVToVector(String(frameXML.graphic))[0];
				for each (var graphicNo:String in graphics)
				{
					childTimeline.addFrame(uint(graphicNo));
				}
				
				childTimeline.repeat = StringUtility.convertStringToBoolean(String(frameXML.loop));
				
				// stageHitArea
				if (frameXML.stageHitArea != undefined)
				{
					for each (var stageHitAreaXML:XML in frameXML.stageHitArea)
					{
						// @targetFrame
						var stageHitAreaTargetFrames:Vector.<String> = null;
						if (String(stageHitAreaXML.@targetFrame) == "all")
						{
							stageHitAreaTargetFrames = new Vector.<String>();
							var stageHitAreaLen:uint = childTimeline.length;
							for (var stageHitAreaI:uint = 1; stageHitAreaI <= stageHitAreaLen; stageHitAreaI++)
							{
								stageHitAreaTargetFrames.push(String(stageHitAreaI));
							}
						}
						else
						{
							stageHitAreaTargetFrames = StringUtility.convertFromCSVToVector(String(stageHitAreaXML.@targetFrame))[0];
						}
						for each (var stageHitAreaTargetFrame:String in stageHitAreaTargetFrames)
						{
							// rectangle
							var stageHitArea:StageHitArea = new StageHitArea();
							stageHitArea.rectangle.x      = Number(stageHitAreaXML.rectangle.x);
							stageHitArea.rectangle.y      = Number(stageHitAreaXML.rectangle.y);
							stageHitArea.rectangle.width  = Number(stageHitAreaXML.rectangle.width);
							stageHitArea.rectangle.height = Number(stageHitAreaXML.rectangle.height);
							
							childTimeline.setStageHitArea(uint(stageHitAreaTargetFrame), stageHitArea);
						}
					}
				}
				
				// pushHitArea
				if (frameXML.pushHitArea != undefined)
				{
					for each (var pushHitAreaXML:XML in frameXML.pushHitArea)
					{
						// @targetFrame
						var pushHitAreaTargetFrames:Vector.<String> = null;
						if (String(pushHitAreaXML.@targetFrame) == "all")
						{
							pushHitAreaTargetFrames = new Vector.<String>();
							var pushHitAreaLen:uint = childTimeline.length;
							for (var pushHitAreaI:uint = 1; pushHitAreaI <= pushHitAreaLen; pushHitAreaI++)
							{
								pushHitAreaTargetFrames.push(String(pushHitAreaI));
							}
						}
						else
						{
							pushHitAreaTargetFrames = StringUtility.convertFromCSVToVector(String(pushHitAreaXML.@targetFrame))[0];
						}
						for each (var pushHitAreaTargetFrame:String in pushHitAreaTargetFrames)
						{
							// rectangle
							var pushHitArea:PushHitArea = new PushHitArea();
							pushHitArea.rectangle.x      = Number(pushHitAreaXML.rectangle.x);
							pushHitArea.rectangle.y      = Number(pushHitAreaXML.rectangle.y);
							pushHitArea.rectangle.width  = Number(pushHitAreaXML.rectangle.width);
							pushHitArea.rectangle.height = Number(pushHitAreaXML.rectangle.height);
							
							childTimeline.setPushHitArea(uint(pushHitAreaTargetFrame), pushHitArea);
						}
					}
				}
				
				// damageHitArea
				if (frameXML.damageHitArea != undefined)
				{
					for each (var damageHitAreaXML:XML in frameXML.damageHitArea)
					{
						// @targetFrame
						var damageHitAreaTargetFrames:Vector.<String> = null;
						if (String(damageHitAreaXML.@targetFrame) == "all")
						{
							damageHitAreaTargetFrames = new Vector.<String>();
							var damageHitAreaLen:uint = childTimeline.length;
							for (var damageHitAreaI:uint = 1; damageHitAreaI <= damageHitAreaLen; damageHitAreaI++)
							{
								damageHitAreaTargetFrames.push(String(damageHitAreaI));
							}
						}
						else
						{
							damageHitAreaTargetFrames = StringUtility.convertFromCSVToVector(String(damageHitAreaXML.@targetFrame))[0];
						}
						for each (var damageHitAreaTargetFrame:String in damageHitAreaTargetFrames)
						{
							var damageHitArea:DamageHitArea = new DamageHitArea();
							
							// rectangle
							for each (var damageHitAreaRectXML:XML in damageHitAreaXML.rectangle)
							{
								damageHitArea.rectangles.push(new Rectangle(
								    Number(damageHitAreaRectXML.x),
								    Number(damageHitAreaRectXML.y),
								    Number(damageHitAreaRectXML.width),
								    Number(damageHitAreaRectXML.height)
								));
							}
							// strongAttribute
							var strongAttributesCSVData:Vector.<Vector.<String>> = StringUtility.convertFromCSVToVector(String(damageHitAreaXML.strongAttribute));
							if (strongAttributesCSVData.length != 0)
							{
								var strongAttributes:Vector.<String> = strongAttributesCSVData[0];
								if (strongAttributes.length != 0)
								{
									if (attackAttribute == null)
									{
										throw new ArgumentError("\"frame.damageHitArea.strongAttribute\" タグに値を設定している場合、createMainTimeline メソッドは attackAttribute パラメータを指定して実行する必要があります。[@name=" + String(frameXML.@name) + "]");
									}
									for each (var strongAttributeKey:String in strongAttributes)
									{
										damageHitArea.strongAttributes.push(attackAttribute.getAttribute(strongAttributeKey));
									}
								}
							}
							// weakAttribute
							var weakAttributesCSVData:Vector.<Vector.<String>> = StringUtility.convertFromCSVToVector(String(damageHitAreaXML.weakAttribute));
							if (weakAttributesCSVData.length != 0)
							{
								var weakAttributes:Vector.<String> = weakAttributesCSVData[0];
								if (weakAttributes.length != 0)
								{
									if (attackAttribute == null)
									{
										throw new ArgumentError("\"frame.damageHitArea.weakAttribute\" タグに値を設定している場合、createMainTimeline メソッドは attackAttribute パラメータを指定して実行する必要があります。[@name=" + String(frameXML.@name) + "]");
									}
									for each (var weakAttributeKey:String in weakAttributes)
									{
										damageHitArea.weakAttributes.push(attackAttribute.getAttribute(weakAttributeKey));
									}
								}
							}
							// damageSoundEffect
							if (String(damageHitAreaXML.damageSoundEffect) != "")
							{
								if (soundEffectCollection == null)
								{
									throw new ArgumentError("\"frame.damageHitArea.damageSoundEffect\" タグに値を設定している場合、createMainTimeline メソッドは damageSoundEffectCollection パラメータを指定して実行する必要があります。[@name=" + String(frameXML.@name) + "]");
								}
								damageHitArea.damageSoundEffect = soundEffectCollection.getSoundEffect(String(damageHitAreaXML.damageSoundEffect));
							}
							
							childTimeline.setDamageHitArea(uint(damageHitAreaTargetFrame), damageHitArea);
						}
					}
				}
				
				// attackHitArea
				if (frameXML.attackHitArea != undefined)
				{
					for each (var attackHitAreaXML:XML in frameXML.attackHitArea)
					{
						// @targetFrame
						var attackHitAreaTargetFrames:Vector.<String> = null;
						if (String(attackHitAreaXML.@targetFrame) == "all")
						{
							attackHitAreaTargetFrames = new Vector.<String>();
							var attackHitAreaLen:uint = childTimeline.length;
							for (var attackHitAreaI:uint = 1; attackHitAreaI <= attackHitAreaLen; attackHitAreaI++)
							{
								attackHitAreaTargetFrames.push(String(attackHitAreaI));
							}
						}
						else
						{
							attackHitAreaTargetFrames = StringUtility.convertFromCSVToVector(String(attackHitAreaXML.@targetFrame))[0];
						}
						for each (var attackHitAreaTargetFrame:String in attackHitAreaTargetFrames)
						{
							var attackHitArea:AttackHitArea = new AttackHitArea();
							
							// rectangle
							for each (var attackHitAreaRectXML:XML in attackHitAreaXML.rectangle)
							{
								attackHitArea.rectangles.push(new Rectangle(
								    Number(attackHitAreaRectXML.x),
								    Number(attackHitAreaRectXML.y),
								    Number(attackHitAreaRectXML.width),
								    Number(attackHitAreaRectXML.height)
								));
							}
							// target
							var attackTargetKeys:Vector.<String> = StringUtility.convertFromCSVToVector(String(attackHitAreaXML.target))[0];
							for each (var attackTargetKey:String in attackTargetKeys)
							{
								attackHitArea.addTarget(AttackTarget.getEnum(attackTargetKey));
							}
							// attackGroup
							if (attackHitAreaXML.attackGroup != undefined && String(attackHitAreaXML.attackGroup) != "")
							{
								if (attackGroups[String(attackHitAreaXML.attackGroup)] == undefined)
								{
									throw new ArgumentError("\"frame.attackHitArea.attackGroup\" タグに指定された ID が存在しません。[@name=" + String(frameXML.@name) + ", ID=" + String(attackHitAreaXML.attackGroup) + "]");
								}
								attackHitArea.attackGroup = attackGroups[String(attackHitAreaXML.attackGroup)];
							}
							// power
							attackHitArea.power.multiplicationNumber = Number(attackHitAreaXML.power.multiplication);
							attackHitArea.power.additionNumber       = Number(attackHitAreaXML.power.addition);
							// angle
							attackHitArea.angle = Number(attackHitAreaXML.angle);
							// damageKeepTime
							attackHitArea.damageKeepTime = uint(attackHitAreaXML.damageKeepTime);
							// flySpeed.x
							attackHitArea.flyXSpeed.multiplicationNumber = Number(attackHitAreaXML.flySpeed.x.multiplication);
							attackHitArea.flyXSpeed.additionNumber       = Number(attackHitAreaXML.flySpeed.x.addition);
							// flySpeed.y
							attackHitArea.flyYSpeed.multiplicationNumber = Number(attackHitAreaXML.flySpeed.y.multiplication);
							attackHitArea.flyYSpeed.additionNumber       = Number(attackHitAreaXML.flySpeed.y.addition);
							// defensible
							attackHitArea.defensible = StringUtility.convertStringToBoolean(String(attackHitAreaXML.defensible));
							// impact
							attackHitArea.impact = StringUtility.convertStringToBoolean(String(attackHitAreaXML.impact));
							// counterbalance
							attackHitArea.counterbalance = StringUtility.convertStringToBoolean(String(attackHitAreaXML.counterbalance));
							// hitStopTime
							attackHitArea.hitStopTime = uint(attackHitAreaXML.hitStopTime);
							// attribute
							if (String(attackHitAreaXML.attribute) != "")
							{
								if (attackAttribute == null)
								{
									throw new ArgumentError("\"frame.attackHitArea.attribute\" タグに値を設定している場合、createMainTimeline メソッドは attackAttribute パラメータを指定して実行する必要があります。[@name=" + String(frameXML.@name) + "]");
								}
								attackHitArea.attribute = attackAttribute.getAttribute(String(attackHitAreaXML.attribute));
							}
							// effect
							if (String(attackHitAreaXML.effect) != "")
							{
								if (effectFactory == null)
								{
									throw new ArgumentError("\"frame.attackHitArea.effect\" タグに値を設定している場合、createMainTimeline メソッドは effectFactory パラメータを指定して実行する必要があります。[@name=" + String(frameXML.@name) + "]");
								}
								attackHitArea.setEffect(String(attackHitAreaXML.effect), effectFactory);
							}
							// soundEffect
							if (String(attackHitAreaXML.soundEffect) != "")
							{
								if (soundEffectCollection == null)
								{
									throw new ArgumentError("\"frame.attackHitArea.soundEffect\" タグに値を設定している場合、createMainTimeline メソッドは soundEffectCollection パラメータを指定して実行する必要があります。[@name=" + String(frameXML.@name) + "]");
								}
								attackHitArea.soundEffect = soundEffectCollection.getSoundEffect(String(attackHitAreaXML.soundEffect));
							}
							
							childTimeline.setAttackHitArea(uint(attackHitAreaTargetFrame), attackHitArea);
						}
					}
				}
				mainTimeline.setChildTimeline(String(frameXML.@name), childTimeline);
			}
			
			return mainTimeline;
		}
	}
}
