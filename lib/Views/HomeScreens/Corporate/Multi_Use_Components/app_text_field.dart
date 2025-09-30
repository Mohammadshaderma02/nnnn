import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final bool isRequired;
  final bool isError;
  final bool obscureToggle; 
  final bool isObscure; 
  final TextInputType keyboardType;
  final void Function(String) onChanged;
  final bool readOnly; 
  final VoidCallback onTap; 

  const AppTextField({
    Key key,
    this.labelText,
    this.hintText,
    this.controller,
    this.isRequired = false,
    this.isError = false,
    this.obscureToggle = false,
    this.isObscure = false,
    this.keyboardType, 
    this.onChanged,
    this.readOnly = false, 
    this.onTap, 
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.labelText,
            style: const TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: widget.isRequired
                ? const [
                    TextSpan(
                      text: ' * ',
                      style: TextStyle(
                        color: Color(0xFFB10000),
                        fontSize: 14,
                      ),
                    )
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureToggle ? _obscureText : false,
            style: const TextStyle(color: Color(0xff11120e)),
            readOnly: widget.readOnly, // Apply read-only
            onTap: widget.onTap, // Apply onTap
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.isError
                      ? const Color(0xFFB10000)
                      : const Color(0xFFD1D7E0),
                  width: 1.0,
                ),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              contentPadding: const EdgeInsets.all(16),
              suffixIcon: widget.obscureToggle
                  ? IconButton(
                      icon: Image.asset(
                        _obscureText
                            ? "assets/images/icon-show.png"
                            : "assets/images/icon-hide.png",
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Color(0xffa4b0c1),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
