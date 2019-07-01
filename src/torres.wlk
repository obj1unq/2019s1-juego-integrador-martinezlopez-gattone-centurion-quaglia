import sistema.*
import wollok.game.*
import camino.*

class Bug {
	var torre
}

class Torre inherits ObjetoEnPantalla {
	
	const property atk
	const property range
	const property pierce
	const property cost
	const property bug = new Bug(torre = 0)
	var   property priority    = first
	
	method setPathInRange(posicion) {
		var ret = #{}
		var pos = posicion
		ret.add(system.getPathIn(pos.down(1)))
		ret.add(system.getPathIn(pos.right(1)))
		ret.add(system.getPathIn(pos.left(1)))		
		ret.add(system.getPathIn(pos.up(1)))				
		new Range(1, range - 1).forEach( { i =>
			pos = position.up(i)
			ret.add(system.getPathIn(pos.up(1)) )
			ret.add(system.getPathIn(pos.right(1)))
			ret.add(system.getPathIn(pos.left(1)))
			pos = position.down(i)
			ret.add(system.getPathIn(pos.down(1)))
			ret.add(system.getPathIn(pos.left(1)))
			ret.add(system.getPathIn(pos.right(1)))		
			pos = position.left(i)
			ret.add(system.getPathIn(pos.left(1)))
			ret.add(system.getPathIn(pos.down(1)))
			ret.add(system.getPathIn(pos.up(1)))		
			pos = position.right(i)
			ret.add(system.getPathIn(pos.right(1)))
			ret.add(system.getPathIn(pos.up(1)))
			ret.add(system.getPathIn(pos.down(1)))		
		} )
		return ret.flatten()
	}
	
	method orderEnemies(enemies) {
		var enemiesInRange = self.setPathInRange(position).map( { camino => game.colliders(camino) } )
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
		if (cost <= jugador.oro() && cabezal.sePuedeConstruir()) {
			jugador.perderOro(cost)
			self.position(cabezal.position())
			system.agregarT(self)
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
	
	override method esTorre() = true
}

class TorreCanion inherits Torre {
	method image () = "torreCañon.png"
}

class TorreShock inherits Torre {
	//Honestamente no se que hacer con esta torre, o podria congelar a los enemigos por un turno y tener cooldown 
	//O podria hacer ataque en cadena, que cuantos mas enemigos haya mas daño hace, no tengo ni idea.
	method image () = "torreShock.png"
}

class TorreBallesta inherits Torre {
	method image () = "torreBallesta.png"
}

class TorreBomba inherits Torre {
	var property aoeRange  = 2
	method image () = "torreBomba.png"
	
	override method atacar() {
		var allEnemies = self.orderEnemies([])
		if (not allEnemies.isEmpty()) {
			var aoe = self.getAoE(allEnemies.head())
			aoe.forEach( { enemigo => enemigo.perderVida(atk)  } )
		}
	}
	
	method getAoE(enemy) {
		var ret = []
		var enemiesInRange = self.setPathInRange(enemy.position()).map( { camino => game.colliders(camino) } )
		enemiesInRange.forEach( { enemiesInPath => 
			enemiesInPath.forEach( { enemie => ret.add(enemie) } )
		} )	
		return ret
	}
}

class TorreGatling inherits Torre {
	method image () = "torreGatling.png"
}

class Mina inherits ObjetoEnPantalla { 
    const property atk = 30
	const property cost = 60
	
	method image() = "mina.png"
	
	method explotar() {
		var enemigos = game.colliders(self).filter( { obj => not obj.esCamino() } )
		if (not enemigos.isEmpty()) {
		enemigos.forEach( { enemigo => enemigo.perderVida(atk) } )
		self.quitarDePantalla()
		system.quitarM(self)
		}
	}
	
	method vender() {
		jugador.ganarOro(cost/3)
		self.quitarDePantalla()
		system.quitarM(self)
	}
	
	method construir() {
		if (cost <= jugador.oro() && cabezal.sePuedeConstruirM()) {
			jugador.perderOro(cost)
			self.position(cabezal.position())
			self.agregarAPantalla()
			system.agregarM(self)
		}
	}
}
