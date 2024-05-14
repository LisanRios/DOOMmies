import wollok.game.*
import world.*
import graphics.*
import enemigos.*
import objects.*

class Player {
	var property vida = 150
	var vivo = true
	var lastPosition = game.at(1,2)
	var property position = game.at(1, 2)
	var property armaEquipada = new Espada(tomado = true)
	var property armadura = 100
	
	method image() {
		if (armaEquipada.toString() == "un/a  Espada") return "sprites/player/player_5.png"
		if (armaEquipada.toString() == "un/a  Fusil") return "sprites/player/player_6.png"
		if (armaEquipada.toString() == "un/a  Escopeta") return "sprites/player/player_1.png"
		return "sprites/player/player_2.png"
	}
	
	method encontrarCuracion(curacion) {
			self.curacion(curacion)
		}

	method ataque(dir) {
        	armaEquipada.usar(position, dir)
        	//armaEquipada.municion()
         // Crear una bala y mostrarla en la posición actual del jugador
        	//game.addVisualCharacterIn(arma, position)
        	//return arma.danio()
    	
    	
	}
	
	method dropArmaEquipada() {
		armaEquipada.position(lastPosition)
		armaEquipada.tomado(false)
		armaEquipada.activar()
		world.addObjetoHabitacionActual(armaEquipada)
		armaEquipada = null
	}
	
	method recargar(arma) = arma.recargar()
	
	method danio(danio) {
		if(armadura >= 0){
			armadura -= danio
		} else {
			vida -= danio
			if (vida <= 0) {
				self.morir()
			}
		}
	}
	
	method curacion(curacion) {
		if (vida + curacion.efecto() > 150) vida += (150 - vida)
		else vida += curacion.efecto()
	}
	
	method armadura(escudo) {
		if (armadura + escudo.efecto() > 100) armadura += (100 - armadura)
		else armadura += escudo.efecto() 
	}
	
	method estaVivo() = vivo
	
	method morir() {
		vivo = false
		game.stop()
		return vivo
	}
	
	method move(dir){
		lastPosition = position
		
		if (dir == 0) position = position.up(1)
		if (dir == 1) position = position.right(1)
		if (dir == 2) position = position.down(1)
		if (dir == 3) position = position.left(1)
		
		var col = game.colliders(self)
		col.forEach({col => col.collide(self)})
	}
	
	method initialize() {
		keyboard.w().onPressDo({self.move(0)})
		keyboard.d().onPressDo({self.move(1)})
		keyboard.s().onPressDo({self.move(2)})
		keyboard.a().onPressDo({self.move(3)})	
		//keyboard.z().onPressDo({self.ataque(escopeta)}) // Ataque con Escopeta
    	//keyboard.x().onPressDo({self.ataque(espada)})   // Ataque con Espada
    	keyboard.up().onPressDo({self.ataque(0)}) 
    	keyboard.right().onPressDo({self.ataque(1)}) 
    	keyboard.down().onPressDo({self.ataque(2)}) 
    	keyboard.left().onPressDo({self.ataque(3)}) 
    	
	}

}