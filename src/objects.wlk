import wollok.game.*

class Armas {
	const property imagenBalas = "sprites/weapons/balas.png"
	
	method municion() = null
	
	method danio() = null
	
	method agregarMunicion(cant) {}
	
	method usar() {}
	
	method recargar() = null
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
	
	override method usar() {
		municionUtilizable -= 1
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
	
	override method usar() {
		danio += municionBase
	}
	
	override method recargar() {
		return null
	}
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
	
	override method usar() {
		municionUtilizable -= 1
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
}

//Items de armas. Estas son los pickups de armas ubicables en el mapa
class Item {
	var property position = game.at(0,0)
	var tomado = false;
	
	method activar() {
		if (not tomado)
			game.addVisual(self)
	}
	method desactivar() {
		if (game.hasVisual(self)) 
			game.removeVisual(self)
	}
	method collide(p) {
		tomado = true;
		game.removeVisual(self)
	}
}

class ItemEspada inherits Item{
	method image() = "sprites/weapons/sword_normal.png"
}

class ItemFusil inherits Item{
	method image() = "sprites/weapons/fusil.png"
}

class ItemEscopeta inherits Item{
	method image() = "sprites/weapons/ShootGun_0.png"
}

class Curacion {	
	method efecto() = null
}

class BotiquinP inherits Curacion {
	const salud = 25
	
	override method efecto() = salud
}

class BotiquinM inherits Curacion {
	const salud = 50
	
	override method efecto() = salud
}

class BotiquinG inherits Curacion {
	const salud = 75
	
	override method efecto() = salud

}