package service;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import ui.Label;

enum CustomerReaction {
	LOVE;
	LIKE;
	DEAD;
}

class Customer extends FlxGroup {
	private var raccoon:FlxSprite;
	private var sign:FlxSprite;

	public var reaction:CustomerReaction = LIKE;

	private var onReveal:Customer->Void;

	public static inline final SCALE:Float = 0.6;

	public function new(x:Float, y:Float, onReveal:Customer->Void) {
		super();
		this.onReveal = onReveal;

		y += FlxG.random.float(0, 32);
		raccoon = new FlxSprite(x, y);
		raccoon.loadGraphic('assets/images/customer.png');
		raccoon.scale.set(SCALE, SCALE);
		add(raccoon);

		sign = new FlxSprite(x + 32, y - 64);
		sign.scale.set(0.8, 0.8);
		sign.loadGraphic(AssetPaths.ui__png, true, 128, 128);
		sign.visible = false;
		add(sign);
	}

	public function setReaction(newReaction:CustomerReaction) {
		this.reaction = newReaction;
		sign.animation.destroyAnimations();
		sign.animation.add('default', [newReaction == LIKE ? 0 : newReaction == LOVE ? 1 : 2]);
		sign.animation.play('default');
	}

	private var total:Float = 0.0;
	private var revealed = false;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		total += elapsed;
		raccoon.scale.set(SCALE, SCALE + Math.cos(total * 4.0) * 0.05);
		if (FlxG.mouse.justPressed && raccoon.overlapsPoint(FlxG.mouse.getPosition()) && !revealed) {
			sign.visible = true;
			revealed = true;
			onReveal(this);
		}
	}
}