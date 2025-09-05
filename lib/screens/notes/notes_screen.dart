import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notes_provider.dart';
import '../../models/note_data.dart';
import '../../utils/app_theme.dart';
import '../../widgets/notes_widgets/note_card.dart';
import '../../widgets/notes_widgets/note_editor.dart';
import '../../widgets/notes_widgets/note_filters.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kişisel Notlar'),
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list : Icons.filter_list_outlined),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showNoteEditor(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Arama çubuğu
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Notlarda ara...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<NotesProvider>().updateSearchQuery('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                context.read<NotesProvider>().updateSearchQuery(value);
              },
            ),
          ),

          // Filtreler
          if (_showFilters) const NoteFilters(),

          // Not listesi
          Expanded(
            child: Consumer<NotesProvider>(
              builder: (context, notesProvider, child) {
                final notes = notesProvider.notes;

                if (notes.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(
                      note: note,
                      onTap: () => _showNoteEditor(context, note: note),
                      onEdit: () => _showNoteEditor(context, note: note),
                      onDelete: () => _showDeleteDialog(context, note),
                      onShare: () => _showShareDialog(context, note),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteEditor(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz not yok',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'İlk notunuzu oluşturmak için + butonuna tıklayın',
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showNoteEditor(BuildContext context, {NoteData? note}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NoteEditor(
        note: note,
        onSave: (note) {
          if (note.id.isEmpty) {
            // Yeni not
            final newNote = note.copyWith(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            context.read<NotesProvider>().addNote(newNote);
          } else {
            // Mevcut notu güncelle
            final updatedNote = note.copyWith(updatedAt: DateTime.now());
            context.read<NotesProvider>().updateNote(updatedNote);
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, NoteData note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notu Sil'),
        content: Text('${note.title} notunu silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<NotesProvider>().deleteNote(note.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Not silindi'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context, NoteData note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notu Paylaş'),
        content: Text('${note.title} notunu sevgilinizle paylaşmak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Burada partner ID'si alınacak
              context.read<NotesProvider>().shareNote(note.id, 'partner_id');
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Not paylaşıldı'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Paylaş'),
          ),
        ],
      ),
    );
  }
}
