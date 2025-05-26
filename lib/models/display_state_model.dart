class DisplayState {
  final String mainDisplay;
  final bool showMemory;
  final bool showSto;
  final bool showRcl;
  final bool showStat;

  DisplayState({
    this.mainDisplay = '0',
    this.showMemory = false,
    this.showSto = false,
    this.showRcl = false,
    this.showStat = false,
  });

  DisplayState copyWith({
    String? mainDisplay,
    bool? showMemory,
    bool? showSto,
    bool? showRcl,
    bool? showStat,
  }) {
    return DisplayState(
      mainDisplay: mainDisplay ?? this.mainDisplay,
      showMemory: showMemory ?? this.showMemory,
      showSto: showSto ?? this.showSto,
      showRcl: showRcl ?? this.showRcl,
      showStat: showStat ?? this.showStat,
    );
  }
}
