package restaurant;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

class CookingPot extends FlxGroup {
	private var pot:FlxSprite;
	private var smoke:FlxSprite;

	private static inline final SMOKE_SCALE = 0.4;

	public function new(x:Float, y:Float) {
		super();

		pot = new FlxSprite(x, y);
		pot.loadGraphic(AssetPaths.cooking_pot__png);
		pot.updateHitbox();
		pot.x = x;
		pot.y = y;

		smoke = new FlxSprite(x - 125, y - 300);
		smoke.scale.set(SMOKE_SCALE, SMOKE_SCALE);
		smoke.loadGraphic("assets/images/smoke.png");

		add(pot);
		add(smoke);
	}

	private var total:Float;
	override public function update(elapsed:Float) {
		super.update(elapsed);
		total += elapsed;
		smoke.alpha = 0.5 + (Math.cos(total * 4.0) * 0.2);
		smoke.scale.y = SMOKE_SCALE + (Math.cos(total * 4.0) * (0.2 * SMOKE_SCALE));
	}
}