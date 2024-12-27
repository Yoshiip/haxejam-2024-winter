package sewers;

import encyclopedia.EncyclopediaButton;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import restaurant.RestaurantState;
import ui.Button;
import ui.CompleteBar;
import ui.Header;
import ui.Label;

class SewersHUD extends FlxGroup {
	private var inventoryText:Label;
	private var continueButton:Button;
	private var shootBar:CompleteBar;
	private var objectiveLabel:Label;
	private var root:SewersState;

	public function new(root:SewersState) {
		super();
		this.root = root;

		add(new Header(root, 'sewers'));

		inventoryText = new Label(16, 2, "");
		add(inventoryText);

		objectiveLabel = new Label(0, 40, "Catch 5 more items to continue");
		objectiveLabel.screenCenter(X);
		add(objectiveLabel);

		continueButton = new Button('Go to restaurant', () -> Utils.switchStateTo(new RestaurantState()));
		continueButton.visible = false;
		add(continueButton);

		shootBar = new CompleteBar('Strength', 'Click to release', -1, 64, 200, 32, root, 'shootStrength', 0.0, 1.0, false);
		add(shootBar);

		add(new EncyclopediaButton(root));
	}

	private function left() {
		return GameData.instance.inventorySize - GameData.instance.inventory.length;
	}

	public function updateHUD() {
		inventoryText.text = '${GameData.instance.inventory.length}/${GameData.instance.inventorySize}';
		objectiveLabel.text = root.isDone() ? "You've done enough fishing for today" : 'Catch ${left()} more items to continue';
		objectiveLabel.screenCenter(X);

		continueButton.visible = root.isDone();
		shootBar.visible = root.hook.state == AIM && !root.isDone();
	}

	public function calculateRecipe() {}
}