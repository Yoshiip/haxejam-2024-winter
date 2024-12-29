package sewers;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import ui.Button;

class SewersState extends FlxState {
	public var items:FlxTypedGroup<FloatingItem>;

	public var hud:SewersHUD;
	private var caughtScreen:ItemCaughtScreen;
	private var line:FlxSprite;
	private var water:FlxSprite;

	public var hook:Hook;
	public var shootStrength:Float = 0.0;
	private final ABYSS_Y = 320;
	private var ui:FlxTypedGroup<Button>;

	var total:Float = 0.0;

	public var magnet:Float = 128.0;

	public var hasFocus:Bool = true;

	public inline static final WATER_Y:Int = 200;
	public inline static final WATER_WIDTH:Int = 256;

	private final PLAYER_POINT = new FlxPoint(258, 70);

	public var bubbles:FlxTypedGroup<Bubble>;

	public function isDone():Bool {
		return GameData.instance.inventorySize - GameData.instance.inventory.length <= 0;
	}

	private static inline final MESSAGE = "You are currently in the sewers, searching for wonders to add to your soup.\nUse your fishing rod to catch fish.\nUnfortunately, the city sewers are very dirty and contain more than just fish...\nBeing somewhat of a hoarder, everything you catch\nwill inevitably end up in the soup, one way or another.";

	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super.create();

		if (GameData.instance.day == 0)
			openSubState(new HelpSubState(closeSubState, MESSAGE));

		FlxG.sound.playMusic(AssetPaths.sewers__mp3, 0.6);

		var background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.sewers__png);
		background.origin.set(0, 0);
		background.scale.set(1 / 3, 1 / 3);
		add(background);

		var player = new FlxSprite(188, 48);
		player.loadGraphic(AssetPaths.player__png);
		player.origin.set(0, 0);
		player.scale.set(0.17, 0.17);
		add(player);

		water = new FlxTiledSprite(AssetPaths.water__png, FlxG.width + WATER_WIDTH, FlxG.height, true, false);
		water.origin.set(0, 0);
		water.setPosition(-WATER_WIDTH, WATER_Y);
		water.scale.set(0.8, 0.8);
		water.alpha = 0.9;
		add(water);

		add(new Abyss(ABYSS_Y));

		bubbles = new FlxTypedGroup();
		add(bubbles);

		spawnItems();

		hud = new SewersHUD(this);
		add(hud);

		ui = new FlxTypedGroup();
		ui.add(hud.encyclopediaButton);
		line = new FlxSprite();
		line.makeGraphic(FlxG.width, FlxG.height, 0, true);
		add(line);

		hook = new Hook(this, 32, 32);
		add(hook);


		caughtScreen = new ItemCaughtScreen(this);
		add(caughtScreen);
		hud.updateHUD();
	}

	private function spawnItems() {
		items = new FlxTypedGroup<FloatingItem>();
		var y = 240;
		var batch = ItemsData.instance.generateBatch(GameData.instance.day);
		Utils.shuffle(batch);
		var i = 0;
		for (item in batch) {
			var floatingItem = new FloatingItem(this, item, FlxG.random.float(0, FlxG.width), y, FlxG.random.bool() ? 1 : -1, i >= GameData.instance.radar);
			y += Std.int(400 / batch.length);
			items.add(floatingItem);
			add(floatingItem);
			i++;
		}
	}

	public function spawnBubble(x:Float, y:Float) {
		final bubble = new Bubble(x, y);

		bubbles.add(bubble);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		total += elapsed;
		shootStrength = Math.abs(Math.cos(total * 3.0));

		bubbles.forEach((bubble:Bubble) -> {
			if (bubble.y < WATER_Y + 100) {
				bubbles.remove(bubble, true);
			}
		});

		water.x += elapsed * 2.0;
		if (water.x > 0)
			water.x -= WATER_WIDTH;
		water.y = 200 + Math.cos(total * 0.7) * 8.0;
		line.visible = hook.state != AIM;
		FlxSpriteUtil.fill(line, 0);


		if (hook.state != AIM) {
			FlxSpriteUtil.drawLine(line, PLAYER_POINT.x, PLAYER_POINT.y, hook.x + 8, hook.y + 8, {
				color: FlxColor.WHITE,
				thickness: 2,
			});
		}

		var mouseOnUi = false;
		ui.forEachAlive((el:Button) -> {
			if (el.background.overlapsPoint(FlxG.mouse.getPosition()))
				mouseOnUi = true;
		});
		if (!mouseOnUi && hasFocus && !isDone() && hook.state == AIM && FlxG.mouse.justPressed) {
			hook.state = SHOOT;
			hook.setPosition(PLAYER_POINT.x, PLAYER_POINT.y);
			hook.velocity.set(Math.max(Hook.MAX_SPEED * shootStrength, 100), -50);
			hud.updateHUD();
		}
	}

	public function itemCaught(floatingItem:FloatingItem) {
		final item = floatingItem.item;
		GameData.instance.inventory.push(item);
		if (!GameData.instance.discoveredItems.contains(item.id)) {
			GameData.instance.discoveredItems.push(item.id);
		}
		FlxG.sound.play('assets/sounds/got_fish.wav', 0.5);
		caughtScreen.showScreen(item);
		hud.updateHUD();
	}
}