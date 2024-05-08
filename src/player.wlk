import wollok.game.*


class Player {
	var vida = 100
	var vivo = true
	var posicion = game.at(1, 2)
	const property inventario = #{}
	
	method imagen() = "DS_base.png"
	
	method ataque(arma) {
		arma.usar()
		arma.municion()
		return arma.danio()
	}
	
	method danio(cant) {
		vida -= cant
		
		if (vida <= 0) {
			self.morir()
		}
		return vida
	}
	
	method estaVivo() = vivo
	
	method morir() {
		vivo = false
		return vivo
	}
	
	method derecha() {
		posicion = posicion.right(1)
	}
	
	method izquierda() {
		posicion = posicion.left(1)
	}
	
	method arriba() {
		posicion = posicion.up(1)
	}
	
	method abajo() {
		posicion = posicion.down(1)
	}

	method encontrarArma(arma) {
		inventario.add(arma)
	}
}

class Armas {

	method municion() = null
	
	method danio() = null

}

class Escopeta inherits Armas {
	var municion = 5
	const danio = 20
	
	override method municion() = municion
	
	override method danio() = danio
	
	method usar() {
		municion -= 1
	}
	
	method agregarMunicion(cant) {
		municion +=cant
	}
}

class Espada inherits Armas {
	const municion = null
	const danio = 5
	
	override method municion() = municion
	
	override method danio() = danio

	method usar() = 0
}

class Fusil inherits Armas {
	var municion = 14
	const danio = 10
	
	override method municion() = municion
	
	override method danio() = danio
	
	method usar() {
		municion -= 1
	}
	
	method agregarMunicion(cant) {
		municion +=cant
	}
}

class Automatica inherits Armas {
	var municion = 30
	const danio = 15

	override method municion() = municion
	
	override method danio() = danio
	
	method usar() {
		municion -= 1
	}

	method agregarMunicion(cant) {
		municion +=cant
	}
}