import wollok.game.*
import world.*
import graphics.*

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

	override method collide(player) {
		super(player)
	}

}

class Escopeta inherits Armas {
	var property playerSprite = "sprites/player/player_1.png"
	
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
		bulletManager.shootBullet(posicion, dir, danio)
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
	var property playerSprite = "sprites/player/player_5.png"
	
	const property municionBase = 0
	var municionUtilizable = 5
	var danio = 5
	
	override method municion() = null
	
	override method danio() = danio
	
	override method agregarMunicion(cant) {
		danio += cant
	}
	override method usar(posicion, dir) {
		var bala = bulletManager.attackSword(posicion, dir, danio)
		bala.tipoArma("espada")  // Indica que la bala fue disparada por una espada
		danio += municionBase
	}
	
	override method recargar() {
		return null
	}
	
	method image() = "sprites/weapons/sword_normal.png"
}

class Fusil inherits Armas {
	var property playerSprite = "sprites/player/player_6.png"
	
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
		bulletManager.shootBullet(posicion, dir, danio)
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
	
	method image() = "sprites/weapons/fusil.png"
}

/*
 * ANTES DE TOCAR NADA LEER
 * -Por que lo dice tan brusco
 */


object bulletManager {
	var cantidadBalas = 12
	var property balas = []
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
	
	method shootBullet(pos, dir, danio) {
		balas.get(puntero).position(pos)
		balas.get(puntero).direction(dir)
		balas.get(puntero).danio(danio)
		self.proxBala()
	}
	
	method attackSword(pos, dir, danio){
		var bala = balas.get(puntero)
		bala.position(pos)
		bala.direction(dir)
		bala.danio(danio)
		self.proxBala()
		return bala  // Devuelve la bala que se está disparando
	}
	
	method removeBullet(b) {
		b.position(game.at(-1, -1))
	}
	
	method proxBala() {
		puntero = (puntero + 1) % cantidadBalas 
	}
	
	method resetBullets() {
		balas.forEach({b => b.position(game.at(-1, -1))})
	}
}

class Bala {
	var property danio = 10000 	
	var property tipoArma = "" 
	var sprite = new AnimatedSprite(frame_duration = 100, images = [
		"sprites/weapons/bala_0.png",
		"sprites/weapons/bala_1.png",
		"sprites/weapons/bala_2.png",
		"sprites/weapons/bala_3.png"
	])
	var spriteManager = new AnimatedSpriteManager(sprite = sprite)
	
	var property position = game.at(0,0)
	var property direction = 0
	var property pasos = 0 
	
	method initialize() {
		spriteManager.setSprite(sprite)
		spriteManager.play()
		game.onTick(200, self.identity().toString()+"_moverTiro", { => self.moverBala() }) //Hace un evento para mover por instancia
	}
	
	method image() = sprite.image()
	
	method moverBala() {
		
		if (not self.outsideScreen() and (tipoArma != "espada" or pasos <= 1)) { // Solo mueve las balas si están dentro de la pantalla y no han superado el límite de pasos (si fueron disparadas por una espada)
	 //Solo mueve las balas si estan dentro de la pantalla, para que no se acumulen los objetos Position()
			if (direction == 0) position = position.up(1)
			if (direction == 1) position = position.right(1)
			if (direction == 2) position = position.down(1)
			if (direction == 3) position = position.left(1)
		pasos+= 1   // Incrementa el contador de pasos
		} else {
			bulletManager.removeBullet(self)
			pasos = 0  // Elimina la bala si ha superado el límite de pasos o está fuera de la pantalla
		}
	}
	
	method outsideScreen() {
		return position.x() < 0 or position.y() < 0 or position.x() >= game.width() or position.y() >= game.height()
	}
	
	method collide(p) {} //NO TOCAR :) O LOS MATO
}

class BotiquinP inherits Curacion {
	const salud = 25
	var numero = 0

	method image() = "sprites/healing/botiquin" +numero+ ".png"
	
	
	override method collide(player){
		super(player)
		var curacion = player.vida() + salud
		player.vida(curacion)
	}
}

class BotiquinM inherits Curacion {
	const salud = 50
	const numero = 1
		
	method image() = "sprites/healing/botiquin" +numero+ ".png"
		
	override method collide(player){
		super(player)
		var curacion = player.vida() + salud
		player.vida(curacion)
	}
}

class BotiquinG inherits Curacion {
	const salud = 75
	const numero = 2
	
	method image() = "sprites/healing/botiquin" +numero+ ".png"
	
		
	override method collide(player){
		super(player)
		var curacion = player.vida() + salud
		player.vida(curacion)
	}
}

class Escudo inherits Curacion {
	var property escudo = 0
	
	//override method efecto() = escudo
}