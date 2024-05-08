class Enemigo {
	var property vivo = true
	
	method defensa(danio){}	
	
	method estaVivo() = vivo
	
	method mover(dir){}
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

