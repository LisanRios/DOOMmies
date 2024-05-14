import wollok.game.*

object audioManager {
	var songFiles = [
		"music/fight.wav",
		"music/tienda.mp3",
		"music/bossfight.mp3"
	]
	var songs = []
	var songPlaying = 0
	
	method initialize() {
		songFiles.forEach({f => 
			var nSong = new Sound(file = f)
			nSong.shouldLoop(true)
			songs.add(nSong)
		})
		console.println(songs)
	}
	
	method play(song) {
		var oldSong = songs.get(songPlaying)
		
		if (oldSong.played()) {
			if (not oldSong.paused())
			oldSong.pause()
		}
		
		if (song == -1) {return 0}
		var newSong = songs.get(song)
		if (newSong.paused()) {
			newSong.resume()
		}
		else {
			newSong.play()
		}
		songPlaying = song
		
		return 0
	}
}
