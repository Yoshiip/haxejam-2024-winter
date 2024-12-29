package sewers;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class FloatingItem extends FlxSprite {
	private var speed:Float = 100.0;

	public static inline final SIZE = 128;

	public var item:Item;

	var direction:Int;

	public var state:SewersState;
	private var bubbleTimer = 0.0;

	public function new(state:SewersState, item:Item, x:Float = 0, y:Float = 0, direction:Int = 1, hidden:Bool = false) {
		super(x, y);
		this.state = state;

		bubbleTimer = FlxG.random.float(0.5, 1.0);

		this.item = item;
		this.direction = direction;

		if (hidden) {
			if (item.type == TOXIC) {
				loadGraphic("assets/images/light_toxic.png");
			} else {
				loadGraphic(AssetPaths.light__png);
			}
			alpha = 0.5;
		} else {
			loadGraphic("assets/images/items.png", true, SIZE, SIZE);
			animation.add("default", item.animation);
			animation.play("default");
			setFacingFlip(LEFT, false, false);
			setFacingFlip(RIGHT, true, false);
		}
		final rScale = 0.5 + FlxG.random.float(-0.05, 0.15);
		scale.set(rScale, rScale);
		updateHitbox();
		speed += FlxG.random.float(-10.0, 20.0);
	}

	private var total:Float = 0;

	override public function update(elapsed:Float) {
		total += elapsed;
		super.update(elapsed);
		bubbleTimer -= elapsed;
		if (bubbleTimer < 0.0) {
			state.spawnBubble(x, y);

			bubbleTimer = FlxG.random.float(3.0, 5.0);
		}
		if (state.hook.state == SHOOT
			&& state.hook.y > SewersState.WATER_Y
			&& getPosition().distanceTo(state.hook.getPosition()) < state.magnet) {
			velocity = (state.hook.getPosition() - getPosition()).normalize() * speed;
		} else {
			velocity = new FlxPoint(this.direction * speed, Math.cos(total) * speed / 10);
		}

		facing = velocity.x > 0 ? LEFT : RIGHT;

		if (this.x > FlxG.width) {
			this.x = -SIZE;
		}
		if (this.x < -SIZE) {
			this.x = FlxG.width;
		}
	}
}