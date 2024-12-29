package end;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import restaurant.DraggeableIngredient;
import ui.Button;
import ui.Label;

class EndState extends FlxState {
	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

		add(new FlxSprite(0, 0, 'assets/images/transition.png'));

		super.create();
		add(new Label(-1, 16, "BANKRUPTCY :(", 64));
		add(new MovingNumber(200, 100, "Day", GameData.instance.day));
		add(new MovingNumber(500, 100, "Final Taste", GameData.instance.taste));
		add(new MovingNumber(800, 100, "Customers Served", GameData.instance.customersServed));
		add(new Label(-1, 180, "Everything you put in the soup:", 24));
		
		// for (i in 0...7) {
		// 	GameData.instance.history = GameData.instance.history.concat(ItemsData.instance.generateBatch(10).map(f -> f.id));
		// }

		var nbItems = GameData.instance.history.length;

		final menuButton = new Button("Menu", () -> {
			Utils.switchStateTo(new MenuState());
		}, -1, FlxG.height - 36);
		menuButton.visible = false;
		add(menuButton);


		var scaleMultiplier = 0.8;
		if(nbItems > 30) {
			scaleMultiplier = 0.5;
		}
		if(nbItems > 120) {
			scaleMultiplier = 0.25;
		}
	
		
		final timer = new FlxTimer();
		var i = 0;
		final spacing = 8;
		timer.start(0.1, (_) -> {
			if (i >= nbItems) {
				timer.cancel();
				menuButton.visible = true;
			} else {
				final itemsPerRow = Math.floor(FlxG.width / (((128) * scaleMultiplier)+spacing));
				final x = spacing + (i % itemsPerRow) * (128 * scaleMultiplier);
				final y = 256 + Math.floor(i / itemsPerRow) * (128 * scaleMultiplier);

				final item = ItemsData.instance.getItem(GameData.instance.history[i]);
				final sprite = new FlxSprite(x, y);
				sprite.loadGraphic("assets/images/items.png", true, 128, 128);
				sprite.alpha = 0.0;
				sprite.angle = FlxG.random.float(-1.0, 1.0) * 90.0;
				FlxTween.tween(sprite, { alpha: 1, angle: 0.0 }, 1.0);
				sprite.scale.set(scaleMultiplier, scaleMultiplier);
				sprite.updateHitbox();
				sprite.animation.add('default', item.animation, 6);
				
				sprite.animation.play('default');
				add(sprite);
				i++;
			}
		}, 0);

	}
}
