class Armas {
	var municion
	const property imagenBalas = "..\assets\sprites\weapons\balas.png"
	
	method municion() = null
	
	method danio() = null
	
	method agregarMunicion(cant) {
		municion += cant
	}
	
	method usar() {
		municion -= 1
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
	
	override method usar() {
		municionUtilizable -= 1
	}
	
	method recargar() {
		municionDisponible -= (municionBase - municionUtilizable)
		municionUtilizable += (municionBase - municionUtilizable)
		return municionUtilizable	
	}
}

class Espada inherits Armas {
	const property municionBase = 0
	var danio = 5
	
	override method municion() = null
	
	override method danio() = danio
	
	override method agregarMunicion(cant) {
		danio += cant
	}
	
	override method usar() {
		danio += municionBase
	}
	
	method recargar() {
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
	
	method recargar() {
		municionDisponible -= (municionBase - municionUtilizable)
		municionUtilizable += (municionBase - municionUtilizable)
		return municionUtilizable
	}
}

class Automatica inherits Armas {
	const property municionBase = 30
	var municionDisponible = 0
	var municionUtilizable = 30
	const danio = 15

	override method municion() = municionDisponible
	
	override method danio() = danio
	
	override method agregarMunicion(cant) {
		municionDisponible += cant
	}
	
	override method usar() {
		municionUtilizable -= 1
	}
	
	method recargar() {
		municionDisponible -= (municionBase - municionUtilizable)
		municionUtilizable += (municionBase - municionUtilizable)
		return municionUtilizable
	}
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

