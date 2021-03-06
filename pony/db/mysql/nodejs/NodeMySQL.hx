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
package pony.db.mysql.nodejs;
#if nodejs
import js.Node;
import js.node.events.EventEmitter;
/**
 * NodeMySQL api
 * @author AxGord <axgord@gmail.com>
 */
typedef NodeMySQL = {
	createConnection:Dynamic->NodeMySQL_Connection
}

typedef NodeMySQL_Connection = {
	connect:(Dynamic->Void)->Void,
	changeUser:Dynamic->(Dynamic->Void)->Void,
	escape:String->String,
	escapeId:String->String,
	pause:(Dynamic->Void)->Void,
	end:Void->Void,
	query:String->?(Dynamic->Dynamic->Array<Dynamic>->Void)->NodeMySQL_QueryResult
}

class NodeMySQL_QueryResult extends EventEmitter<NodeMySQL_QueryResult> {}
#end