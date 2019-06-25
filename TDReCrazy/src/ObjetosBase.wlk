import wollok.game.*

class ObjetoEnPantalla {
	var property position = game.at(0,0)
	
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
	
	var property enemigos = [] //Contiene una lista con todos los enemigos en pantalla
	//Misma idea que con la lista de torres, poder recorrer cada enemigo y decirle que avance
	
	method agregar(torre) {
		torres.add(torre)
	}
	
	method quitar(torre) {
		torres.remove(torre)
	}
	
	method agregarE(enemigo) {
		enemigos.add(enemigo)
	}
	
	method quitarE(enemigo) {
		enemigos.remove(enemigo)
	}
	
	method torreLenta() {
		return new Torre(atk = 15, range = 5, pierce = 1, cost = 100)
	}
	
	method torreRapida() {
		return new Torre(atk = 5, range = 3, pierce = 6, cost = 180)
	}
	method torreNormal() {
		return new Torre(atk = 10, range= 3, pierce= 3, cost= 200)
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
		//falta el sistema de oleadas
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

class Torre inherits ObjetoEnPantalla {
	const property atk
	const property range
	const property pierce
	const property cost
	var   property pathInRange = #{}
	var   property priority    = first
	
	const property player = jugador
	const property sistem = system
	const property cabe = cabezal
	
	method setPathInRange() {
		var pos = position
		pathInRange.add(sistem.getPathIn(pos.down(1)))
		pathInRange.add(sistem.getPathIn(pos.right(1)))
		pathInRange.add(sistem.getPathIn(pos.left(1)))		
		pathInRange.add(sistem.getPathIn(pos.up(1)))				
		new Range(1, range - 1).forEach( { i =>
			pos = position.up(i)
			pathInRange.add(sistem.getPathIn(pos.up(1)) )
			pathInRange.add(sistem.getPathIn(pos.right(1)))
			pathInRange.add(sistem.getPathIn(pos.left(1)))
			pos = position.down(i)
			pathInRange.add(sistem.getPathIn(pos.down(1)))
			pathInRange.add(sistem.getPathIn(pos.left(1)))
			pathInRange.add(sistem.getPathIn(pos.right(1)))		
			pos = position.left(i)
			pathInRange.add(sistem.getPathIn(pos.left(1)))
			pathInRange.add(sistem.getPathIn(pos.down(1)))
			pathInRange.add(sistem.getPathIn(pos.up(1)))		
			pos = position.right(i)
			pathInRange.add(sistem.getPathIn(pos.right(1)))
			pathInRange.add(sistem.getPathIn(pos.up(1)))
			pathInRange.add(sistem.getPathIn(pos.down(1)))		
		} )
		self.pathInRange(pathInRange.flatten())
	}
	
	method atacar() {
		var allEnemies = []
		var enemiesInRange = pathInRange.map( { camino => game.colliders(camino) } )
		enemiesInRange.forEach( { enemiesInPath => 
			enemiesInPath.forEach( { enemy => allEnemies.add(enemy) } )
		} )	
		allEnemies.sortBy( { e1, e2 => priority.getPriority(e1, e2) } )
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
			self.position(cabe.position())
			sistem.agregar(self)
			self.agregarAPantalla()
		}
	}
	
	method cambiarPrioridad() {
		if (priority == first) { priority = last } 
		else { 
			if (priority == last) { priority = strong }
			else { priority = first }
		}
	}
}

class Mina inherits ObjetoEnPantalla { 
    const property atk = 20
	const property cost = 150
	
	const property player = jugador
	const property sistem = system
	const property cabe = cabezal
	
	
	
	method explotar() {
		var enemigos = game.getObjectsIn (self.position())
		enemigos.forEach( { enemigo => enemigo.perderVida(atk) } )
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
			self.position(cabe.position())
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
	
	method engendrar() {
		self.agregarAPantalla()
		sistem.agregarE(self)
	}
	
	method atacar() {
		player.perderHp(atk)
		self.quitarDePantalla()
		sistem.quitarE(self)
	}
	
	method morir() {
		player.ganarOro(recompenza)
		self.quitarDePantalla()
		sistem.quitarE(self)
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
		var range = [1..speed]
		range.forEach( {
			if((pos+1) >= sistem.distanciaALaMeta()) { self.atacar() } 
			else { self.position(sistem.camino().find(pos+1)) }
		} )
		
		
		//if ((pos+speed) >= sistem.distanciaALaMeta()) {
		//	self.atacar()
		//} else {
		//	self.position(sistem.camino().find(pos+speed))
		//	//modificar en versiones posteriores
		//}
	}
}
