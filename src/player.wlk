import wollok.game.*
import world.*

class Player {
	var vida = 100
	var vivo = true
	var property position = game.at(1, 2)
	const property inventario = #{}
	
	method image() = "sprites/player/player_0.png"
	
	method ataque(arma) {
		if(inventario.contains(arma)){
		arma.usar()
		arma.municion()
		return arma.danio()
		}
		return false
	}
	
	method danio(cant) {
		vida -= cant
		
		if (vida <= 0) {
			self.morir()
		}
		return vida
	}
	
	method estaVivo() = vivo
	
	method morir() {
		vivo = false
		return vivo
	}
	
	method move(dir){
		if (dir == 0) position = position.up(1)
		if (dir == 1) position = position.right(1)
		if (dir == 2) position = position.down(1)
		if (dir == 3) position = position.left(1)
		
		var col = game.colliders(self)
		col.forEach({col =>
			if (col.toString() == "un/a  Puerta") {
				var d = col.direction()
				position = col.playerPos()
				world.cambiarHabitacionAdyacente(d)
			}
			
			console.println(col.toString())
		})
	}
	
	method initialize() {
		keyboard.up().onPressDo({self.move(0)})
		keyboard.right().onPressDo({self.move(1)})
		keyboard.down().onPressDo({self.move(2)})
		keyboard.left().onPressDo({self.move(3)})
	}

	method encontrarArma(arma) {
		if (inventario.contains(arma)) arma.agregarMunicion(arma.municionBase())
		inventario.add(arma)
	}
}

class Armas {
	method municion() = null
	
	method danio() = null
}

class Escopeta inherits Armas {
	const property municionBase = 5
	var municion = 5
	const danio = 20
	
	override method municion() = municion
	
	override method danio() = danio
	
	method agregarMunicion(cant) {
		municion += cant
	}
	
	method usar() {
		municion -= 1
	}
}

class Espada inherits Armas {
	const property municionBase = 0
	var danio = 5
	
	override method municion() = null
	
	override method danio() = danio
	
	method agregarMunicion(cant) {
		danio += cant
	}
	
	method usar() {
		danio += municionBase
	}
}

class Fusil inherits Armas {
	const property municionBase = 14
	var municion = 14
	const danio = 10
	
	override method municion() = municion
	
	override method danio() = danio
	
	method agregarMunicion(cant) {
		municion += cant
	}
	
	method usar() {
		municion -= 1
	}	
}

class Automatica inherits Armas {
	const property municionBase = 30
	var municion = 30
	const danio = 15

	override method municion() = municion
	
	override method danio() = danio
	
	method agregarMunicion(cant) {
		municion += cant
	}
	
	method usar() {
		municion -= 1
	}
}
