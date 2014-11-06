package pony.touchManager.hitTestSources;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.geom.Point;

/**
 * ...
 * @author Maletin
 */
class NativeHitTestSource implements IHitTestSource
{
	private var _container:DisplayObjectContainer;
	private var _point:Point = new Point();

	public function new(container:DisplayObjectContainer) 
	{
		_container = container;
	}
	
	/* INTERFACE touchManager.hitTestSources.IHitTestSource */
	
	public function hitTest(x:Float, y:Float):Dynamic 
	{
		_point.x = x;
		_point.y = y;
		_point = _container.globalToLocal(_point);
		return childUnderPoint(_point.x, _point.y, _container);
	}
	
	private function childUnderPoint(x:Float, y:Float, container:DisplayObjectContainer, testShape:Bool = true):Dynamic
	{
		if (!container.mouseChildren && container.mouseEnabled && container.visible) return container;
		var i:Int = container.numChildren - 1;
		while (i >= 0)
		{
			var child:DisplayObject = container.getChildAt(i);
			if (child == null || !child.visible)
			{
				i--;
				continue;
			}
			if (child.hitTestPoint(x, y, testShape))
			{
				if (Std.is(child, DisplayObjectContainer))
				{
					var containerChild:Dynamic = childUnderPoint(x, y, cast child, testShape);
					if (containerChild != null) return containerChild;
				}
				else if (Std.is(child, InteractiveObject))
				{
					if (untyped child.mouseEnabled) return child;
				}
			}
			
			i--;
		}
		
		if (container.mouseEnabled) return container;
		return null;
	}
	
	public function parent(object:Dynamic):Dynamic
	{
		if (!Std.is(object, flash.display.DisplayObject)) return null;
		if (object == _container) return null;
		var objectsParent = object.parent;
		return objectsParent;
	}
	
}