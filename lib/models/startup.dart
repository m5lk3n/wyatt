class Startup {
  bool isLoading = true; // -> SplashScreen regardless of other values
  bool hasNoKey =
      false; // key == null && empty + && isNotLoading -> WelcomeScreen
  bool hasInvalidKey =
      false; // key != null && !isValid + && isNotLoading -> WelcomeScreen
  // TODO: add check for reminders/LTDs

  Startup({
    this.isLoading = true,
    this.hasNoKey = false,
    this.hasInvalidKey = false,
  });

  Startup copyWith({bool? isLoading, bool? hasNoKey, bool? hasInvalidKey}) {
    return Startup(
      isLoading: isLoading ?? this.isLoading,
      hasNoKey: hasNoKey ?? this.hasNoKey,
      hasInvalidKey: hasInvalidKey ?? this.hasInvalidKey,
    );
  }

  @override
  String toString() {
    return 'Startup(isLoading: $isLoading, hasNoKey: $hasNoKey, hasInvalidKey: $hasInvalidKey)';
  }
}
