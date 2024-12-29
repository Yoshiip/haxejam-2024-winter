package ui;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxBar;

class CompleteBar extends FlxTypedGroup<FlxSprite> {
	public var bar:FlxBar;
	public var value:Label;
	public var titleLabel:Label;
	public var subtextLabel:Label;
	public var valueLabel:Label;

	public function new(title:String, subtext:String, x:Float = -1, y:Float = -1, width:Int = 200, height:Int = 24, ?parentRef:Dynamic, variable:String = '',
			min:Float = 0.0, max:Float = 1.0, ?showValue:Bool = false) {
		super(4);
		bar = new FlxBar(x, y + 28, LEFT_TO_RIGHT, width, height, parentRef, variable, min, max, true);
		add(bar);

		this.titleLabel = new Label(x, y, title);
		titleLabel.autoSize = false;
		titleLabel.alignment = CENTER;
		titleLabel.fieldWidth = width;
		add(titleLabel);

		this.subtextLabel = new Label(x, y + height + 26, subtext, 16);
		subtextLabel.autoSize = false;
		subtextLabel.alignment = CENTER;
		subtextLabel.fieldWidth = width;
		subtextLabel.alpha = 0.6;
		add(subtextLabel);

		if (showValue) {
			this.valueLabel = new Label(x, y + 28, "");
			valueLabel.autoSize = false;
			valueLabel.alignment = CENTER;
			valueLabel.fieldWidth = width;
			add(valueLabel);
			if (x == -1)
				valueLabel.screenCenter(X);
			if (y == -1)
				valueLabel.screenCenter(Y);
		}

		if (x == -1) {
			bar.screenCenter(X);
			titleLabel.screenCenter(X);
			subtextLabel.screenCenter(X);
		}

		if (y == -1) {
			bar.screenCenter(Y);
			bar.y += 28;
			titleLabel.screenCenter(Y);
			subtextLabel.screenCenter(Y);
			subtextLabel.y += height + 26;
		}
	}


	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (this.valueLabel != null)
			this.valueLabel.text = '${bar.value}';
	}
}