package org.ahiufomasao.yasume.effects 
{
	
	// TODO: asdoc
	/**
	 * エフェクト
	 * 
	 * @author asahiufo/AM902
	 */
	public interface IEffect 
	{
		/**
		 * 初期処理
		 */
		function initialize():void;
		/**
		 * エフェクト実行
		 * 
		 * @param context 実行コンテキスト
		 */
		function exec():Boolean;
		/**
		 * エフェクト描画
		 */
		function draw():void;
		/**
		 * 終了処理
		 */
		function terminate():void;
	}
}