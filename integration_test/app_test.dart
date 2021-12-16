import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test_tutorial/main.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  // Define una prueba. la función TestWidgets también proporcionará un WidgetTester
  // para que podamos trabajar con él. El WidgetTester nos permitirá construir e interactuar
  // con Widgets en el entorno de pruebas.  
  testWidgets(
    "Prueba en donde no se ingresa ningún texto"
    "Se espera que salga un error y no se pueda ir a la página de visualización",
    (WidgetTester tester) async {
      // Las pruebas comienzan en el widget raíz del árbol de widgets
      await tester.pumpWidget(MyApp());

      // Hacer tap/click en el botón
      await tester.tap(find.byType(FloatingActionButton));
      
      // Esperar a que terminen todas las animaciones
      await tester.pumpAndSettle();

      // Encontrar por tipo
      expect(find.byType(TypingPage), findsOneWidget); // El widget de página con la entrada de texto es de tipo TypingPage
      expect(find.byType(DisplayPage), findsNothing); // La segunda página que muestra la entrada es de tipo DisplayPage
      
      // Este es el texto que muestra un mensaje de error en el TextFormField, cuando no se ingresa nada
      expect(find.text('Input at least one character'), findsOneWidget);
    },
  );

  testWidgets(
    "Prueba en donde se ingresa un texto"
    "Se espera que se pueda ir a la página de visualización en donde se mostrará el texto ingresado,"
    "luego se regresa a la página de escritura donde la entrada es clara",
    (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      // Ingresasr textos
      final inputText = 'Hello there, this is an input.';
      await tester.enterText(find.byKey(Key('your-text-field')), inputText);

      // Tap en el FAB - Floating Action Button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Deberíamos estar en la página de visualización que muestra el texto introducido
      expect(find.byType(TypingPage), findsNothing);
      expect(find.byType(DisplayPage), findsOneWidget);
      expect(find.text(inputText), findsOneWidget);

      // Pulse sobre la flecha "hacia atrás" en la AppBar
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Deberíamos volver a la TypingPage y el texto introducido anteriormente
      // debería ser borrado
      expect(find.byType(TypingPage), findsOneWidget);
      expect(find.byType(DisplayPage), findsNothing);
      expect(find.text(inputText), findsNothing);
    },
  );

}