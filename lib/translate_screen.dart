import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For clipboard operations
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for launching URLs

class TranslateScreen extends StatefulWidget {
  @override
  _TranslateScreenState createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final TextEditingController _controller = TextEditingController();
  final GoogleTranslator _translator = GoogleTranslator();
  String _result = '';
  String _fromLanguage = 'en';
  String _toLanguage = 'fr';
  bool _isLoading = false;

  Future<void> _translateText() async {
    final String text = _controller.text;
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final translation = await _translator.translate(
        text,
        from: _fromLanguage,
        to: _toLanguage,
      );

      setState(() {
        _result = translation.text;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _result));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to clipboard')),
    );
  }

  void _pasteFromClipboard() async {
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        _controller.text = clipboardData.text!;
      });
    }
  }

  Future<void> _launchPrivacyPolicy() async {
    const url = 'https://www.termsfeed.com/live/2164be7b-130d-46cc-9947-afbb46f462b4'; // Replace with your actual privacy policy URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
              backgroundColor: Colors.white,
        title: Center(child: Text('Bajo Translate')),
        actions: [
          IconButton(
            icon: Icon(Icons.policy),
            onPressed: _launchPrivacyPolicy, // Opens the privacy policy link
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Logo (replace 'assets/logo.png' with your asset)
              Center(
                child: Image.asset('assets/logo.png', height: 100),
              ),
              SizedBox(height: 20),
              // Input text field with paste functionality
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter text to translate',
                      ),
                      maxLines: 3,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.paste),
                    onPressed: _pasteFromClipboard,
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Language selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: _fromLanguage,
                    items: ['en', 'fr', 'so'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _fromLanguage = newValue!;
                      });
                    },
                  ),
                  Icon(Icons.arrow_forward),
                  DropdownButton<String>(
                    value: _toLanguage,
                    items: ['en', 'fr', 'so'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _toLanguage = newValue!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Translate button with loading indicator
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _translateText,
                      child: Text('Translate'),
                    ),
              SizedBox(height: 20),
              // Result display with copy button
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: SelectableText(
                  _result.isEmpty ? 'Result here...' : _result,
                  showCursor: true,
                  cursorColor: Colors.blue,
                  cursorWidth: 2,
                  toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                ),
              ),
              if (_result.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: _copyToClipboard,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}