import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/todos_provider.dart';
import '../../models/todo_data.dart';
import '../../utils/app_theme.dart';
import '../../widgets/todos_widgets/todo_card.dart';
import '../../widgets/todos_widgets/todo_editor.dart';
import '../../widgets/todos_widgets/todo_filters.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
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
        title: const Text('Yapılacaklar'),
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
              _showTodoEditor(context);
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
                hintText: 'Yapılacaklarda ara...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<TodosProvider>().updateSearchQuery('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                context.read<TodosProvider>().updateSearchQuery(value);
              },
            ),
          ),

          // Filtreler
          if (_showFilters) const TodoFilters(),

          // İstatistikler
          _buildStats(),

          // Todo listesi
          Expanded(
            child: Consumer<TodosProvider>(
              builder: (context, todosProvider, child) {
                final todos = todosProvider.todos;

                if (todos.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return TodoCard(
                      todo: todo,
                      onTap: () => _showTodoEditor(context, todo: todo),
                      onEdit: () => _showTodoEditor(context, todo: todo),
                      onToggle: () => _toggleTodo(todo),
                      onDelete: () => _showDeleteDialog(context, todo),
                      onShare: () => _showShareDialog(context, todo),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTodoEditor(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStats() {
    return Consumer<TodosProvider>(
      builder: (context, todosProvider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Toplam',
                  '${todosProvider.totalTodos}',
                  Icons.list,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Tamamlanan',
                  '${todosProvider.completedTodos}',
                  Icons.check_circle,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Bekleyen',
                  '${todosProvider.pendingTodos}',
                  Icons.pending,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Geciken',
                  '${todosProvider.overdueTodos}',
                  Icons.warning,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz yapılacak yok',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'İlk görevinizi oluşturmak için + butonuna tıklayın',
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showTodoEditor(BuildContext context, {TodoData? todo}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TodoEditor(
        todo: todo,
        onSave: (todo) {
          if (todo.id.isEmpty) {
            // Yeni todo
            final newTodo = todo.copyWith(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              createdAt: DateTime.now(),
            );
            context.read<TodosProvider>().addTodo(newTodo);
          } else {
            // Mevcut todo'yu güncelle
            context.read<TodosProvider>().updateTodo(todo);
          }
        },
      ),
    );
  }

  void _toggleTodo(TodoData todo) {
    final newStatus = todo.status == TodoStatus.completed
        ? TodoStatus.pending
        : TodoStatus.completed;
    context.read<TodosProvider>().updateTodoStatus(todo.id, newStatus);
  }

  void _showDeleteDialog(BuildContext context, TodoData todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Görevi Sil'),
        content: Text('${todo.title} görevini silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TodosProvider>().deleteTodo(todo.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Görev silindi'),
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

  void _showShareDialog(BuildContext context, TodoData todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Görevi Paylaş'),
        content: Text('${todo.title} görevini sevgilinizle paylaşmak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Burada partner ID'si alınacak
              context.read<TodosProvider>().shareTodo(todo.id, 'partner_id');
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Görev paylaşıldı'),
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
