import Item.ItemId;
import Item.ItemType;
import flixel.FlxG;
import lime.math.Vector2;

class ItemsData {
	public static final instance:ItemsData = new ItemsData();

	public var items:Array<Item>;
	public var unknownItem = new Item(NORMAL, UNKNOWN, 'Unknown Fish', "???", [8], 0, 0);

	final private function vecToInt(vectors:Array<Vector2>):Array<Int> {
		final intArray:Array<Int> = [];
		for (vector in vectors) {
			intArray.push(Std.int(vector.x) + Std.int(vector.y) * 8);
		}
		return intArray;
	}

	public function getItem(id:ItemId):Item {
		return items.filter((i:Item) -> i.id == id)[0];
	}

	private function new() {
		items = [];
		items.push(new Item(NORMAL, COMMON_FISH, 'Common Fish', "Adds 10 taste to the soup.", [0], 10, 0));
		items.push(new Item(NORMAL, RARE_FISH, 'Rare Fish', "Adds 20 taste to the soup.", [1], 20, 0));
		items.push(new Item(NORMAL, SALMON, 'Salmon', "Adds 30 taste to the soup.", [2], 30, 0));
		items.push(new Item(NORMAL, KOI, 'Koi', "Adds 15 taste, and 15 extra taste if added in an odd-numbered slot.", [13], 15, 0));
		items.push(new Item(SPECIAL, CATFISH, 'Catfish', "Adds 10 taste and doubles the effect of the next ingredient.", [6], 10, 1));
		items.push(new Item(SPECIAL, PUFFERFISH, 'Pufferfish', "Adds 5 taste and halves the effect of the previous ingredient.", [10], 5, 1));
		items.push(new Item(SPECIAL, PHANTOMFISH, 'Phantomfish', 'Repeats the effect of the previous item.', [15], 0, 1));
		items.push(new Item(TOXIC, BANANA, 'Banana Peel', "Removes 10 taste from the soup.", [3], -10, 1));
		items.push(new Item(TOXIC, CAN, 'Can', "Removes 20 taste from the soup.", [12], -20, 2));
		items.push(new Item(SPECIAL, CLOWNFISH, 'Clownfish', "Adds 10 taste and cancels the effect of the next ingredient.", [9], 10, 2));
		items.push(new Item(SPECIAL, PARSLEY, 'Parsley', "Adds 5 taste, and 30 extra taste if it's the last ingredient in the recipe.", [4], 5, 2));
		items.push(new Item(NORMAL, GOLDFISH, 'Goldfish', "Adds 10 taste, and 20 extra taste if added in an even-numbered slot.", [5], 10, 3));
		items.push(new Item(TOXIC, METAL_PIECE, 'Piece of Metal', "Removes 50 taste from the soup.", [14], -50, 3));
		items.push(new Item(SPECIAL, TRASHFISH, 'Trashfish', 'Add 50 taste if the previous item is trash, otherwise removes 25.', [7], 0, 4));
		items.push(new Item(SPECIAL, RAINBOWFISH, 'Rainbowfish', '+50% effect to all items.', [16], 0, 5));
		items.push(new Item(TOXIC, NUCLEAR_WASTE, 'Nuclear Waste', "Removes 150 taste from the soup.", [11], -150, 6));
	}


	private static final MAX_CONSTRAINTS:Map<ItemId, Int> = [
		COMMON_FISH => 2,
		RARE_FISH => 2,
		RAINBOWFISH => 2,
		TRASHFISH => 2,
		PARSLEY => 2,
		CATFISH => 2,
		NUCLEAR_WASTE => 2
	];

	private static final MAX_TYPES:Map<ItemType, Map<String, Int>> = [
		NORMAL => ['0' => 4, '4' => 5, '8' => 6,],
		SPECIAL => ['0' => 2, '2' => 3, '6' => 4],
		TOXIC => ['0' => 0, '1' => 1, '3' => 2, '5' => 3, '7' => 4,]
	];

	final public function generateBatch(day:Int):Array<Item> {
		var batch:Array<Item> = [];
		var counts:Map<ItemType, Int> = [NORMAL => 0, SPECIAL => 0, TOXIC => 0];

		function getMaxForType(itemType:ItemType):Int {
			var keys:Array<String> = [];
			for (key in MAX_TYPES[itemType].keys()) {
				keys.push(key);
			}

			keys.sort((a, b) -> Std.parseInt(a) - Std.parseInt(b));

			for (k in keys) {
				if (day < Std.parseInt(k))
					return MAX_TYPES[itemType][k];
			}

			return MAX_TYPES[itemType][keys[keys.length - 1]];
		}

		function canAddItem(item:Item):Bool {
			if (MAX_CONSTRAINTS.exists(item.id) && batch.filter(i -> i.id == item.id).length >= MAX_CONSTRAINTS[item.id])
				return false;
			return counts[item.type] < getMaxForType(item.type);
		}

		var eligibleItems = items.filter(item -> item.minDay <= day);

		var typeLimits:Map<ItemType, Int> = [
			NORMAL => getMaxForType(NORMAL),
			SPECIAL => getMaxForType(SPECIAL),
			TOXIC => getMaxForType(TOXIC)
		];

		for (type in [NORMAL, SPECIAL, TOXIC]) {
			var typeItems = eligibleItems.filter(item -> item.type == type).filter(item -> canAddItem(item));
			if (typeItems.length == 0)
				continue;
	
			while (counts[type] < typeLimits[type]) {
				var candidate = FlxG.random.getObject(typeItems);
				if (candidate != null) {
					batch.push(candidate);
					counts[type]++;
				} else {
					break;
				}
			}
		}

		return batch;
	}
}