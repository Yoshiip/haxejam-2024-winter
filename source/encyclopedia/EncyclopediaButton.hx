package encyclopedia;

import flixel.FlxG;
import flixel.FlxState;
import ui.Button;

class EncyclopediaButton extends Button {
	public function new(state:FlxState) {
		super("Encyclopedia", () -> {
			state.openSubState(new EncyclopediaState(() -> {
				state.closeSubState();
			}));
		}, -1, FlxG.height - 80);
	}
}