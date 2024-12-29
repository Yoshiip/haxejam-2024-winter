package restaurant;

import Item.ItemId;
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

	public var taste:Int = 0;
	public var valueMultiplier:Float = 1.0;
	public var valueBonus:Int = 0;

	public static inline final SLOT_SIZE:Int = 88;
	private static inline final THICKNESS:Float = 2;

	private var numberText:Label;
	private var multiplierLabel:Label;
	private var valueText:Label;
	private var multiplierSprite:FlxSprite;


	public function new(root:RestaurantState, x:Float, y:Float, number:Int) {
		super();
		this.root = root;

		this.multiplierSprite = new FlxSprite(x - 16, y - 16);
		multiplierSprite.loadGraphic(AssetPaths.ui__png, true, 128, 128);
		multiplierSprite.animation.add('stop', [10]);
		multiplierSprite.animation.add('red', [5]);
		multiplierSprite.animation.add('blue', [4]);
		multiplierSprite.animation.add('none', [11]);
		multiplierSprite.animation.play('none');
		multiplierSprite.alpha = 0.5;
		add(multiplierSprite);

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

		this.valueText = new Label(x, y + SLOT_SIZE, '', 28);
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
		this.multiplierSprite.scale.set(0.9 + Math.cos(total * 4.0) * 0.2, 0.9 + Math.sin(total * 4.0) * 0.2);

		if (this.frame.overlapsPoint(FlxG.mouse.getPosition())) {
			this.frame.scale.set(1.0 + Math.cos(total * 4.0) * 0.1, 1.0 + Math.sin(total * 4.0) * 0.1);
		} else {
			this.frame.scale.set(1.0, 1.0);
		}
	}

	public function reset() {
		this.taste = 0;
		this.valueBonus = 0;
		this.setMultiplier(1.0);
	}

	public function addValuesToSlot(number:Int, bonus:Int, multiplier:Float) {
		final slot = root.getSlot(number);
		if (slot != null) {
			slot.addValues(Std.int(bonus * valueMultiplier), multiplier * valueMultiplier);
		}
	}

	public function applyInsideEffect(itemId:ItemId = null, processedItems:Array<ItemId> = null):Void {
		if (processedItems == null)
			processedItems = [];
		

		if (itemId != null && processedItems.indexOf(itemId) >= 0) 
			return;
		if (itemId != null)
			processedItems.push(itemId);

		if (itemId == null) {
			if (inside == null) {
				return;
			}
			itemId = inside.item.id;
		}

		switch (itemId) {
			case KOI:
				if (number % 2 == 1) {
					this.valueBonus += 15;
				}
			case TRASHFISH:
				var previousSlot = root.getSlot(number - 1);
				final value = ItemsData.instance.getItem(TRASHFISH).baseTaste;
				if (previousSlot != null && previousSlot.inside != null && previousSlot.inside.item.type == TOXIC) {
					this.valueBonus = 50;
				} else {
					this.valueBonus = -25;
				}
			case RAINBOWFISH:
				for (slot in root.slots) {
					if (slot != this) {
						slot.addValues(0, 1.5);
					}
				}
			case PHANTOMFISH:
				var previousSlot = root.getSlot(number - 1);
				if (previousSlot != null && previousSlot.inside != null) {
					this.taste = previousSlot.inside.item.baseTaste;
					this.valueBonus = previousSlot.valueBonus;
					this.valueMultiplier = previousSlot.valueMultiplier;
					applyInsideEffect(previousSlot.inside.item.id, processedItems);
				}
			case CATFISH:
				addValuesToSlot(number + 1, 0, 2.0);
			case PUFFERFISH:
				addValuesToSlot(number - 1, 0, 0.5);
			case CLOWNFISH:
				addValuesToSlot(number + 1, 0, 0.0);
			case GOLDFISH:
				if (number % 2 == 0) {
					this.valueBonus += 20;
				}
			case PARSLEY:
				if (number == root.slots.length - 1) {
					this.valueBonus += 30;
				}
			case _:
				return;
		}
	}
	public function setMultiplier(value:Float) {
		this.valueMultiplier = value;
		if (value <= 0.0) {
			this.multiplierSprite.animation.play('stop');
		} else if (value >= 3.0) {
			this.multiplierSprite.animation.play('blue');
		} else if (value >= 2.0) {
			this.multiplierSprite.animation.play('red');
		} else {
			this.multiplierSprite.animation.play('none');
		}
		this.multiplierLabel.visible = value != 1.0;
		this.multiplierLabel.color = value <= 0.0 ? FlxColor.RED : FlxColor.WHITE;

		this.multiplierLabel.text = '${value}x';
	}


	public function addValues(bonus:Int, multiplier:Float) {
		this.valueBonus += bonus;
		this.setMultiplier(valueMultiplier * multiplier);
	}

	public function calculateFinalValue() {
		if (inside == null) {
			this.valueText.visible = false;
			this.taste = 0;
			return;
		}
		if (inside.item.baseTaste != 0) {
			taste = inside.item.baseTaste;
		}
		taste = Std.int((taste + valueBonus) * valueMultiplier);
		this.valueText.visible = true;
		this.valueText.text = '${Std.string(taste)}';
		if (taste > 0) {
			this.valueText.color = FlxColor.GREEN;
		} else if (taste < 0) {
			this.valueText.color = FlxColor.RED;
		} else {
			this.valueText.color = FlxColor.WHITE;
		}
	}
}