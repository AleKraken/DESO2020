import 'package:comidapp/models/ingrediente.dart';

class ComidaCreada {
  static ComidaCreada comidaCreada;

  List<Ingrediente> listaIngredientes = new List<Ingrediente>();
  List<String> listaCantidadesIngredientes = new List<String>();
  String nombreComida;
  String categoria;
  String area;
  String pasosPreparacion;
  int minutosPreparacion;
  String rutaImagen;
  int calorias;

  void limpiarElementos() {
    listaIngredientes.clear();
    listaCantidadesIngredientes.clear();
    nombreComida = "";
    categoria = "";
    area = "";
    pasosPreparacion = "";
    minutosPreparacion = null;
    rutaImagen = "";
    calorias = null;
  }

  static ComidaCreada getComidaCreada() {
    if (comidaCreada == null) {
      comidaCreada = new ComidaCreada();
    }
    return comidaCreada;
  }

  void setNombreComida(String _nombreComida) {
    nombreComida = _nombreComida;
  }

  void setCategoria(String _categoria) {
    categoria = _categoria;
  }

  void setArea(String _area) {
    area = _area;
  }

  void setPasosPreparacion(String _pasosPreparacion) {
    pasosPreparacion = _pasosPreparacion;
  }

  void setMinutosPreparacion(int _minutosPreparacion) {
    minutosPreparacion = _minutosPreparacion;
  }

  void setRutaImagen(String _rutaImagen) {
    rutaImagen = _rutaImagen;
  }

  void setCalorias(int _calorias) {
    calorias = _calorias;
  }

  String getNombreComida() => nombreComida;

  String getCategoria() => categoria;

  String getArea() => area;

  String getPasosPreparacion() => pasosPreparacion;

  int getMinutosPreparacion() => minutosPreparacion;

  String getRutaImagen() => rutaImagen;

  int getCalorias() => calorias;

  List<Ingrediente> getListaIngredientes() => listaIngredientes;
  List<String> getListaCantidadesIngredientes() => listaCantidadesIngredientes;

  void agregarIngrediente(Ingrediente ingrediente) {
    listaIngredientes.add(ingrediente);
  }

  void quitarIngrediente(Ingrediente ingrediente) {
    for (int i = 0; i < listaIngredientes.length; i++) {
      if (ingrediente.idIngrediente == listaIngredientes[i].idIngrediente) {
        listaIngredientes.removeAt(i);
        quitarCantidadIngredienteDeLista(i);
      }
    }
  }

  void agregarCantidadIngredienteALista() {
    listaCantidadesIngredientes.add("");
  }

  void setCantidadIngrediente(int index, String cantidad) {
    listaCantidadesIngredientes[index] = cantidad;
  }

  void quitarCantidadIngredienteDeLista(int index) {
    listaCantidadesIngredientes.removeAt(index);
  }
}
