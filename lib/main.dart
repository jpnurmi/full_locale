import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<List<String>> loadLanguages() async {
  final languages = <String>[];
  for (final locale in AppLocalizations.supportedLocales) {
    final l10n = await AppLocalizations.delegate.load(locale);
    languages.add(l10n.languageName);
  }
  return languages;
}

Future<void> main() async {
  runApp(LanguageApp(
    languages: await loadLanguages(),
    locales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
  ));
}

class LanguageApp extends StatefulWidget {
  const LanguageApp({
    Key? key,
    required this.languages,
    required this.locales,
    required this.localizationsDelegates,
  })  : assert(languages.length == locales.length),
        super(key: key);

  final List<String> languages;
  final List<Locale> locales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  @override
  State<LanguageApp> createState() => _LanguageAppState();
}

class _LanguageAppState extends State<LanguageApp> {
  var _selected = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: widget.locales[_selected],
      supportedLocales: widget.locales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
        appBar: AppBar(title: const Text('#92731')),
        body: SingleChildScrollView(
          child: Table(
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(),
            },
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  const TitleLabel('Language:'),
                  LanguageList(
                    languages: widget.languages,
                    selected: _selected,
                    onSelected: (index) => setState(() => _selected = index),
                  ),
                ],
              ),
              const TableRow(
                children: <Widget>[
                  TitleLabel('Locale:'),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: LocaleView(),
                  ),
                ],
              ),
              const TableRow(
                children: <Widget>[
                  TitleLabel('Location:'),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: LocationView(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleLabel extends StatelessWidget {
  const TitleLabel(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}

// Let the user select one of the available translations.
class LanguageList extends StatelessWidget {
  const LanguageList({
    Key? key,
    required this.languages,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  final List<String> languages;
  final int selected;
  final void Function(int index) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (var i = 0; i < languages.length; ++i)
          ListTile(
            selected: i == selected,
            title: Text(languages[i]),
            onTap: () => onSelected(i),
          ),
      ],
    );
  }
}

// A dummy example of something that needs to convert the application locale to
// a valid POSIX locale.
class LocaleView extends StatelessWidget {
  const LocaleView({Key? key}) : super(key: key);

  // e.g. /usr/share/i18n/SUPPORTED
  static bool isValidLocale(Locale locale) => locale.countryCode != null;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: isValidLocale(locale)
          ? Text('$locale.UTF-8')
          : Text(
              '$locale.UTF-8 (INVALID)',
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
    );
  }
}

// A dummy example of something that presents/asks the user's location, which
// defaults to the country of the selected language. Could be a map and a list
// of autocompleted locations like in the Ubuntu desktop installer.
class LocationView extends StatelessWidget {
  const LocationView({Key? key}) : super(key: key);

  // An imaginary enternal DB of countries (e.g. geoname.org)
  static const countryDB = {
    'BR': 'Brazil',
    'CA': 'Canada',
    'FI': 'Finland',
    'PT': 'Portugal',
    'SE': 'Sweden',
    'UK': 'United Kingdom',
    'US': 'United States',
  };

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: locale.countryCode != null
          ? Text(countryDB[locale.countryCode]!)
          : Text(
              'UNKNOWN',
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
    );
  }
}
