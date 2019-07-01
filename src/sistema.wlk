import wollok.game.*
import torres.*
import enemigos.*
import camino.*
import niveles.*

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
	
	var property niveles = [nivel1, nivel2]
	
	method nivelActual() = niveles.first()
	
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
	
	method distanciaALaMeta() {
		return camino.size()
	}
	
	method getPathIn(position) {
		return game.getObjectsIn(position).filter( { obj => obj.esCamino() } )
	}
	
	method nextTurn() {
		turn = turn + 1
		if (partidaContinua and turn == 38) {
			self.pasarDeNivel()
		} else {
			self.avanzarTodos()
			self.atacarTodas()
			self.nivelActual().spawnWave()
		}
	}
	
	method avanzarTodos() {
		enemigos.forEach( { enemigo => enemigo.avanzar() } )
	}
	
	method atacarTodas() {
		torres.forEach( { torre => torre.atacar() } )
	}
	method pasarDeNivel() {
			niveles.remove(niveles.first())
			turn = 0
			nivel2.crear()
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
	
	method image() = "Player.png"
	
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