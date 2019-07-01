import sistema.*
import wollok.game.*
import camino.*

class Enemy inherits ObjetoEnPantalla {
	const property atk
	var   property vida
	const property recompenza
	const property speed
	
	var   property pos    = 0
	
	method engendrar() {
		self.agregarAPantalla()
		system.agregarE(self)
	}
	
	method atacar() {
		self.quitarDePantalla()
		jugador.perderHp(atk)
		system.quitarE(self)
	}
	
	method morir() {
		jugador.ganarOro(recompenza)
		self.quitarDePantalla()
		system.quitarE(self)
	}
	
	method perderVida(cant) {
		if (cant >= vida) {
			self.morir()
		} else {
			vida -= cant
		}
	}
	
	method ganarVida(cant) { 
		vida += cant
	}

	method avanzar() {
		if((pos+speed) >= system.distanciaALaMeta()) { self.atacar() } 
		else { 
			new Range(1, speed).forEach( { n => 
				self.position(system.camino().get(pos+1).position())
					pos = pos + 1
			} )
		}
	}
}

class Raider inherits Enemy {
	method image() = "enemigo1.png"
}

class Incredibilis inherits Enemy { 
	method image() = "enemigo2.png"
}

class AlienSith inherits Enemy {
	method image() = "enemigo3.png"
}

class Curandero inherits Enemy {
	method image() = "enemigo4.png"
		
	override method avanzar(){
		if((pos+speed) >= system.distanciaALaMeta()) { self.atacar() } 
		else { 
			new Range(1, speed).forEach( { n => 
				self.position(system.camino().get(pos+1).position())
					pos = pos + 1
				self.ganarVida(15)
			} )
		}
	}
}

class ShovelKnight inherits Enemy {
	method image() = "enemigo5.png"
}

class Robot inherits Enemy {
	method image() = "robot.png"
}

class Zombie inherits Enemy {
	method image() = "zombie.png"
}

class AlienTrooper inherits Enemy {
	method image() = "alienz.png"
}

class Alien inherits Enemy {
	method image() = "alien.png"
}

class ZombieAxe inherits Enemy {
	method image() = "zombie1.png"
}

class DarkLord inherits Enemy {
	method image() = "Boss2.png"
}

class DeusVult inherits Enemy {
	method image() = "Boss.png"
	
	override method avanzar(){
		if((pos+speed) >= system.distanciaALaMeta()) { self.atacar() } 
		else { 
			new Range(1, speed).forEach( { n => 
				self.position(system.camino().get(pos+1).position())
					pos = pos + 1
				self.ganarVida(50)
			} )
		}
	}
	
	override method morir(){
		system.ganar()
	}
}

class MadDog inherits Enemy {
	method image() = "bosses.png"
}