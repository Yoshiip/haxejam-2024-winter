package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Button extends FlxTypedGroup<FlxSprite> {
	var background:FlxSprite;
	var label:Label;

	public var disabled = false;

	var onClick:Void->Void;

	public function new(text:String = '', ?onClick:Void->Void, x:Float = -1, y:Float = -1, width:Float = 200, height:Float = 24) {
		super(4);
		this.onClick = onClick;

		background = new FlxSprite(x, y);
		background.makeGraphic(Std.int(width), Std.int(height), FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(background, 0, 0, width, height, height / 2, height / 2);
		add(background);

		label = new Label(x, y - height * 0.12, text, Std.int(height * 0.75));
		label.alignment = CENTER;
		label.autoSize = false;
		label.fieldWidth = width;
		add(label);

		if (x == -1) {
			background.screenCenter(X);
			label.screenCenter(X);
		}
		if (y == -1) {
			background.screenCenter(Y);
			label.screenCenter(Y);
			label.y -= height * 0.12;
		}
	}

	private var startedPressOnButton = false;

	private var total:Float = 0.0;

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (background.overlapsPoint(FlxG.mouse.getPosition())) {
			background.alpha = 0.5;
			label.alpha = 0.8 + Math.cos(total) * 0.2;
			if (FlxG.mouse.justPressed)
				startedPressOnButton = true;
			if (FlxG.mouse.pressed) {
				background.alpha = 0.7;
			}
			if (FlxG.mouse.justReleased && startedPressOnButton) {
				startedPressOnButton = false;
				if (!disabled)
					onClick();
			}
		} else {
			background.alpha = 0.3;
			label.alpha = 1.0;
		}
	}
}