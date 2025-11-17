// lib/main.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart' as qrfl;
import 'widgets/qr_image.dart';
import 'utils/download_qr.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// NOTE: Add firebase packages later and initialize Firebase in main()
// e.g. firebase_core, firebase_auth, cloud_firestore, firebase_storage

void main() {
  runApp(const MediTrackApp());
}

class MediTrackApp extends StatelessWidget {
  const MediTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        scaffoldBackgroundColor: const Color(0xFFF7FBFF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => LoginScreen(),
        '/signup': (_) => SignupScreen(),
        '/dashboard': (_) => DashboardScreen(),
        '/doctor': (_) => DoctorDashboard(),
        '/summary': (_) => AISummaryScreen(),
        '/settings': (_) => SettingsScreen(),
      },
    );
  }
}

/* -------------------------
   Splash Screen
   ------------------------- */
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading, then navigate to login.
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: size.width * 0.34,
              height: size.width * 0.34,
              decoration: BoxDecoration(
                color: const Color(0xFFEBF6FF),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.medical_information_outlined,
                size: 72,
                color: Color(0xFF2B7FFF),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'MediTrack',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Lifetime Health, One Tap Away.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------------
   Login & Signup Screens
   ------------------------- */
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        elevation: 0,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              'Welcome back! Sign in to access your medical records.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            AuthTextField(label: 'Email'),
            const SizedBox(height: 12),
            AuthTextField(label: 'Password', obscure: true),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: integrate with firebase_auth signInWithEmailAndPassword
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    },
                    child: const Text('Login with Email'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: implement phone OTP flow
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Phone login placeholder — add OTP.')),
                );
              },
              icon: const Icon(Icons.phone_android),
              label: const Text('Login with Phone'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B7FFF),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text("Don't have an account? Sign up"),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        elevation: 0,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          children: [
            AuthTextField(label: 'Full name'),
            const SizedBox(height: 12),
            AuthTextField(label: 'Email'),
            const SizedBox(height: 12),
            AuthTextField(label: 'Password', obscure: true),
            const SizedBox(height: 12),
            AuthTextField(label: 'Phone (optional)'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: create user in firebase_auth and create initial Firestore doc
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  final String label;
  final bool obscure;
  const AuthTextField({required this.label, this.obscure = false, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

/* -------------------------
   Dashboard with Tabs
   ------------------------- */
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const HealthProfileTab(),
    const MedicalTimelineTab(),
    const UploadReportsTab(),
    const QRAccessTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediTrack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_search),
            onPressed: () => Navigator.pushNamed(context, '/doctor'),
            tooltip: 'Doctor Dashboard',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _tabs[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        selectedItemColor: const Color(0xFF2B7FFF),
        unselectedItemColor: Colors.black54,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Timeline'),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/summary'),
        label: const Text('AI Summary'),
        icon: const Icon(Icons.smart_toy_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

/* -------------------------
   Health Profile Tab
   ------------------------- */
class HealthProfileTab extends StatelessWidget {
  const HealthProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data. Replace with Firestore model later.
    const name = 'Suraj Kumar Chaudhary';
    const age = '20';
    const bloodGroup = 'B+';
    const allergies = 'None';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _roundedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Basic Info',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFEBF6FF),
                    child: const Icon(Icons.person, color: Color(0xFF2B7FFF)),
                  ),
                  title: Text(name),
                  subtitle: const Text('Patient ID: PT-000124'),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoChip('Age', age),
                    _infoChip('Blood', bloodGroup),
                    _infoChip('Allergies', allergies),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: edit profile
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit Profile')));
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _roundedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Long-term Conditions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('- Type II Diabetes (2021)\n- Fatty Liver (2024)\n- Dengue (2015)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.04), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

/* -------------------------
   Medical Timeline Tab
   ------------------------- */
class MedicalTimelineTab extends StatelessWidget {
  const MedicalTimelineTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder list. Replace with real Firestore query.
    final events = [
      {'date': '2024-05-12', 'title': 'Liver Enzyme Treatment', 'clinic': 'Apollo'},
      {'date': '2021-03-01', 'title': 'Diabetes Diagnosed', 'clinic': 'City Clinic'},
      {'date': '2017-09-08', 'title': 'Fracture Surgery', 'clinic': 'Orthopedic Center'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final e = events[index];
        return _roundedCard(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFEFF7F0),
              child: const Icon(Icons.local_hospital, color: Color(0xFF2BBF6A)),
            ),
            title: Text(e['title'] ?? ''),
            subtitle: Text('${e['clinic'] ?? ''} • ${e['date'] ?? ''}'),
            trailing: IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () {
                // TODO: open report
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open report placeholder')));
              },
            ),
          ),
        );
      },
      separatorBuilder: (context, i) => const SizedBox(height: 12),
      itemCount: events.length,
    );
  }
}

/* -------------------------
   Upload Reports Tab
   ------------------------- */
class UploadReportsTab extends StatelessWidget {
  const UploadReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_file, size: 84, color: Color(0xFF2B7FFF)),
            const SizedBox(height: 12),
            const Text('Upload medical reports (PDF / Image)'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: use file_picker + firebase_storage upload & save metadata to firestore
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload flow placeholder')));
              },
              icon: const Icon(Icons.file_upload),
              label: const Text('Upload Report'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tip: Add doctor name, hospital & date when uploading for better timeline organization.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------------
   QR Code / Doctor Access Tab
   ------------------------- */
class QRAccessTab extends StatelessWidget {
  const QRAccessTab({super.key});

  @override
  Widget build(BuildContext context) {
    // For demo: static user id. Replace with user's unique id later.
    const qrData = 'PT-000124';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use compatibility widget (now named QrImage) so the code can use `data:` style call.
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: QrImage(
                data: qrData,
                version: qrfl.QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
                gapless: true,
                moduleColor: Colors.black, // force test color to ensure visibility
                eyeColor: Colors.black,
                margin: 4.0,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Share this QR with your doctor to grant access.'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    // Generate QR bytes and trigger download / save
                    const double imgSize = 1000; // higher resolution for download
                    final painter = qrfl.QrPainter(
                      data: qrData,
                      version: qrfl.QrVersions.auto,
                      gapless: false,
                      dataModuleStyle: qrfl.QrDataModuleStyle(color: Colors.black),
                      eyeStyle: qrfl.QrEyeStyle(eyeShape: qrfl.QrEyeShape.square, color: Colors.black),
                    );
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.showSnackBar(const SnackBar(content: Text('Preparing QR...')));
                    try {
                      final bd = await painter.toImageData(imgSize);
                      if (bd != null) {
                        final bytes = bd.buffer.asUint8List();
                        final result = await downloadQr(bytes, 'medi_qr_$qrData.png');
                            messenger.showSnackBar(SnackBar(content: Text(result ?? 'Downloaded')));
                      } else {
                        messenger.showSnackBar(const SnackBar(content: Text('Failed to generate QR image')));
                      }
                    } catch (e) {
                      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download QR'),
                ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Share the QR image. On web, fallback to download (web share of files is limited).
                        const double imgSize = 1000;
                        final painter = qrfl.QrPainter(
                          data: qrData,
                          version: qrfl.QrVersions.auto,
                          gapless: false,
                          dataModuleStyle: qrfl.QrDataModuleStyle(color: Colors.black),
                          eyeStyle: qrfl.QrEyeStyle(eyeShape: qrfl.QrEyeShape.square, color: Colors.black),
                        );
                        final messenger = ScaffoldMessenger.of(context);
                        messenger.showSnackBar(const SnackBar(content: Text('Preparing to share...')));
                        try {
                          final bd = await painter.toImageData(imgSize);
                          if (bd == null) {
                            messenger.showSnackBar(const SnackBar(content: Text('Failed to generate QR image')));
                            return;
                          }
                          final bytes = bd.buffer.asUint8List();
                          if (kIsWeb) {
                            // Web: trigger download as a fallback for sharing files
                            await downloadQr(bytes, 'medi_qr_$qrData.png');
                            messenger.showSnackBar(const SnackBar(content: Text('Downloaded (use your browser share to send)')));
                            return;
                          }
                          // Non-web: save to temp and share via platform share sheet
                          final path = await downloadQr(bytes, 'medi_qr_$qrData.png');
                          if (path != null) {
                            await Share.shareXFiles([XFile(path)], text: 'MediTrack QR for $qrData');
                            messenger.showSnackBar(const SnackBar(content: Text('Shared')));
                          } else {
                            messenger.showSnackBar(const SnackBar(content: Text('Failed to save file for sharing')));
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: allow generation of temporary access codes & revoke
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generate Access Code')));
                  },
                  icon: const Icon(Icons.key),
                  label: const Text('Generate Access Code'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------------
   Doctor Dashboard
   ------------------------- */
class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final controller = TextEditingController();

  void _search() {
    final code = controller.text.trim();
    // TODO: query Firestore for patient by code or scan QR with camera
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Searching for patient: $code (placeholder)')));
    // Simulate navigation to a patient view
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorPatientView()));
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Search patient by QR / Access Code'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Enter Access Code / Patient ID',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: implement QR scanner
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('QR scanner placeholder')));
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan QR'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text('Recent Patients'),
                    subtitle: Text('Shows last viewed patients for quick access'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorPatientView extends StatelessWidget {
  const DoctorPatientView({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with real patient data loaded from Firestore
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Records')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Patient: Suraj Kumar Chaudhary', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _roundedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('AI Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Chronic liver condition (2024). Type-II Diabetes (2021). Currently on Metformin.'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _roundedCard(
                    child: ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('2024-05-12 • Liver Report'),
                      subtitle: const Text('Apollo Hospital'),
                      trailing: IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {
                          // TODO: download/view report file
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------------
   AI Summary Page
   ------------------------- */
class AISummaryScreen extends StatelessWidget {
  const AISummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder summary. Replace with response from ai_service.
    const summary =
        'Patient overview: Type-II Diabetes since 2021. Fatty liver noted in 2024 with elevated enzymes. Current medications: Metformin 500mg daily. No known drug allergies.';

    return Scaffold(
      appBar: AppBar(title: const Text('AI Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _roundedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Concise Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(summary),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: call AI again or regenerate
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Regenerate placeholder')));
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Regenerate'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: show full notes extraction
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('View Details'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text('AI Insights (high level)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(title: Text('Medication Conflict Check'), subtitle: Text('No conflicts found (placeholder)')),
                  ListTile(title: Text('Follow-up Suggestion'), subtitle: Text('Liver panel in 3 months')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------------
   Settings Page
   ------------------------- */
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          _roundedCard(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              onTap: () {
                // TODO: navigate to profile edit
              },
            ),
          ),
          const SizedBox(height: 12),
          const Text('Privacy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          _roundedCard(
            child: Column(
              children: [
                SwitchListTile(
                  value: true,
                  onChanged: (v) {
                    // TODO: toggle sharing settings
                  },
                  title: const Text('Allow temporary doctor access'),
                ),
                ListTile(
                  title: const Text('Data Privacy & Export'),
                  subtitle: const Text('Request account export / delete'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _roundedCard(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // TODO: sign out via Firebase Auth
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------------
   Small UI Helpers
   ------------------------- */

Widget _roundedCard({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.03),
          blurRadius: 12,
          offset: const Offset(0, 6),
        )
      ],
    ),
    child: child,
  );
}
