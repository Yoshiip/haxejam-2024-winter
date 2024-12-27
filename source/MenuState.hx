import flixel.FlxState;
import restaurant.RestaurantState;
import ui.Button;
import ui.Label;

class MenuState extends FlxState {
	var playButton:Button;

	override public function create() {
		super.create();

		var title = new Label(0, 64, "Raccoon's Soup", 48);
		title.screenCenter(X);
		add(title);

		var subtitle = new Label(0, 200, "AYMERI'S 100", 24);
		subtitle.screenCenter(X);
		add(subtitle);
		playButton = new Button("Play", clickPlay);
		add(playButton);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	function clickPlay() {
		Utils.switchStateTo(new RestaurantState());
	}
}