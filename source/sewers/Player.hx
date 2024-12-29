package sewers;

import flixel.FlxSprite;

class Player extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic('assets/images/player.png');
		scale.set(0.25, 0.25);
	}
}