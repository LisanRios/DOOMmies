import wollok.game.*

object gui {
	var property player = null
	
	var healthLabel = new guiLabel()
	
	method init() {
		game.addVisual(healthLabel)
		game.addVisual(caraGui)
		game.onTick(50, "UpdateGuiEvent", {=> self.update()})
	}
	
	method update() {
		healthLabel.update(player.vida())
	}
}

object caraGui {
	var property position = game.at(0,0)
	var img = "ui/cara_mid.png"
	
	method image() = img
}

class guiLabel {
	var property position = game.at(1,0)
	var txt = "TEST"
	
	method text() = txt
	method update(t) {
		txt = t.toString()
	}
}

class guiLabelNumberDigit {
	
}