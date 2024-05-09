import wollok.game.*
import world.*

class Player {
	var vida = 100
	var vivo = true
	var flag = 0
	var property position = game.at(1, 2)
	const property inventario = #{}
	const property equipado = #{}
	
	method image() = "sprites/player/player_0.png"

	method encontrarArma(arma) {
		if (inventario.contains(arma)) arma.agregarMunicion(arma.municionBase())
		inventario.add(arma)
	}
	
	method encontrarCuracion(curacion) {
		flag += 1
		inventario.add(curacion)
	}
	
	method ataque(arma) {
		if(inventario.contains(arma)){
			arma.usar()
			arma.municion()
			return arma.danio()
		}
		return false
	}
	
	method recargar(arma) = arma.recargar()
	
	method danio(cant) {
		vida -= cant
		
		if (vida <= 0) {
			self.morir()
		}
		return vida
	}
	
	method curacion(curacion) {
		if(inventario.contains(curacion)) {
			if (vida + curacion.efecto() > 100) vida += (100 - vida)
			else vida += curacion.efecto()
			flag -=1
			if (flag < 0) flag = 0
			if (flag == 0) inventario.remove(curacion)
			return vida
		}
		return false
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
	
	method equip(dir) { //aca no supe como hacer que rquipe o desequipe un objeto xd 
						//(mas que nada pensaba hacer que cambie de arma con un boton tipo gta sa)
		if (dir == 1) equipado.add()
		if (dir == 2) equipado.add()
	}
	
	method initialize() {
		keyboard.up().onPressDo({self.move(0)})
		keyboard.right().onPressDo({self.move(1)})
		keyboard.down().onPressDo({self.move(2)})
		keyboard.left().onPressDo({self.move(3)})
		keyboard.a().onPressDo({self.equip(1)})
		keyboard.s().onPressDo({self.equip(2)})		
	//	keyboard.z().onPressDo({self.shoot()})
	//	keyboard.x().onPressDo({self.reload()})
	//	keyboard.space().onPressDo({self.heal()})
	}

}

class Armas {
	var municion = 0
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
}