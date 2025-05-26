import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/calculator_provider.dart';
import 'ui/calculator_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorProvider(),
      child: MaterialApp(
        title: 'Casio fx-991ES Plus',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: CasioCalculator(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// class CasioCalculator extends StatefulWidget {
//   const CasioCalculator({super.key});

//   @override
//   State<CasioCalculator> createState() => _CasioCalculatorState();
// }

// class _CasioCalculatorState extends State<CasioCalculator> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Center(
//           child: Container(
//             decoration: BoxDecoration(
//               color: const Color(0xFF2B2B2B),
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
//             ),
//             child: Column(
//               children: [
//                 // Top section with branding
//                 Container(
//                   padding: EdgeInsets.all(8),
//                   child: Column(
//                     children: [
//                       // CASIO branding
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'CASIO',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text('fx-991ES PLUS', style: TextStyle(color: Colors.white, fontSize: 12)),
//                         ],
//                       ),
//                       SizedBox(height: 4),
//                       // Model description
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           'Natural-V.P.A.M.',
//                           style: TextStyle(color: Colors.white70, fontSize: 8),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
        
//                 // Display
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 8),
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF8BC34A),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Container(
//                     margin: EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF1B1B1B),
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                     child: Column(
//                       children: [
//                         // Status indicators
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('S-V.P.A.M.', style: TextStyle(color: Colors.white, fontSize: 8)),
//                               Row(
//                                 children: [
//                                   Text('M', style: TextStyle(color: Colors.white, fontSize: 8)),
//                                   SizedBox(width: 8),
//                                   Text('STO', style: TextStyle(color: Colors.white, fontSize: 8)),
//                                   SizedBox(width: 8),
//                                   Text('RCL', style: TextStyle(color: Colors.white, fontSize: 8)),
//                                   SizedBox(width: 8),
//                                   Text('STAT', style: TextStyle(color: Colors.white, fontSize: 8)),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Main display area
//                         Expanded(
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             alignment: Alignment.centerRight,
//                             child: Text(
//                               '0',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 24,
//                                 fontFamily: 'monospace',
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
        
//                 SizedBox(height: 8),
        
//                 // Button matrix
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     child: Column(
//                       children: [
//                         // Row 1
//                         buildButtonRow([
//                           {'text': 'SHIFT', 'color': Color(0xFFFF9800), 'textColor': Colors.white},
//                           {'text': 'ALPHA', 'color': Color(0xFFFF9800), 'textColor': Colors.white},
//                           {'text': 'REPLAY', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                           {'text': 'MODE', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                           {'text': 'ON', 'color': Color(0xFFE91E63), 'textColor': Colors.white},
//                         ]),
//                         SizedBox(height: 4),
        
//                         // Row 2
//                         buildButtonRow([
//                           {'text': 'x⁻¹', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'nCr', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'Pol(', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'x³', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'S⇔D', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                         ]),
//                         SizedBox(height: 4),
        
//                         // Row 3
//                         buildButtonRow([
//                           {'text': '√', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'x²', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': '^', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'log', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'ln', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                         ]),
//                         SizedBox(height: 4),
        
//                         // Row 4
//                         buildButtonRow([
//                           {'text': '(-)', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': '°\'"', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'hyp', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'sin', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'cos', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                         ]),
//                         SizedBox(height: 4),
        
//                         // Row 5
//                         buildButtonRow([
//                           {'text': 'RCL', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'ENG', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': '(', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': ')', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'tan', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                         ]),
//                         SizedBox(height: 4),
        
//                         // Row 6
//                         buildButtonRow([
//                           {'text': 'STO', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'M+', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': '7', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                           {'text': '8', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                           {'text': '9', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                         ]),
//                         SizedBox(height: 4),
        
//                         // Row 7
//                         buildButtonRow([
//                           {'text': 'CALC', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'SOLVE', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': '4', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                           {'text': '5', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                           {'text': '6', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                         ]),
//                         SizedBox(height: 4),
        
//                         // Row 8
//                         buildButtonRow([
//                           {'text': '∫dx', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'MATRIX', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': '1', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                           {'text': '2', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                           {'text': '3', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                         ]),
//                         SizedBox(height: 4),
        
//                         // Row 9
//                         buildButtonRow([
//                           {'text': 'RAN#', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': 'DT', 'color': Color(0xFF424242), 'textColor': Colors.white},
//                           {'text': '0', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                           {'text': '.', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                           {'text': '×10ˣ', 'color': Color(0xFF616161), 'textColor': Colors.white},
//                         ]),
//                         SizedBox(height: 4),
        
//                         // Row 10
//                         Row(
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: buildButton('DEL', Color(0xFF616161), Colors.white),
//                             ),
//                             SizedBox(width: 4),
//                             Expanded(child: buildButton('÷', Color(0xFF424242), Colors.white)),
//                             SizedBox(width: 4),
//                             Expanded(child: buildButton('×', Color(0xFF424242), Colors.white)),
//                             SizedBox(width: 4),
//                             Expanded(child: buildButton('-', Color(0xFF424242), Colors.white)),
//                           ],
//                         ),
//                         SizedBox(height: 4),
        
//                         // Row 11
//                         Row(
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: buildButton('AC', Color(0xFFE91E63), Colors.white),
//                             ),
//                             SizedBox(width: 4),
//                             Expanded(child: buildButton('+', Color(0xFF424242), Colors.white)),
//                             SizedBox(width: 4),
//                             Expanded(
//                               flex: 2,
//                               child: buildButton('=', Color(0xFF4CAF50), Colors.white),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildButtonRow(List<Map<String, dynamic>> buttons) {
//     return Row(
//       children: buttons.map((button) {
//         return Expanded(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 2),
//             child: buildButton(button['text'], button['color'], button['textColor']),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget buildButton(String text, Color color, Color textColor) {
//     return Container(
//       height: 35,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(4),
//         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 2))],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(4),
//           onTap: () {
//             // Button press logic would go here
//             print('Pressed: $text');
//           },
//           child: Center(
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: textColor,
//                 fontSize: text.length > 3 ? 10 : 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
