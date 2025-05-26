import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../constants/button_config.dart';
import '../models/button_model.dart';

class CasioCalculator extends StatelessWidget {
  const CasioCalculator({super.key});

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
                        ..._buildButtonMatrix(),
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
                      Text('S-V.P.A.M.', style: TextStyle(color: Colors.white, fontSize: 8)),
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
            // Main display area
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                alignment: Alignment.centerRight,
                child: Consumer<CalculatorProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      provider.displayState.mainDisplay,
                      style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'monospace'),
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

  Widget _buildStatusIndicator(String text, bool isVisible) {
    return Text(
      text,
      style: TextStyle(color: isVisible ? Colors.white : Colors.transparent, fontSize: 8),
    );
  }

  List<Widget> _buildButtonMatrix() {
    final buttonMatrix = ButtonConfig.getButtonMatrix();
    return buttonMatrix
        .map(
          (row) => Column(
            children: [
              Row(
                children: row
                    .map(
                      (button) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: _buildCalculatorButton(button),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 4),
            ],
          ),
        )
        .toList();
  }

  Widget _buildBottomRow() {
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
  }

  Widget _buildLastRow() {
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
        child: Consumer<CalculatorProvider>(
          builder: (context, provider, child) {
            return InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                provider.handleButtonPress(button.text, button.type);
              },
              child: Center(
                child: Text(
                  button.text,
                  style: TextStyle(
                    color: button.textColor,
                    fontSize: button.text.length > 3 ? 10 : 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
