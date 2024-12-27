package sewers;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class Abyss extends FlxGroup {
	public function new(baseY:Float) {
		super();

		var gradient = new FlxTiledSprite('assets/images/abyss.png', FlxG.width, 256, true, false);
		gradient.scale.set(1.0, 8.0);
		gradient.y = baseY;
		add(gradient);

		var background = new FlxSprite(0, baseY + 256);
		background.makeGraphic(FlxG.width, FlxG.height, 0xff2e222f);
		add(background);
	}
}