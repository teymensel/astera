import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notes_provider.dart';
import '../../utils/app_theme.dart';

class NoteFilters extends StatefulWidget {
  const NoteFilters({super.key});

  @override
  State<NoteFilters> createState() => _NoteFiltersState();
}

class _NoteFiltersState extends State<NoteFilters> {
  String _selectedSortBy = 'updatedAt';
  bool _sortAscending = false;
  List<String> _selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) {
        final allTags = notesProvider.getAllTags();
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sıralama
              Row(
                children: [
                  const Text(
                    'Sırala:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedSortBy,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'updatedAt',
                          child: Text('Son Güncelleme'),
                        ),
                        DropdownMenuItem(
                          value: 'createdAt',
                          child: Text('Oluşturma Tarihi'),
                        ),
                        DropdownMenuItem(
                          value: 'title',
                          child: Text('Başlık'),
                        ),
                        DropdownMenuItem(
                          value: 'contentLength',
                          child: Text('Uzunluk'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedSortBy = value;
                          });
                          notesProvider.updateSorting(value, _sortAscending);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _sortAscending = !_sortAscending;
                      });
                      notesProvider.updateSorting(_selectedSortBy, _sortAscending);
                    },
                    icon: Icon(
                      _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Tag filtreleri
              if (allTags.isNotEmpty) ...[
                const Text(
                  'Etiketler:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: allTags.map((tag) {
                    final isSelected = _selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        });
                        notesProvider.updateSelectedTags(_selectedTags);
                      },
                      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                      checkmarkColor: AppTheme.primaryColor,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                if (_selectedTags.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedTags.clear();
                      });
                      notesProvider.updateSelectedTags([]);
                    },
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Tümünü Temizle'),
                  ),
              ],

              // İstatistikler
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.analytics,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${notesProvider.totalNotes} not, ${notesProvider.totalWords} kelime',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
