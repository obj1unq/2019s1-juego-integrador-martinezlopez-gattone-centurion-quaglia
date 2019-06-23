import sistema.*
import wollok.game.*

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

class TorreCanion inherits Torre {
	//La torre normal, basica, efectiva.
	method image () = "torreCañon.png"
}

class TorreShock inherits Torre {
	//Honestamente no se que hacer con esta torre, o podria congelar a los enemigos por un turno y tener cooldown 
	//O podria hacer ataque en cadena, que cuantos mas enemigos haya mas daño hace, no tengo ni idea.
	method image () = "torreShock.png"
}

class TorreBallesta inherits Torre {
	//Te hunde el pecho. LITERAL.
	method image () = "torreBallesta.png"
}

class TorreBomba inherits Torre {
	//La hacemos explotar al colocarse o como lo hacemos?
	method image () = "torreBomba.png"
}

class TorreGatling inherits Torre {
	//RATATATATATATATATATATA!
	method image () = "torreGatling.png"
}

class Mina inherits ObjetoEnPantalla { 
    const property atk = 20
	const property cost = 150
	
	const property player = jugador
	const property sistem = system
	const property cabe = cabezal
	
	method image() = "mina.png"
	
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
