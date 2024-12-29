package restaurant;

import encyclopedia.EncyclopediaButton;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxSpriteUtil;
import service.ServiceState;
import ui.Button;
import ui.CompleteBar;
import ui.Header;
import ui.Label;

class RestaurantHUD extends FlxGroup {
	public var tooltip:Tooltip;

	private var playButton:Button;
	private var continueButton:Button;

	private var tasteLabel:Label;
	private var tasteBar:CompleteBar;

	private var root:RestaurantState;

	public function new(root:RestaurantState) {
		super();
		this.root = root;

		tasteBar = new CompleteBar('Taste', 'Objective: ${root.tasteObjective}', -1, 72, 200, 32, root, 'taste', 0.0, root.tasteObjective);
		add(tasteBar);

		tasteLabel = new Label(-1, 96, '');
		add(tasteLabel);

		continueButton = new Button("Continue", continuePressed, -1, 400, 200, 32);
		continueButton.visible = false;
		add(continueButton);

		tooltip = new Tooltip();
		root.add(tooltip);

		add(new EncyclopediaButton(root));

		add(new Header(root, 'restaurant'));
	}


	public function updateHUD() {
		var allInside = true;
		root.slots.forEachAlive(function(slot:Slot) {
			if (slot.inside == null)
				allInside = false;
		});
		continueButton.visible = allInside;
		tasteLabel.text = '${root.taste}';
	}


	private function continuePressed() {
		GameData.instance.taste = root.taste;
		root.slots.forEach((slot:Slot) -> {
			if (slot.inside != null)
				GameData.instance.history.push(slot.inside.item.id);
		});
		Utils.switchStateTo(new ServiceState());
	}
}