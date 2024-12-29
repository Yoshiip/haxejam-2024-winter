package restaurant;

import flixel.FlxG;
import flixel.FlxSprite;
import ui.Label;

class DraggeableIngredient extends FlxSprite {
	public var item:Item;

	private var nameLabel:Label;
	private var hovered:Bool = false;
	private var onMouseOver:Void->Void;
	private var onMouseExit:Void->Void;

	public function new(item:Item, x:Float, y:Float, ?onMouseOver:Void->Void, ?onMouseExit:Void->Void) {
		super(x, y);
		this.item = item;
		this.onMouseOver = onMouseOver;
		this.onMouseExit = onMouseExit;

		setSize(16, 16);

		loadGraphic("assets/images/items.png", true, 128, 128);
		
		animation.add('default', item.animation, 6);
		animation.play('default');
	}

	private var total:Float;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		total += elapsed;
		if (overlapsPoint(FlxG.mouse.getPosition())) {
			if (!hovered) {
				hovered = true;
				if (onMouseOver != null) {
					FlxG.sound.play('assets/sounds/hover.wav', 0.05);
					onMouseOver();
				}
			}
			scale.set(1.0 + Math.cos(total * 4.0) * 0.2, 1.0 + Math.sin(total * 4.0) * 0.2);
		} else if (hovered) {
			hovered = false;
			scale.set(1.0, 1.0);
			if (onMouseExit != null)
				onMouseExit();
		}
		if (hovered) {
			scale.set(1.0 + Math.cos(total * 4.0) * 0.2, 1.0 + Math.sin(total * 4.0) * 0.2);
		}
	}
}