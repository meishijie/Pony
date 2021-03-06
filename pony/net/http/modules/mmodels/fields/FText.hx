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
package pony.net.http.modules.mmodels.fields;

import pony.net.http.modules.mmodels.Field;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;

class FText extends Field
{

	public function new(?len:Int, notnull:Bool=true)
	{
		super(len);
		this.notnull = notnull;
		type = 'Text';
		tplPut = CTextPut;
	}
	
	override public function htmlInput(cl:String, act:String, value:String, hidden:Bool=false):String {
		return
			'<textarea ' + (cl != null?'class="' + cl + '" ':'') +
			'name="' + model.name + '.' + act + '.' +
			name + '">'+value+'</textarea>';
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class CTextPut extends pony.text.tpl.TplPut<FText, Dynamic> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String 
	{
		if (args.exists('noesc'))
			return Reflect.field(b, name);
		else
			return @await html(name);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String 
	{
		return @await tag(name, [], arg, new Map(), kid);
	}
	
	@:async
	public function html(f:String):String {
		return StringTools.replace(StringTools.htmlEscape(Std.string(Reflect.field(b, f))), '\r\n', '<br/>');
	}
	
}