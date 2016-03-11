/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.pixi.ui;

import pixi.core.sprites.Sprite;
import pony.geom.Point;
import pony.time.Tween;

/**
 * AnimBar
 * @author AxGord <axgord@gmail.com>
 */
class AnimBar extends Bar {

	private var animation:Sprite;
	private var tween:Tween;
	
	public function new(
		bg:String,
		fillBegin:String,
		fill:String,
		?animation:String,
		animationSpeed:Int = 2000,
		?offset:Point<Int>,
		invert:Bool = false,
		useSpriteSheet:Bool=false,
		creep:Float = 0
	) {
		super(bg, fillBegin, fill, offset, invert, useSpriteSheet, creep);
		if (animation == null) return;
		this.animation = PixiAssets.cImage(animation, useSpriteSheet);
		this.animation.visible = false;
		if (offset != null) {
			this.animation.x = offset.x;
			this.animation.y = offset.y;
		}
		tween = new Tween(animationSpeed, true, true, true, true);
		tween.onUpdate << animUpdate;
		onReady < animInit;
	}
	
	private function animInit():Void addChildAt(animation, children.length);
	
	private function animUpdate(alp:Float):Void animation.alpha = alp;
	
	public function startAnimation():Void {
		animation.visible = true;
		tween.play();
	}
	
	public function stopAnimation():Void {
		animation.visible = false;
		tween.stopOnEnd();
	}
	
	override public function destroy():Void {
		if (animation != null) {
			tween.destroy();
			tween = null;
			removeChild(animation);
			animation.destroy();
			animation = null;
		}
		super.destroy();
	}
	
}