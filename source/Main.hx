package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import restaurant.RestaurantState;
import service.ServiceState;
import sewers.SewersState;

class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(0, 0, RestaurantState, 60, 60, true, true));
	}
}
