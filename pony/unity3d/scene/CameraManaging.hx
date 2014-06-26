package pony.unity3d.scene ;

using hugs.HUGSWrapper;

/**
 * Camera
 * @author DIS
 */


class CameraManaging extends unityengine.MonoBehaviour
{
	private var target:unityengine.Transform;
	
	private var distance:Float = 10.0;
	private var distanceX:Float = 0;

	private var xSpeed:Float = 250.0;
	private var ySpeed:Float = 120.0;

	private var yMinLimit:Int = -20;
	private var yMaxLimit:Int = 80;

	private var maxDist : Float = 200;
	private var minDist : Float = 30;
	private var zoomSpeed : Float = 5;
	
	private var keyZoomUp:unityengine.KeyCode = unityengine.KeyCode.KeypadPlus;
	private var keyZoomOut:unityengine.KeyCode = unityengine.KeyCode.KeypadMinus;
	
	private var keyTurnUp:unityengine.KeyCode = unityengine.KeyCode.UpArrow;
	private var keyTurnDown:unityengine.KeyCode = unityengine.KeyCode.DownArrow;
	private var keyTurnLeft:unityengine.KeyCode = unityengine.KeyCode.LeftArrow;
	private var keyTurnRight:unityengine.KeyCode = unityengine.KeyCode.RightArrow;
	
	private var isInverted:Bool;

	private var x:Float = 0.0;
	private var y:Float = 0.0; 
	
	var vector:unityengine.Vector3;
	
	private function clampAngle(angle:Float, min:Float, max:Float )
	{
		if (angle < -360) angle -= 360;
		if (angle > 360) angle += 360;
		return unityengine.Mathf.Clamp(angle, min, max);
	}	
	
	
	private function Start():Void 
	{
		var angles:unityengine.Vector3 = this.transform.eulerAngles;
		x = angles.x;
		y = angles.y;
		
		
		if (target.rigidbody != null && target.rigidbody.active) 
		{
			target.rigidbody.freezeRotation = true;
		}
	}
	
	private function LateUpdate():Void 
	{
		
		#if touchscript
		
		if (target.active && Helper.touchDown && !Helper.doubleDown)
		{
			x += Helper.touchDX * xSpeed * 0.001;
			y -= Helper.touchDY * ySpeed * 0.001;
	
			y = clampAngle(y, yMinLimit, yMaxLimit);
		}
		#else
		
		if (target.active && unityengine.Input.GetMouseButton(1))
		{
			x += unityengine.Input.GetAxis("Mouse X") * xSpeed * 0.02;
			y -= unityengine.Input.GetAxis("Mouse Y") * ySpeed * 0.02;
	
			y = clampAngle(y, yMinLimit, yMaxLimit);
		}
		#end
		vector.Set(0.0, 0.0, -distance);
		transform.rotation = unityengine.Quaternion.Euler(y, x, 0);
		transform.position = transform.rotation.mulVector3(vector).add(target.position);
		#if touchscript

			if (Helper.doubleDown)
			{
				var m = Helper.touchDY * 0.01 * zoomSpeed;
				if (distance+m >= maxDist) {
					m = maxDist - distance;
					distance = maxDist;
				} else if (distance+m <= minDist) {
					m = minDist - distance;
					distance = minDist;
				} else
					distance += m;

				transform.Translate(unityengine.Vector3.forward.mul(m)); 
			}
			
		#else
		if (!isInverted) {
			if (unityengine.Input.GetAxis("Mouse ScrollWheel") < 0 && distance < maxDist) 
			{
				distance += zoomSpeed;
				this.transform.Translate(unityengine.Vector3.forward.mul(-zoomSpeed));
			}
		
			if (unityengine.Input.GetAxis("Mouse ScrollWheel") > 0 && distance > minDist)
			{
				distance -= zoomSpeed;                             
				transform.Translate(unityengine.Vector3.forward.mul(zoomSpeed) ); 
			}
		}
		else {
			
			if (unityengine.Input.GetAxis("Mouse ScrollWheel") < 0 && distance > minDist) 
			{
				distance -= zoomSpeed;
				this.transform.Translate(unityengine.Vector3.forward.mul(zoomSpeed));
			}
		
			if (unityengine.Input.GetAxis("Mouse ScrollWheel") > 0 && distance < maxDist)
			{
				distance += zoomSpeed;                             
				transform.Translate(unityengine.Vector3.forward.mul(-zoomSpeed) ); 
			}
		}
		
		
		
		#end
		if (unityengine.Input.GetKey(keyZoomOut) && distance < maxDist) 
		{
			distance += zoomSpeed / 10;
			transform.Translate(unityengine.Vector3.forward.mul(-zoomSpeed / 10));
		}
		
		if (unityengine.Input.GetKey(keyZoomUp) && distance > minDist) 
		{
			distance -= zoomSpeed / 10;
			transform.Translate(unityengine.Vector3.forward.mul(zoomSpeed / 10));
		}
		
		if (unityengine.Input.GetKey(keyTurnUp)) 
		{
			y += ySpeed * 0.004;
		}
		
		if (unityengine.Input.GetKey(keyTurnDown)) 
		{
			y -= ySpeed * 0.004;
		}
		
		if (unityengine.Input.GetKey(keyTurnLeft)) 
		{
			x += xSpeed * 0.004;
		}
		
		if (unityengine.Input.GetKey(keyTurnRight)) 
		{
			x -= xSpeed * 0.004;
		}
	}

	
}