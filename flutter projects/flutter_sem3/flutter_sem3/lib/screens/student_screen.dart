import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/student_model.dart';
import '../providers/student_provider.dart';
import '../utils/message.dart';

class StudentScreen extends ConsumerStatefulWidget {
  const StudentScreen({super.key});

  @override
  ConsumerState<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends ConsumerState<StudentScreen> {
  bool _showButton = false;
  final _scroller = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroller.addListener(() {
      final shouldShow = _scroller.position.pixels >= 500;
      if (shouldShow != _showButton) {
        setState(() => _showButton = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _showButton ? _buildFloating() : null,
    );
  }

  AppBar _buildAppBar() => AppBar(
        title: const Text('Student Screen'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/add'),
            icon: const Icon(Icons.person_add),
          ),
        ],
      );

  Widget _buildBody() {
    final studentAsync = ref.watch(studentNotifierProvider);
    return Center(
      child: RefreshIndicator(
        onRefresh: () => ref.read(studentNotifierProvider.notifier).refresh(),
        child: studentAsync.when(
          data: _buildGridView,
          error: (e, s) {
            debugPrint('Error: $e');
            debugPrint('StackTrace: $s');
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 200),
                Center(child: Text('Error: $e')),
              ],
            );
          },
          loading: _buildSkeleton,
        ),
      ),
    );
  }

  Widget _buildFloating() {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () {
        _scroller.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: const Icon(Icons.arrow_upward),
    );
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      child: GridView.builder(
        itemCount: 40,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
        ),
        itemBuilder: (context, index) {
          return const Card(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Loading student',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView(List<StudentModel> items) {
    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 200),
          Center(child: Text('No Students')),
        ],
      );
    }

    return GridView.builder(
      controller: _scroller,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 1,
      ),
      itemBuilder: (context, index) => _buildItem(items[index]),
    );
  }

  Widget _buildItem(StudentModel item) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              item.fullName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_buildDeleteIconButton(item)],
          ),
        ],
      ),
    );
  }

  IconButton _buildDeleteIconButton(StudentModel item) {
    return IconButton(
      onPressed: () => _deleteStudent(item),
      icon: const Icon(Icons.delete),
    );
  }

  Future<void> _deleteStudent(StudentModel item) async {
    final confirmed = await showDeleteDialog(context) ?? false;
    if (!mounted || !confirmed) return;

    try {
      await ref.read(studentNotifierProvider.notifier).delete(item.id);
      if (!mounted) return;
      showMessage(context, 'Student deleted successfully');
    } catch (e, s) {
      debugPrint('Deleting error: $e');
      debugPrint('StackTrace: $s');
      if (!mounted) return;
      showMessage(context, 'Student deleted failed');
    }
  }
}
