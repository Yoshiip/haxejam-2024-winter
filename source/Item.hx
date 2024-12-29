package;

class Item {
	public var type:ItemType;
	public var id:ItemId;
	public var name:String;
	public var description:String;
	public var animation:Array<Int>;
	public var baseTaste:Int = 0;
	public var minDay:Int = 0;

	public function new(type:ItemType, id:ItemId, name:String, description:String, animation:Array<Int>, baseTaste:Int = 10, minDay:Int = 0) {
		this.type = type;
		this.id = id;
		this.name = name;
		this.description = description;
		this.animation = animation;
		this.baseTaste = baseTaste;
		this.minDay = minDay;
	}
}

enum ItemType {
	NORMAL;
	SPECIAL;
	TOXIC;
}

enum ItemId {
	UNKNOWN;
	COMMON_FISH;
	RARE_FISH;
	SALMON;
	KOI;
	CATFISH;
	PUFFERFISH;
	CLOWNFISH;
	PARSLEY;
	PHANTOMFISH;
	TRASHFISH;
	RAINBOWFISH;
	BANANA;
	CAN;
	GOLDFISH;
	METAL_PIECE;
	NUCLEAR_WASTE;
}