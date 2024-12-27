package sewers;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class FloatingItem extends FlxSprite {
	static inline var SPEED:Float = 100.0;

	public var item:Item;

	var direction:Int;

	public var state:SewersState;

	public function new(state:SewersState, item:Item, x:Float = 0, y:Float = 0, direction:Int = 1, hidden:Bool = false) {
		super(x, y);
		this.state = state;

		this.item = item;
		this.direction = direction;

		if (hidden) {
			loadGraphic("assets/images/light.png");
			alpha = 0.5;
		} else {
			loadGraphic("assets/images/items.png", true, 128, 128);
			animation.add("default", item.animation);
			animation.play("default");
			setFacingFlip(LEFT, false, false);
			setFacingFlip(RIGHT, true, false);
		}
		scale.set(0.5, 0.5);
		updateHitbox();
	}

	private var total:Float = 0;

	override public function update(elapsed:Float) {
		total += elapsed;
		super.update(elapsed);
		if (state.hook.state == SHOOT
			&& state.hook.y > SewersState.WATER_Y
			&& getPosition().distanceTo(state.hook.getPosition()) < state.magnet) {
			velocity = (state.hook.getPosition() - getPosition()).normalize() * SPEED;
		} else {
			velocity = new FlxPoint(this.direction * SPEED, Math.cos(total) * SPEED / 10);
		}

		facing = velocity.x > 0 ? LEFT : RIGHT;

		if (this.x > FlxG.width) {
			this.x -= FlxG.width;
		}
		if (this.x < 0) {
			this.x += FlxG.width;
		}
	}
}