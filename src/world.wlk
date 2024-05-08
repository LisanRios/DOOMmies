import wollok.game.*

//Objeto que maneja y genera el mundo
object world {
	var property habitaciones = []
	var espacios_disponibles = [ [0,0] ]
	var espacios_ocupados = []
	
	var property habitacion_actual = null
	var tipos_habitacion = []
	
	
	method cambiarHabitacion(h) {
		habitacion_actual.desactivar()
		habitacion_actual = h
		habitacion_actual.activar()
	}
	
	method cambiarHabitacionAdyacente(dir) {
		var adyacente = habitacion_actual.habitacionAdyacente(dir)
		if (adyacente != null) {
			self.cambiarHabitacion(adyacente)
		}
	}
	
	method generateWorld(maxHabitaciones) {
		tipos_habitacion = [
			HabitacionJefe,
			HabitacionPowerup
		]
		habitaciones.clear()
		espacios_ocupados.clear()
		espacios_disponibles.clear()
		espacios_disponibles = [ [0,0] ]
		
		//Instancia la primera habitacion que es de la que parte el jugador
		self.instanciarHabitacion( HabitacionPlayerSpawn, [0,0] )
		var tiposHabitacion = self.calcularTiposHabitacion(maxHabitaciones)
		
		//Instancia habitaciones de su tipo asignado
		tiposHabitacion.forEach({tipo =>
			var pos = espacios_disponibles.get(0.randomUpTo(espacios_disponibles.size()-1))
			self.instanciarHabitacion(tipo, pos)
		})
		
		//Configura los punteros (de que habitacion va a que habitacion)
		self.configurarPunteros()
		
		habitaciones.forEach({habitacion => habitacion.init()})
		
		habitacion_actual = habitaciones.first()
		habitacion_actual.activar()
	}
	
	//Toma un array [x, y] y devuelve un array con los lados del array
	method generarLados(pos){
		return [
			[pos.get(0), pos.get(1)+1],
			[pos.get(0)+1, pos.get(1)],
			[pos.get(0), pos.get(1)-1],
			[pos.get(0)-1, pos.get(1)]
		]
	}
	
	//Instancia una habitacion
	method instanciarHabitacion(_tipo, _posicion){
		var habitacion = new Habitacion(position = _posicion, tipo = _tipo)
		habitaciones.add(habitacion)
		
		espacios_ocupados.add(_posicion)
		espacios_disponibles.remove(_posicion)
		
		var lados = self.generarLados(_posicion)
		
		//Agrega los espacios libres disponibles
		lados.forEach({cand_pos => 
			
			//Si el eje x es par O el eje x es impar y el eje y es par
			var spawnable = cand_pos.get(1) % 2 == 0 or (
				cand_pos.get(1) % 2 == 1 and cand_pos.get(0) % 2 == 0
			)
			
			if (not espacios_ocupados.contains(cand_pos) and spawnable) {
				espacios_disponibles.add(cand_pos)
			}
		})
	}
	
	//Precalcula los tipos de habitacion, de un pool de tipos
	method calcularTiposHabitacion(_maxHabitaciones) {
		//Crea un array lleno de ceros
		var tipos = []
		var rang = new Range(start = 1, end = _maxHabitaciones)
		
		rang.forEach({a => tipos.add(0)})
		
		var t_index = 0
		tipos = tipos.map({tipo =>
			var prob = 0.randomUpTo(_maxHabitaciones) > _maxHabitaciones*0.7
			if (prob and t_index < tipos_habitacion.size()) {
				var t = tipos_habitacion.get(t_index)
				console.println(t)
				t_index += 1
				return t
			}
			else {
				return HabitacionNormal
			}
		})
		
		if (not tipos.contains(HabitacionJefe)) {
			tipos = tipos.subList(0, tipos.size()-2)
			tipos.add(HabitacionJefe)
		}
		
		return tipos
	}
	
	method configurarPunteros(){
		habitaciones.forEach({habitacion =>
			var ladosAdyacentes = self.generarLados(habitacion.position())
			
			var habitacionesAdyacentes = ladosAdyacentes.map({ lado =>
				var hpos = habitaciones.filter({h => h.position() == lado})
				if (hpos.isEmpty()){
					return null
				}
				else{
					return hpos.first()
				}
			})
			
			habitacion.adyacentes(habitacionesAdyacentes)
		})
	}
}

class Habitacion{
	var position = [0,0]
	var property adyacentes = [null, null, null, null] //Arriba, Derecha, Abajo, Izquierda
	var tipo = HabitacionNormal
	
	var entidades = []
	
	var posicionesPuertas = [
		new Position(x = 7, y = 14),
		new Position(x = 14, y = 7),
		new Position(x = 7, y = 0),
		new Position(x = 0, y = 7)
	]
	var posPlayerPuertas = [
		new Position(x = 7, y = 1),
		new Position(x = 1, y = 7),
		new Position(x = 7, y = 13),
		new Position(x = 13, y = 7)
	]
	
	method position() = position
	method tipo() = tipo
	
	method init() {
		//Spawnea las puertas
		var i = 0
		adyacentes.forEach({ adj =>
			if (adj != null) {
				entidades.add(new Puerta(
					direction = i, 
					position = posicionesPuertas.get(i),
					playerPos = posPlayerPuertas.get(i)
				))
			}
			i+=1
		})
	}
	
	method activar(){
		console.println(tipo.background())
		game.ground(tipo.background())
		entidades.forEach({entidad => game.addVisual(entidad)})
	}
	
	method desactivar(){
		entidades.forEach({entidad => game.removeVisual(entidad)})
	}
	
	method habitacionAdyacente(lado){ //Arriba, Derecha, Abajo, Izquierda
		return adyacentes.get(lado)
	}
}

class TipoHabitacion {
	method background() = "backgrounds/infierno.png"
}
object HabitacionNormal inherits TipoHabitacion {
	override method background() = "backgrounds/ladrillo.png"
}
object HabitacionPlayerSpawn inherits TipoHabitacion {}
object HabitacionJefe inherits TipoHabitacion {
	override method background() = "backgrounds/ladrillo.png"
}
object HabitacionPowerup inherits TipoHabitacion {}
object HabitacionTienda inherits TipoHabitacion {}
object HabitacionDesafio inherits TipoHabitacion {}

class Puerta {
	var property position = game.at(0,0)
	var property direction = 0
	var property playerPos = null
	
	method image() = "sprites/door/door_0.png"
}