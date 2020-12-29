import 'dart:math';

import 'package:comidapp/json/JsonGetter.dart';
import 'package:comidapp/models/comida.dart';
import 'package:comidapp/models/comidaDelDia.dart';
import 'package:comidapp/models/comidaHasIngrediente.dart';
import 'package:comidapp/json/ingredientFromJson.dart';
import 'package:comidapp/models/horarioComidas.dart';
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
  static const String COLUMN_DISGUSTAINGREDIENTE = "disgustaIngrediente";

  //CONSTANTES PARA LA TABLA  COMIDA-INGREDIENTE
  static const String TABLE_COMIDA_HAS_INGREDIENTE = "ComidaHasIngrediente";
  static const String COLUMN_FOREIGN_COMIDA = "comida_idComida";
  static const String COLUMN_FOREIGN_INGREDIENTE = "ingrediente_idIngrediente";
  static const String COLUMN_MEDIDAINGREDIENTE = "medidaIngrediente";

  //CONSTANTES PARA LA TABLA 'HORARIO COMIDAS'
  static const String TABLE_HORARIO_COMIDAS = "HorarioComidas";
  static const String COLUMN_IDCOMIDAHORARIO = "idComidaHorario";
  static const String COLUMN_DIASEMANA = "diaSemana";
  static const String COLUMN_FOREIGN_COMIDA_DEL_DIA =
      "comidaDelDia_idComidaDelDia";

  //CONSTANTES PARA LA TABLA 'COMIDA DEL DIA'
  static const String TABLE_COMIDA_DEL_DIA = 'ComidaDelDia';
  static const String COLUMN_IDCOMIDADELDIA = 'idComidaDelDia';
  static const String COLUMN_HORA = 'hora';
  static const String COLUMN_NOMBRECOMIDADELDIA = 'nombreComidaDelDia';

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
          "$COLUMN_DISGUSTAINGREDIENTE INTEGER NOT NULL,"
          "PRIMARY KEY ($COLUMN_IDINGREDIENTE AUTOINCREMENT)"
          ");",
        );

        //TABLA COMIDAS-INGREDIENTES
        print("CREANDO TABLA COMIDAS-INGREDIENTES");
        await database.execute(
          "CREATE TABLE IF NOT EXISTS $TABLE_COMIDA_HAS_INGREDIENTE ("
          "$COLUMN_FOREIGN_COMIDA INTEGER NOT NULL,"
          "$COLUMN_FOREIGN_INGREDIENTE INTEGER,"
          "$COLUMN_MEDIDAINGREDIENTE"
          ");",
        );

        //TABLA HORARIO COMIDAS
        print("CREANDO TABLA HORARIO COMIDAS");
        await database.execute(
          "CREATE TABLE IF NOT EXISTS $TABLE_HORARIO_COMIDAS ("
          "$COLUMN_IDCOMIDAHORARIO INTEGER NOT NULL,"
          "$COLUMN_FOREIGN_COMIDA INTEGER NOT NULL,"
          "$COLUMN_DIASEMANA INTEGER NOT NULL,"
          "$COLUMN_FOREIGN_COMIDA_DEL_DIA INTEGER NOT NULL,"
          "PRIMARY KEY ($COLUMN_IDCOMIDAHORARIO AUTOINCREMENT)"
          ");",
        );

        //TABLA COMIDA DEL DIA
        print("CREANDO TABLA COMIDA DEL DIA");
        await database.execute(
          "CREATE TABLE IF NOT EXISTS $TABLE_COMIDA_DEL_DIA ("
          "$COLUMN_IDCOMIDADELDIA INTEGER NOT NULL,"
          "$COLUMN_HORA INTEGER,"
          "$COLUMN_NOMBRECOMIDADELDIA TEXT NOT NULL,"
          "PRIMARY KEY ($COLUMN_IDCOMIDADELDIA AUTOINCREMENT)"
          ");",
        );

        //INSERTAR INFORMACION EN COMIDA DEL DIA
        await database.execute("INSERT INTO $TABLE_COMIDA_DEL_DIA "
            "($COLUMN_HORA, $COLUMN_NOMBRECOMIDADELDIA)"
            " values ('9:00 am', 'Desayuno');");
        await database.execute("INSERT INTO $TABLE_COMIDA_DEL_DIA "
            "($COLUMN_HORA, $COLUMN_NOMBRECOMIDADELDIA)"
            " values ('11:00 am', 'Almuerzo');");
        await database.execute("INSERT INTO $TABLE_COMIDA_DEL_DIA "
            "($COLUMN_HORA, $COLUMN_NOMBRECOMIDADELDIA)"
            " values ('3:30 pm', 'Comida');");
        await database.execute("INSERT INTO $TABLE_COMIDA_DEL_DIA "
            "($COLUMN_HORA, $COLUMN_NOMBRECOMIDADELDIA)"
            " values ('8:30 pm', 'Cena');");

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
              "($COLUMN_NOMBREINGREDIENTE, $COLUMN_RUTAIMAGENINGREDIENTE, $COLUMN_FAVORITOINGREDIENTE, $COLUMN_DISGUSTAINGREDIENTE)"
              " values ($nombreIngrediente, $rutaImagenIngrediente, 0, 0);");
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

  Future inicializarBase() async {
    final db = await database;
    return db;
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

  Future setDisgustaIngrediente(int idIngrediente, int ponerDisgusta) async {
    final db = await database;
    return await db.rawUpdate(
        "UPDATE $TABLE_INGREDIENTE SET $COLUMN_DISGUSTAINGREDIENTE = $ponerDisgusta WHERE $COLUMN_IDINGREDIENTE =$idIngrediente");
  }

  Future insertComidaDeHorario(
      int idComida, int diaSemana, int idComidaDelDia) async {
    final db = await database;

    await db.rawInsert("INSERT INTO $TABLE_HORARIO_COMIDAS "
        "($COLUMN_FOREIGN_COMIDA, $COLUMN_DIASEMANA, $COLUMN_FOREIGN_COMIDA_DEL_DIA)"
        " values ($idComida, $diaSemana, $idComidaDelDia);");
  }

  Future deleteComidaDelHorario(int index) async {
    final db = await database;

    await db.rawDelete(
        "DELETE FROM $TABLE_HORARIO_COMIDAS WHERE $COLUMN_IDCOMIDAHORARIO = $index");
  }

  Future<List<Comida>> getComidasSugeridasFavoritos() async {
    final db = await database;

    var comidas = await db.rawQuery("SELECT DISTINCT "
        "a.$COLUMN_IDCOMIDA,"
        "a.$COLUMN_NOMBRECOMIDA,"
        "a.$COLUMN_CATEGORIACOMIDA,"
        "a.$COLUMN_AREA,"
        "a.$COLUMN_MINUTOSPREPARACION,"
        "a.$COLUMN_PASOSPREPARACION,"
        "a.$COLUMN_CALORIAS,"
        "a.$COLUMN_RUTAIMAGEN,"
        "a.$COLUMN_FAVORITOCOMIDA "
        "FROM $TABLE_COMIDA a, $TABLE_INGREDIENTE b, $TABLE_COMIDA_HAS_INGREDIENTE c "
        "WHERE b.$COLUMN_FAVORITOINGREDIENTE = 1 "
        "AND b.$COLUMN_IDINGREDIENTE = c.$COLUMN_FOREIGN_INGREDIENTE "
        "AND a.$COLUMN_IDCOMIDA = c.$COLUMN_FOREIGN_COMIDA "
        "ORDER BY RANDOM() "
        "LIMIT 15");

    if (comidas.length < 1) {
      comidas = await db.rawQuery("SELECT "
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
          "ORDER BY RANDOM() "
          "LIMIT 16");
    }

    List<Comida> listaComidas = List<Comida>();
    comidas.forEach((comidaActual) async {
      Comida comida = Comida.fromMap(comidaActual);

      listaComidas.add(comida);
      await Future.delayed(Duration.zero);
    });

    return listaComidas;
  }

  Future<Comida> getComidaConIngredientes(Comida comida) async {
    final db = await database;

    comida.listaIngredientesEnComida = new List<int>();
    comida.listaMedidasIngredientes = new List<String>();

    List<Map<String, dynamic>> ingredientesEnComida = await db.rawQuery(
        "SELECT $COLUMN_FOREIGN_INGREDIENTE, $COLUMN_MEDIDAINGREDIENTE "
        "FROM $TABLE_COMIDA_HAS_INGREDIENTE "
        "WHERE $COLUMN_FOREIGN_COMIDA = ${comida.idComida}");

    ingredientesEnComida.forEach(
      (ingredienteActual) async {
        ComidaHasIngrediente ingrediente =
            ComidaHasIngrediente.fromMap(ingredienteActual);

        if (ingrediente.foreignIdIngrediente != null) {
          comida.listaIngredientesEnComida
              .add(ingrediente.foreignIdIngrediente);

          comida.listaMedidasIngredientes.add(ingrediente.medidaIngrediente);
        }

        await Future.delayed(Duration.zero);
      },
    );
    return comida;
  }

  Future<List<Comida>> getComidasSugeridasDisgustos() async {
    final db = await database;

    var comidasDisgusto = await db.rawQuery("SELECT DISTINCT "
        "a.$COLUMN_IDCOMIDA,"
        "a.$COLUMN_NOMBRECOMIDA,"
        "a.$COLUMN_CATEGORIACOMIDA,"
        "a.$COLUMN_AREA,"
        "a.$COLUMN_MINUTOSPREPARACION,"
        "a.$COLUMN_PASOSPREPARACION,"
        "a.$COLUMN_CALORIAS,"
        "a.$COLUMN_RUTAIMAGEN,"
        "a.$COLUMN_FAVORITOCOMIDA "
        "FROM $TABLE_COMIDA a, $TABLE_INGREDIENTE b, $TABLE_COMIDA_HAS_INGREDIENTE c "
        "WHERE b.$COLUMN_DISGUSTAINGREDIENTE = 1 "
        "AND b.$COLUMN_IDINGREDIENTE = c.$COLUMN_FOREIGN_INGREDIENTE "
        "AND a.$COLUMN_IDCOMIDA = c.$COLUMN_FOREIGN_COMIDA "
        "ORDER BY RANDOM() ");

    if (comidasDisgusto.length < 1) {
      comidasDisgusto = await db.rawQuery("SELECT "
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
          "ORDER BY RANDOM() "
          "LIMIT 16");
    }

    List<Comida> listaComidasDisgusto = List<Comida>();
    comidasDisgusto.forEach((comidaActual) async {
      Comida comida = Comida.fromMap(comidaActual);

      listaComidasDisgusto.add(comida);
      await Future.delayed(Duration.zero);
    });

    var comidas = await db.rawQuery("SELECT DISTINCT "
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
        "ORDER BY RANDOM() ");

    List<Comida> listaComidas = List<Comida>();
    comidas.forEach((comidaActual) async {
      Comida comida = Comida.fromMap(comidaActual);

      listaComidas.add(comida);
      await Future.delayed(Duration.zero);
    });

    List<int> listaComidasInt = new List<int>();
    for (int i = 0; i < listaComidas.length; i++) {
      listaComidasInt.add(listaComidas[i].idComida);
    }

    List<int> listaComidasDisgustoInt = new List<int>();
    for (int i = 0; i < listaComidasDisgusto.length; i++) {
      listaComidasDisgustoInt.add(listaComidasDisgusto[i].idComida);
    }

    List<int> listaReducidaInt = new List<int>();
    listaReducidaInt = listaComidasInt
        .toSet()
        .difference(listaComidasDisgustoInt.toSet())
        .toList();

    List<Comida> listaReducida = new List<Comida>();
    for (int i = 0; i < listaComidas.length; i++) {
      for (int y = 0; y < listaReducidaInt.length; y++) {
        if (listaReducidaInt[y] == listaComidas[i].idComida) {
          listaReducida.add(listaComidas[i]);
        }
        if (listaReducida.length > 14) {
          return listaReducida;
        }
      }
    }
    print("OBTENIDOS ${listaReducida.length} ELEMENTOS EN LISTA REDUCIDA");
    return listaReducida;
  }

  Future insertarNuevaComida(
      Comida comida,
      List<Ingrediente> listaIngredientesAInsertar,
      List<String> listaCantidades) async {
    final db = await database;

    await db.insert(TABLE_COMIDA, comida.toMap());

    var ultimo = await db.query(TABLE_COMIDA,
        columns: [
          COLUMN_IDCOMIDA,
        ],
        limit: 1,
        orderBy: "$COLUMN_IDCOMIDA desc");

    List<Comida> lastComida = List<Comida>();

    ultimo.forEach((current) {
      Comida comidaUltimo = Comida.fromMap(current);

      lastComida.add(comidaUltimo);
    });

    for (int i = 0; i < listaIngredientesAInsertar.length; i++) {
      ComidaHasIngrediente comidaHasIngrediente = new ComidaHasIngrediente();
      comidaHasIngrediente.foreignIdComida = lastComida[0].idComida;
      comidaHasIngrediente.foreignIdIngrediente =
          listaIngredientesAInsertar[i].idIngrediente;
      comidaHasIngrediente.medidaIngrediente = listaCantidades[i];

      await db.insert(
          TABLE_COMIDA_HAS_INGREDIENTE, comidaHasIngrediente.toMap());
    }
    return Future.delayed(Duration.zero);
  }

  Future<List<Comida>> getComidasDeHorario(int indexDia) async {
    final db = await database;

    var comidas = await db.rawQuery("SELECT "
        "a.$COLUMN_IDCOMIDA,"
        "a.$COLUMN_NOMBRECOMIDA,"
        "a.$COLUMN_CATEGORIACOMIDA,"
        "a.$COLUMN_AREA,"
        "a.$COLUMN_MINUTOSPREPARACION,"
        "a.$COLUMN_PASOSPREPARACION,"
        "a.$COLUMN_CALORIAS,"
        "a.$COLUMN_RUTAIMAGEN,"
        "a.$COLUMN_FAVORITOCOMIDA "
        "FROM $TABLE_COMIDA a, $TABLE_HORARIO_COMIDAS b "
        "WHERE a.$COLUMN_IDCOMIDA = b.$COLUMN_FOREIGN_COMIDA "
        "AND b.$COLUMN_DIASEMANA = $indexDia");

    List<Comida> listaComidas = List<Comida>();
    comidas.forEach((comidaActual) async {
      Comida comida = Comida.fromMap(comidaActual);

      listaComidas.add(comida);
      await Future.delayed(Duration.zero);
    });

    return listaComidas;
  }

  Future<List<ComidaDelDia>> getComidasDelDia() async {
    final db = await database;

    var comidasDelDia = await db.rawQuery("SELECT "
        "$COLUMN_IDCOMIDADELDIA,"
        "$COLUMN_HORA,"
        "$COLUMN_NOMBRECOMIDADELDIA "
        "FROM $TABLE_COMIDA_DEL_DIA ");

    List<ComidaDelDia> listaComidasDelDia = List<ComidaDelDia>();
    comidasDelDia.forEach((comidaActual) async {
      ComidaDelDia comida = ComidaDelDia.fromMap(comidaActual);

      listaComidasDelDia.add(comida);
      await Future.delayed(Duration.zero);
    });

    return listaComidasDelDia;
  }

  Future<List<HorarioComida>> getHorario(int indexDia) async {
    final db = await database;

    var comidasEnHorario = await db.rawQuery("SELECT "
        "$COLUMN_IDCOMIDAHORARIO,"
        "$COLUMN_FOREIGN_COMIDA,"
        "$COLUMN_DIASEMANA,"
        "$COLUMN_FOREIGN_COMIDA_DEL_DIA "
        "FROM $TABLE_HORARIO_COMIDAS "
        "WHERE $COLUMN_DIASEMANA = $indexDia");

    List<HorarioComida> listaComidasEnHorario = List<HorarioComida>();
    comidasEnHorario.forEach((comidaActual) async {
      HorarioComida comidaEnHorario = HorarioComida.fromMap(comidaActual);

      listaComidasEnHorario.add(comidaEnHorario);
      await Future.delayed(Duration.zero);
    });

    return listaComidasEnHorario;
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

    return listaComidas;
  }

  Future<Ingrediente> getIngredienteIndividual(int index) async {
    final db = await database;

    var ingredientes = await db.rawQuery("SELECT "
        "$COLUMN_IDINGREDIENTE,"
        "$COLUMN_NOMBREINGREDIENTE,"
        "$COLUMN_RUTAIMAGENINGREDIENTE,"
        "$COLUMN_FAVORITOINGREDIENTE,"
        "$COLUMN_DISGUSTAINGREDIENTE "
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
        "$COLUMN_FAVORITOINGREDIENTE,"
        "$COLUMN_DISGUSTAINGREDIENTE "
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
        "$COLUMN_FAVORITOINGREDIENTE,"
        "$COLUMN_DISGUSTAINGREDIENTE "
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

    return listaComidas;
  }
}
