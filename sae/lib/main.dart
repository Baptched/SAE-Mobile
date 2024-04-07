import 'dart:io';

import 'package:flutter/material.dart';
import './UI/connexion.dart';
import 'package:supabase/supabase.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final client = SupabaseClient('https://crlpavoxnmyrdlzmfijc.supabase.co/', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNybHBhdm94bm15cmRsem1maWpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA0OTQ4MjgsImV4cCI6MjAyNjA3MDgyOH0.6kSBHiUAyRtSbukm26F9U-EvMPy-hyFjRLLgTd6Qjfc');


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Connexion()
    );
  }
}
