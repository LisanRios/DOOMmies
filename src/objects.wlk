import wollok.game.*
import world.*

class Armas {
	
	
	var property position = game.at(0,0)
	var property tomado = false;
	
	method municion() = null
	
	method danio() = null
	
	method agregarMunicion(cant) {}
	
	method usar(posicion) {}
	
	method recargar() = null
	
	
	
	method activar() {
		if (not game.hasVisual(self))
			game.addVisual(self)
	}
	method desactivar() {
		if (game.hasVisual(self)) 
			game.removeVisual(self)
	}
	method collide(p) {
		tomado = true;
		game.removeVisual(self)
		world.removeObjetoHabitacionActual(self)
		p.dropArmaEquipada()
		p.armaEquipada(self)
	}
}

class Escopeta inherits Armas {
	const property municionBase = 5
	var municionDisponible = 0
	var municionUtilizable = 5
	const danio = 20
	
	override method municion() = municionDisponible
	
	override method danio() = danio
	
	override method agregarMunicion(cant) {
		municionDisponible += cant
	}
	

	
	override method usar(posicion) {
		var municion = new Bala()
		municion.position(posicion)
		game.addVisual(municion) 
		game.onTick(3, "tiroEscopeta", { => municion.moverBala(posicion) })
		//municionUtilizable -= 1
	}
	
	override method recargar() {
		if (municionDisponible - municionUtilizable < 0) {
			municionUtilizable += municionDisponible
			municionDisponible = 0
			return municionUtilizable
		}
		else {
			municionDisponible -= (municionBase - municionUtilizable)
			municionUtilizable += (municionBase - municionUtilizable)
			return municionUtilizable	
		}
	}
	
	method image() = "sprites/weapons/ShootGun_0.png"
}

class Espada inherits Armas {
	const property municionBase = 0
	var municionUtilizable = 5
	var danio = 5
	
	override method municion() = null
	
	override method danio() = danio
	
	override method agregarMunicion(cant) {
		danio += cant
	}
	
	override method usar(posicion) {
	
		danio += municionBase
	}
	
	override method recargar() {
		return null
	}
	
	method image() = "sprites/weapons/sword_normal.png"
}

class Fusil inherits Armas {
	const property municionBase = 14
	var municionDisponible = 0
	var municionUtilizable = 14
	const danio = 10
	
	override method municion() = municionDisponible
	
	override method danio() = danio
	
	override method agregarMunicion(cant) {
		municionDisponible += cant
	}
	
	
	override method usar(posicion) {
		var municion = new Bala()
		municion.position(posicion)
		game.addVisual(municion) 
		game.onTick(3, "tiroEscopeta", { => municion.moverBala(posicion) })
		//municionUtilizable -= 1
	}
	
	override method recargar() {
		if (municionDisponible - municionUtilizable < 0) {
			municionUtilizable += municionDisponible
			municionDisponible = 0
			return municionUtilizable
		}
		else {
			municionDisponible -= (municionBase - municionUtilizable)
			municionUtilizable += (municionBase - municionUtilizable)
			return municionUtilizable	
		}
	}
	
	method image() = "sprites/weapons/fusil.png"
}

class Bala {
	const property image = "sprites/weapons/balas.png"
	
	var property position = game.at(0,0)
	
	method moverBala(posicion) {
		position = position.right(1)
		if (position.x() == 5 ){
			game.removeVisual(self)
		} 
	}
}

class Curacion {	
	method efecto() = null
}

class BotiquinP inherits Curacion {
	const salud = 25
	
	override method efecto() = salud
	
	method image() = "sprites/healing/botiquin0.png"
}

class BotiquinM inherits Curacion {
	const salud = 50
	
	override method efecto() = salud
	
	method image() = "sprites/healing/botiquin1.png"
}

class BotiquinG inherits Curacion {
	const salud = 75
	
	override method efecto() = salud

	method image() = "sprites/healing/botiquin2.png"
}