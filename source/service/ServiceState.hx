package service;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import sewers.SewersState;
import ui.Button;
import ui.Header;

class ServiceState extends FlxState {
	var customers:FlxTypedGroup<Customer>;
	var header:Header;

	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super.create();

		var button = new Button('End Day', () -> {
			GameData.instance.inventory = [];
			GameData.instance.day += 1;
			Utils.switchStateTo(new SewersState());
		}, -1, 32);
		add(button);

		header = new Header(this, 'service');

		var customersCount = 4;

		customers = new FlxTypedGroup<Customer>();
		var taste = GameData.instance.taste;
		var objective = GameData.instance.TASTE_OBJECTIVE[GameData.instance.day];
		for (i in 0...customersCount) {
			final customer = new Customer(100 + i * 200, 200, (customer:Customer) -> {
				switch (customer.reaction) {
					// case LOVE: {
					// 		GameData.instance.toxicity = Std.int(Math.max(GameData.instance.toxicity - 3, 0));
					// 	};
					case LIKE: return;
					case DEAD: GameData.instance.deaths++;
					case _: return;
				}
				header.updateHeader();
			});
			customer.setReaction(taste > objective * FlxG.random.float(0.8) ? LOVE : LIKE);
			customers.add(customer);
			add(customer);
		}

		add(header);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}