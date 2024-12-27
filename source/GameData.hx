import Item.ItemId;

class GameData {
	public static final instance:GameData = new GameData();

	public var day:Int = 0;
	public var level:Int = 0;
	public var xpLeft:Int = 0;
	public var inventory:Array<Item> = [];
	public var discoveredItems:Array<ItemId> = [];
	public var history:Array<ItemId> = [];
	public var inventorySize:Int = 5;
	public var taste:Int = 0;
	public var deaths:Int = 0;
	public var maxDeaths:Int = 3;

	// UPGRADES
	public var abyssLevel:Int = 0;

	public var TASTE_OBJECTIVE = [
		100, 200, 300, 450, 650, 850, 1100, 1400, 1700, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 6000, 7000, 8000, 9000, 10000, 11000, 12000
	];

	public function resetGame() {
		day = 0;
		level = 0;
		xpLeft = 100;
		inventory = [];
		inventorySize = 5;
		taste = 0;
	}

	private function new() {
		resetGame();
		inventory.push(ItemsData.instance.items[0]);
		inventory.push(ItemsData.instance.items[1]);
		inventory.push(ItemsData.instance.items[2]);
		inventory.push(ItemsData.instance.items[3]);
		inventory.push(ItemsData.instance.items[4]);
		inventory.push(ItemsData.instance.items[5]);
		inventory.push(ItemsData.instance.items[5]);
		inventory.push(ItemsData.instance.items[5]);
		inventory.push(ItemsData.instance.items[5]);
		inventory.push(ItemsData.instance.items[6]);
		inventory.push(ItemsData.instance.items[7]);
	}
}