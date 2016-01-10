/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.ui.gui;
import pony.events.Event2;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.magic.HasSignal;
import pony.ui.touch.TouchableBase;

enum ButtonState {
	Default; Focus; Leave; Press;
}

/**
 * ButtonCore
 * @author AxGord <axgord@gmail.com>
 */
class ButtonCore extends Tumbler implements HasSignal {

	@:auto public var onVisual:Signal2<Int, ButtonState>;
	@:bindable public var lowMode:Int = 0;
	@:bindable public var mode:Int = 0;
	@:bindable public var bMode:Bool = false;
	public var touch:TouchableBase;
	@:auto public var onClick:Signal1<Int>;
	@:bindable public var state:ButtonState = Default;
	
	
	private var modeBeforeDisable:Int = 1;
	
	public function new(t:TouchableBase) {
		super();
		
		touch = t;
		t.onClick << function() if (enabled) eClick.dispatch(mode);
		
		t.onDown << function() {
			enableOverDown();
			state = Press;
		}
		t.onUp << function() {
			disableOverDown();
			state = Focus;
		}
		t.onOver << function() state = Focus;
		t.onOut << function() state = Default;
		
		t.onOutUp << function() {
			disableOverDown();
			state = Default;
		}
		
		changeState << function(v) if (lowMode != 1) eVisual.dispatch(lowMode, v);
		
		changeLowMode << function(v) eVisual.dispatch(v,state);
		changeLowMode - 1 << disable;
		changeLowMode / 1 << enable;
		onEnable << function() lowMode = modeBeforeDisable;
		onDisable << function() {
			modeBeforeDisable = lowMode;
			lowMode = 1;
		}
		changeLowMode / 1 << function(v) mode = v > 1 ? v - 1 : v;
		changeBMode << function(v) mode = v ? 1 : 0;
		allowChangeMode();
		onEnable << allowChangeMode;
		onDisable << disallowChangeMode;
	}
	
	public function destroy():Void {
		touch.destroy();
		eVisual.destroy();
		eClick.destroy();
		untyped (changeLowMode:Event2<Int,Int>).destroy();
		untyped (changeMode:Event2<Int,Int>).destroy();
		untyped (changeBMode:Event2<Int,Int>).destroy();
		untyped (changeState:Event2<Int,Int>).destroy();
	}
	
	private function allowChangeMode():Void changeMode << changeModeHandler;
	
	private function disallowChangeMode():Void changeMode >> changeModeHandler;
	
	private function changeModeHandler(v:Int):Void {
		lowMode = v != 0 ? v + 1 : v;
		bMode = v == 1;
	}
	
	@:extern inline private function enableOverDown():Void {
		touch.onOverDown << overDownHandler;
		touch.onOutDown << outDownHandler;
	}
	
	@:extern inline private function disableOverDown():Void {
		touch.onOverDown >> overDownHandler;
		touch.onOutDown >> outDownHandler;
	}
	
	private function overDownHandler():Void {
		eVisual.dispatch(lowMode, Press);
	}
	
	private function outDownHandler():Void {
		eVisual.dispatch(lowMode, Leave);
	}
	
	@:extern inline public function switchMap(a:Array<Int>):Void {
		onClick << function(v) mode = a[v];
	}
	
	@:extern inline public function bswitch():Void {
		onClick << function() bMode = !bMode;
	}
	
	
}