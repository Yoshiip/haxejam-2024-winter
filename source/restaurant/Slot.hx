package restaurant;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import ui.Label;

class Slot extends FlxTypedGroup<FlxSprite> {
	public var frame:FlxSprite;

	public var root:RestaurantState;
	public var number:Int;
	public var inside:DraggeableIngredient;

	private var flameSprite:FlxSprite;

	public var valueMultiplier:Float = 1.0;
	public var valueBonus:Int = 0;

	public var taste = 0;

	public static inline final SLOT_SIZE:Int = 88;

	private var numberText:Label;
	private var multiplierLabel:Label;
	private var valueText:Label;

	private static inline final THICKNESS:Float = 2;

	public function new(root:RestaurantState, x:Float, y:Float, number:Int) {
		super();
		this.root = root;

		this.flameSprite = new FlxSprite(x - 16, y - 16);
		flameSprite.loadGraphic(AssetPaths.ui__png, true, 128, 128);
		flameSprite.animation.add('default', [5]);
		flameSprite.animation.play('default');
		flameSprite.visible = false;
		flameSprite.alpha = 0.5;
		add(flameSprite);

		this.frame = new FlxSprite(x, y);
		this.frame.makeGraphic(SLOT_SIZE, SLOT_SIZE, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(this.frame, THICKNESS, THICKNESS, SLOT_SIZE - THICKNESS * 2, SLOT_SIZE - THICKNESS * 2, 16, 16, FlxColor.TRANSPARENT, {
			color: FlxColor.WHITE,
			thickness: THICKNESS,
		});
		add(this.frame);

		this.number = number;

		this.numberText = new Label(x, y + SLOT_SIZE / 3, Std.string(number + 1), 32);
		this.numberText.alpha = 0.5;
		this.numberText.autoSize = false;
		this.numberText.alignment = CENTER;
		this.numberText.fieldWidth = SLOT_SIZE;
		this.root.add(this.numberText);

		this.multiplierLabel = new Label(x, y - 28, "x1");
		this.multiplierLabel.autoSize = false;
		this.multiplierLabel.alignment = CENTER;
		this.multiplierLabel.fieldWidth = SLOT_SIZE;
		this.multiplierLabel.visible = false;
		add(this.multiplierLabel);

		this.valueText = new Label(x, y + SLOT_SIZE, '');
		this.valueText.autoSize = false;
		this.valueText.alignment = CENTER;
		this.valueText.fieldWidth = SLOT_SIZE;
		this.valueText.visible = false;
		add(this.valueText);
	}

	private var total:Float;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		total += elapsed;

		this.numberText.alpha = inside == null ? 0.6 : 1.0;
		this.frame.alpha = inside == null ? 0.6 : 1.0;
		this.flameSprite.scale.set(0.9 + Math.cos(total * 4.0) * 0.2, 0.9 + Math.sin(total * 4.0) * 0.2);

		if (this.frame.overlapsPoint(FlxG.mouse.getPosition())) {
			this.frame.scale.set(1.0 + Math.cos(total * 4.0) * 0.1, 1.0 + Math.sin(total * 4.0) * 0.1);
		} else {
			this.frame.scale.set(1.0, 1.0);
		}
	}

	public function clearMultipliers() {
		this.valueBonus = 0;
		this.setMultiplier(1.0);
		this.setMultiplier(1.0);
	}

	public function addValuesToSlot(number:Int, bonus:Int, multiplier:Float) {
		final slot = root.getSlot(number);
		if (slot != null) {
			slot.addValues(Std.int(bonus * valueMultiplier), multiplier * valueMultiplier);
		}
	}

	public function setMultiplier(value:Float) {
		this.valueMultiplier = value;
		this.flameSprite.visible = value >= 2.0;
		this.multiplierLabel.visible = value != 1.0;
		this.multiplierLabel.color = value <= 0.0 ? FlxColor.RED : FlxColor.WHITE;

		this.multiplierLabel.text = '${value}x';
	}

	public function calculateValues() {
		if (inside == null)
			return;
		switch (inside.item.id) {
			case KOI:
				if (number % 2 == 1)
					this.valueBonus += 15;
			case CATFISH:
				addValuesToSlot(number + 1, 0, 2.0);
			case PUFFERFISH:
				addValuesToSlot(number - 1, 0, 0.5);
			case CLOWNFISH:
				addValuesToSlot(number - 1, 0, 0.0);
			case GOLDFISH:
				if (number % 2 == 0)
					this.valueBonus += 20;
			case PARSLEY:
				if (number == root.slots.length - 1)
					this.valueBonus += 30;
			case _:
				return;
		}
	}

	public function addValues(bonus:Int, multiplier:Float) {
		this.valueBonus += bonus;
		this.setMultiplier(valueMultiplier * multiplier);
	}

	public function applyItemEffect() {
		if (inside == null) {
			this.valueText.visible = false;
			this.taste = 0;
			this.taste = 0;
			return;
		}
		switch (inside.item.id) {
			case UNKNOWN:
				taste = 0;
			case COMMON_FISH:
				taste = 10;
			case RARE_FISH:
				taste = 20;
			case SALMON:
				taste = 30;
			case KOI:
				taste = 15;
			case CATFISH:
				taste = 10;
			case CLOWNFISH:
				taste = 10;
			case PUFFERFISH:
				taste = 5;
			case GOLDFISH:
				taste = 10;
			case PARSLEY:
				taste = 5;
			case BANANA:
				taste = -5;
			case CAN:
				taste = -10;
			case METAL_PIECE:
				taste = -20;
			case NUCLEAR_WASTE:
				taste = -30;
		}
		taste = Std.int((taste + valueBonus) * valueMultiplier);
		this.valueText.visible = true;
		if (taste > 0) {
			this.valueText.color = FlxColor.GREEN;
			this.valueText.text = '${Std.string(taste)}';
		} else {
			this.valueText.color = FlxColor.WHITE;
			this.valueText.text = '${Std.string(taste)}';
		}
	}
}