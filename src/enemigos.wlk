import wollok.game.*
import world.*
import graphics.*
import player.*
import objects.*


class Enemigo {
	var property vivo = true
	var property position = game.at(0,0)
	var posicionOriginal = null
	
	method initialize(){
		posicionOriginal = position
	}
	
	method defensa(danio){}	
	
	method estaVivo() = vivo
	
	method perseguirJugador() {
		var player = world.player()
		var positioncand = null
		
		if (player.position().x() < position.x() and not self.mismoTipoEnPosicion(position.left(1)) ) {
			position = position.left(1)
		}
		if (player.position().x() > position.x() and not self.mismoTipoEnPosicion(position.right(1)) ) {
			position = position.right(1)
		}
		if (player.position().y() < position.y() and not self.mismoTipoEnPosicion(position.down(1)) ) {
			position = position.down(1)
		}
		if (player.position().y() > position.y() and not self.mismoTipoEnPosicion(position.up(1)) ) {
			position = position.up(1)
		}
	}
	
	method mismoTipoEnPosicion(pos) {
		var o = game.getObjectsIn(pos)
		o = o.filter({obj => 
			return obj.toString() == self.toString()
		})
		return not o.isEmpty()
	}
	
	method activar() {
		if (posicionOriginal == null) posicionOriginal = position
		position = posicionOriginal
		game.onTick(500, self.identity().toString()+"_perseguir", {self.perseguirJugador()})
		game.addVisual(self)
	}
	method desactivar() {
		game.removeTickEvent(self.identity().toString()+"_perseguir")
		game.removeVisual(self)
	}
	method collide(p) {
		game.say(self, "AAAAAA")
		self.ataque(p)
	}
}

class Minions inherits Enemigo{
	var vida = 5 
	const ataque = 5	
	
	override method defensa(danio){
		vida -= danio
		if(vida <= 0){
			vivo = false
			var escudo = new Escudo()
			var player = new Player()
			escudo.escudo(5)
			player.armadura(escudo)
		}
	}
	
	method ataque(jugador){
		jugador.danio(ataque)
	}
	
	method image() = "sprites/monsters/minion.png"
	
}

class Soldado inherits Enemigo{
	var vida = 50 
	const ataque = 25	
	var armadura = 50
	

	override method defensa(danio){
		if(armadura >= 0){
			armadura -= danio
		} else {
			vida -= danio
			if (vida <= 0) {
			var escudo = new Escudo()
			var player = new Player()
			escudo.escudo(30)
			player.armadura(escudo)
			}
		}
	}
	
	method ataque(jugador){
		jugador.danio(ataque)
	}
	
	method image()= "sprites/monsters/soldado.png"
}

class Demonio inherits Enemigo{
	var vida = 100 
	const ataque = 75	
	var armadura = 100

	override method defensa(danio){
		if(armadura >= 0){
			armadura -= danio
		} else {
			vida -= danio
			if (vida <= 0){
			var escudo = new Escudo()
			var player = new Player()
			escudo.escudo(50)
			player.armadura(escudo)
			}
		}
	}
	
	method ataque(jugador){
		jugador.danio(ataque)
	}
	
	method image()= "sprites/monsters/demonio.png"
}

class Jefe inherits Enemigo {
	var vida = 250 
	const ataque = 100	
	var armadura = 250

	override method defensa(danio){
		if(armadura >= 0){
			armadura -= danio
		} else {
			vida -= danio
		}
	}
	
	method ataque(jugador){
		jugador.danio(ataque)
	}
	
	method image()= "sprites/monsters/jefe.png"
}

