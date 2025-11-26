import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../constants/button_config.dart';
import '../models/button_model.dart';
import 'dart:math' as math;

class CasioCalculator extends StatefulWidget {
  const CasioCalculator({super.key});

  @override
  State<CasioCalculator> createState() => _CasioCalculatorState();
}

class _CasioCalculatorState extends State<CasioCalculator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2B2B2B),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
            ),
            child: Column(
              children: [
                // Top section with branding
                _buildHeader(),
                // Display
                _buildDisplay(),
                SizedBox(height: 8),

                // Button matrix
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        // Fixed: Use Expanded to contain the button matrix
                        Expanded(
                          child: Consumer<CalculatorProvider>(
                            builder: (context, provider, child) {
                              final buttonMatrix = ButtonConfig.getButtonMatrix(
                                shiftPressed: provider.shiftPressed,
                                alphaPressed: provider.alphaPressed,
                              );
                              return Column(
                                children: buttonMatrix
                                    .map(
                                      (row) => Expanded(
                                        child: Row(
                                          children: row
                                              .map(
                                                (button) => Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                      vertical: 2,
                                                    ),
                                                    child: _buildCalculatorButton(button),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 4),
                        _buildBottomRow(),
                        SizedBox(height: 4),
                        _buildLastRow(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CASIO',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('fx-991ES PLUS', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text('Natural-V.P.A.M.', style: TextStyle(color: Colors.white70, fontSize: 8)),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplay() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF8BC34A),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B1B),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          children: [
            // Status indicators
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Consumer<CalculatorProvider>(
                builder: (context, provider, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('S-V.P.A.M.', style: TextStyle(color: Colors.white, fontSize: 8)),
                          SizedBox(width: 8),
                          Text(
                            provider.isRadianMode ? 'RAD' : 'DEG',
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          ),
                          SizedBox(width: 8),
                          _buildStatusIndicator('SHIFT', provider.shiftPressed),
                          SizedBox(width: 4),
                          _buildStatusIndicator('ALPHA', provider.alphaPressed),
                        ],
                      ),
                      Row(
                        children: [
                          _buildStatusIndicator('M', provider.displayState.showMemory),
                          SizedBox(width: 8),
                          _buildStatusIndicator('STO', provider.displayState.showSto),
                          SizedBox(width: 8),
                          _buildStatusIndicator('RCL', provider.displayState.showRcl),
                          SizedBox(width: 8),
                          _buildStatusIndicator('STAT', provider.displayState.showStat),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            // Main display area with cursor
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                alignment: Alignment.centerRight,
                child: Consumer<CalculatorProvider>(
                  builder: (context, provider, child) {
                    return GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        // Calculate cursor position based on tap
                        _handleDisplayTap(details, provider);
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: _buildDisplayWithCursor(
                            provider.displayState.mainDisplay,
                            provider.cursorPosition,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build display text with cursor
  List<Widget> _buildDisplayWithCursor(String text, int cursorPosition) {
    List<Widget> widgets = [];

    if (text.isEmpty) {
      widgets.add(
        Text(
          '0',
          style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'monospace'),
        ),
      );
      widgets.add(_buildCursor());
      return widgets;
    }

    // Split text at cursor position
    String beforeCursor = text.substring(0, math.min(cursorPosition, text.length));
    String afterCursor = text.substring(math.min(cursorPosition, text.length));

    if (beforeCursor.isNotEmpty) {
      widgets.add(
        Text(
          beforeCursor,
          style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'monospace'),
        ),
      );
    }

    // Add cursor
    widgets.add(_buildCursor());

    if (afterCursor.isNotEmpty) {
      widgets.add(
        Text(
          afterCursor,
          style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'monospace'),
        ),
      );
    }

    return widgets;
  }

  Widget _buildCursor() {
    return Container(
      width: 1,
      height: 20,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 1),
    );
  }

  void _handleDisplayTap(TapDownDetails details, CalculatorProvider provider) {
    // Calculate approximate cursor position based on tap location
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    double tapX = details.localPosition.dx;

    // Rough estimation - you might want to make this more precise
    String text = provider.displayState.mainDisplay;
    double charWidth = 10.8; // Approximate character width for monospace font
    int position = (tapX / charWidth).round();
    position = math.max(0, math.min(position, text.length));

    provider.setCursorPosition(position);
  }

  Widget _buildStatusIndicator(String text, bool isVisible) {
    return Text(
      text,
      style: TextStyle(color: isVisible ? Colors.white : Colors.transparent, fontSize: 8),
    );
  }

  Widget _buildBottomRow() {
    return Consumer<CalculatorProvider>(
      builder: (context, provider, child) {
        final buttons = ButtonConfig.getBottomRowButtons();
        return Row(
          children: buttons.map((button) {
            return Expanded(
              flex: button.flex ?? 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: _buildCalculatorButton(button),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildLastRow() {
    return Consumer<CalculatorProvider>(
      builder: (context, provider, child) {
        final buttons = ButtonConfig.getLastRowButtons();
        return Row(
          children: buttons.map((button) {
            return Expanded(
              flex: button.flex ?? 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: _buildCalculatorButton(button),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCalculatorButton(CalculatorButton button) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: button.color,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            final provider = Provider.of<CalculatorProvider>(context, listen: false);
            provider.handleButtonPress(button.text, button.type);
          },
          child: Center(
            child: Text(
              button.text,
              style: TextStyle(
                color: button.textColor,
                fontSize: button.text.length > 3 ? 9 : 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
