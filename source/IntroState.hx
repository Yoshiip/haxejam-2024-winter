import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import sewers.SewersState;
import ui.Button;
import ui.Label;

class IntroState extends FlxState {
	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super.create();
		add(new FlxSprite(0, 0, 'assets/images/transition.png'));

		add(new Label(-1, -1, "One day, a raccoon woke up and decided\nto open his own soup restaurant.\n
With no money, he had to go and get\nhis food from the village sewers..."));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.mouse.justReleased)
			Utils.switchStateTo(new SewersState());
	}
}