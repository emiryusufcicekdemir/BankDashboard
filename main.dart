import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallet Dashboard',
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  String selectedFilter = 'Tümü';

  final List<Map<String, dynamic>> transactions = [
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

  List<Map<String, dynamic>> get filteredTransactions {
    if (selectedFilter == 'Tümü') return transactions;
    return transactions
        .where((tx) => tx['type'] == selectedFilter.toLowerCase())
        .toList();
  }

  void _showTransactionDetails(Map<String, dynamic> tx) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(tx['description']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tarih: ${tx['date']}'),
                Text('Tutar: ₺ ${tx['amount'].toStringAsFixed(2)}'),
                Text('Tür: ${tx['type'] == 'gelen' ? 'Gelen' : 'Giden'}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hata bildirimi gönderildi.')),
                  );
                },
                child: const Text('Hata Bildir'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kapat'),
              ),
            ],
          ),
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Gelecekte sayfa yönlendirmeleri buraya eklenebilir.
  }

  @override
  Widget build(BuildContext context) {
    final filters = ['Tümü', 'Gelen', 'Giden'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hesabım'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'İşlemler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Döviz Kuru',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FR1: Profil Alanı
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Merhaba Emir Yusuf',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // FR2: Bakiye Kartı
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

              // FR3: Filtre Butonları
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Text(filter),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // FR3: İşlem Listesi
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
                    return Card(
                      child: ListTile(
                        onTap: () => _showTransactionDetails(tx),
                        leading: Icon(
                          tx['type'] == 'gelen'
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color:
                              tx['type'] == 'gelen' ? Colors.green : Colors.red,
                        ),
                        title: Text(tx['description']),
                        subtitle: Text(tx['date']),
                        trailing: Text(
                          '₺ ${tx['amount'].toStringAsFixed(2)}',
                          style: TextStyle(
                            color:
                                tx['type'] == 'gelen'
                                    ? Colors.green
                                    : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
