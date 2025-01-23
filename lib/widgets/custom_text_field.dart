import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customTextField(TextEditingController controller, String hintText,
    {bool obscureText = false}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    style: GoogleFonts.poppins(fontSize: 16),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
      filled: true,
      fillColor: Colors.teal.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.teal.shade200, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.teal.shade500, width: 2),
      ),
    ),
  );
}
