package end;

import flixel.group.FlxGroup.FlxTypedGroup;
import ui.Label;

class MovingNumber extends FlxTypedGroup<Label> {
	private var titleLabel:Label;
	private var valueLabel:Label;

	public function new(x:Float, y:Float, title:String, targetValue:Int, width:Int = 300) {
		super(2);
		titleLabel = new Label(x, y, title);
		titleLabel.autoSize = false;
		titleLabel.fieldWidth = width;
		titleLabel.alignment = CENTER;
		add(titleLabel);

		valueLabel = new Label(x, y + 32, '${targetValue}', 32);
		valueLabel.autoSize = false;
		valueLabel.fieldWidth = width;
		valueLabel.alignment = CENTER;
		add(valueLabel);
	}
}