import wollok.game.*
import world.*
import graphics.*
import player.*


class Enemigo {
	var property vivo = true
	var property position = EntityIdSystem.newEntityById(65535)
	
	method defensa(danio){}	
	
	method estaVivo() = vivo
	
	method position(player) = game.at(self.seguirX(player),self.seguirY(player))
	
	method seguirX(player) = player.position().x()
	
	method seguirY(player) = player.position().y()
}

class Minions inherits Enemigo{
	var vida = 5 
	const ataque = 5	

	override method defensa(danio){
		vida -= danio
		if(vida <= 0){
			vivo = false
		}
	}
	
	method ataque(jugador){
		jugador.danio(ataque)
	}
	
	method image() = "../assets/sprites/test/testsprite_0.png"
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
		}
	}
	
	method ataque(jugador){
		jugador.danio(ataque)
	}
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
		}
	}
	
	method ataque(jugador){
		jugador.danio(ataque)
	}
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
}

