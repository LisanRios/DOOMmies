import wollok.game.*
import world.*
import graphics.*
import enemigos.*
import objects.*

class Player {
	var property vida = 150
	var vivo = true
	var flag = 0
	var property position = game.at(1, 2)
	const property inventario = #{new Fusil(), new Espada(), new Escopeta(), new BotiquinP(), new BotiquinM(), new BotiquinG()}
	
	method image() = "sprites/player/player_0.png"
	method image2() = "sprites/player/player_2.png"
	method image3() = "sprites/player/player_5.png"
	method image4() = "sprites/player/player_6.png"

	method encontrarArma(arma) {
		if (inventario.contains(arma)) arma.agregarMunicion(arma.municionBase())
		inventario.add(arma)
	}
	
	method encontrarCuracion(curacion) {
		flag += 1
		inventario.add(curacion)
	}
	
	method ataque(arma) {
    	if (inventario.contains(arma)) {
        	arma.usar()
        	arma.municion()
         // Crear una bala y mostrarla en la posición actual del jugador
        	game.addVisualCharacterIn(arma, position)
        	return arma.danio()
    	}
    	return 0
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
			if (vida + curacion.efecto() > 150) vida += (150 - vida)
			else vida += curacion.efecto()
			flag -= 1
			if (flag < 0) flag = 0
			if (flag == 0) inventario.remove(curacion)
			return vida
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
		keyboard.z().onPressDo({self.ataque(escopeta)}) // Ataque con Escopeta
    	keyboard.x().onPressDo({self.ataque(espada)})   // Ataque con Espada
    	keyboard.space().onPressDo({self.ataque(fusil)}) // Ataque con Fusil
    	keyboard.q().onPressDo({self.curacion(botiquinp)}) // Usar botiquin pequeño
	    keyboard.w().onPressDo({self.curacion(botiquinm)}) // Usar botiquin mediano
	    keyboard.e().onPressDo({self.curacion(botiquing)}) // Usar botiquin grande
	}

}