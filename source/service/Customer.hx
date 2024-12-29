package service;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;

class Customer extends FlxGroup {
	public var raccoon:FlxSprite;
	public var sign:FlxSprite;

	public var like = false;
	public var love = false;
	public var revealed = false;

	private var onClick:Customer->Void;

	public static inline final SCALE:Float = 1.0;

	public function new(x:Float, y:Float, onClick:Customer->Void) {
		super();
		this.onClick = onClick;

		y += FlxG.random.float(0, 32);
		raccoon = new FlxSprite(x + 200, y);
		raccoon.alpha = 0.0;
		raccoon.loadGraphic('assets/images/customer.png');
		raccoon.scale.set(SCALE, SCALE);
		add(raccoon);

		sign = new FlxSprite(x + 32, y - 64);
		sign.scale.set(0.8, 0.8);
		sign.loadGraphic(AssetPaths.ui__png, true, 128, 128);
		sign.visible = false;
		add(sign);
		FlxTween.tween(raccoon, {
			x: x,
			alpha: 1.0,
		}, 0.8);
	}

	public function setLike(like:Bool) {
		this.like = like;
		sign.animation.destroyAnimations();
		sign.animation.add('default', [love ? 2 : like ? 1 : 0]);
		sign.animation.play('default');
	}

	private var total:Float = 0.0;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		total += elapsed;
		raccoon.scale.set(SCALE, SCALE + Math.cos(total * 4.0) * 0.05);
		if (FlxG.mouse.justReleased && raccoon.overlapsPoint(FlxG.mouse.getPosition())) {
			sign.visible = true;
			onClick(this);
		}
	}
}