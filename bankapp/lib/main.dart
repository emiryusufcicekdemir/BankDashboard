import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TransactionProvider())],
      child: const MyApp(),
    ),
  );
}

class TransactionProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'gelen',
      'description': 'Temmuz Maaşı',
      'date': '01.07.2025',
      'amount': 55000.00,
    },
    {
      'type': 'giden',
      'description': 'Spotify Abonelik',
      'date': '02.07.2025',
      'amount': 49.99,
    },
    {
      'type': 'giden',
      'description': 'Mobil Hat Faturası',
      'date': '03.07.2025',
      'amount': 320.75,
    },
    {
      'type': 'gelen',
      'description': 'Freelance Proje',
      'date': '04.07.2025',
      'amount': 1250.00,
    },
    {
      'type': 'giden',
      'description': 'Su Faturası',
      'date': '03.07.2025',
      'amount': 300.75,
    },
  ];

  List<Map<String, dynamic>> get transactions => _transactions;

  void addTransaction(Map<String, dynamic> tx) {
    _transactions.add(tx);
    notifyListeners();
  }

  void removeTransaction(int index) {
    _transactions.removeAt(index);
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkMode = false;

  void toggleDarkMode(bool value) {
    setState(() {
      darkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallet Dashboard',
      theme:
          darkMode
              ? ThemeData.dark()
              : ThemeData(primarySwatch: Colors.lightGreen),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _sayfaGoster() {
    switch (_selectedIndex) {
      case 0:
        return const HesabimSayfasi();
      case 1:
        return const DovizKuruSayfasi();
      case 2:
        return const AyarlarSayfasi();
      default:
        return const HesabimSayfasi();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton(
                backgroundColor: Colors.lightGreen,
                onPressed: () async {
                  final yeniHarcama = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HarcamaEkleSayfasi(),
                    ),
                  );

                  if (yeniHarcama != null &&
                      yeniHarcama is Map<String, dynamic>) {
                    // Transaction ekle
                    Provider.of<TransactionProvider>(
                      context,
                      listen: false,
                    ).addTransaction(yeniHarcama);

                    // 🔹 Ses çal
                    final player = AudioPlayer();
                    await player.play(AssetSource('sounds/success.mp3'));
                  }
                },
                child: const Icon(Icons.add),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hesabım'),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Döviz Kuru',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
      ),
      body: _sayfaGoster(),
    );
  }
}

class HesabimSayfasi extends StatefulWidget {
  const HesabimSayfasi({super.key});

  @override
  State<HesabimSayfasi> createState() => _HesabimSayfasiState();
}

class _HesabimSayfasiState extends State<HesabimSayfasi> {
  String selectedFilter = 'Tümü';

  @override
  Widget build(BuildContext context) {
    final filters = ['Tümü', 'Gelen', 'Giden'];
    final provider = Provider.of<TransactionProvider>(context);
    final filteredTransactions =
        selectedFilter == 'Tümü'
            ? provider.transactions
            : provider.transactions
                .where((tx) => tx['type'] == selectedFilter.toLowerCase())
                .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                SizedBox(width: 12),
                Text(
                  'Merhaba Emir Yusuf',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.lightGreen,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: const [
                    Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Toplam Bakiye',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '₺ 29,380.26',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children:
                  filters.map((filter) {
                    final bool isSelected = selectedFilter == filter;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed:
                              () => setState(() => selectedFilter = filter),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isSelected
                                    ? Colors.lightGreen
                                    : Colors.grey[300],
                            foregroundColor:
                                isSelected ? Colors.white : Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(filter),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 12),
            const Text(
              'Son İşlemler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTransactions.length,
                itemBuilder: (context, index) {
                  final tx = filteredTransactions[index];
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text("Silme Onayı"),
                              content: Text(
                                "'${tx['description']}' işlemini silmek istediğinize emin misiniz?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("İptal"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    provider.removeTransaction(
                                      provider.transactions.indexOf(tx),
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Sil"),
                                ),
                              ],
                            ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    tx['type'] == 'gelen'
                                        ? Colors.green
                                        : Colors.red,
                                child: Icon(
                                  tx['type'] == 'gelen'
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx['description'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      tx['date'],
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₺ ${tx['amount'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  color:
                                      tx['type'] == 'gelen'
                                          ? Colors.green
                                          : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DovizKuruSayfasi extends StatelessWidget {
  const DovizKuruSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, String>> dovizKurlari = {
      "USD": {"Alış": "₺ 40.5543", "Satış": "₺ 40.6274"},
      "EUR": {"Alış": "₺ 47.2245", "Satış": "₺ 47.3096"},
      "GBP": {"Alış": "₺ 54.4089", "Satış": "₺ 54.6926"},
      "CHF": {"Alış": "₺ 51.4089", "Satış": "₺ 51.6926"},
      "SEK": {"Alış": "₺ 4.2089", "Satış": "₺ 4.4926"},
    };

    return Scaffold(
      appBar: AppBar(title: const Text("Döviz Kurları")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children:
            dovizKurlari.entries.map((entry) {
              final code = entry.key;
              final values = entry.value;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.lightGreen,
                    child: Text(
                      code,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(code),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Alış: ${values["Alış"]}"),
                      Text("Satış: ${values["Satış"]}"),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class AyarlarSayfasi extends StatelessWidget {
  const AyarlarSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Ayarlar")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Karanlık Mod"),
            value: appState?.darkMode ?? false,
            onChanged: (val) {
              appState?.toggleDarkMode(val);
            },
          ),
          const ListTile(
            title: Text("Hakkında"),
            subtitle: Text("Wallet Dashboard v1.0"),
          ),
        ],
      ),
    );
  }
}

class HarcamaEkleSayfasi extends StatefulWidget {
  const HarcamaEkleSayfasi({super.key});

  @override
  State<HarcamaEkleSayfasi> createState() => _HarcamaEkleSayfasiState();
}

class _HarcamaEkleSayfasiState extends State<HarcamaEkleSayfasi> {
  final _formKey = GlobalKey<FormState>();
  String? aciklama;
  double? tutar;
  String tur = 'giden';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Harcama Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: tur,
                decoration: const InputDecoration(labelText: "Tür"),
                items: const [
                  DropdownMenuItem(value: 'giden', child: Text("Giden")),
                  DropdownMenuItem(value: 'gelen', child: Text("Gelen")),
                ],
                onChanged: (val) => setState(() => tur = val ?? 'giden'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Açıklama"),
                onSaved: (val) => aciklama = val,
                validator:
                    (val) =>
                        val == null || val.isEmpty ? "Açıklama giriniz" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Tutar"),
                keyboardType: TextInputType.number,
                onSaved: (val) => tutar = double.tryParse(val ?? ""),
                validator:
                    (val) =>
                        val == null || double.tryParse(val) == null
                            ? "Geçerli bir tutar giriniz"
                            : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final yeniHarcama = {
                      'type': tur,
                      'description': aciklama!,
                      'date': _bugunTarih(),
                      'amount': tutar!,
                    };
                    Navigator.pop(context, yeniHarcama);
                  }
                },
                child: const Text("Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _bugunTarih() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}";
  }
}
