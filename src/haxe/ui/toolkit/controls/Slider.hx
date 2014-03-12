package haxe.ui.toolkit.controls;

import flash.events.MouseEvent;
import flash.geom.Point;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.Direction;
import haxe.ui.toolkit.core.Screen;

/**
 Slider bar control
 **/
 
@:event("UIEvent.CHANGE", "Dispatched when the value of the slider changes") 
class Slider extends Progress {
	private var _thumb:Button;
	
	private var _mouseDownOffset:Float = -1; // the offset from the thumb pos where the mouse event was detected
	
	public function new() {
		super();
		
		_valueBgComp.sprite.buttonMode = true;
		_valueBgComp.sprite.useHandCursor = true;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		
		_thumb = new Button();
		_thumb.id = "thumb";
		_thumb.remainPressed = true;
		_thumb.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		addChild(_thumb);
		
		addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
		addEventListener(MouseEvent.MOUSE_DOWN, _onBackgroundMouseDown);
	}
	
	private override function get_value():Dynamic {
		return pos;
	}
	
	private override function set_value(newValue:Dynamic):Dynamic {
		pos = Std.parseFloat(newValue);
		return newValue;
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onMouseDown(event:MouseEvent):Void {
	}
	
	private function _onScreenMouseMove(event:MouseEvent):Void {
	}

	private function _onScreenMouseUp(event:MouseEvent):Void {
		_mouseDownOffset = -1;
		Screen.instance.removeEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
		Screen.instance.removeEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
	}
	
	private function _onBackgroundMouseDown(event:MouseEvent):Void {
	}
	
	private function calcPosFromCoord(coord:Float):Float {
		return 0;
	}
	
	private function _onMouseWheel(event:MouseEvent):Void {
		if (event.delta != 0) {
			if (_direction == Direction.HORIZONTAL) {
				if (event.delta < 0) {
					pos += 5;
				} else if (event.delta > 0) {
					pos -= 5;
				}
			} else if (_direction == Direction.VERTICAL) {
				if (event.delta < 0) {
					pos -= 5;
				} else if (event.delta > 0) {
					pos += 5;
				}
			}
		}
	}
}
