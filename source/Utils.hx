package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Utils {
	public static function switchStateTo(newState:FlxState) {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(newState);
		});
	}

	public static function smoothMove(sprite:FlxSprite, newPosition:FlxPoint, delta:Float) {
		sprite.x = FlxMath.lerp(sprite.x, newPosition.x, delta * 10.0);
		sprite.y = FlxMath.lerp(sprite.y, newPosition.y, delta * 10.0);
	}

	// public static function smoothMoveGroup(sprite:SuperGroup<FlxSprite>, newPosition:FlxPoint, delta:Float) {
	// 	sprite.setX(FlxMath.lerp(sprite.getX(), newPosition.x, delta * 10.0));
	// 	sprite.setY(FlxMath.lerp(sprite.getY(), newPosition.y, delta * 10.0));
	// }
}