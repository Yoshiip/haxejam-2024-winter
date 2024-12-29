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
	private var continueButton:Button;
	private var shootBar:CompleteBar;
	private var objectiveLabel:Label;
	private var root:SewersState;
	private var header:Header;

	public var encyclopediaButton:Button;

	public function new(root:SewersState) {
		super();
		this.root = root;
		header = new Header(root, 'sewers');
		add(header);


		objectiveLabel = new Label(0, 40, "Catch 5 more items to continue");
		objectiveLabel.screenCenter(X);
		add(objectiveLabel);

		continueButton = new Button('Go to restaurant', () -> Utils.switchStateTo(new RestaurantState()));
		continueButton.visible = false;
		add(continueButton);

		shootBar = new CompleteBar('Strength', 'Click to release', -1, 64, 200, 32, root, 'shootStrength', 0.0, 1.0, false);
		add(shootBar);

		encyclopediaButton = new EncyclopediaButton(root);
		add(encyclopediaButton);
	}

	private function left() {
		return GameData.instance.inventorySize - GameData.instance.inventory.length;
	}

	public function updateHUD() {
		objectiveLabel.text = root.isDone() ? "You've done enough fishing for today" : 'Catch ${left()} more items to continue';
		objectiveLabel.screenCenter(X);

		continueButton.visible = root.isDone();
		shootBar.visible = root.hook.state == AIM && !root.isDone();
		header.updateHeader();
	}

	public function calculateRecipe() {}
}