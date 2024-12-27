package restaurant;

import flixel.FlxSprite;
import flixel.tweens.misc.ShakeTween;

class CookingPot extends FlxSprite {
	public function new(x:Float, y:Float, scale:Float) {
		super(x, y);

		loadGraphic("assets/images/cooking_pot.png");
		this.scale.set(scale, scale);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}