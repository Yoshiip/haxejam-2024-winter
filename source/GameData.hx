import Item.ItemId;
import flixel.FlxG;

class GameData {
	public static final instance:GameData = new GameData();

	public var day:Int = 0;
	public var level:Int = 0;
	public var lastLevelCheck:Int = 0;
	public var xpLeft:Int = 0;
	public var inventory:Array<Item> = [];
	public var discoveredItems:Array<ItemId> = [];
	public var history:Array<ItemId> = [];
	public var inventorySize:Int = 5;
	public var taste:Int = 0;
	public var customers:Int = 3;
	public var customersServed:Int = 0;
	public var radar:Int = 3;

	// UPGRADES
	public var abyssLevel:Int = 0;

	public var TASTE_OBJECTIVE = [
		25, 50, 100, 200, 300, 400, 500, 650, 800, 1000, 1250, 1500, 1800, 2100, 2400, 2700, 3000, 3300, 3600, 3900, 4200, 4500, 5000, 5500, 6000, 6500, 7000,
		7500, 8000, 8500, 9000, 9500, 10000, 11000, 12000, 13000, 14000, 15000, 16000, 17000, 18000, 19000, 20000, 22000, 24000, 26000, 28000, 30000, 40000,
		50000, 60000, 70000, 80000, 90000, 100000
	];

	public function resetGame() {
		day = 0;
		level = 0;
		lastLevelCheck = 0;
		xpLeft = 1;
		inventory = [];
		discoveredItems = [];
		history = [];

		inventorySize = 5;
		taste = 0;
		customers = 3;
		customersServed = 0;
		radar = 3;
	}

	public function getXpTarget():Int {
		return level + 1;
	}

	public function getTasteObjective(targetDay:Int = -1) {
		if (targetDay == -1)
			targetDay = day;
		if (targetDay > TASTE_OBJECTIVE.length)
			return FlxG.random.int(100000, 1000000);
		return TASTE_OBJECTIVE[targetDay];
	}

	private function new() {
		resetGame();
		// inventory.push(ItemsData.instance.getItem(PHANTOMFISH));
		// inventory.push(ItemsData.instance.getItem(PHANTOMFISH));
		// inventory.push(ItemsData.instance.getItem(NUCLEAR_WASTE));
		// inventory.push(ItemsData.instance.getItem(TRASHFISH));
		// inventory.push(ItemsData.instance.getItem(CATFISH));
		// inventory.push(ItemsData.instance.getItem(RAINBOWFISH));
		// inventory.push(ItemsData.instance.getItem(CLOWNFISH));
		// inventory.push(ItemsData.instance.getItem(PUFFERFISH));
		// inventory.push(ItemsData.instance.getItem(RAINBOWFISH));
		// inventory.push(ItemsData.instance.getItem(PARSLEY));
		// inventory.push(ItemsData.instance.getItem(CAN));
		
	}
}