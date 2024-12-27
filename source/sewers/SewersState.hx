package sewers;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class SewersState extends FlxState {
	public var items:FlxTypedGroup<FloatingItem>;

	private var hud:SewersHUD;
	private var caughtScreen:ItemCaughtScreen;
	private var line:FlxSprite;
	private var water:FlxSprite;

	public var hook:Hook;
	public var shootStrength:Float = 0.0;

	var total:Float = 0.0;

	public var magnet:Float = 128.0;

	public var hasFocus:Bool = true;

	public inline static final WATER_Y:Int = 200;
	public inline static final WATER_WIDTH:Int = 256;

	private final PLAYER_POINT = new FlxPoint(80, 80);

	public function isDone():Bool {
		return GameData.instance.inventorySize - GameData.instance.inventory.length <= 0;
	}

	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super.create();

		FlxG.sound.playMusic("assets/music/sewers.mp3");

		var background = new FlxSprite(0, 0);
		background.origin.set(0, 0);
		background.loadGraphic('assets/images/sewers.png');
		add(background);

		water = new FlxTiledSprite('assets/images/water.png', FlxG.width + WATER_WIDTH, FlxG.height, true, false);
		water.origin.set(0, 0);
		water.setPosition(-WATER_WIDTH, WATER_Y);
		water.scale.set(0.8, 0.8);
		water.alpha = 0.5;
		add(water);

		final ABYSS_Y = 320;
		add(new Abyss(ABYSS_Y));

		items = new FlxTypedGroup<FloatingItem>();
		var y = 240;
		var batch = ItemsData.instance.generateBatch(GameData.instance.day);
		for (item in batch) {
			var floatingItem = new FloatingItem(this, item, FlxG.random.float(0, FlxG.width), y, FlxG.random.bool() ? 1 : -1, y > ABYSS_Y);
			y += Std.int(300 / batch.length);
			items.add(floatingItem);
			add(floatingItem);
		}

		hud = new SewersHUD(this);
		add(hud);

		line = new FlxSprite();
		line.makeGraphic(FlxG.width, FlxG.height, 0, true);
		add(line);

		hook = new Hook(this, 32, 32);
		add(hook);

		caughtScreen = new ItemCaughtScreen(this);
		add(caughtScreen);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		total += elapsed;
		shootStrength = Math.abs(Math.cos(total * 2.0));

		water.x += elapsed * 2.0;
		if (water.x > 0)
			water.x -= WATER_WIDTH;
		water.y = 200 + Math.cos(total * 0.7) * 8.0;
		line.visible = hook.state != AIM;
		FlxSpriteUtil.fill(line, 0);

		if (hook.state != AIM) {
			FlxSpriteUtil.drawLine(line, PLAYER_POINT.x, PLAYER_POINT.y, hook.x, hook.y, {
				color: FlxColor.WHITE,
				thickness: 2,
			});
		}

		if (hasFocus && !isDone() && hook.state == AIM && FlxG.mouse.justPressed) {
			hook.state = SHOOT;
			hook.setPosition(32, 32);
			hook.velocity.set(1000 * shootStrength, -50);
			hud.updateHUD();
		}
	}

	public function itemCaught(floatingItem:FloatingItem) {
		final item = floatingItem.item;
		GameData.instance.inventory.push(item);
		if (!GameData.instance.discoveredItems.contains(item.id)) {
			GameData.instance.discoveredItems.push(item.id);
		}
		caughtScreen.showScreen(item);
		hud.updateHUD();
	}
}