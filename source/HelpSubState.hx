import flixel.FlxG;
import flixel.FlxSubState;
import ui.Label;

class HelpSubState extends FlxSubState {
	var onClose:Void->Void;
	var message:String;
	var closeLabel:Label;

	public function new(onClose:Void->Void, message:String) {
		super(0xcc000000);
		this.onClose = onClose;
		this.message = message;
	}

	private var alpha:Float = 1.0;

	override public function create() {
		super.create();
		final label = new Label(-1, -1, message, 24);
		label.wordWrap = false;
		label.autoSize = false;
		add(label);

		closeLabel = new Label(-1, FlxG.height - 200, '(click to close)');
		closeLabel.alpha = 0.5;
		add(closeLabel);
	}

	private var total:Float = 0.0;
	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.mouse.justReleased) {
			onClose();
		}
		closeLabel.y = FlxG.height - 200 + Math.cos(4.0) * 20.0;
		closeLabel.scale.set(1.0 + Math.cos(total * 4.0) * 0.2, 1.0 + Math.cos(total * 4.0) * 0.2);
		total += elapsed;
	}
}