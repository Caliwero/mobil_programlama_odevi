import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';

final weatherServiceProvider = Provider((ref) => WeatherService());

final weatherViewModelProvider =
StateNotifierProvider<WeatherViewModel, AsyncValue<WeatherModel?>>((ref) {
  final weatherService = ref.watch(weatherServiceProvider);
  return WeatherViewModel(weatherService);
});

class WeatherViewModel extends StateNotifier<AsyncValue<WeatherModel?>> {
  final WeatherService _weatherService;

  WeatherViewModel(this._weatherService) : super(const AsyncValue.data(null));

  Future<void> getWeather(String city) async {
    state = const AsyncValue.loading();
    try {
      final weather = await _weatherService.getWeather(city);
      state = AsyncValue.data(weather);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}