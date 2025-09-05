import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/todos_provider.dart';
import '../../models/todo_data.dart';
import '../../utils/app_theme.dart';

class TodoFilters extends StatefulWidget {
  const TodoFilters({super.key});

  @override
  State<TodoFilters> createState() => _TodoFiltersState();
}

class _TodoFiltersState extends State<TodoFilters> {
  String _selectedSortBy = 'createdAt';
  bool _sortAscending = false;
  List<String> _selectedTags = [];
  List<TodoStatus> _selectedStatuses = [];
  List<TodoPriority> _selectedPriorities = [];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Consumer<TodosProvider>(
      builder: (context, todosProvider, child) {
        final allTags = todosProvider.getAllTags();
        final allCategories = todosProvider.getAllCategories();
        
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
                          value: 'createdAt',
                          child: Text('Oluşturma Tarihi'),
                        ),
                        DropdownMenuItem(
                          value: 'dueDate',
                          child: Text('Bitiş Tarihi'),
                        ),
                        DropdownMenuItem(
                          value: 'priority',
                          child: Text('Öncelik'),
                        ),
                        DropdownMenuItem(
                          value: 'title',
                          child: Text('Başlık'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedSortBy = value;
                          });
                          todosProvider.updateSorting(value, _sortAscending);
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
                      todosProvider.updateSorting(_selectedSortBy, _sortAscending);
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

              // Durum filtreleri
              const Text(
                'Durum:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: TodoStatus.values.map((status) {
                  final isSelected = _selectedStatuses.contains(status);
                  return FilterChip(
                    label: Text(_getStatusText(status)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedStatuses.add(status);
                        } else {
                          _selectedStatuses.remove(status);
                        }
                      });
                      todosProvider.updateSelectedStatuses(_selectedStatuses);
                    },
                    selectedColor: _getStatusColor(status).withOpacity(0.2),
                    checkmarkColor: _getStatusColor(status),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Öncelik filtreleri
              const Text(
                'Öncelik:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: TodoPriority.values.map((priority) {
                  final isSelected = _selectedPriorities.contains(priority);
                  return FilterChip(
                    label: Text(_getPriorityText(priority)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedPriorities.add(priority);
                        } else {
                          _selectedPriorities.remove(priority);
                        }
                      });
                      todosProvider.updateSelectedPriorities(_selectedPriorities);
                    },
                    selectedColor: _getPriorityColor(priority).withOpacity(0.2),
                    checkmarkColor: _getPriorityColor(priority),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Kategori filtresi
              if (allCategories.isNotEmpty) ...[
                const Text(
                  'Kategori:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: _selectedCategory,
                  hint: const Text('Kategori seçin'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Tümü'),
                    ),
                    ...allCategories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                    todosProvider.updateSelectedCategory(value);
                  },
                ),
                const SizedBox(height: 16),
              ],

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
                        todosProvider.updateSelectedTags(_selectedTags);
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
                      todosProvider.updateSelectedTags([]);
                    },
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Tümünü Temizle'),
                  ),
              ],

              const SizedBox(height: 16),

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
                      '${todosProvider.totalTodos} görev, %${todosProvider.completionPercentage.toStringAsFixed(0)} tamamlandı',
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

  String _getStatusText(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return 'Bekliyor';
      case TodoStatus.inProgress:
        return 'Devam Ediyor';
      case TodoStatus.completed:
        return 'Tamamlandı';
      case TodoStatus.cancelled:
        return 'İptal';
    }
  }

  Color _getStatusColor(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return Colors.grey;
      case TodoStatus.inProgress:
        return AppTheme.primaryColor;
      case TodoStatus.completed:
        return AppTheme.successColor;
      case TodoStatus.cancelled:
        return AppTheme.errorColor;
    }
  }

  String _getPriorityText(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return 'Düşük';
      case TodoPriority.medium:
        return 'Orta';
      case TodoPriority.high:
        return 'Yüksek';
      case TodoPriority.urgent:
        return 'Acil';
    }
  }

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return AppTheme.successColor;
      case TodoPriority.medium:
        return AppTheme.warningColor;
      case TodoPriority.high:
        return AppTheme.errorColor;
      case TodoPriority.urgent:
        return AppTheme.secondaryColor;
    }
  }
}
