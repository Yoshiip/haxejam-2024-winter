package sewers;

import flixel.FlxSprite;

class Bubble extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);

		loadGraphic(AssetPaths.items__png, true, 128, 128);
		scale.set(0.25, 0.25);
		alpha = 0.5;
		updateHitbox();
		animation.add('default', [17]);
		animation.play('default');
	}

	private var total = 0.0;

	override public function update(elapsed:Float) {
		super.update(elapsed);

		total += elapsed;
		x += Math.cos(total * 4.0) * 100.0 * elapsed;
		y -= 100.0 * elapsed;
	}
}