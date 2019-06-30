import wollok.game.*
import torres.*
import enemigos.*

class ObjetoEnPantalla {
	var property position = game.at(0,0)
	
	method agregarAPantalla() {
		game.addVisual(self)
	}
	
	method quitarDePantalla() {
		game.removeVisual(self)
	}
	
	method esCamino() = false
	
	method esTorre() = false
}

//el nombre no esta fijo
object system {
	var property camino = [] //Contiene una lista con las posiciones de los caminos
	/**
	 *
	 * Esta propiedad decidi ponerla luego de pensar las diferentes formas de recorrer el camino
	 * para hacer avanzar a las unidades y pense que esta seria la mas sencilla
	 *
	 **/ 
	var property torres = [] //Contiene una lista con todas las torres
	//La idea es tener una lista con todas las torres para poder hacer que ataquen al final del turno
	
	var property enemigos = [] //Contiene una lista con todos los enemigos en pantalla
	//Misma idea que con la lista de torres, poder recorrer cada enemigo y decirle que avance
	
	var property turn = 0
	
	var property partidaContinua = true
	
	method agregarT(torre) {
		torres.add(torre)
	}
	
	method quitarT(torre) {
		torres.remove(torre)
	}
	
	method agregarE(enemigo) {
		enemigos.add(enemigo)
	}
	
	method quitarE(enemigo) {
		enemigos.remove(enemigo)
	}
	
	method torreLenta() { //a.k.a La torre ballesta.
		return new TorreBallesta (atk = 45, range = 4, pierce = 1, cost = 100)
	}
	
	method torreRapida() { //a.k.a La torre gatling. Es obvio.
		return new TorreGatling (atk = 15, range = 2, pierce = 6, cost = 180)
	}
	
	method torreNormal() { //El cañonaso.
		return new TorreCanion (atk = 21, range= 3, pierce= 3, cost = 150)
	}
	
	method torreBomba() { //Boom.
		return new TorreBomba (atk = 30, range = 2, pierce = 8, cost = 260)
	}
	
	method mina() {
		return new Mina()
	}
	
	method inutilDeLaEspada() {
		return new Incredibilis (atk = 5, vida = 50, recompenza = 80, speed = 2)
	}
	
	method inutilDelHacha() {
		return new Raider (atk = 15, vida = 125, recompenza = 120, speed = 1)
	}
	
	method inutilQueCorre() {
		return new Alien (atk = 10, vida = 30, recompenza = 120, speed = 4)
	}
	
	method inutilQueBufea() {
		return new Curandero (atk = 2, vida = 75, recompenza = 60, speed = 2)
	}
	
	method shovelKnight() {
		return new ShovelKnight (atk = 5, vida = 500, recompenza = 2000, speed = 1)
	}
	
	method distanciaALaMeta() {
		return camino.size()
	}
	
	method getPathIn(position) {
		return game.getObjectsIn(position).filter( { obj => obj.esCamino() } )
	}
	
	method nextTurn() {
		turn = turn + 1
		if (partidaContinua) {
			self.avanzarTodos()
			self.atacarTodas()
			self.spawnWave()
		}
	}
	
	method spawnWave() {
		var waveToSpawn = []
		if (turn == 1) {
			2.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
		}
		if (turn == 5) {
			3.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
			2.times( { n => waveToSpawn.add(self.inutilDelHacha()) } )
			3.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
		}
		if (turn == 10) {
			2.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
			4.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
			3.times( { n => waveToSpawn.add(self.inutilDelHacha()) } )
			1.times( { n => waveToSpawn.add(self.inutilQueBufea()) } )
		}
		if (turn == 14) {
			5.times( { n => waveToSpawn.add(self.inutilDelHacha()) } )
			5.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
		}
		if (turn == 18) {
			5.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
			3.times( { n => waveToSpawn.add(self.inutilDelHacha()) } )
		}
		if (turn == 20) {
			1.times( { n => waveToSpawn.add(self.shovelKnight()) } )
			2.times( { n => waveToSpawn.add(self.inutilQueBufea()) } )
		}
		if (turn == 22) {
			7.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
			3.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
		}
		if (turn == 26) {
			3.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
			6.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
		}
		if (turn == 30) {
			15.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
		}
		waveToSpawn.forEach( { enemy => enemy.engendrar() } )
	}
	
	method avanzarTodos() {
		enemigos.forEach( { enemigo => enemigo.avanzar() } )
	}
	
	method atacarTodas() {
		torres.forEach( { torre => torre.atacar() } )
	}
	
	method ganar() {
		partidaContinua = false
		pantallaDeVictoria.agregarAPantalla()
	}
	
	method perder() {
		partidaContinua = false
		pantallaDeDerrota.agregarAPantalla()
	}
}

object pantallaDeDerrota inherits ObjetoEnPantalla {
	
	method image() = 0 //TODO: conseguir imagen
	
}

object pantallaDeVictoria inherits ObjetoEnPantalla {
	
	method image() = 0 //TODO: conseguir imagen
	
}

object jugador {
	var property oro = 500
	var property hp  = 100
	
	method position() = game.at(7,8)
	
	method image() = "player.png"
	
	method ganarOro(cant) {
		oro += cant
	}
	
	method perderOro(cant) {
		oro -= cant
	}
	
	method aumentarHp(cant) {
		hp += cant
	}
	
	method perderHp(cant) {
		hp -= cant	
	}
	
	method esCamino() {
		return false
	}
}

class Camino inherits ObjetoEnPantalla {
	override method esCamino() { return true }
	
	method image() = "suelo1.png"
}

object cabezal inherits ObjetoEnPantalla {
	
	override method agregarAPantalla() {
		game.addVisualCharacter(self)
	}
	
	method image() = "cabezal1.png"
	
	method sePuedeConstruir() {
	      return game.colliders(self) == []
	}
	
	method sePuedeConstruirM() {
	      return not game.colliders(self).filter( { obj => obj.esCamino() } ) == []
	}
	
	method move(nuevaPosicion) {
		self.position(nuevaPosicion)
	}
}

object first {
	method getPriority(e1, e2) {
		return e1.pos() > e2.pos()
	}
}

object last {
	method getPriority(e1, e2) {
		return e1.pos() < e2.pos()
	}
}

object strong {
	method getPriority(e1, e2) {
		return e1.vida() > e2.vida()
	}
}