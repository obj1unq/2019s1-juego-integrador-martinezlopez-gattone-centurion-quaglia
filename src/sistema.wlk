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
}

//el nombre no esta fijo
object system {
	const property camino = [] //Contiene una lista con las posiciones de los caminos
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
		return new TorreBallesta (atk = 15, range = 5, pierce = 1, cost = 100)
	}
	
	method torreRapida() { //a.k.a La torre gatling. Es obvio.
		return new TorreGatling (atk = 5, range = 2, pierce = 6, cost = 180)
	}
	
	method torreNormal() { //El cañonaso.
		return new TorreCanion (atk = 7, range= 3, pierce= 3, cost = 150)
	}
	
	method torreBomba() { //Boom.
		return new TorreBomba (atk = 10, range = 1, pierce = 8, cost = 120)
	}
	
	method distanciaALaMeta() {
		return camino.size()
	}
	
	method getPathIn(position) {
		return game.getObjectsIn(position).filter( { obj => obj.esCamino() } )
	}
	
	method nextTurn() {
		self.avanzarTodos()
		self.atacarTodas()
	}
	
	method avanzarTodos() {
		enemigos.forEach( { enemigo => enemigo.avanzar() } )
	}
	
	method atacarTodas() {
		torres.forEach( { torre => torre.atacar() } )
	}
}

object jugador {
	var property oro
	var property hp
	
	method position() = game.at(4,9)
	
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
	      return game.getObjectsIn(self.position()) == []
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