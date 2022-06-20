import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
          currentTheme: ThemeData(),
          textTheme: SettingsState.medium,
          bubbleAlignment: false,
          centerDate: false,
        ));

  void initTextTheme(int fontSizeIndex) async {
    switch (fontSizeIndex) {
      case 0:
        emit(
          state.copyWith(
            textTheme: SettingsState.small,
          ),
        );
        break;
      case 1:
        emit(
          state.copyWith(
            textTheme: SettingsState.medium,
          ),
        );
        break;
      case 2:
        emit(
          state.copyWith(
            textTheme: SettingsState.large,
          ),
        );
        break;
    }
  }

  void resetSettings() async {
    emit(
      state.copyWith(
        textTheme: SettingsState.medium,
        bubbleAlignment: false,
        centerDate: false,
      ),
    );
    emit(
      state.copyWith(
        currentTheme: state.lightTheme,
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', 'light');
  }

  void changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('theme') == 'light') {
      emit(
        state.copyWith(currentTheme: state.darkTheme),
      );
      prefs.setString('theme', 'dark');
    } else {
      emit(
        state.copyWith(currentTheme: state.lightTheme),
      );
      prefs.setString('theme', 'light');
    }
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? '';
    ThemeData themeData;
    if (theme == 'light' || theme == '') {
      themeData = state.lightTheme;
    } else {
      themeData = state.darkTheme;
    }

    emit(
      state.copyWith(
        currentTheme: themeData,
        textTheme: SettingsState.medium,
      ),
    );
  }

  void changeTextTheme(int index) async {
    final prefs = await SharedPreferences.getInstance();
    initTextTheme(index);
    if (prefs.getString('theme') == 'light') {
      emit(
        state.copyWith(currentTheme: state.lightTheme),
      );
    } else {
      emit(
        state.copyWith(currentTheme: state.darkTheme),
      );
    }
  }

  void changeAlignment() {
    emit(
      state.copyWith(
        bubbleAlignment: !state.bubbleAlignment,
      ),
    );
  }

  void changeCenterDate() {
    emit(
      state.copyWith(
        centerDate: !state.centerDate,
      ),
    );
  }
}
