import wollok.game.*
import sistema.*
import torres.*
import enemigos.*
import camino.*

class Niveles {
	
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
		return new AlienSith (atk = 10, vida = 30, recompenza = 120, speed = 4)
	}
	
	method inutilQueBufea() {
		return new Curandero (atk = 10, vida = 75, recompenza = 60, speed = 2)
	}
	
	method inutilConTuercas() {
		return new Robot (atk = 14, vida = 110, recompenza = 115, speed = 1)
	}
	
	method inutilDeOtroMundo() {
		return new Alien (atk = 6, vida = 40, recompenza = 75, speed = 2)
	}
	
	method inutilEspacial() {
		return new AlienTrooper (atk = 8, vida = 80, recompenza = 100, speed = 3)
	}
	
	method inutilNoMuerto() {
		return new Zombie (atk = 3, vida = 20, recompenza = 30, speed = 2)
	}
	
	method inutilNoMuertoConEstilo() {
		return new ZombieAxe (atk = 5, vida = 25, recompenza = 35, speed = 2)
	}
	
	method shovelKnight() {
		return new ShovelKnight (atk = 5000, vida = 2500, recompenza = 2000, speed = 1)
	}
	
	method dakhKnight() {
		return new DarkLord (atk = 5000, vida = 2300, recompenza = 2500, speed = 2)
	}
	
	method weWillTakeJerusalem() {
		return new DeusVult (atk = 5000, vida = 1800, recompenza = 3000, speed = 2)
	}
	
	method abomination() {
		return new MadDog (atk = 5000, vida = 2000, recompenza = 2000, speed = 3)
	}
}

object nivel1 inherits Niveles {
	
	method crear() {
	game.clear()
	game.ground("fondo.png")
	const c1 = new Camino(position = game.at(0,0))
	const c2 = new Camino(position = game.at(0,1))
	const c3 = new Camino(position = game.at(1,1))
	const c4 = new Camino(position = game.at(1,2))
	const c5 = new Camino(position = game.at(1,3))
	const c6 = new Camino(position = game.at(2,3))
	const c7 = new Camino(position = game.at(3,3))
	const c8 = new Camino(position = game.at(4,3))
	const c9 = new Camino(position = game.at(5,3))
	const c10 = new Camino(position = game.at(5,4))
	const c11 = new Camino(position = game.at(5,5))
	const c12 = new Camino(position = game.at(5,6))
	const c13 = new Camino(position = game.at(5,7))
	const c14 = new Camino(position = game.at(6,7))
	const c15 = new Camino(position = game.at(6,8))
	const c16 = new Camino(position = game.at(6,9))
	const c17 = new Camino(position = game.at(7,9))
	cabezal.agregarAPantalla()
	game.addVisualIn(jugador, game.at(8,9))
	c1.agregarAPantalla()
	c2.agregarAPantalla()
	c3.agregarAPantalla()
	c4.agregarAPantalla()
	c5.agregarAPantalla()
	c6.agregarAPantalla()
	c7.agregarAPantalla()
	c8.agregarAPantalla()
	c9.agregarAPantalla()
	c10.agregarAPantalla()
	c11.agregarAPantalla()
	c12.agregarAPantalla()
	c13.agregarAPantalla()
	c14.agregarAPantalla()
	c15.agregarAPantalla()
	c16.agregarAPantalla()
	c17.agregarAPantalla()
	system.camino([c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17])
	}
	
	method limiteDeTurnos(){
		return 38
	}
	
	method spawnWave() {
		var waveToSpawn = []
		if (system.turn() == 1) {
			2.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
		}
		if (system.turn() == 5) {
			3.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
			2.times( { n => waveToSpawn.add(self.inutilDelHacha()) } )
			3.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
		}
		if (system.turn() == 10) {
			2.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
			4.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
			3.times( { n => waveToSpawn.add(self.inutilDelHacha()) } )
			1.times( { n => waveToSpawn.add(self.inutilQueBufea()) } )
		}
		if (system.turn() == 14) {
			5.times( { n => waveToSpawn.add(self.inutilDelHacha()) } )
			5.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
		}
		if (system.turn() == 18) {
			5.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
			3.times( { n => waveToSpawn.add(self.inutilDelHacha()) } )
		}
		if (system.turn() == 20) {
			1.times( { n => waveToSpawn.add(self.shovelKnight()) } )
			2.times( { n => waveToSpawn.add(self.inutilQueBufea()) } )
		}
		if (system.turn() == 22) {
			7.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
			3.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
		}
		if (system.turn() == 26) {
			3.times( { n => waveToSpawn.add(self.inutilDeLaEspada()) } )
			6.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
		}
		if (system.turn() == 30) {
			15.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
		}
		waveToSpawn.forEach( { enemy => enemy.engendrar() } )
	}
}

object nivel2 inherits Niveles {
		method crear() {
		game.clear()
		game.ground("fondoArena.jpg")			
		const c1 = new Camino(position = game.at(0,0))
		const c2 = new Camino(position = game.at(0,1))
		const c3 = new Camino(position = game.at(1,1))
		const c4 = new Camino(position = game.at(1,2))
		const c5 = new Camino(position = game.at(1,3))
		const c6 = new Camino(position = game.at(1,4))
		const c7 = new Camino(position = game.at(1,5))
		const c8 = new Camino(position = game.at(1,6))
		const c9 = new Camino(position = game.at(1,7))
		const c10 = new Camino(position = game.at(2,7))
		const c11 = new Camino(position = game.at(3,7))
		const c12 = new Camino(position = game.at(4,7))
		const c13 = new Camino(position = game.at(5,7))
		const c14 = new Camino(position = game.at(5,6))
		const c15 = new Camino(position = game.at(5,5))
		const c16 = new Camino(position = game.at(5,4))
		const c17 = new Camino(position = game.at(6,4))
		cabezal.agregarAPantalla()
		game.addVisualIn(jugador, game.at(7,4))
		c1.agregarAPantalla()
		c2.agregarAPantalla()
		c3.agregarAPantalla()
		c4.agregarAPantalla()
		c5.agregarAPantalla()
		c6.agregarAPantalla()
		c7.agregarAPantalla()
		c8.agregarAPantalla()
		c9.agregarAPantalla()
		c10.agregarAPantalla()
		c11.agregarAPantalla()
		c12.agregarAPantalla()
		c13.agregarAPantalla()
		c14.agregarAPantalla()
		c15.agregarAPantalla()
		c16.agregarAPantalla()
		c17.agregarAPantalla()
		system.camino([c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17])
	}
	
	method limiteDeTurnos(){
		return 76
	}
		
	method spawnWave() {
	var waveToSpawn = []
	if (system.turn() == 39) {
		5.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
	}
	if (system.turn() == 43) {
		7.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		5.times( { n => waveToSpawn.add(self.inutilEspacial()) } )
		7.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
	}
	if (system.turn() == 47) {
		5.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		6.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
	}
	if (system.turn() == 48) {
		7.times( { n => waveToSpawn.add(self.inutilEspacial()) } )
		3.times( { n => waveToSpawn.add(self.inutilConTuercas()) } )
	}
	if (system.turn() == 52) {
		5.times( { n => waveToSpawn.add(self.inutilConTuercas()) } )
		5.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
	}
	if (system.turn() == 56) {
		8.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
		5.times( { n => waveToSpawn.add(self.inutilEspacial()) } )
		4.times( { n => waveToSpawn.add(self.inutilConTuercas()) } )
	}
	if (system.turn() == 58) {
		9.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		4.times( { n => waveToSpawn.add(self.inutilConTuercas()) } )
	}
	if (system.turn() == 59) {
		8.times( { n => waveToSpawn.add(self.inutilConTuercas()) } )
		7.times( { n => waveToSpawn.add(self.inutilEspacial()) } )
	}
	if (system.turn() == 60) {
		7.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		10.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
	}
	if (system.turn() == 62) {
		8.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		5.times( { n => waveToSpawn.add(self.inutilEspacial()) } )
	}
	if (system.turn() == 64) {
		5.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		9.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
	}
	if (system.turn() == 67) {
		13.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		1.times( { n => waveToSpawn.add(self.dakhKnight()) } )
	}
	if (system.turn() == 68) {
		9.times( { n => waveToSpawn.add(self.inutilEspacial()) } )
		1.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
	}
	waveToSpawn.forEach( { enemy => enemy.engendrar() } )
	}
}
object nivel3 inherits Niveles {
		method crear() {
		game.clear()
		game.ground("fondoNevado.jpg")			
		const c1 = new Camino(position = game.at(0,0))
		const c2 = new Camino(position = game.at(0,1))
		const c3 = new Camino(position = game.at(1,1))
		const c4 = new Camino(position = game.at(2,1))
		const c5 = new Camino(position = game.at(3,1))
		const c6 = new Camino(position = game.at(4,1))
		const c7 = new Camino(position = game.at(5,1))
		const c8 = new Camino(position = game.at(5,2))
		const c9 = new Camino(position = game.at(5,3))
		const c10 = new Camino(position = game.at(5,4))
		const c11 = new Camino(position = game.at(4,4))
		const c12 = new Camino(position = game.at(4,5))
		const c13 = new Camino(position = game.at(4,6))
		const c14 = new Camino(position = game.at(4,7))
		const c15 = new Camino(position = game.at(3,7))
		const c16 = new Camino(position = game.at(2,7))
		const c17 = new Camino(position = game.at(2,8))
		cabezal.agregarAPantalla()
		game.addVisualIn(jugador, game.at(2,9))
		c1.agregarAPantalla()
		c2.agregarAPantalla()
		c3.agregarAPantalla()
		c4.agregarAPantalla()
		c5.agregarAPantalla()
		c6.agregarAPantalla()
		c7.agregarAPantalla()
		c8.agregarAPantalla()
		c9.agregarAPantalla()
		c10.agregarAPantalla()
		c11.agregarAPantalla()
		c12.agregarAPantalla()
		c13.agregarAPantalla()
		c14.agregarAPantalla()
		c15.agregarAPantalla()
		c16.agregarAPantalla()
		c17.agregarAPantalla()
		system.camino([c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17])
	}

	method limiteDeTurnos(){
		return 104
	}
	
	method spawnWave() {
	var waveToSpawn = []
	if (system.turn() == 39) {
		5.times( { n => waveToSpawn.add(self.inutilNoMuerto()) } )
	}
	if (system.turn() == 43) {
		7.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		5.times( { n => waveToSpawn.add(self.inutilEspacial()) } )
		7.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
	}
	if (system.turn() == 47) {
		5.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		6.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
	}
	if (system.turn() == 48) {
		7.times( { n => waveToSpawn.add(self.inutilEspacial()) } )
		3.times( { n => waveToSpawn.add(self.inutilConTuercas()) } )
	}
	if (system.turn() == 52) {
		5.times( { n => waveToSpawn.add(self.inutilConTuercas()) } )
		5.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
	}
	if (system.turn() == 56) {
		8.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
		5.times( { n => waveToSpawn.add(self.inutilEspacial()) } )
		4.times( { n => waveToSpawn.add(self.inutilConTuercas()) } )
	}
	if (system.turn() == 58) {
		9.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		4.times( { n => waveToSpawn.add(self.inutilConTuercas()) } )
	}
	if (system.turn() == 59) {
		8.times( { n => waveToSpawn.add(self.inutilConTuercas()) } )
		7.times( { n => waveToSpawn.add(self.inutilEspacial()) } )
	}
	if (system.turn() == 60) {
		7.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		10.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
	}
	if (system.turn() == 62) {
		8.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		5.times( { n => waveToSpawn.add(self.inutilEspacial()) } )
	}
	if (system.turn() == 64) {
		5.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		9.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
	}
	if (system.turn() == 67) {
		13.times( { n => waveToSpawn.add(self.inutilDeOtroMundo()) } )
		1.times( { n => waveToSpawn.add(self.dakhKnight()) } )
	}
	if (system.turn() == 68) {
		9.times( { n => waveToSpawn.add(self.inutilEspacial()) } )
		1.times( { n => waveToSpawn.add(self.inutilQueCorre()) } )
	}
	waveToSpawn.forEach( { enemy => enemy.engendrar() } )
	}
}