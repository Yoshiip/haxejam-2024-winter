package service;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import restaurant.CookingPot;
import results.ResultsState;
import ui.Button;
import ui.Header;
import ui.Label;

class ServiceState extends FlxState {
	var customers:FlxTypedGroup<Customer>;
	var header:Header;
	var remaining = 0;
	var endDayButton:Button;

	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super.create();

		final background = new FlxSprite(0, 0);
		background.loadGraphic('assets/images/service.png');
		background.origin.set(0, 0);
		background.scale.set(1 / 3, 1 / 3);
		add(background);



		header = new Header(this, 'service');

		final helpLabel = new Label(-1, 80, 'Tap a customer to serve them.\nTap again to let the customer out and another in.');
		helpLabel.alignment = CENTER;
		add(helpLabel);
		final gameData = GameData.instance;
		
		gameData.customersServed += gameData.customers;
		remaining = gameData.customers;
		customers = new FlxTypedGroup<Customer>();
		for (i in 0...Std.int(Math.min(gameData.customers, 4))) {
			spawnCustomer(100 + i * 200);
		}
		add(customers);

		final desk = new FlxSprite(0, 0);
		desk.loadGraphic('assets/images/desk.png');
		desk.origin.set(0, 0);
		desk.scale.set(1 / 3, 1 / 3);
		add(desk);

		add(new Label(-1, 200, 'Taste: ${gameData.taste}', 28));
		add(new Label(-1, 240, 'Objective: ${gameData.getTasteObjective()}'));

		add(new CookingPot(200, 380));

		endDayButton = new Button('End Day', () -> {
			gameData.inventory = [];
			Utils.switchStateTo(new ResultsState());
		}, -1, FlxG.height - 80);
		endDayButton.visible = false;
		add(endDayButton);

		add(header);
	}

	private function spawnCustomer(x:Float) {
		remaining -= 1;
		final taste = GameData.instance.taste;
		final objective = GameData.instance.TASTE_OBJECTIVE[GameData.instance.day];
		final customer = new Customer(x + 200, 300, (customer:Customer) -> {
			if (customer.revealed) {
				customers.remove(customer, true);
				if (remaining > 0) {
					spawnCustomer(x);
				}
			} else {
				if (customer.like) {
					giveXp();
					if (customer.love)
						giveXp();
					FlxG.sound.play('assets/sounds/customer_like.wav', 0.5);
				} else {
					GameData.instance.customers--;
					FlxG.sound.play('assets/sounds/customer_dislike.wav', 0.5);
				}
				customer.revealed = true;
			}
			header.updateHeader();
		});
		customer.love = taste > objective * FlxG.random.float(1.2, 1.5);
		customer.setLike(taste > objective * FlxG.random.float(0.6));
		customers.add(customer);
	}

	public function giveXp() {
		GameData.instance.xpLeft -= 1;
		if (GameData.instance.xpLeft <= 0) {
			GameData.instance.level += 1;
			GameData.instance.xpLeft += GameData.instance.getXpTarget();
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		endDayButton.visible = customers.length == 0;
	}
}