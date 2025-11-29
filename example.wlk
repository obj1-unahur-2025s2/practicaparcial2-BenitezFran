// ================ PERSONAJE ================
// actualizacion de cositas
class Personaje {

var rol
// cazador , brujo, guerrero
const property fuerza
const inteligencia
const estrategia

  method estrategia() = estrategia

  method cambiarRol(unNuevoRol){
    rol = unNuevoRol
  }
  method potencialOfensivo(){
   return fuerza * 10 + rol.extra()
  }
  method esInteligente()
  method esGroso() = self.esInteligente() || 
                      rol.esGroso(self)
}
// ================ ORCO ================
class Orco inherits Personaje{
  override method potencialOfensivo(){
    return 
      super() + rol.brutalidadInnata(super())
  }
  override method esInteligente() = false
}

// ================ HUMANOS ================
class Humanos inherits Personaje{
    
    override method esInteligente() = inteligencia > 50
}


// ===== guerrero
object rolGuerrero{

  method extra() = 100
  method brutalidadInnata(unValor) {
    return 0
  }
  method esGroso(unPersonaje){
    return unPersonaje.fuerza()>50
  }
}
// ===== cazador
class RolCazador{
 var mascota = new Mascota(fuerza = 0, edad = 0, tieneGarras = false)

 method cambiarMascota(num, num2 , bol ) {
   mascota = new Mascota(fuerza = num, edad = num2, tieneGarras = bol)
 }
  method brutalidadInnata(unValor) {
    return 0
  }

 method extra() = mascota.extra()
 method esGroso(unPersonaje){
  mascota.esLongeva()
 }
}
// ===== mascota
class Mascota{
  const fuerza
  const edad
  const tieneGarras

  method extra() = if(tieneGarras) fuerza * 2 else fuerza

  method initialize(){
    if(fuerza >= 100){
      self.error("la mascota no puede tener fuerza mayor a 100")
    }
  }
  method esLongeva() = edad > 10
}
// ===== brujo
object rolBrujo{
  method extra(){}
  method brutalidadInnata(unValor) {
    return unValor * 0.1
  }
  method esGroso(unPersonaje) = true
}


// ================ LOCALIDADES ================
class Localidades{
  var ejercito = new Ejercito()
  method enlistar(unPersonaje){
    ejercito.agregar(unPersonaje)
  }
  method poderDefensivo() = ejercito.potencialOfensivo()
  method serOcupada(unEjercito)
}
// ==== ALDEA
class Aldea inherits Localidades{

  const cantMaxima

  override method enlistar(unPersonaje){
    if(ejercito.personajes().size() >= cantMaxima){
      self.error("Ejercito Completo")
    }
    super(unPersonaje)
  } 
  override method serOcupada(unEjercito){
    ejercito.clear()
    unEjercito.losNamberWan().forEach({
      p=>self.enlistar(p)
    })
    unEjercito.quitarLosNamberWan(cantMaxima.min(10))
  }
}
// ==== CIUDAD
class Ciudad inherits Localidades{
  override method poderDefensivo(){
    return super() + 300
  }
  override method serOcupada(unEjercito){
    ejercito = unEjercito
  }
}
// ==== Ejercito
class Ejercito{
  const property personajes = #{}

  method potencial() = personajes.sum({p=>p.potencialOfensivo()})
  method agregar(unPersonaje){personajes.add(unPersonaje)}

  method invadir(unaLocalidad){
    if(self.puedeInvadir(unaLocalidad)){
      unaLocalidad.serOcupada(self)
    }
  }
  method puedeInvadir(unaLocalidad){
    return 
      self.potencial() > unaLocalidad.poderDefensivo()
  }
  method losNamberWan() = self.listaOrdenadaPorPoder().take(10)
  method listaOrdenadaPorPoder(){
    return personajes.aslist().sortBy({p1,p2=>p1.potencialOfensivo()>p2.potencialOfensivo()})
  }

  method quitarLosNamberWan(cantidadAQuitar){
    personajes.removeAll(self.losNamberWan().take(cantidadAQuitar))
  }
}
