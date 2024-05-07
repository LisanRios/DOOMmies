import wollok.game.*

///////CLASES DE SPRITES/////////
//Cada objeto/mob/como se llame debe tener varios objetos AnimatedSprite que definen las animaciones
//Y un objeto AnimatedSpriteManager el cual maneja el sprite actual y hace los cambios de sprite

//Clase de sprite animado. Puede reproducir y parar la animacion, y obtener el frame actual
class AnimatedSprite {
	const property animationId = self.identity().toString() + "_animation"
	var frame = 0
	var frame_duration = 10
	var property images = ["null.png"]
	method initialize() {
		
	}
	
	//Arranca la animacion
	method play() {
		game.onTick(frame_duration, animationId, {=> self.next_frame()})
	}
	
	//Para la animacion
	method stop() {
		game.removeTickEvent(animationId)
		frame  = 0
	}
	
	//Avanza al proximo frame. Si no hay vuelve al inicial.
	method next_frame() {
		frame = (frame + 1) % images.size()
	}
	
	//Retorna la imagen en la que esta el sprite
	method image() = images.get(frame)
}

//Manager de sprites animados para simplificar las cosas
//Todas las cosas que necesiten: reproducir/parar el sprite, y cambiar el sprite se deberia hacer
//desde este objeto.
class AnimatedSpriteManager{
	var sprite = null
	var playing = false
	
	method image() {
		if (sprite != null) {
			return sprite.image()
		}
		else {
			return "null.png"
		}
	}
	
	method setSprite(newSprite) {
		sprite.stop()
		sprite = newSprite
		if (playing) sprite.play()
	}
	
	method play() {
		playing = true;
		if (sprite != null) sprite.play()
	}
	
	method stop() {
		playing = false;
		if (sprite != null) sprite.stop()
	}
	
	method currentSprite() = sprite
	method currentSpriteAnimationId() = sprite.animationId()
}

//Ejemplo de objeto usando AnimatedSprite y AnimatedSpriteManager
object TestAnimatedObject {
	var property position = game.at(4,5)
	
	var sprFlyingDown = new AnimatedSprite(images = [
		"sprites/test/testsprite_0.png",
		"sprites/test/testsprite_1.png",
		"sprites/test/testsprite_2.png"
	], frame_duration = 200)
	
	var sprFlyingUp = new AnimatedSprite(images = [
		"sprites/test/testsprite_4.png",
		"sprites/test/testsprite_6.png",
		"sprites/test/testsprite_7.png"
	], frame_duration = 200)
	
	var sprite = new AnimatedSpriteManager(sprite = sprFlyingDown)
	
	method image() = sprite.image()
	
	method initialize() {
		sprite.play()
		
		game.onTick(5000, "TestChangeSprite", {=> self.testChangeSprite()})
	}
	
	method testChangeSprite() {
		console.println(sprite.currentSpriteAnimationId())
		
		if (sprite.currentSpriteAnimationId() == sprFlyingUp.animationId()){ 
			sprite.setSprite(sprFlyingDown)
		}
		
		else if (sprite.currentSpriteAnimationId() == sprFlyingDown.animationId()){ 
			sprite.setSprite(sprFlyingUp)
		}
	}
}