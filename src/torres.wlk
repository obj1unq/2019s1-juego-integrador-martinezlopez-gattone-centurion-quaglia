import sistema.*
import wollok.game.*

class Torre inherits ObjetoEnPantalla {
	const property atk
	const property range
	const property pierce
	const property cost
	var   property pathInRange = #{}
	var   property priority    = first
	
	const property cabe = cabezal
	
	method setPathInRange(path, posicion) {
		var pos = posicion
		path.add(system.getPathIn(pos.down(1)))
		path.add(system.getPathIn(pos.right(1)))
		path.add(system.getPathIn(pos.left(1)))		
		path.add(system.getPathIn(pos.up(1)))				
		new Range(1, range - 1).forEach( { i =>
			pos = position.up(i)
			path.add(system.getPathIn(pos.up(1)) )
			path.add(system.getPathIn(pos.right(1)))
			path.add(system.getPathIn(pos.left(1)))
			pos = position.down(i)
			path.add(system.getPathIn(pos.down(1)))
			path.add(system.getPathIn(pos.left(1)))
			path.add(system.getPathIn(pos.right(1)))		
			pos = position.left(i)
			path.add(system.getPathIn(pos.left(1)))
			path.add(system.getPathIn(pos.down(1)))
			path.add(system.getPathIn(pos.up(1)))		
			pos = position.right(i)
			path.add(system.getPathIn(pos.right(1)))
			path.add(system.getPathIn(pos.up(1)))
			path.add(system.getPathIn(pos.down(1)))		
		} )
	}
	
	method orderEnemies(enemies) {
		var enemiesInRange = pathInRange.map( { camino => game.colliders(camino) } )
		enemiesInRange.forEach( { enemiesInPath => 
			enemiesInPath.forEach( { enemy => enemies.add(enemy) } )
		} )	
		return enemies.sortedBy( { e1, e2 => priority.getPriority(e1, e2) } )
	}
	
	method atacar() {
		var allEnemies = []
		self.orderEnemies(allEnemies).take(pierce).forEach( { enemigo => enemigo.perderVida(atk) } )
	}
	
	method vender() {
		jugador.ganarOro(cost/3)
		self.quitarDePantalla()
		system.quitarT(self)
	}
	
	method construir() {
		if (cost <= jugador.oro() && cabe.sePuedeConstruir()) {
			jugador.perderOro(cost)
			self.position(cabe.position())
			system.agregarT(self)
			self.agregarAPantalla()
			self.setPathInRange(pathInRange, position)
			self.pathInRange(pathInRange.flatten())
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
	var property pathInAoE = #{}
	var property aoeRange  = 2
	//La hacemos explotar al colocarse o como lo hacemos?
	method image () = "torreBomba.png"
	
	override method atacar() {
		var allEnemies = []
		var aoe
		if (not self.orderEnemies(allEnemies).isEmpty()) {
			aoe = self.getAoE(self.orderEnemies(allEnemies).head())
			aoe.forEach( { enemigo => enemigo.perderVida(atk)  } )
		}
	}
	
	method getAoE(enemy) {
		self.setPathInRange(pathInAoE, enemy.position())
		self.pathInAoE(pathInAoE.flatten())
		var enemiesInRange = pathInAoE.map( { camino => game.colliders(camino) } )
		enemiesInRange.forEach( { enemiesInPath => 
			enemiesInPath.forEach( { enemie => enemiesInRange.add(enemie) } )
		} )	
		return enemiesInRange
	}
}

class TorreGatling inherits Torre {
	//RATATATATATATATATATATA!
	method image () = "torreGatling.png"
}

class Mina inherits ObjetoEnPantalla { 
    const property atk = 30
	const property cost = 60
	
	const property cabe = cabezal
	
	method image() = "mina.png"
	
	method explotar() {
		var enemigos = game.getObjectsIn (self.position())
		enemigos.forEach( { enemigo => enemigo.perderVida(atk) } )
		self.quitarDePantalla()
	}
	
	method vender() {
		jugador.ganarOro(cost/3)
		self.quitarDePantalla()
	}
	
	method construir() {
		if (cost <= jugador.oro() && cabe.sePuedeConstruirM()) {
			jugador.perderOro(cost)
			self.position(cabe.position())
			self.agregarAPantalla()
		}
	}
}
