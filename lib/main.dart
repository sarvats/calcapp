import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData.dark(),
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _displayText = '0';
  String _operand1 = '';
  String _operand2 = '';
  String _operator = '';
  bool _shouldClear = false;
  
  void _updateDisplay(String value) {
    setState(() {
      if (_shouldClear) {
        _displayText = value;
        _shouldClear = false;
      } else {
        _displayText = _displayText == '0' ? value : _displayText + value;
      }
    });
  }

  
  void _onNumberPress(String number) {
    if (_operator.isEmpty) {
      _operand1 += number;
    } else {
      _operand2 += number;
    }
    _updateDisplay(number);
  }

  
  void _onOperatorPress(String operator) {
    if (_operand1.isNotEmpty) {
      _operator = operator;
      _shouldClear = true; 
    }
  }

  
  void _calculate() {
    double result = 0;
    double num1 = double.tryParse(_operand1) ?? 0;
    double num2 = double.tryParse(_operand2) ?? 0;

    switch (_operator) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '*':
        result = num1 * num2;
        break;
      case '/':
        result = num2 != 0 ? num1 / num2 : double.nan; 
        break;
    }

    setState(() {
      _displayText = result.isNaN ? 'Error' : result.toString();
      _operand1 = result.isNaN ? '' : result.toString();
      _operand2 = '';
      _operator = '';
    });
  }

  
  void _clear() {
    setState(() {
      _displayText = '0';
      _operand1 = '';
      _operand2 = '';
      _operator = '';
      _shouldClear = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              _displayText,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          
          _buildButtonRow(['7', '8', '9', '/']),
          _buildButtonRow(['4', '5', '6', '*']),
          _buildButtonRow(['1', '2', '3', '-']),
          _buildButtonRow(['C', '0', '=', '+']),
        ],
      ),
    );
  }

  
  Widget _buildButtonRow(List<String> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: values.map((value) {
        return _buildButton(value);
      }).toList(),
    );
  }

 
  Widget _buildButton(String value) {
    return InkWell(
      onTap: () {
        if (value == 'C') {
          _clear();
        } else if (value == '=') {
          _calculate();
        } else if ('+-*/'.contains(value)) {
          _onOperatorPress(value);
        } else {
          _onNumberPress(value);
        }
      },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
        ),
        child: Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
