package sewers;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

enum HookState {
	AIM;
	SHOOT;
	RECOVER;
}

class Hook extends FlxSprite {
	public inline static final MAX_SPEED = 700;

	var root:SewersState;

	public var state:HookState;

	var pointPos:FlxPoint;

	override public function new(root:SewersState, x:Float, y:Float) {
		super(0, 240);
		this.root = root;
		state = AIM;
		loadGraphic('assets/images/hook.png');
		scale.set(0.5, 0.5);
		updateHitbox();

	}

	private var inWater:Bool = false;

	private var total:Float;

	override public function update(elapsed:Float) {
		total += elapsed;
		super.update(elapsed);
		visible = state != AIM;

		if (state == AIM)
			inWater = false;

		if (y > 200) {
			if (!inWater && visible) {
				FlxG.sound.play('assets/sounds/splash.wav', 0.5);
				inWater = true;
			}
			this.velocity.x *= 0.97;
			this.acceleration.y = 40;
			maxVelocity.set(MAX_SPEED, 80);
		} else {
			this.velocity.x *= 0.99;
			this.acceleration.y = 100;
			maxVelocity.set(MAX_SPEED, 200);
		}
		if (y > FlxG.height) {
			state = AIM;
			root.hud.updateHUD();
		}
		if (state == SHOOT) {
			FlxG.overlap(this, root.items, hookTouchedItem);
		}
	}

	function hookTouchedItem(hook:Hook, item:FloatingItem) {
		state = AIM;
		root.itemCaught(item);
		item.kill();
	}
}