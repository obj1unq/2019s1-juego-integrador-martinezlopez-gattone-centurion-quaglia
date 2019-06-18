import wollok.game.*

class ObjetoEnPantalla {
	var property posicion = game.at(0,0)
	
	method agregarAPantalla() {
		game.addVisual(self)
	}
	
	method quitarDePantalla() {
		game.removeVisual(self)
	}
	
	method esCamino() {
		return false
	}
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
	
	method agregar(torre) {
		torres.add(torre)
	}
	method quitar(torre) {
		torres.remove(torre)
	}
	
	method torreLenta() {
		return new Torre(atk = 9999, range = 3, pierce = 1, cost = 200)
	}
	
	method torreRapida() {
		return new Torre(atk = 9, range = 3, pierce = 5, cost = 180)
	}
	method torreNormal(){
		return new Torre(atk = 15, range= 3, pierce= 6, cost=100 )
	}
	
	method distanciaALaMeta() {
		return camino.size()
	}
	
	method getPathIn(position) {
		return game.getObjectsIn(position)
	}
	
	method nextTurn() {}
}

object jugador {
	var property oro
	var property hp
	
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
}

object cabezal inherits ObjetoEnPantalla {
	
	override method agregarAPantalla() {
		game.addVisualCharacter(self)
	}
	
	method sePuedeConstruir() {
	      return game.getObjectsIn(self.posicion()==[])
	}
	method move(nuevaPosicion){
		self.posicion(nuevaPosicion)
	}
}

class Torre inherits ObjetoEnPantalla {
	const property atk = 0
	const property range = 0
	const property pierce = 0
	const property cost = 0
	const property pathInRange = []
	
	const property player = jugador
	const property sistem = system
	const property cabe = cabezal
	
	method setPathInRange() {
		var pos = posicion
		pathInRange.add(sistem.getPathIn(pos.down(1)))
		pathInRange.add(sistem.getPathIn(pos.right(1)))
		pathInRange.add(sistem.getPathIn(pos.left(1)))		
		pathInRange.add(sistem.getPathIn(pos.up(1)))				
		new Range(1, range - 1).forEach( { i =>
			pos = posicion.up(i)
			pathInRange.add(sistem.getPathIn(pos.up(1)) )
			pathInRange.add(sistem.getPathIn(pos.right(1)))
			pathInRange.add(sistem.getPathIn(pos.left(1)))
			pos = posicion.down(i)
			pathInRange.add(sistem.getPathIn(pos.down(1)))
			pathInRange.add(sistem.getPathIn(pos.left(1)))
			pathInRange.add(sistem.getPathIn(pos.right(1)))		
			pos = posicion.left(i)
			pathInRange.add(sistem.getPathIn(pos.left(1)))
			pathInRange.add(sistem.getPathIn(pos.down(1)))
			pathInRange.add(sistem.getPathIn(pos.up(1)))		
			pos = posicion.right(i)
			pathInRange.add(sistem.getPathIn(pos.right(1)))
			pathInRange.add(sistem.getPathIn(pos.up(1)))
			pathInRange.add(sistem.getPathIn(pos.down(1)))		
		} )
	}
	
	method atacar() {
		var allEnemies = []
		var enemiesInRange = pathInRange.map( { camino => game.colliders(camino) } )
		enemiesInRange.forEach( { enemiesInPath => 
			enemiesInPath.forEach( { enemy => allEnemies.add(enemy) } )
		} )	
		allEnemies.sortBy( { e1, e2 => e1.pos() > e2.pos() } )
		var maxPierce = pierce.min(allEnemies.size())
		new Range(1, maxPierce).forEach( { i =>
			allEnemies.get(i).perderVida(atk)
		} )
	}
	
	method vender() {
		player.ganarOro(cost/3)
		self.quitarDePantalla()
		sistem.quitar(self)
	}
	
	method construir() {
		if (cost <= player.oro() && cabe.sePuedeConstruir()) {
			player.perderOro(cost)
			self.posicion(cabe.posicion())
			sistem.agregar(self)
			self.agregarAPantalla()
		}
	}
}

class Mina inherits ObjetoEnPantalla { 
    const property atk = 0
	const property pierce = 9999
	const property cost = 0
	
	const property player = jugador
	const property sistem = system
	const property cabe = cabezal
	
	
	
	method explotar() {
		var enemigos=game.getObjectsIn (self.posicion())
		enemigos.forEach({enemigo=>enemigo.perderVida(atk)})
		self.quitarDePantalla()
	}
	
	method vender() {
		player.ganarOro(cost/3)
		self.quitarDePantalla()
		sistem.quitar(self)
	}
	
	method construir() {
		if (cost <= player.oro() && cabe.sePuedeConstruir()) {
			player.perderOro(cost)
			self.posicion(cabe.posicion())
			sistem.agregar(self)
			self.agregarAPantalla()
		}
	}
}


class Enemy inherits ObjetoEnPantalla {
	const property atk
	const property maxHp
	var   property vida
	const property recompenza
	const property speed
	
	var   property pos    = 0
	const property player = jugador
	const property sistem = system
	
	method atacar() {
		player.perderHp(atk)
		self.quitarDePantalla()
	}
	
	method morir() {
		player.ganarOro(recompenza)
		self.quitarDePantalla()
	}
	
	method perderVida(cant) {
		if (cant >= vida) {
			self.morir()
		} else {
			vida -= cant
		}
	}
	
	method ganarVida(cant) { //hice este metodo por si nos pinta hacer unidades enemigas que puedan curar
		if (vida+cant >= maxHp) {
			vida = maxHp
		} else {
			vida += cant
		}
	}

	method avanzar() {
		if ((pos+speed) >= sistem.distanciaALaMeta()) {
			self.atacar()
		} else {
			self.posicion(sistem.camino().find(pos+speed))
			//modificar en versiones posteriores
		}
	}
}
