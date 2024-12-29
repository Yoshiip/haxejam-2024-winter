package restaurant;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import ui.Label;

class RestaurantState extends FlxState {
	private var pot:CookingPot;
	private var hud:RestaurantHUD;

	public var ingredients:FlxTypedGroup<DraggeableIngredient>;
	public var slots:FlxTypedGroup<Slot>;
	public var dragging:DraggeableIngredient;

	private var baseDrag:FlxPoint;

	public var taste:Int = 0;
	public var tasteObjective:Int = 100;

	private static final MESSAGE = "Welcome to your kitchen!\nHere you'll have to prepare your dishes for the day's customers.\nArrange your ingredients in the boxes and depending\non the order in which you put them the result will be different.\n\nExperiment!";

	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super.create();

		taste = GameData.instance.taste;
		tasteObjective = GameData.instance.TASTE_OBJECTIVE[GameData.instance.day];

		var background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.kitchen__png);
		background.origin.set(0, 0);
		background.scale.set(0.666, 0.666);
		add(background);

		FlxG.sound.playMusic(AssetPaths.cooking__mp3, 0.5);

		final potX = FlxG.width / 2;
		final potY = FlxG.height / 2 + 200;
		pot = new CookingPot(potX - 150, potY - 100);
		add(pot);

		this.addSlots();
		this.addIngredients();

		hud = new RestaurantHUD(this);
		add(hud);
		if (GameData.instance.day == 0)
			openSubState(new HelpSubState(closeSubState, MESSAGE));

	}

	private function addSlots() {
		slots = new FlxTypedGroup<Slot>();
		final slotsCount = GameData.instance.inventorySize;
		final width = (Slot.SLOT_SIZE * 1.25);
		final totalWidth = width * slotsCount;
		final startX = (FlxG.width - totalWidth) / 2;
	
		for (i in 0...slotsCount) {
			var slotX = startX + i * width;
	
			var slot = new Slot(this, slotX, 220, i);
			slots.add(slot);
			add(slot);
		}
	}


	private final itemsHovered:Array<Item> = [];

	private function addIngredients() {
		ingredients = new FlxTypedGroup<DraggeableIngredient>();
		final center = FlxG.width / 2;
		final safeAreaWidth = 232;
		for (item in GameData.instance.inventory) {
			var x = 0.0;

			if (FlxG.random.bool()) {
				x = FlxG.random.float(center + safeAreaWidth, FlxG.width - 90);
			} else {
				x = FlxG.random.float(24, center - safeAreaWidth);
			}
			var ingredient = new DraggeableIngredient(item, x, FlxG.random.float(0, FlxG.height - 128), () -> {
				if (!itemsHovered.contains(item)) {
					itemsHovered.push(item);
					hud.tooltip.showTooltip(itemsHovered[0]);
				}
			}, () -> {
				removeHovered(item);
			});
			ingredients.add(ingredient);
			add(ingredient);
		}
	}

	private function removeHovered(item:Item) {
		if (dragging != null && dragging.item == item)
			return;
		if (itemsHovered.contains(item)) {
			itemsHovered.remove(item);
		}
		if (itemsHovered.length == 0) {
			hud.tooltip.hideTooltip();
		} else {
			hud.tooltip.showTooltip(itemsHovered[0]);
		}
	}

	private function recipeChanged() {
		slots.forEach((slot:Slot) -> slot.reset());
		slots.forEach((slot:Slot) -> slot.applyInsideEffect());
		slots.forEach((slot:Slot) -> slot.calculateFinalValue());
		taste = GameData.instance.taste;
		slots.forEach((slot:Slot) -> taste += slot.taste);
		hud.updateHUD();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (dragging != null) {
			Utils.smoothMove(dragging, FlxG.mouse.getPosition() - baseDrag, elapsed);

			if (!FlxG.mouse.pressed) {
				slots.forEachAlive(function(slot:Slot) {
					if (slot.inside == null && slot.frame.overlapsPoint(FlxG.mouse.getPosition())) {
						slot.inside = dragging;
						dragging.x = slot.frame.x - 12;
						dragging.y = slot.frame.y - 12;
						recipeChanged();
					}
				});
				final item = dragging.item;
				dragging = null;
				removeHovered(item);
			}
		} else {
			ingredients.forEachAlive(function(ingredient:DraggeableIngredient) {
				if (FlxG.mouse.pressed && ingredient.overlapsPoint(FlxG.mouse.getPosition())) {
					dragging = ingredient;
					slots.forEach(function(slot:Slot) {
						if (slot.inside == dragging) {
							slot.inside = null;
							recipeChanged();
						}
					});
					baseDrag = new FlxPoint(FlxG.mouse.x - dragging.x, FlxG.mouse.y - dragging.y);
				}
			});
		}
	}

	public function getSlot(number:Int):Slot {
		if (number < 0 || number >= slots.length)
			return null;
		final matchedSlot = slots.getFirst((slot:Slot) -> return slot.number == number);

		return matchedSlot;
	}
}