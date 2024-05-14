import wollok.game.*
import world.*

//Clase madre para los pickups de arma y curacion
class Pickup {
	var property position = game.at(0,0)
	var property tomado = false;
	
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
	}
}

class Armas inherits Pickup{
	method municion() = null
	
	method danio() = null
	
	method agregarMunicion(cant) {}
	
	method usar(posicion, dir) {}
	
	method recargar() = null
	
	override method collide(p) {
		super(p)
		p.dropArmaEquipada()
		p.armaEquipada(self)
	}
}

class Curacion inherits Pickup{	
	method efecto() = null
	
	override method collide(p) {
		super(p)
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
	

	
	override method usar(posicion, dir) {
		bulletManager.shootBullet(posicion, dir)
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
	
	override method usar(posicion, dir) {
	
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
	
	
	override method usar(posicion, dir) {
		bulletManager.shootBullet(posicion, dir)
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

object bulletManager {
	var cantidadBalas = 12
	var balas = []
	var puntero = 0 //Posicion del array con la bala a disparar, se eligiria la bala con FIFO
	
	method initialize() {
		var cBalas = new Range(start = 1, end = cantidadBalas)
		cBalas.forEach({c => 
			var bala = new Bala()
			bala.position(game.at(-1, -1))
			game.addVisual(bala)
			balas.add(bala)
		})
	}
	
	method shootBullet(pos, dir) {
		console.println("Bala: "+puntero.toString())
		balas.get(puntero).position(pos)
		balas.get(puntero).direction(dir)
		self.proxBala()
	}
	
	method removeBullet(b) {
		b.position(game.at(-1, -1))
	}
	
	method proxBala() {
		puntero = (puntero + 1) % cantidadBalas 
	}
	
	method resetBullets() {
		console.println(balas.toString())
		balas.forEach({b => b.position(game.at(-1, -1))})
	}
}

class Bala {
	const property image = "sprites/weapons/balas.png"
	
	var property position = game.at(0,0)
	var property direction = 0
	
	method initialize() {
		game.onTick(200, self.identity().toString()+"_moverTiro", { => self.moverBala() }) //Hace un evento para mover por instancia
	}
	
	method moverBala() {
		if (not self.outsideScreen()){ //Solo mueve las balas si estan dentro de la pantalla, para que no se acumulen los objetos Position()
			if (direction == 0) position = position.up(1)
			if (direction == 1) position = position.right(1)
			if (direction == 2) position = position.down(1)
			if (direction == 3) position = position.left(1)
			
		}
	}
	
	method outsideScreen() {
		return position.x() < 0 or position.y() < 0 or position.x() >= game.width() or position.y() >= game.height()
	}
	
	method collide(p) {}
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

class Escudo inherits Curacion {
	var property escudo = 0
	
	override method efecto() = escudo
}