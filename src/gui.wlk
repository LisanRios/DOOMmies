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
		healthLabel.update("SALUD: " + player.vida().toString() + "\nARMADURA: " + player.armadura().toString())
	}
}

object caraGui {
	var property position = game.at(0,0)
	var img = "ui/cara_mid.png"
	
	method initialize() {
		game.schedule(250.randomUpTo(1000), {=> self.randFace()})
	}
	
	method image() = img
	
	method randFace() {
		img = ["ui/cara_der.png", "ui/cara_mid.png", "ui/cara_izq.png"].get(0.randomUpTo(2))
		game.schedule(250.randomUpTo(1000), {=> self.randFace()})
	}
	
	method collide(p) {}
}

class guiLabel {
	var property position = game.at(2,0)
	var txt = "TEST"
	
	method text() = txt
	method textColor() = "FFFFFFFF"
	method update(t) {
		txt = t
	}
	
	method collide(p) {}
}

class guiLabelNumberDigit {
	
}

