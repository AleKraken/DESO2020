import 'package:comidapp/json/JsonGetter.dart';
import 'package:comidapp/models/comida.dart';
import 'package:comidapp/json/ingredientFromJson.dart';
import 'package:comidapp/models/ingrediente.dart';
import 'package:comidapp/json/mealsFromJson.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  //CONSTANTES PARA LA TABLA 'COMIDA'
  static const String TABLE_COMIDA = "Comida";
  static const String COLUMN_IDCOMIDA = "idComida";
  static const String COLUMN_NOMBRECOMIDA = "nombreComida";
  static const String COLUMN_DESCRIPCION = "descripcion";
  static const String COLUMN_MINUTOSPREPARACION = "minutosPreparacion";
  static const String COLUMN_PASOSPREPARACION = "pasosPreparacion";
  static const String COLUMN_CALORIAS = "calorias";
  static const String COLUMN_RUTAIMAGEN = "rutaImagen";
  static const String COLUMN_FAVORITOCOMIDA = "favoritoComida";

  //CONSTANTES PARA LA TABLA 'INGREDIENTE'
  static const String TABLE_INGREDIENTE = "Ingrediente";
  static const String COLUMN_IDINGREDIENTE = "idIngrediente";
  static const String COLUMN_NOMBREINGREDIENTE = "nombreIngrediente";
  static const String COLUMN_RUTAIMAGENINGREDIENTE = "rutaImagenIngrediente";
  static const String COLUMN_FAVORITOINGREDIENTE = "favoritoIngrediente";

  //CONSTANTES PARA LA TABLA  COMIDA-INGREDIENTE
  static const String TABLE_COMIDA_HAS_INGREDIENTE = "comidaIngrediente";
  static const String COLUMN_FOREIGN_COMIDA = "comida_idComida";
  static const String COLUMN_FOREIGN_INGREDIENTE = "ingrediente_idIngrediente";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'Comidapp.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creando Tablas");

        //TABLA DE COMIDAS
        await database.execute(
          "CREATE TABLE IF NOT EXISTS $TABLE_COMIDA ("
          "$COLUMN_IDCOMIDA INTEGER NOT NULL,"
          "$COLUMN_NOMBRECOMIDA TEXT NOT NULL,"
          "$COLUMN_DESCRIPCION TEXT,"
          "$COLUMN_MINUTOSPREPARACION INTEGER NOT NULL,"
          "$COLUMN_PASOSPREPARACION TEXT NOT NULL,"
          "$COLUMN_CALORIAS INTEGER,"
          "$COLUMN_RUTAIMAGEN TEXT,"
          "$COLUMN_FAVORITOCOMIDA INTEGER NOT NULL,"
          "PRIMARY KEY ($COLUMN_IDCOMIDA AUTOINCREMENT)"
          ");",
        );

        //TABLA DE INGREDIENTES
        await database.execute(
          "CREATE TABLE IF NOT EXISTS $TABLE_INGREDIENTE ("
          "$COLUMN_IDINGREDIENTE INTEGER NOT NULL,"
          "$COLUMN_NOMBREINGREDIENTE TEXT NOT NULL,"
          "$COLUMN_RUTAIMAGENINGREDIENTE TEXT,"
          "$COLUMN_FAVORITOINGREDIENTE INTEGER NOT NULL,"
          "PRIMARY KEY ($COLUMN_IDINGREDIENTE AUTOINCREMENT)"
          ");",
        );

        //TABLA COMIDAS-INGREDIENTES
        await database.execute(
          "CREATE TABLE IF NOT EXISTS $TABLE_COMIDA_HAS_INGREDIENTE ("
          "$COLUMN_FOREIGN_COMIDA INTEGER,"
          "$COLUMN_FOREIGN_INGREDIENTE INTEGER"
          ");",
        );

        //INSERTAR INFORMACION DE COMIDAS
        Meal listaComidas = await JsonGetter.getComidas();

        for (int i = 0; i < listaComidas.meals.length; i++) {
          String nombreComida = '"${listaComidas.meals[i].strMeal}"';
          String rutaImagen = '"${listaComidas.meals[i].strMealThumb}"';

          print("GUARDANDO COMIDA $i EN BASE");
          await database.execute("INSERT INTO $TABLE_COMIDA "
              "($COLUMN_NOMBRECOMIDA, $COLUMN_DESCRIPCION, $COLUMN_MINUTOSPREPARACION, $COLUMN_PASOSPREPARACION, $COLUMN_CALORIAS, $COLUMN_RUTAIMAGEN, $COLUMN_FAVORITOCOMIDA)"
              " values ($nombreComida, 'Rica ensaladita para la dieta', 45, '1.- Sírvelo y listo xd', 750, $rutaImagen, 0);");
        }

        //INSERTAR INFORMACIÓN DE INGREDIENTES
        Ingredient listaIngredientes = await JsonGetter.getIngredientes();

        for (int i = 0; i < listaIngredientes.ingredientes.length; i++) {
          String nombreIngrediente =
              '"${listaIngredientes.ingredientes[i].strIngredient}"';
          String rutaImagenIngrediente =
              '"https://www.themealdb.com/images/ingredients/${listaIngredientes.ingredientes[i].strIngredient}-Small.png"';

          print("GUARDANDO INGREDIENTE $i EN BASE");
          await database.execute("INSERT INTO $TABLE_INGREDIENTE "
              "($COLUMN_NOMBREINGREDIENTE, $COLUMN_RUTAIMAGENINGREDIENTE, $COLUMN_FAVORITOINGREDIENTE)"
              " values ($nombreIngrediente, $rutaImagenIngrediente, 0);");
        }
      },
    );
  }

  Future<List<Comida>> getComidas() async {
    final db = await database;

    var comidas = await db.rawQuery("SELECT "
        "$COLUMN_IDCOMIDA,"
        "$COLUMN_NOMBRECOMIDA,"
        "$COLUMN_DESCRIPCION,"
        "$COLUMN_MINUTOSPREPARACION,"
        "$COLUMN_PASOSPREPARACION,"
        "$COLUMN_CALORIAS,"
        "$COLUMN_RUTAIMAGEN,"
        "$COLUMN_FAVORITOCOMIDA "
        "FROM $TABLE_COMIDA ");

    List<Comida> listaComidas = List<Comida>();

    comidas.forEach((comidaActual) {
      Comida comida = Comida.fromMap(comidaActual);
      listaComidas.add(comida);
    });

    return listaComidas;
  }

  Future<List<Ingrediente>> getIngredientes() async {
    final db = await database;

    var ingredientes = await db.rawQuery("SELECT "
        "$COLUMN_IDINGREDIENTE,"
        "$COLUMN_NOMBREINGREDIENTE,"
        "$COLUMN_RUTAIMAGENINGREDIENTE,"
        "$COLUMN_FAVORITOINGREDIENTE "
        "FROM $TABLE_INGREDIENTE ");

    List<Ingrediente> listaIngredientes = List<Ingrediente>();

    ingredientes.forEach((ingredienteActual) {
      Ingrediente ingrediente = Ingrediente.fromMap(ingredienteActual);
      listaIngredientes.add(ingrediente);
    });

    return listaIngredientes;
  }

  Future<List<Ingrediente>> getIngredientesEnComida(
      int idComidaSeleccionada) async {
    final db = await database;

    var ingredientes = await db.rawQuery("SELECT "
        "a.$COLUMN_IDINGREDIENTE,"
        "a.$COLUMN_NOMBREINGREDIENTE,"
        "a.$COLUMN_FAVORITOINGREDIENTE "
        "FROM $TABLE_INGREDIENTE a, $TABLE_COMIDA_HAS_INGREDIENTE b "
        "WHERE b.$COLUMN_FOREIGN_COMIDA = $idComidaSeleccionada");

    List<Ingrediente> listaIngredientes = List<Ingrediente>();

    ingredientes.forEach((ingredienteActual) {
      Ingrediente ingrediente = Ingrediente.fromMap(ingredienteActual);
      listaIngredientes.add(ingrediente);
    });

    return listaIngredientes;
  }
}
