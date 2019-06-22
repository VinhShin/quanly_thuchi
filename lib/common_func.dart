String formatMoney(String money) {
  String newFormat = "";
  for (int i = 0; i < money.length; i++) {
    newFormat = money[money.length-i-1] + newFormat;
    if ((i+1) % 3 == 0 && i != money.length-1) {
      newFormat = "." + newFormat;
    }
  }
  return newFormat;
}
