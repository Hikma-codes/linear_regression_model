import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

//  API configuration 
const String kApiBaseUrl = 'https://linear-regression-model-ovfh.onrender.com';

// Field descriptor 
class FieldConfig {
  final String key;
  final String label;
  final String hint;
  final double min;
  final double max;
  final bool isInt;

  const FieldConfig({
    required this.key,
    required this.label,
    required this.hint,
    required this.min,
    required this.max,
    this.isInt = false,
  });
}

const List<FieldConfig> kFields = [
  FieldConfig(
      key: 'Age', label: 'Age', hint: '0 – 100', min: 0, max: 100, isInt: true),
  FieldConfig(
      key: 'Basic_Computer_Knowledge_Score',
      label: 'Basic Computer Knowledge Score',
      hint: '0.0 – 100.0',
      min: 0,
      max: 100),
  FieldConfig(
      key: 'Internet_Usage_Score',
      label: 'Internet Usage Score',
      hint: '0.0 – 100.0',
      min: 0,
      max: 100),
  FieldConfig(
      key: 'Mobile_Literacy_Score',
      label: 'Mobile Literacy Score',
      hint: '0.0 – 100.0',
      min: 0,
      max: 100),
  FieldConfig(
      key: 'Post_Training_Basic_Computer_Knowledge_Score',
      label: 'Post-Training Computer Knowledge',
      hint: '0.0 – 100.0',
      min: 0,
      max: 100),
  FieldConfig(
      key: 'Post_Training_Internet_Usage_Score',
      label: 'Post-Training Internet Usage',
      hint: '0.0 – 100.0',
      min: 0,
      max: 100),
  FieldConfig(
      key: 'Post_Training_Mobile_Literacy_Score',
      label: 'Post-Training Mobile Literacy',
      hint: '0.0 – 100.0',
      min: 0,
      max: 100),
  FieldConfig(
      key: 'Modules_Completed',
      label: 'Modules Completed',
      hint: '0 – 100',
      min: 0,
      max: 100,
      isInt: true),
  FieldConfig(
      key: 'Average_Time_Per_Module',
      label: 'Avg. Time Per Module (hrs)',
      hint: '0.0 – 100.0',
      min: 0,
      max: 100),
  FieldConfig(
      key: 'Quiz_Performance',
      label: 'Quiz Performance Score',
      hint: '0.0 – 100.0',
      min: 0,
      max: 100),
  FieldConfig(
      key: 'Session_Count',
      label: 'Session Count',
      hint: '0 – 500',
      min: 0,
      max: 500,
      isInt: true),
  FieldConfig(
      key: 'Adaptability_Score',
      label: 'Adaptability Score',
      hint: '0.0 – 100.0',
      min: 0,
      max: 100),
  FieldConfig(
      key: 'Feedback_Rating',
      label: 'Feedback Rating',
      hint: '0.0 – 5.0',
      min: 0,
      max: 5),
];

// Entry point 
void main() {
  runApp(const DigitalLiteracyApp());
}

class DigitalLiteracyApp extends StatelessWidget {
  const DigitalLiteracyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Literacy Predictor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, // accent touches
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.dmSansTextTheme(
          ThemeData.light().textTheme.apply(
                bodyColor: Colors.black,
                displayColor: Colors.black,
              ),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const PredictionPage(),
    );
  }
}

//Single prediction page 
class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    for (final f in kFields) f.key: TextEditingController()
  };

  bool _isLoading = false;
  String? _resultText;
  bool _isError = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // API call 
  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _resultText = null;
      _isError = false;
    });

    final Map<String, dynamic> payload = {};
    for (final f in kFields) {
      final raw = _controllers[f.key]!.text.trim();
      payload[f.key] = f.isInt ? int.parse(raw) : double.parse(raw);
    }

    try {
      final response = await http
          .post(
            Uri.parse('$kApiBaseUrl/predict'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final score =
            (data['predicted_Skill_Application'] as num).toStringAsFixed(2);
        setState(() {
          _resultText = 'Predicted Skill Application Score\n$score / 100';
          _isError = false;
        });
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          _resultText =
              'Error ${response.statusCode}: ${data['detail'] ?? 'Unknown error'}';
          _isError = true;
        });
      }
    } on Exception catch (e) {
      setState(() {
        _resultText =
            'Could not reach the server.\nCheck your connection.\n\n$e';
        _isError = true;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearAll() {
    for (final c in _controllers.values) c.clear();
    setState(() {
      _resultText = null;
      _isError = false;
    });
  }

  String? _validate(FieldConfig field, String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final n = num.tryParse(value.trim());
    if (n == null) return 'Enter a valid number';
    if (n < field.min || n > field.max)
      return 'Must be ${field.min}–${field.max}';
    if (field.isInt && value.contains('.')) return 'Must be a whole number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blueAccent, Colors.white],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'DIGITAL LITERACY',
                            style: GoogleFonts.spaceMono(
                              fontSize: 10,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Skill Predictor',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 28,
                          color: Colors.black,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    _sectionLabel('LEARNER PROFILE'),
                    ..._buildFields(kFields.sublist(0, 4)),
                    const SizedBox(height: 16),
                    _sectionLabel('POST-TRAINING SCORES'),
                    ..._buildFields(kFields.sublist(4, 7)),
                    const SizedBox(height: 16),
                    _sectionLabel('ENGAGEMENT METRICS'),
                    ..._buildFields(kFields.sublist(7, 11)),
                    const SizedBox(height: 16),
                    _sectionLabel('LEARNING QUALITY'),
                    ..._buildFields(kFields.sublist(11)),
                    const SizedBox(height: 28),
                    _isLoading
                        ? Center(
                            child: ScaleTransition(
                              scale: _pulseAnimation,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.teal.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.teal, width: 1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Predicting...',
                                      style: TextStyle(
                                          color: Colors.teal, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _predict,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Predict',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _clearAll,
                      child: Text(
                        'Clear All',
                        style: GoogleFonts.dmSans(
                            color: Colors.black38, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_resultText != null) _buildResult(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 4),
        child: Text(
          text,
          style: GoogleFonts.spaceMono(
              fontSize: 9, color: Colors.black54, letterSpacing: 2.5),
        ),
      );

  List<Widget> _buildFields(List<FieldConfig> fields) {
    final widgets = <Widget>[];
    for (int i = 0; i < fields.length; i++) {
      widgets.add(_buildField(fields[i]));
      if (i < fields.length - 1) widgets.add(const SizedBox(height: 12));
    }
    return widgets;
  }

  Widget _buildField(FieldConfig field) {
    return TextFormField(
      controller: _controllers[field.key],
      keyboardType: field.isInt
          ? TextInputType.number
          : const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: field.isInt
          ? [FilteringTextInputFormatter.digitsOnly]
          : [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
      validator: (v) => _validate(field, v),
      style: GoogleFonts.dmSans(color: Colors.black, fontSize: 15),
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.hint,
        labelStyle: GoogleFonts.dmSans(color: Colors.black54, fontSize: 13),
        hintStyle: GoogleFonts.dmSans(color: Colors.black26, fontSize: 12),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.teal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorStyle: GoogleFonts.spaceMono(fontSize: 10, color: Colors.red),
      ),
    );
  }

  Widget _buildResult() {
    final isSuccess = !_isError;
    final bgColor =
        isSuccess ? Colors.teal.withOpacity(0.1) : Colors.red.withOpacity(0.1);
    final borderColor =
        isSuccess ? Colors.teal.withOpacity(0.4) : Colors.red.withOpacity(0.4);
    final iconData =
        isSuccess ? Icons.check_circle_outline : Icons.error_outline;
    final iconColor = isSuccess ? Colors.teal : Colors.red;
    final lines = _resultText!.split('\n');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          Icon(iconData, color: iconColor, size: 28),
          const SizedBox(height: 10),
          if (isSuccess && lines.length >= 2) ...[
            Text(
              lines[0],
              style: GoogleFonts.dmSans(
                  color: Colors.black54, fontSize: 12, letterSpacing: 0.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              lines[1],
              style:
                  GoogleFonts.dmSerifDisplay(color: Colors.teal, fontSize: 36),
              textAlign: TextAlign.center,
            ),
          ] else
            Text(
              _resultText!,
              style: GoogleFonts.dmSans(
                color: _isError ? Colors.red : Colors.black,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
