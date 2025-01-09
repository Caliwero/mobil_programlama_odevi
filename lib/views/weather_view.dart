import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../viewmodels/weather_view_model.dart';
import 'dart:ui';

class WeatherView extends ConsumerWidget {
  WeatherView({Key? key}) : super(key: key);

  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherViewModelProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1488CC),
              Color(0xFF2B32B2),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Arkaplan desenler
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                left: -80,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              // Ana içerik
              Column(
                children: [
                  // Üst bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hava Durumu',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh, color: Colors.white),
                          onPressed: () {
                            if (_cityController.text.isNotEmpty) {
                              ref
                                  .read(weatherViewModelProvider.notifier)
                                  .getWeather(_cityController.text);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  // Arama alanı
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _cityController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Şehir ara...',
                                    hintStyle: TextStyle(
                                      color: Colors.white70,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.search, color: Colors.white),
                                onPressed: () {
                                  if (_cityController.text.isNotEmpty) {
                                    ref
                                        .read(weatherViewModelProvider.notifier)
                                        .getWeather(_cityController.text);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Hava durumu içeriği
                  Expanded(
                    child: weatherState.when(
                      data: (weather) {
                        if (weather == null) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/images/search.json',
                                  width: size.width * 0.5,
                                  height: size.width * 0.5,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Hadi bir şehir arayalım!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                // Ana hava durumu kartı
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10.0,
                                      sigmaY: 10.0,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    weather.name,
                                                    style: TextStyle(
                                                      fontSize: 28,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    weather.weather.first
                                                        .description
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '${weather.main.temp.round()}°',
                                                style: TextStyle(
                                                  fontSize: 48,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Lottie.asset(
                                            weather.weather.first.animationPath,
                                            width: size.width * 0.5,
                                            height: size.width * 0.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                // Detay kartları
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDetailCard(
                                        'En Düşük',
                                        '${weather.main.tempMin.round()}°',
                                        Icons.arrow_downward,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: _buildDetailCard(
                                        'En Yüksek',
                                        '${weather.main.tempMax.round()}°',
                                        Icons.arrow_upward,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDetailCard(
                                        'Nem',
                                        '%${weather.main.humidity}',
                                        Icons.water_drop_outlined,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: _buildDetailCard(
                                        'Hissedilen',
                                        '${weather.main.feelsLike.round()}°',
                                        Icons.thermostat_outlined,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      loading: () => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Hava durumu getiriliyor...',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/images/error.json',
                              width: size.width * 0.5,
                              height: size.width * 0.5,
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Ups! Bir şeyler ters gitti.\nLütfen tekrar deneyin.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.white70,
                size: 24,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}