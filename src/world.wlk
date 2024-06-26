import wollok.game.*
import enemigos.*
import objects.*
import audio.*

//Objeto que maneja y genera el mundo
object world {
	var property player = null
	
	var property habitaciones = []
	var espacios_disponibles = [ [0,0] ]
	var espacios_ocupados = []
	
	var property habitacion_actual = null
	var tipos_habitacion = [
			HabitacionPowerup,
			HabitacionPowerup,
			HabitacionPowerup,
			HabitacionPowerup,
			HabitacionPowerup,
			HabitacionPowerup,
			HabitacionPowerup
		]
	
	method cambiarHabitacion(h) {
		bulletManager.resetBullets() //Borra todas las balas
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
	
	method addObjetoHabitacionActual(obj) {
		habitacion_actual.addEntidad(obj)
	}
	
	method removeObjetoHabitacionActual(obj) {
		habitacion_actual.removeEntidad(obj)
	}
}

class Habitacion{
	var position = [0,0]
	var property adyacentes = [null, null, null, null] //Arriba, Derecha, Abajo, Izquierda
	var property tipo = HabitacionNormal
	
	var property entidades = []
	
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
		
		//Spawnea una plantilla de entidades
		var temps = tipo.templates()
		
		if (not temps.isEmpty()) {
			var template = temps.get(0.randomUpTo(temps.size()-1))
			template.entradas().forEach({entrada => 
				var entityId = entrada.get(0)
				var pos = entrada.get(1)
				
				var newEntity = EntityIdSystem.newEntityById(entityId)
				newEntity.position(pos)
				
				entidades.add(newEntity)
			})
		}
	}
	
	method activar(){
		game.ground(tipo.background())
		entidades.forEach({entidad => entidad.activar()})
		audioManager.play(tipo.song())
	}
	
	method desactivar(){
		entidades.forEach({entidad => entidad.desactivar()})
	}
	
	method habitacionAdyacente(lado){ //Arriba, Derecha, Abajo, Izquierda
		return adyacentes.get(lado)
	}
	
	method addEntidad(obj) {
		entidades.add(obj)
	}
	
	method removeEntidad(obj) {
		entidades.remove(obj)
	}
}

class TipoHabitacion {
	method song() = 0
	method templates() = []
	method background() = "backgrounds/infierno.png"
}
object HabitacionNormal inherits TipoHabitacion {
	override method background() = "backgrounds/ladrillo.png"
	override method templates() = [
		new Template(entradas = [
			[2, new Position(x = 7, y = 7)]
		]),
		new Template(entradas = [
			[0, new Position(x = 5, y = 7)],
			[0, new Position(x = 9, y = 7)],
			[0, new Position(x = 7, y = 5)],
			[0, new Position(x = 7, y = 9)]
		]),
		new Template(entradas = [
			[1, new Position(x = 5, y = 5)],
			[1, new Position(x = 5, y = 9)],
			[1, new Position(x = 9, y = 5)],
			[1, new Position(x = 9, y = 9)]
		])
	]
}
object HabitacionPlayerSpawn inherits TipoHabitacion {
	override method song() = -1
}
object HabitacionJefe inherits TipoHabitacion {
	override method song() = 2
	override method background() = "backgrounds/ladrillo.png"
	override method templates() = [
		new Template(entradas = [
			[3, new Position(x = 7, y = 11)]
		])
	]
}
object HabitacionPowerup inherits TipoHabitacion {
	override method song() = 1
	override method templates() = [
		new Template(entradas = [
			[1001, new Position(x = 7, y = 11)]
		]),
		new Template(entradas = [
			[1002, new Position(x = 7, y = 11)]
		]),
		new Template(entradas = [
			[1003, new Position(x = 7, y = 11)]
		]),
		new Template(entradas = [
			[1501, new Position(x = 7, y = 11)]
		])
		
	]
}
object HabitacionTienda inherits TipoHabitacion {}
object HabitacionDesafio inherits TipoHabitacion {}

//No se puede devolver un nombre de clase para instanciar ese nombre de clase
//Entonces tengo que crear un sistema de ids de entidades para almacenar nombres de clase 
//de alguna forma; esto para que funcione el sistema de plantillas
object EntityIdSystem {
	method newEntityById(id) {
		if (id == 0) { return new Minions()}
		if (id == 1) { return new Soldado()}
		if (id == 2) { return new Demonio()}
		if (id == 3) { return new Jefe()}
		if (id == 1001) {return new Espada()}
		if (id == 1002) {return new Fusil()}
		if (id == 1003) {return new Escopeta()}
		if (id == 1501) {return new BotiquinP()}
		if (id == 1502) {return new BotiquinM()}
		if (id == 1503) {return new BotiquinG()}
		return null
	}
}

class Template {
	var property entradas = [] //Cada entrada es un ID de entidad y un objeto Position
}

class Puerta{
	var property position = game.at(0,0)
	var property direction = 0
	var property playerPos = null
	
	method activar() {game.addVisual(self)}
	method desactivar() {game.removeVisual(self)}
	method image() {
		
		if (world.habitacion_actual().adyacentes().get(direction).tipo() == HabitacionJefe) {
			return "sprites/door/door_boss.png"
		}
		
		if (world.habitacion_actual().adyacentes().get(direction).tipo() == HabitacionPowerup) {
			return "sprites/door/door_powerup.png"
		}
		
		return "sprites/door/door_0.png"
	}
	method collide(p) {
		p.position(playerPos)
		world.cambiarHabitacionAdyacente(direction)
	}
}