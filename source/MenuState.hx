import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.net.URLRequest;
import ui.Button;

class MenuState extends FlxState {
	var playButton:Button;
	var aymeriSprite:FlxSprite;

	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super.create();

		FlxG.sound.playMusic('assets/music/calm.mp3');

		var background = new FlxSprite(0, 0);
		background.loadGraphic('assets/images/menu.png');
		background.origin.set(0, 0);
		background.scale.set(1 / 3, 1 / 3);
		add(background);

		final logo = new FlxSprite(0, -64);
		logo.loadGraphic("assets/images/raccoons_soup_logo.png");
		logo.scale.set(0.4, 0.4);
		logo.screenCenter(X);
		add(logo);

		playButton = new Button("Play", () -> {
			GameData.instance.resetGame();
			Utils.switchStateTo(new IntroState());
		});
		add(playButton);
		aymeriSprite = new FlxSprite(24, FlxG.height - 112);
		aymeriSprite.loadGraphic(AssetPaths.aymeri_100_logo__png);
		aymeriSprite.origin.set(0, 0);
		aymeriSprite.scale.set(0.1, 0.1);
		aymeriSprite.updateHitbox();
		add(aymeriSprite);

	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (aymeriSprite.overlapsPoint(FlxG.mouse.getPosition())) {
			aymeriSprite.alpha = 1.0;
			if (FlxG.mouse.justReleased) {
				Lib.getURL(new URLRequest("https://aymeri100.fr"), "_blank");
			}
		} else {
			aymeriSprite.alpha = 0.8;

		}
	}

}