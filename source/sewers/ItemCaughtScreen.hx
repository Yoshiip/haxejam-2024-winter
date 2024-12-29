package sewers;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import ui.Label;

class ItemCaughtScreen extends FlxTypedGroup<FlxSprite> {
	private var background:FlxSprite;
	private var itemSprite:FlxSprite;
	private var itemNameLabel:Label;
	private var itemDescriptionLabel:Label;
	private var topLabel:Label;
	private var closeLabel:Label;
	private var root:SewersState;

	public function new(root:SewersState) {
		super();

		this.root = root;

		background = new FlxSprite(0, 0);
		background.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.alpha = 0.5;
		add(background);

		final centerY = FlxG.height / 2.0;

		itemSprite = new FlxSprite();
		itemSprite.loadGraphic(AssetPaths.items__png, true, 128, 128);
		itemSprite.screenCenter();
		add(itemSprite);

		itemNameLabel = new Label(-1, centerY + 32, '', 48);
		itemNameLabel.autoSize = false;
		itemNameLabel.alignment = CENTER;
		itemNameLabel.fieldWidth = 480;
		add(itemNameLabel);

		itemDescriptionLabel = new Label(-1, centerY + 96, '', 24);
		itemDescriptionLabel.autoSize = false;
		itemDescriptionLabel.alignment = CENTER;
		itemDescriptionLabel.fieldWidth = 400;
		itemDescriptionLabel.alpha = 0.8;
		add(itemDescriptionLabel);

		topLabel = new Label(-1, 64, 'Congratulations!', 24);
		add(topLabel);

		closeLabel = new Label(-1, FlxG.height - 100, '(click to close)');
		closeLabel.alpha = 0.5;
		add(closeLabel);

		visible = false;
	}

	private var alpha:Float = 0.5;

	function updateAlpha(alpha:Float) {
		this.alpha = alpha;
		forEach(function(sprite) sprite.alpha = alpha);
		background.alpha = alpha / 2.0;
	}

	public function showScreen(item:Item) {
		itemNameLabel.text = item.name;
		itemDescriptionLabel.text = item.description;
		itemSprite.animation.destroyAnimations();
		itemSprite.animation.add('default', item.animation, 2);
		itemSprite.animation.play('default');
		root.hasFocus = false;

		itemNameLabel.screenCenter(X);
		itemDescriptionLabel.screenCenter(X);
		topLabel.screenCenter(X);

		closing = false;
		visible = true;
		FlxTween.num(0, 1, .66, {ease: FlxEase.circOut}, updateAlpha);
	}

	private var total:Float;
	private var closing:Bool = false;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (visible) {
			total += elapsed;
			if (FlxG.mouse.justReleased && !closing) {
				closing = true;
				FlxTween.num(1, 0, .66, {
					ease: FlxEase.circOut,
					onComplete: (_) -> {
						visible = false;
						root.hasFocus = true;
					}
				}, updateAlpha);
			}
			closeLabel.alpha = 0.7 + Math.cos(total) * 0.2;
			closeLabel.y = FlxG.height - 100 + Math.cos(total) * 10;
			itemSprite.scale.set(1.0 + Math.cos(total) * 0.2, 1.0 + Math.cos(total) * 0.2);
		}
	}
}