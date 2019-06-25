import sistema.*
import wollok.game.*

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
		jugador.perderHp(atk)
		self.quitarDePantalla()
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
	
	//method ganarVida(cant) { //hice este metodo por si nos pinta hacer unidades enemigas que puedan curar
	//	if (vida+cant >= maxHp) {
	//		vida = maxHp
	//	} else {
	//		vida += cant
	//	}
	//}

	method avanzar() {
		//new Range(1, speed).forEach( { n => 
			//if((pos+1) >= system.distanciaALaMeta()) { self.atacar() } 
			//else { 
				//self.position(system.camino().get(pos+1).position())
				//pos = pos + 1
			//}
		//} )
		
		
		if ((pos+speed) >= system.distanciaALaMeta()) {
			self.atacar()
		} else {
			self.position(system.camino().get(pos+speed).position())
			pos = pos + speed
		} 
	}
}

class Raider inherits Enemy {
	//Unidad enemiga estandar. Te mete el hacha por el or..
	method image() = "enemigo1.png"
}

class Incredibilis inherits Enemy { //Lo siento chicos, pero ponerle este nombre fue algo que no pude evitar.
	//Comandante enemigo, aumenta la moral (stat) de sus compañeros.
	method image() = "enemigo2.png"
}

class Alien inherits Enemy {
	//Unidad veloz pero con un daño minimo, pensada para asaltos rapidos.
	method image() = "enemigo3.png"
}

class Curandero inherits Enemy {
	//Unidad enemiga que cura, su daño para el player es infimo.
	method image() = "enemigo4.png"
}

class ShovelKnight inherits Enemy {
	//Unidad de asalto pesado, lento en avance pero tiene mucho aguanta y un gran poder de ataque.
	method image() = "enemigo5.png"
}
