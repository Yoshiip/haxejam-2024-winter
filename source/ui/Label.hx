package ui;

import flixel.text.FlxText;
import flixel.util.FlxColor;

class Label extends FlxText {
	public function new(x:Float, y:Float, text:String = '', size:Int = 20) {
		super(x, y, 0, text, size);

		setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, size / 10.0);

		this.font = "fonts/Arial Rounded Bold.ttf";

		if (x == -1) {
			screenCenter(X);
		}
		if (y == -1) {
			screenCenter(Y);
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}