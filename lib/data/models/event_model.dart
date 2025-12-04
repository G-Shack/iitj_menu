import 'package:equatable/equatable.dart';

enum EventStatus {
  upcoming,
  completed,
  cancelled,
}

class EventModel extends Equatable {
  final String name;
  final String venue;
  final String time;
  final EventStatus status;

  const EventModel({
    required this.name,
    required this.venue,
    required this.time,
    required this.status,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      name: json['name'] as String? ?? '',
      venue: json['venue'] as String? ?? '',
      time: json['time'] as String? ?? '',
      status: _parseStatus(json['status'] as String? ?? 'upcoming'),
    );
  }

  static EventStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return EventStatus.completed;
      case 'cancelled':
      case 'canceled':
        return EventStatus.cancelled;
      case 'upcoming':
      default:
        return EventStatus.upcoming;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'venue': venue,
      'time': time,
      'status': status.name,
    };
  }

  @override
  List<Object?> get props => [name, venue, time, status];
}
