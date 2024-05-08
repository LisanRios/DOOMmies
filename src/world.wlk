import wollok.game.*

// <DEBUG> >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
class RoomBlockTest {
	var property position = game.at(0,0)
	var property tipo = HabitacionNormal
	method image(){
		if (tipo == HabitacionPlayerSpawn){
			return "sprites/test/testsprite_5.png/"
		}
		if (tipo == HabitacionNormal){
			return "sprites/test/testsprite_0.png"
		}
		else if (tipo == HabitacionJefe){
			return "sprites/test/testsprite_3.png"
		}
		else if (tipo == HabitacionPowerup){
			return "sprites/test/testsprite_6.png"
		}	
		return "null.png"
	}
}

object testPlayer {
	var property position = game.at(0,0)
	var property habitacionActual = null;
	method image() = "sprites/player/player_0.png/"
	
	method move(dir){
		var newHabitacion = habitacionActual.adyacentes().get(dir)
		if (newHabitacion != null){
			habitacionActual = newHabitacion
			
			position = new Position(
				x = habitacionActual.position().get(0)+7, 
				y = habitacionActual.position().get(1)+7
			)
		}
	}
	
	method initialize() {
		keyboard.up().onPressDo({self.move(0)})
		keyboard.right().onPressDo({self.move(1)})
		keyboard.down().onPressDo({self.move(2)})
		keyboard.left().onPressDo({self.move(3)})
	}
}

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< </DEBUG>

//Objeto que maneja y genera el mundo
object world {
	var property habitaciones = []
	var espacios_disponibles = [ [0,0] ]
	var espacios_ocupados = []
	
	var habitacion_actual = null
	var tipos_habitacion = []
	
	
	method cambiarHabitacion() {
		
	}
	
	method cambiarHacitacionAdyacente() {
		
	}
	
	method generarWorld(maxHabitaciones) {
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
		
		
		//Esto es de debug para visualizar el mapa antes de hacer la cosa jugable
		game.allVisuals().forEach({visual => game.removeVisual(visual)})
		game.width(15)
		game.height(15)
		habitaciones.forEach({habitacion =>
			var mapBlock = new RoomBlockTest()
			mapBlock.tipo(habitacion.tipo())
			game.addVisualIn(mapBlock, new Position(
				x = habitacion.position().get(0) + 7,
				y = habitacion.position().get(1) + 7
			))
		})
		
		game.addVisual(testPlayer)
		testPlayer.position(
			new Position(
				x = habitaciones.first().position().get(0)+7, 
				y = habitaciones.first().position().get(1)+7
			)
		)
		testPlayer.habitacionActual(habitaciones.first())
		
		game.start()
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
	
	method position() = position
	method tipo() = tipo
	
	method activarHabitacion(){
		
	}
	
	method desactivarHabitacion(){
		
	}
	
	method habitacionAdyacente(){
		
	}
}

object HabitacionNormal {}
object HabitacionPlayerSpawn{}
object HabitacionJefe {}
object HabitacionPowerup {}
object HabitacionTienda {}
object HabitacionDesafio {}