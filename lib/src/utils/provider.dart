  import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

T? maybeRead<T>(BuildContext context) {
    try {
      return context.read<T>();
    } on ProviderNotFoundException {
      return null;
    }
  }

  T? maybeWatch<T>(BuildContext context) {
    try {
      return context.watch<T>();
    } on ProviderNotFoundException {
      return null;
    }
  }