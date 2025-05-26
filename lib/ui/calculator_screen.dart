import 'package:flutter/material.dart';

import '../constants/button_config.dart';
import '../constants/colors.dart';
import '../logic/calculator_logic.dart';
import '../models/button_model.dart';
import '../models/display_state_model.dart';

class CasioCalculator extends StatefulWidget {
  const CasioCalculator({super.key});

  @override
  State<CasioCalculator> createState() => _CasioCalculatorState();
}

class _CasioCalculatorState extends State<CasioCalculator> {
  DisplayState _displayState = DisplayState();

  void _updateDisplay(DisplayState newState) {
    setState(() {
      _displayState = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: CalculatorColors.background,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
            ),
            child: Column(
              children: [
                _buildHeader(),
                _buildDisplay(),
                SizedBox(height: 8),
                _buildButtonMatrix(),
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
        color: CalculatorColors.displayBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: CalculatorColors.displayScreen,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(children: [_buildStatusIndicators(), _buildMainDisplay()]),
      ),
    );
  }

  Widget _buildStatusIndicators() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('S-V.P.A.M.', style: TextStyle(color: Colors.white, fontSize: 8)),
          Row(
            children: [
              if (_displayState.showMemory)
                Text('M', style: TextStyle(color: Colors.white, fontSize: 8)),
              SizedBox(width: 8),
              if (_displayState.showSto)
                Text('STO', style: TextStyle(color: Colors.white, fontSize: 8)),
              SizedBox(width: 8),
              if (_displayState.showRcl)
                Text('RCL', style: TextStyle(color: Colors.white, fontSize: 8)),
              SizedBox(width: 8),
              if (_displayState.showStat)
                Text('STAT', style: TextStyle(color: Colors.white, fontSize: 8)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainDisplay() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        alignment: Alignment.centerRight,
        child: Text(
          _displayState.mainDisplay,
          style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'monospace'),
        ),
      ),
    );
  }

  Widget _buildButtonMatrix() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            // Regular button rows
            ...ButtonConfig.getButtonMatrix().map(
              (row) => Column(children: [_buildButtonRow(row), SizedBox(height: 4)]),
            ),
            // Special bottom rows
            _buildSpecialButtonRow(ButtonConfig.getBottomRowButtons()),
            SizedBox(height: 4),
            _buildSpecialButtonRow(ButtonConfig.getLastRowButtons()),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<CalculatorButton> buttons) {
    return Row(
      children: buttons.map((button) {
        return Expanded(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 2), child: _buildButton(button)),
        );
      }).toList(),
    );
  }

  Widget _buildSpecialButtonRow(List<CalculatorButton> buttons) {
    return Row(
      children: buttons.map((button) {
        return Expanded(
          flex: button.flex!,
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 2), child: _buildButton(button)),
        );
      }).toList(),
    );
  }

  Widget _buildButton(CalculatorButton button) {
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
            CalculatorLogic.handleButtonPress(button.text, button.type, _updateDisplay);
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
        ),
      ),
    );
  }
}
