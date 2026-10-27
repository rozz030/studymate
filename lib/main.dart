import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';

import 'providers/study_provider.dart';
import 'providers/note_provider.dart';

import 'repositories/study_material_repository.dart';
import 'repositories/saved_reference_repository.dart';
import 'repositories/study_note_repository.dart';

import 'services/open_library_service.dart';
import 'services/saved_reference_service.dart';
import 'services/study_note_service.dart';

import 'screens/home_page.dart';
import 'screens/explore_page.dart';
import 'screens/saved_page.dart';
import 'screens/notes_page.dart';
import 'screens/profile_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  final supabase = Supabase.instance.client;

  final studyRepository = StudyMaterialRepository(OpenLibraryService());

  final savedReferenceService = SavedReferenceService(supabase);

  final savedReferenceRepository = SavedReferenceRepository(
    savedReferenceService,
  );

  final studyNoteService = StudyNoteService(supabase);

  final studyNoteRepository = StudyNoteRepository(studyNoteService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<StudyProvider>(
          create: (_) =>
              StudyProvider(studyRepository, savedReferenceRepository),
        ),

        ChangeNotifierProvider<NoteProvider>(
          create: (_) => NoteProvider(studyNoteRepository)..loadNotes(),
        ),
      ],
      child: const StudyMateApp(),
    ),
  );
}

class StudyMateApp extends StatelessWidget {
  const StudyMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyMate',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ExplorePage(),
    SavedPage(),
    NotesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined),
            selectedIcon: Icon(Icons.note_alt),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
