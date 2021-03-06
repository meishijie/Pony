/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
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
**/
package pony.flash.starling.ui;

import flash.geom.Point;
import pony.geom.Angle;
import pony.ui.gui.TurningCore;
import starling.display.Sprite;
import starling.display.DisplayObject;
import pony.ui.touch.starling.touchManager.TouchEventType;
import pony.ui.touch.starling.touchManager.TouchManager;
import pony.ui.touch.starling.touchManager.TouchManagerEvent;

/**
 * TurningStarling
 * @author Maletin
 */
class StarlingTurningFree extends Sprite
{
	private static var _id:Int = 0;
	public var id:Int = _id++;
	
	private var _source:Sprite;
	
	private var handle:DisplayObject;
	private var lmin:DisplayObject;
	private var lmax:DisplayObject;
	private var button:StarlingButton;
	
	private var _handleInitAngleDeg:Float;
	private var _zero:Point = new Point(0, 0);
	private var _bufferPoint:Point = new Point(0, 0);
	
	public var core:TurningCore;

	public function new(source:Sprite, core:TurningCore, flashSource:flash.display.Sprite) 
	{
		super();
		
		_source = source;
		this.core = core;
		
		this.transformationMatrix = _source.transformationMatrix;
		
		handle = _source.getChildByName("handle");
		lmin = _source.getChildByName("lmin");
		lmax = _source.getChildByName("lmax");
		button = cast _source.getChildByName("button");
		
		while (_source.numChildren > 0)
		{
			addChild(_source.getChildAt(0));
		}
		
		handle.touchable = false;
		button.touchable = true;
		
		_handleInitAngleDeg = untyped flashSource.handle.rotation;
		
		core.changeAngle << function(r:Angle) handle.rotation = (r - _handleInitAngleDeg) / 180 * Math.PI;
		
		if (lmin != null) lmin.visible = false;
		if (lmax != null) lmax.visible = false;
		
		if (lmin != null) core.minAngle = untyped flashSource.lmin.rotation;
		if (lmax != null) core.maxAngle = untyped flashSource.lmax.rotation;
		core.currentAngle = _handleInitAngleDeg;
		

		TouchManager.addListener(this, onMove, [TouchEventType.Down, TouchEventType.Move]);
	}
	
	private function onMove(e:TouchManagerEvent):Void
	{
		localToGlobal(_zero, _bufferPoint);
		core.toPoint( { x:e.globalX - _bufferPoint.x, y:e.globalY - _bufferPoint.y } );
	}
	

	
}