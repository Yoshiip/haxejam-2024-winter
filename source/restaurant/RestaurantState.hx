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
	public var toxicity:Int = 0;

	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super.create();

		taste = GameData.instance.taste;
		toxicity = GameData.instance.toxicity;
		tasteObjective = GameData.instance.TASTE_OBJECTIVE[GameData.instance.day];

		var background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.kitchen__png);
		background.origin.set(0, 0);
		background.scale.set(0.666, 0.666);
		add(background);

		FlxG.sound.playMusic(AssetPaths.cooking__mp3);

		pot = new CookingPot(FlxG.width / 2, FlxG.height / 2 - 32, 0.5);
		add(pot);

		this.addSlots(pot.x, pot.y);
		this.addIngredients();

		hud = new RestaurantHUD(this);
		add(hud);
		openSubState(new HelpSubState(() -> {
			closeSubState();
		},
			"Bienvenue dans votre cuisine! Ici vous allez devoir préparer vos plats pour vos clients de la journée. Disposez vos ingrédients dans les cases, et en fonction de l'ordre dans lequel vous les mettez le résultat sera différent. Expérimentez!"));

	}

	private function addSlots(potX:Float, potY:Float) {
		slots = new FlxTypedGroup<Slot>();
		final slotsCount = GameData.instance.inventorySize;
		final radius = slotsCount * 10 + 100;

		for (i in 0...slotsCount) {
			var angle = (Math.PI * 2 / (slotsCount + 1)) * i - Math.PI / 2;
			var slotX = potX + Math.cos(angle) * radius - Slot.SLOT_SIZE / 2;
			var slotY = potY + Math.sin(angle) * radius - Slot.SLOT_SIZE / 2;

			var slot = new Slot(this, slotX, slotY, i);
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
		slots.forEach((slot:Slot) -> slot.clearMultipliers());
		slots.forEach((slot:Slot) -> slot.calculateValues());
		slots.forEach((slot:Slot) -> slot.applyItemEffect());
		taste = GameData.instance.taste;
		toxicity = GameData.instance.toxicity;
		slots.forEach((slot:Slot) -> taste += slot.values.taste);
		slots.forEach((slot:Slot) -> toxicity += slot.values.toxicity);
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