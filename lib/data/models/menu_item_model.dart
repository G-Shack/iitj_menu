import 'package:equatable/equatable.dart';

// Simple model for individual menu items (just strings now)
class MenuItem extends Equatable {
  final String name;

  const MenuItem({
    required this.name,
  });

  @override
  List<Object?> get props => [name];
}
