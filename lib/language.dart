class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "๐ป๐ณ", "Viแปt Nam", "vn"),
      Language(2, "๐ด๓ ง๓ ข๓ ฅ๓ ฎ๓ ง๓ ฟ", "English", "en"),
      Language(3, "๐จ๐ณ", "China", "cn"),
    ];
  }
}
