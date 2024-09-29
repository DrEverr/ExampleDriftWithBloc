class Tools {
  static String shortenString(String s, {int length = 100}) {
    if (s.length > length) {
      int lastSpace = s.lastIndexOf(' ', length);
      if (lastSpace != -1) {
        return '${s.substring(0, lastSpace)} (read more)';
      }
      return '${s.substring(0, length)} (read more)';
    }
    return s;
  }
}
