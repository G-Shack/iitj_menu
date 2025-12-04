import 'event_model.dart';

class AppConfigModel {
  final bool showOptionsScreen;
  final List<EventModel> events;
  final String moreScreenMessage;
  final String timetableMessage;

  const AppConfigModel({
    this.showOptionsScreen = true,
    this.events = const [],
    this.moreScreenMessage = 'No updates currently',
    this.timetableMessage = 'Coming Soon',
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      showOptionsScreen: json['show_options_screen'] as bool? ?? true,
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => EventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      moreScreenMessage:
          json['more_screen_message'] as String? ?? 'No updates currently',
      timetableMessage: json['timetable_message'] as String? ?? 'Coming Soon',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'show_options_screen': showOptionsScreen,
      'events': events.map((e) => e.toJson()).toList(),
      'more_screen_message': moreScreenMessage,
      'timetable_message': timetableMessage,
    };
  }
}
