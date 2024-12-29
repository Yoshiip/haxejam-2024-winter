package restaurant;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import ui.Label;

class Tooltip extends FlxTypedGroup<FlxSprite> {
	var background:FlxSprite;
	var name:FlxText;
	var description:FlxText;

	private static final size = {
		x: 280,
		y: 160,
	};

	public function new() {
		super();
		final startX = FlxG.mouse.x;
		final startY = FlxG.mouse.y;
		background = new FlxSprite(startX, startY);
		background.makeGraphic(size.x, size.y, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRectComplex(background, startX, startY, size.x, size.y, 8, 8, 8, 8, FlxColor.GRAY, {
			thickness: 2,
			color: FlxColor.WHITE
		});
		background.alpha = 0.3;
		add(background);

		name = new Label(startX, startY, 'test', 32);

		add(name);
		description = new Label(startX, startY + 36, 'test', 18);
		description.autoSize = false;
		description.fieldWidth = size.x - 8;
		add(description);

		visible = false;
	}

	public function showTooltip(item:Item) {
		name.text = item.name;
		description.text = item.description;
		visible = true;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (visible) {
			var offset = new FlxPoint(FlxG.mouse.x + 16, FlxG.mouse.y + 16);
			if (offset.x + size.x > FlxG.width)
				offset.x -= size.x;
			if (offset.y + size.y > FlxG.height)
				offset.y -= size.y;
			Utils.smoothMove(background, offset, elapsed);
			Utils.smoothMove(name, offset.add(8, 8), elapsed);
			Utils.smoothMove(description, offset.add(8, 40), elapsed);
		}
	}

	public function hideTooltip() {
		visible = false;
	}
}