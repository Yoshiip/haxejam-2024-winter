package results;

import end.EndState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import sewers.SewersState;
import ui.Header;
import ui.Label;

enum Phase {
	OVERVIEW;
	UNLOCK;
	OBJECTIVE;
}

enum UnlockType {
	ITEM;
	CUSTOMER;
	RADAR;
	RECIPE;
}

typedef Unlock = {
	type:UnlockType,
	data:Any,
}

class ResultsState extends FlxState {
	var overviewGroup:FlxTypedGroup<Label>;
	var unlocksGroup:FlxTypedGroup<FlxSprite>;
	var objectiveGroup:FlxTypedGroup<Label>;

	private var unlockIconSprite:FlxSprite;
	private var unlockTitleLabel:Label;
	private var unlockNameLabel:Label;
	private var unlockDescriptionLabel:Label;

	var newUnlocks:Array<Unlock> = [];

	var index:Int = 0;
	var phase:Phase = OVERVIEW;
	var gameOver:Bool = false;

	var newObjectiveLabel:Label;
	var titleObjectiveLabel:Label;

	public static final LEVEL_UP_REWARDS:Array<UnlockType> = [
		CUSTOMER, RECIPE, CUSTOMER, RADAR, CUSTOMER, RADAR, CUSTOMER, RECIPE, CUSTOMER, CUSTOMER, RADAR, CUSTOMER, RECIPE, RADAR, CUSTOMER, CUSTOMER, RECIPE,
		CUSTOMER, CUSTOMER, RADAR, RECIPE, RADAR, RADAR, RADAR,
	];

	var newLevelsCount:Int = 0;

	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super.create();

		GameData.instance.day += 1;

		add(new FlxSprite(0, 0, 'assets/images/transition.png'));

		FlxG.sound.playMusic('assets/music/calm.mp3');

		final centerY = FlxG.height / 2;
		gameOver = GameData.instance.customers <= 0;

		overviewGroup = new FlxTypedGroup();
		if (gameOver) {
			final overviewLabel = new Label(-1, -1,
				'Unfortunately, the overwhelming number of customers\nwho no longer like your soup means you have to close down.');
			overviewGroup.add(overviewLabel);
		} else {
			final overviewLabel = new Label(-1, -1, 'You\'ll have some of today\'s soup left over.\nYou decide to save it for tomorrow\'s soup.');
			overviewGroup.add(overviewLabel);
		}
		add(overviewGroup);

		newUnlocks = [];
		for (item in ItemsData.instance.items) {
			if (item.minDay == GameData.instance.day) {
				newUnlocks.push({
					type: ITEM,
					data: item,
				});
			}
		}

		newLevelsCount = GameData.instance.level - GameData.instance.lastLevelCheck;
		if (newLevelsCount != 0) {
			for (i in GameData.instance.lastLevelCheck...(GameData.instance.lastLevelCheck + newLevelsCount)) {
				if (i >= LEVEL_UP_REWARDS.length) {
					newUnlocks.push({
						type: CUSTOMER,
						data: i,
					});
					GameData.instance.customers++;
				} else {
					switch (LEVEL_UP_REWARDS[i]) {
						case CUSTOMER:
							GameData.instance.customers++;
						case RECIPE:
							GameData.instance.inventorySize++;
						case RADAR:
							GameData.instance.radar++;
						case _:
							return;
					}
					newUnlocks.push({
						type: LEVEL_UP_REWARDS[i],
						data: i,
					});
				}
			}
			GameData.instance.lastLevelCheck = GameData.instance.level;
		}

		final centerY = FlxG.height / 2;

		unlockTitleLabel = new Label(-1, 64, '', 32);
		unlockNameLabel = new Label(-1, centerY + 100, '', 32);
		unlockIconSprite = new FlxSprite(64, 64);
		unlockIconSprite.screenCenter();
		unlockDescriptionLabel = new Label(-1, centerY + 200, '', 32);

		unlocksGroup = new FlxTypedGroup();
		unlocksGroup.add(unlockTitleLabel);
		unlocksGroup.add(unlockNameLabel);
		unlocksGroup.add(unlockIconSprite);
		unlocksGroup.add(unlockDescriptionLabel);
		add(unlocksGroup);

		objectiveGroup = new FlxTypedGroup();
		titleObjectiveLabel = new Label(-1, centerY - 32, "NEW TASTE OBJECTIVE", 24);
		newObjectiveLabel = new Label(-1, centerY + 32, "000", 100);
		objectiveGroup.add(titleObjectiveLabel);
		objectiveGroup.add(newObjectiveLabel);
		add(objectiveGroup);

		add(new Header(this, 'results'));

		changePhaseTo(OVERVIEW);
	}

	private function showNextUnlock() {
		if (index > newUnlocks.length - 1) {
			changePhaseTo(OBJECTIVE);
			return;
		}
		FlxG.sound.play('assets/sounds/level_up.wav', 0.5);
		var titleText = '';
		var nameText = '';
		var descriptionText = '';
		var unlock = newUnlocks[index];
		unlockIconSprite.animation.reset();
		switch (unlock.type) {
			case ITEM:
				titleText = 'NEW ITEM IN THE SEWERS!';
				final item = cast(unlock.data, Item);
				nameText = item.name;
				descriptionText = item.description;
				unlockIconSprite.loadGraphic(AssetPaths.items__png, true, 128, 128);
				unlockIconSprite.animation.add('default', item.animation);
			case CUSTOMER:
				titleText = 'LEVEL UP (${Std.int(unlock.data) + 1})!';
				nameText = 'New customer';
				descriptionText = '';
				unlockIconSprite.loadGraphic(AssetPaths.ui__png, true, 128, 128);
				unlockIconSprite.animation.add('default', [7]);
			case RECIPE:
				titleText = 'LEVEL UP (${Std.int(unlock.data) + 1})!';
				nameText = 'Recipe';
				descriptionText = 'One more ingredient in the recipe';
				unlockIconSprite.loadGraphic(AssetPaths.ui__png, true, 128, 128);
				unlockIconSprite.animation.add('default', [8]);
			case RADAR:
				titleText = 'LEVEL UP (${Std.int(unlock.data) + 1})!';
				nameText = 'Radar';
				descriptionText = 'Allows you to see the type of one more fish in the sewers';
				unlockIconSprite.loadGraphic(AssetPaths.ui__png, true, 128, 128);
				unlockIconSprite.animation.add('default', [9]);
		}
		unlockTitleLabel.text = titleText;
		unlockNameLabel.text = nameText;
		unlockDescriptionLabel.text = descriptionText;
		unlockTitleLabel.screenCenter(X);
		unlockDescriptionLabel.screenCenter(X);
		unlockNameLabel.screenCenter(X);
		unlockIconSprite.animation.play('default');
		unlockIconSprite.screenCenter();
	}

	public function changePhaseTo(newPhase:Phase) {
		phase = newPhase;
		overviewGroup.visible = phase == OVERVIEW;
		unlocksGroup.visible = phase == UNLOCK;
		objectiveGroup.visible = phase == OBJECTIVE;
		switch (phase) {
			case OBJECTIVE:
				final gameData = GameData.instance;
				FlxTween.num(gameData.getTasteObjective(gameData.day - 1), gameData.getTasteObjective(gameData.day), 3, {
					onComplete: (_) -> {
						animationDone = true;
					}
				}, (value:Float) -> {
					newObjectiveLabel.text = '${Math.floor(value)}';
				},);
			case UNLOCK:
				showNextUnlock();
			case _:
				return;
		}
	}

	private var animationDone = false;

	private var total:Float = 0.0;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		total += elapsed * 4.0;
		switch (phase) {
			case OVERVIEW:
				if (FlxG.mouse.justReleased) {
					if (gameOver) {
						Utils.switchStateTo(new EndState());
					} else {
						changePhaseTo(UNLOCK);
					}
				}

			case UNLOCK:
				unlockIconSprite.scale.set(1.0 + Math.cos(total) * 0.2, 1.0 + Math.cos(total) * 0.2);
				unlockIconSprite.angle += elapsed * 10.0;
				if (FlxG.mouse.justReleased) {
					if (index >= newUnlocks.length - 1) {
						changePhaseTo(OBJECTIVE);
					} else {
						index++;
						showNextUnlock();
					}
				}
			case OBJECTIVE:
				if (FlxG.mouse.justReleased && animationDone) {
					Utils.switchStateTo(new SewersState());
				}
		}
	}
}