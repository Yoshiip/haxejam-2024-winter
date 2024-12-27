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

	private var tasteBar:CompleteBar;

	private var root:RestaurantState;

	public function new(root:RestaurantState) {
		super();
		this.root = root;

		addBars();

		continueButton = new Button("Continue", continuePressed, -1, 400, 200, 32);
		continueButton.visible = false;
		add(continueButton);

		final recipeText = new Label(0, 120, 'Recipe', 28);
		recipeText.screenCenter(X);
		add(recipeText);

		final recipeHintText = new Label(0, 160, 'Choose the order in which you put your ingredients in the soup!');
		recipeHintText.screenCenter(X);
		add(recipeHintText);

		tooltip = new Tooltip();
		root.add(tooltip);

		add(new EncyclopediaButton(root));

		add(new Header(root, 'restaurant'));
	}

	private function addBars() {
		final centerX = FlxG.width / 2;
		final centerY = FlxG.height / 2;
		final spacing = 64;
		final width = 200;
		tasteBar = new CompleteBar('Taste', 'Objective: ${root.tasteObjective}', centerX - width, centerY, width, 32, root, 'taste', 0.0, root.tasteObjective);
		add(tasteBar);

	}

	public function updateHUD() {
		var allInside = true;
		root.slots.forEachAlive(function(slot:Slot) {
			if (slot.inside == null)
				allInside = false;
		});
		continueButton.visible = allInside;
	}

	private function continuePressed() {
		Utils.switchStateTo(new ServiceState());
	}
}