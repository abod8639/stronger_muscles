
DateTime? _lastTapTime;
const Duration _debounceDuration = Duration(milliseconds: 500);

void doubleTapPrevention(Function onTap) {
  final now = DateTime.now();
  if (_lastTapTime == null || now.difference(_lastTapTime!) > _debounceDuration) {
    _lastTapTime = now;
    onTap();
  }
}