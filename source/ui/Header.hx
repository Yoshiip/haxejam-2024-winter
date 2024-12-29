package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

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

		final gameData = GameData.instance;
		final day = gameData.day + 1;
		if (stateId == 'restaurant') {
			stateLabel = new Label(-1, 5, 'Kitchen (Day ${day})');
		} else if (stateId == 'sewers') {
			stateLabel = new Label(-1, 5, 'Sewers (Day ${day})');
			final inventoryLabel = new Label(128, 5, '${gameData.inventory.length}/${gameData.inventorySize}');
			add(inventoryLabel);
			var i = 0;
			for (item in gameData.inventory) {
				final sprite = new FlxSprite(128 + 80 + 32 * i, 8);
				sprite.loadGraphic(AssetPaths.items__png, true, 128, 128);
				sprite.animation.add('default', item.animation);
				sprite.animation.play('default');
				sprite.origin.set(0, 0);
				sprite.scale.set(0.25, 0.25);
				add(sprite);
				i++;
			}
		} else if (stateId == 'service') {
			stateLabel = new Label(-1, 5, 'Service (Day ${day})');
		} else {
			stateLabel = new Label(-1, 5, '');

		}
		add(stateLabel);

		// CUSTOMERS
		final customerSprite = new FlxSprite(8, 0);
		customerSprite.loadGraphic(AssetPaths.ui__png, true, 128, 128);
		customerSprite.animation.add('default', [6]);
		customerSprite.animation.play('default');
		customerSprite.origin.set(0, 0);
		customerSprite.scale.set(0.25, 0.25);
		add(customerSprite);

		final customerLabel = new Label(48, 5, '${gameData.customers}');
		add(customerLabel);

		if (gameData.level > 0) {
			final xpTarget = gameData.getXpTarget();

			final levelLabel = new Label(FlxG.width - 208, 5, 'Level ${gameData.level + 1}');
			add(levelLabel);
			final xpBar = new FlxBar(FlxG.width - 108, 16, LEFT_TO_RIGHT, 100, 10, null, "", 0, xpTarget, true);
			xpBar.value = xpTarget - gameData.xpLeft;
			add(xpBar);

			// final progressLabel = new Label(FlxG.width - 32, 5, '${gameData.xpLeft - gameData.getXpTarget()}/${gameData.getXpTarget()}', 16);
			// progressLabel.alpha = 0.6;
			// add(progressLabel);
		}
		// if (gameData.deaths > 0) {
		// 	add(new Label(120, 5, 'Deaths: '));

		// 	for (i in 0...gameData.maxDeaths) {
		// 		var skull = new FlxSprite(200 + i * 32, 6);
		// 		skull.loadGraphic(AssetPaths.ui__png, true, 128, 128);
		// 		skull.origin.set(0, 0);
		// 		skull.scale.set(0.24, 0.24);
		// 		skull.animation.add('default', [i >= gameData.deaths ? 4 : 3]);
		// 		skull.animation.play('default');
		// 		add(skull);
		// 	}
		// }


	}
}