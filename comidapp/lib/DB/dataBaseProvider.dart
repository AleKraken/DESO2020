import 'dart:math';

import 'package:comidapp/json/JsonGetter.dart';
import 'package:comidapp/models/comida.dart';
import 'package:comidapp/models/comidaHasIngrediente.dart';
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
  static const String COLUMN_CATEGORIACOMIDA = "categoriaComida";
  static const String COLUMN_AREA = "area";
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

  //CONSTANTES PARA LA TABLA  COMIDA-INGREDIENTE Y FAVORITOS
  static const String TABLE_COMIDA_HAS_INGREDIENTE = "ComidaHasIngrediente";
  static const String COLUMN_FOREIGN_COMIDA = "comida_idComida";
  static const String COLUMN_FOREIGN_INGREDIENTE = "ingrediente_idIngrediente";
  static const String COLUMN_MEDIDAINGREDIENTE = "medidaIngrediente";

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
        print("CREANDO TABLA COMIDA");
        await database.execute(
          "CREATE TABLE IF NOT EXISTS $TABLE_COMIDA ("
          "$COLUMN_IDCOMIDA INTEGER NOT NULL,"
          "$COLUMN_NOMBRECOMIDA TEXT NOT NULL,"
          "$COLUMN_CATEGORIACOMIDA TEXT,"
          "$COLUMN_AREA TEXT,"
          "$COLUMN_MINUTOSPREPARACION INTEGER,"
          "$COLUMN_PASOSPREPARACION TEXT NOT NULL,"
          "$COLUMN_CALORIAS INTEGER,"
          "$COLUMN_RUTAIMAGEN TEXT,"
          "$COLUMN_FAVORITOCOMIDA INTEGER NOT NULL,"
          "PRIMARY KEY ($COLUMN_IDCOMIDA AUTOINCREMENT)"
          ");",
        );

        //TABLA DE INGREDIENTES
        print("CREANDO TABLA INGREDIENTES");
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
        print("CREANDO TABLA COMIDAS-INGREDIENTES");
        await database.execute(
          "CREATE TABLE IF NOT EXISTS $TABLE_COMIDA_HAS_INGREDIENTE ("
          "$COLUMN_FOREIGN_COMIDA INTEGER,"
          "$COLUMN_FOREIGN_INGREDIENTE INTEGER,"
          "$COLUMN_MEDIDAINGREDIENTE"
          ");",
        );

        //INSERTAR INFORMACION DE COMIDAS
        Meal listaComidas = await JsonGetter.getComidas();

        for (int i = 0; i < listaComidas.meals.length; i++) {
          var rng = new Random();

          print("INSERTANDO COMIDA $i");
          String nombreComida = '${listaComidas.meals[i].strMeal}';
          String categoria = '${listaComidas.meals[i].strCategory}';
          String area = '${listaComidas.meals[i].strArea}';
          int minutos = rng.nextInt(135) + 15;
          String instrucciones = '${listaComidas.meals[i].strInstructions}';
          int calorias = rng.nextInt(1150) + 150;
          String rutaImagen = '${listaComidas.meals[i].strMealThumb}';

          Comida comida = new Comida(
              nombreComida: nombreComida,
              categoria: categoria,
              area: area,
              minutosPreparacion: minutos,
              pasosPreparacion: instrucciones,
              calorias: calorias,
              rutaImagen: rutaImagen,
              favoritoComida: 0);

          await database.insert(TABLE_COMIDA, comida.toMap());

          print("GUARDANDO COMIDA $i EN BASE");
        }
        //INSERTAR INFORMACIÓN DE INGREDIENTES
        Ingredient listaIngredientes = await JsonGetter.getIngredientes();

        for (int i = 0; i < listaIngredientes.ingredientes.length; i++) {
          print("INSERTANDO INGREDIENTE $i");
          String nombreIngrediente =
              '"${listaIngredientes.ingredientes[i].strIngredient}"';
          String rutaImagenIngrediente =
              '"https://www.themealdb.com/images/ingredients/${listaIngredientes.ingredientes[i].strIngredient}-Small.png"';

          print("GUARDANDO INGREDIENTE $i EN BASE");
          await database.execute("INSERT INTO $TABLE_INGREDIENTE "
              "($COLUMN_NOMBREINGREDIENTE, $COLUMN_RUTAIMAGENINGREDIENTE, $COLUMN_FAVORITOINGREDIENTE)"
              " values ($nombreIngrediente, $rutaImagenIngrediente, 0);");
        }

        int getIdIngrediente(int indexComida, int indexIngrediente) {
          switch (indexIngrediente) {
            case 1:
              return listaComidas.meals[indexComida].idIngredient1;
              break;
            case 2:
              return listaComidas.meals[indexComida].idIngredient2;
              break;
            case 3:
              return listaComidas.meals[indexComida].idIngredient3;
              break;
            case 4:
              return listaComidas.meals[indexComida].idIngredient4;
              break;
            case 5:
              return listaComidas.meals[indexComida].idIngredient5;
              break;
            case 6:
              return listaComidas.meals[indexComida].idIngredient6;
              break;
            case 7:
              return listaComidas.meals[indexComida].idIngredient7;
              break;
            case 8:
              return listaComidas.meals[indexComida].idIngredient8;
              break;
            case 9:
              return listaComidas.meals[indexComida].idIngredient9;
              break;
            case 10:
              return listaComidas.meals[indexComida].idIngredient10;
              break;
            case 11:
              return listaComidas.meals[indexComida].idIngredient11;
              break;
            case 12:
              return listaComidas.meals[indexComida].idIngredient12;
              break;
            case 13:
              return listaComidas.meals[indexComida].idIngredient13;
              break;
            case 14:
              return listaComidas.meals[indexComida].idIngredient14;
              break;
            case 15:
              return listaComidas.meals[indexComida].idIngredient15;
              break;
            case 16:
              return listaComidas.meals[indexComida].idIngredient16;
              break;
            case 17:
              return listaComidas.meals[indexComida].idIngredient17;
              break;
            case 18:
              return listaComidas.meals[indexComida].idIngredient18;
              break;
            case 19:
              return listaComidas.meals[indexComida].idIngredient19;
              break;
            case 20:
              return listaComidas.meals[indexComida].idIngredient20;
              break;

            case 0:
              return 0;
              break;
          }
          return 0;
        }

        String getMedidaIngrediente(int indexComida, int indexIngrediente) {
          switch (indexIngrediente) {
            case 1:
              return listaComidas.meals[indexComida].strMeasure1;
              break;
            case 2:
              return listaComidas.meals[indexComida].strMeasure2;
              break;
            case 3:
              return listaComidas.meals[indexComida].strMeasure3;
              break;
            case 4:
              return listaComidas.meals[indexComida].strMeasure4;
              break;
            case 5:
              return listaComidas.meals[indexComida].strMeasure5;
              break;
            case 6:
              return listaComidas.meals[indexComida].strMeasure6;
              break;
            case 7:
              return listaComidas.meals[indexComida].strMeasure7;
              break;
            case 8:
              return listaComidas.meals[indexComida].strMeasure8;
              break;
            case 9:
              return listaComidas.meals[indexComida].strMeasure9;
              break;
            case 10:
              return listaComidas.meals[indexComida].strMeasure10;
              break;
            case 11:
              return listaComidas.meals[indexComida].strMeasure11;
              break;
            case 12:
              return listaComidas.meals[indexComida].strMeasure12;
              break;
            case 13:
              return listaComidas.meals[indexComida].strMeasure13;
              break;
            case 14:
              return listaComidas.meals[indexComida].strMeasure14;
              break;
            case 15:
              return listaComidas.meals[indexComida].strMeasure15;
              break;
            case 16:
              return listaComidas.meals[indexComida].strMeasure16;
              break;
            case 17:
              return listaComidas.meals[indexComida].strMeasure17;
              break;
            case 18:
              return listaComidas.meals[indexComida].strMeasure18;
              break;
            case 19:
              return listaComidas.meals[indexComida].strMeasure19;
              break;
            case 20:
              return listaComidas.meals[indexComida].strMeasure20;
              break;

            case 0:
              return "Vacío";
              break;
          }
          return "Vacío";
        }

        //INSERTAR EN LA TABLA COMIDA_HAS_INGREDIENTE
        int y = 0;
        for (int i = 0; i < listaComidas.meals.length; i++) {
          print("INSERTANDO $i EN COMIDA_HAS_INGREDIENTE");
          y = 0;
          while (y < 20) {
            int idIngrediente = getIdIngrediente(i, y + 1);
            String medidaIngrediente = '"${getMedidaIngrediente(i, y + 1)}"';

            await database.execute("INSERT INTO $TABLE_COMIDA_HAS_INGREDIENTE "
                "($COLUMN_FOREIGN_COMIDA, $COLUMN_FOREIGN_INGREDIENTE, $COLUMN_MEDIDAINGREDIENTE)"
                " values (${i + 1}, $idIngrediente, $medidaIngrediente);");
            await Future.delayed(Duration.zero);
            y++;
          }
          await Future.delayed(Duration.zero);
        }
      },
    );
  }

  Future setComidaFavorita(int idComida, int ponerFavorita) async {
    final db = await database;
    return await db.rawUpdate(
        "UPDATE $TABLE_COMIDA SET $COLUMN_FAVORITOCOMIDA = $ponerFavorita WHERE $COLUMN_IDCOMIDA =$idComida");
  }

  Future setIngredienteFavorito(int idIngrediente, int ponerFavorito) async {
    final db = await database;
    return await db.rawUpdate(
        "UPDATE $TABLE_INGREDIENTE SET $COLUMN_FAVORITOINGREDIENTE = $ponerFavorito WHERE $COLUMN_IDINGREDIENTE =$idIngrediente");
  }

  Future<List<Comida>> getComidas() async {
    final db = await database;

    var comidas = await db.rawQuery("SELECT "
        "$COLUMN_IDCOMIDA,"
        "$COLUMN_NOMBRECOMIDA,"
        "$COLUMN_CATEGORIACOMIDA,"
        "$COLUMN_AREA,"
        "$COLUMN_MINUTOSPREPARACION,"
        "$COLUMN_PASOSPREPARACION,"
        "$COLUMN_CALORIAS,"
        "$COLUMN_RUTAIMAGEN,"
        "$COLUMN_FAVORITOCOMIDA "
        "FROM $TABLE_COMIDA ");

    List<Comida> listaComidas = List<Comida>();
    comidas.forEach((comidaActual) async {
      Comida comida = Comida.fromMap(comidaActual);

      listaComidas.add(comida);
      await Future.delayed(Duration.zero);
    });

    for (int i = 0; i < listaComidas.length; i++) {
      listaComidas[i].listaIngredientesEnComida = new List<int>();
      listaComidas[i].listaMedidasIngredientes = new List<String>();

      List<Map<String, dynamic>> ingredientesEnComida = await db.rawQuery(
          "SELECT $COLUMN_FOREIGN_INGREDIENTE, $COLUMN_MEDIDAINGREDIENTE "
          "FROM $TABLE_COMIDA_HAS_INGREDIENTE "
          "WHERE $COLUMN_FOREIGN_COMIDA = ${listaComidas[i].idComida}");

      ingredientesEnComida.forEach((ingredienteActual) async {
        ComidaHasIngrediente ingrediente =
            ComidaHasIngrediente.fromMap(ingredienteActual);

        if (ingrediente.foreignIdIngrediente != null) {
          listaComidas[i]
              .listaIngredientesEnComida
              .add(ingrediente.foreignIdIngrediente);

          listaComidas[i]
              .listaMedidasIngredientes
              .add(ingrediente.medidaIngrediente);
        }

        await Future.delayed(Duration.zero);
      });
    }

    return listaComidas;
  }

  Future<Ingrediente> getIngredienteIndividual(int index) async {
    final db = await database;

    var ingredientes = await db.rawQuery("SELECT "
        "$COLUMN_IDINGREDIENTE,"
        "$COLUMN_NOMBREINGREDIENTE,"
        "$COLUMN_RUTAIMAGENINGREDIENTE,"
        "$COLUMN_FAVORITOINGREDIENTE "
        "FROM $TABLE_INGREDIENTE "
        "WHERE $COLUMN_IDINGREDIENTE = $index");

    Ingrediente ingrediente = new Ingrediente();

    ingredientes.forEach((ingredienteActual) {
      ingrediente = Ingrediente.fromMap(ingredienteActual);
    });

    return ingrediente;
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

  Future<List<Ingrediente>> getIngredientesFavoritos() async {
    final db = await database;

    var ingredientes = await db.rawQuery("SELECT "
        "$COLUMN_IDINGREDIENTE,"
        "$COLUMN_NOMBREINGREDIENTE,"
        "$COLUMN_RUTAIMAGENINGREDIENTE,"
        "$COLUMN_FAVORITOINGREDIENTE "
        "FROM $TABLE_INGREDIENTE "
        "WHERE $COLUMN_FAVORITOINGREDIENTE = 1");

    List<Ingrediente> listaIngredientes = List<Ingrediente>();

    ingredientes.forEach((ingredienteActual) {
      Ingrediente ingrediente = Ingrediente.fromMap(ingredienteActual);
      listaIngredientes.add(ingrediente);
    });

    return listaIngredientes;
  }

  Future<List<Comida>> getComidasFavoritas() async {
    final db = await database;

    var comidas = await db.rawQuery("SELECT "
        "$COLUMN_IDCOMIDA,"
        "$COLUMN_NOMBRECOMIDA,"
        "$COLUMN_CATEGORIACOMIDA,"
        "$COLUMN_AREA,"
        "$COLUMN_MINUTOSPREPARACION,"
        "$COLUMN_PASOSPREPARACION,"
        "$COLUMN_CALORIAS,"
        "$COLUMN_RUTAIMAGEN,"
        "$COLUMN_FAVORITOCOMIDA "
        "FROM $TABLE_COMIDA "
        "WHERE $COLUMN_FAVORITOCOMIDA = 1");

    List<Comida> listaComidas = List<Comida>();
    comidas.forEach((comidaActual) async {
      Comida comida = Comida.fromMap(comidaActual);

      listaComidas.add(comida);
      await Future.delayed(Duration.zero);
    });

    for (int i = 0; i < listaComidas.length; i++) {
      listaComidas[i].listaIngredientesEnComida = new List<int>();
      listaComidas[i].listaMedidasIngredientes = new List<String>();

      List<Map<String, dynamic>> ingredientesEnComida = await db.rawQuery(
          "SELECT $COLUMN_FOREIGN_INGREDIENTE, $COLUMN_MEDIDAINGREDIENTE "
          "FROM $TABLE_COMIDA_HAS_INGREDIENTE "
          "WHERE $COLUMN_FOREIGN_COMIDA = ${listaComidas[i].idComida}");

      ingredientesEnComida.forEach((ingredienteActual) async {
        ComidaHasIngrediente ingrediente =
            ComidaHasIngrediente.fromMap(ingredienteActual);

        if (ingrediente.foreignIdIngrediente != null) {
          listaComidas[i]
              .listaIngredientesEnComida
              .add(ingrediente.foreignIdIngrediente);

          listaComidas[i]
              .listaMedidasIngredientes
              .add(ingrediente.medidaIngrediente);
        }

        await Future.delayed(Duration.zero);
      });
    }

    return listaComidas;
  }
}
