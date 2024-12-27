package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.net.URLRequest;

class Header extends FlxGroup {
	var background:FlxSprite;
	var moreGames:Button;
	var dayLabel:Label;
	var stateLabel:Label;

	var state:FlxState;
	var stateId:String;

	public function new(state:FlxState, stateId:String) {
		super();
		this.state = state;
		this.stateId = stateId;

		updateHeader();
	}

	public function updateHeader() {
		clear();
		background = new FlxSprite(0, 0);
		background.makeGraphic(FlxG.width, 40, FlxColor.BLACK);
		background.alpha = 0.3;
		add(background);

		if (stateId == 'restaurant') {
			stateLabel = new Label(-1, 5, "Kitchen");
		} else if (stateId == 'sewers') {
			stateLabel = new Label(-1, 5, "Sewers");
		} else if (stateId == 'service') {
			stateLabel = new Label(-1, 5, "Service");
		}
		add(stateLabel);

		dayLabel = new Label(8, 5, 'Day ${GameData.instance.day + 1}');
		add(dayLabel);

		if (GameData.instance.deaths > 0) {
			add(new Label(120, 5, 'Deaths: '));

			for (i in 0...GameData.instance.maxDeaths) {
				var skull = new FlxSprite(200 + i * 32, 6);
				skull.loadGraphic(AssetPaths.ui__png, true, 128, 128);
				skull.origin.set(0, 0);
				skull.scale.set(0.24, 0.24);
				skull.animation.add('default', [i >= GameData.instance.deaths ? 4 : 3]);
				skull.animation.play('default');
				add(skull);
			}
		}

		// moreGames = new Button("Aymeri's 100", () -> {
		// 	Lib.getURL(new URLRequest("https://aymeri100.fr"), "_blank");
		// }, FlxG.width - 208, 8);
		// add(moreGames);
	}
}