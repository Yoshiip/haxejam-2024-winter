package encyclopedia;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import restaurant.DraggeableIngredient;
import restaurant.Tooltip;
import ui.Label;

class EncyclopediaState extends FlxSubState {
	var background:FlxSprite;
	var ingredients:FlxTypedGroup<DraggeableIngredient>;

	var tooltip:Tooltip;
	var onClose:Void->Void;

	public function new(onClose:Void->Void) {
		super();
		this.onClose = onClose;
	}

	private var alpha:Float = 1.0;

	override public function create() {
		super.create();
		background = new FlxSprite(0, 0);
		background.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(background);
		tooltip = new Tooltip();

		add(new Label(-1, 32, "Encyclopedia", 48));

		var i = 0;
		ingredients = new FlxTypedGroup();
		for (item in ItemsData.instance.items) {
			final discovered = GameData.instance.discoveredItems.contains(item.id);
			final finalItem = discovered ? item : ItemsData.instance.unknownItem;
			var ingredient = new DraggeableIngredient(finalItem, 100 + (i % 4) * 300, 100 + Math.floor(i / 4) * 120, () -> {
				tooltip.showTooltip(finalItem);
			}, () -> {
				tooltip.hideTooltip();
			});
			ingredients.add(ingredient);
			add(ingredient);
			i++;
		}

		FlxTween.num(0, 1, .66, {ease: FlxEase.circOut}, updateAlpha);

		add(tooltip);
	}

	function updateAlpha(alpha:Float) {
		this.alpha = alpha;
		ingredients.forEach(function(sprite) sprite.alpha = alpha);
		background.alpha = alpha / 1.2;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.mouse.justReleased)
			FlxTween.num(1, 0, .66, {
				ease: FlxEase.circOut,
				onComplete: (_) -> {
					onClose();
				}
			}, updateAlpha);
	}
}