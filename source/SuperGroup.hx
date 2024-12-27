import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

typedef SpriteProperties = {
	relativeX:Float,
	relativeY:Float,
	alpha:Float,
	angle:Float,
	scaleX:Float,
	scaleY:Float,
}

class SuperGroup<T:FlxBasic> extends FlxTypedGroup<T> {
	public static final DEFAULT_PROPERTIES:SpriteProperties = {
		relativeX: 0,
		relativeY: 0,
		alpha: 1.0,
		angle: 0.0,
		scaleX: 1.0,
		scaleY: 1.0,
	};

	private var _x:Float = 0;
	private var _y:Float = 0;
	private var _alpha:Float = 1;
	private var _scale:Float = 1;

	private var relatives:Map<Int, SpriteProperties> = new Map();

	public function setX(value:Float):Float {
		var deltaX = value - _x;
		_x = value;
		for (child in members) {
			if (Std.is(child, FlxSprite)) {
				cast(child, FlxSprite).x += deltaX;
			}
		}
		return _x;
	}

	public function setY(value:Float):Float {
		var deltaY = value - _y;
		_y = value;
		for (child in members) {
			if (Std.is(child, FlxSprite)) {
				cast(child, FlxSprite).y += deltaY;
			}
		}
		return _y;
	}

	public function setAlpha(value:Float):Float {
		_alpha = value;
		for (child in members) {
			if (Std.is(child, FlxSprite)) {
				cast(child, FlxSprite).alpha = _alpha;
			}
		}
		return _alpha;
	}

	public function getX():Float {
		return _x;
	}

	public function getY():Float {
		return _y;
	}

	public function getAlpha():Float {
		return _alpha;
	}
}