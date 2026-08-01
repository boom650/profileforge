# Flutter Shimmer, Skeleton & List Animation Patterns

## Dependencies

```yaml
dependencies:
  shimmer: ^3.0.0          # pub.dev: shimmer
  flutter_staggered_animations: ^1.1.1  # pub.dev: flutter_staggered_animations
```

---

## 1. Shimmer (Skeleton Loading) — `shimmer` package

### Basic Shimmer

```dart
import 'package:shimmer/shimmer.dart';

Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(
    width: 200,
    height: 80,
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
```

### Profile Page Skeleton

```dart
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar circle
            const CircleAvatar(radius: 50, backgroundColor: Colors.white),
            const SizedBox(height: 16),
            // Name bar
            Container(
              width: 160,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            // Email bar
            Container(
              width: 200,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 24),
            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (_) => _buildStatBlock()),
            ),
            const SizedBox(height: 24),
            // Bio lines
            ...List.generate(3, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                width: double.infinity,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBlock() {
    return Column(
      children: [
        Container(
          width: 60, height: 24,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40, height: 12,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
        ),
      ],
    );
  }
}
```

### Mission List Skeleton

```dart
class MissionListSkeleton extends StatelessWidget {
  final int itemCount;
  const MissionListSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Usage: Skeleton ↔ Content Toggle

```dart
class MissionListPage extends StatefulWidget {
  @override
  State<MissionListPage> createState() => _MissionListPageState();
}

class _MissionListPageState extends State<MissionListPage> {
  List<Mission> missions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    // simulate network
    await Future.delayed(const Duration(seconds: 2));
    missions = List.generate(10, (i) => Mission(id: i, title: 'Mission $i'));
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const MissionListSkeleton();
    return ListView.builder(
      itemCount: missions.length,
      itemBuilder: (context, i) => ListTile(title: Text(missions[i].title)),
    );
  }
}
```

---

## 2. Staggered List Animation — `flutter_staggered_animations`

```dart
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class StaggeredListView extends StatelessWidget {
  final List<String> items;
  const StaggeredListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.mission),
                    title: Text(items[index]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

### Staggered Grid

```dart
AnimationLimiter(
  child: GridView.count(
    crossAxisCount: 2,
    children: List.generate(20, (index) {
      return AnimationConfiguration.staggeredGrid(
        position: index,
        duration: const Duration(milliseconds: 375),
        columnCount: 2,
        child: ScaleAnimation(
          child: FadeInAnimation(
            child: Card(
              child: Center(child: Text('Item $index')),
            ),
          ),
        ),
      );
    }),
  ),
)
```

### Staggered Column

```dart
Column(
  children: AnimationConfiguration.toStaggeredList(
    duration: const Duration(milliseconds: 475),
    childAnimationBuilder: (widget) => SlideAnimation(
      verticalOffset: 30.0,
      child: FadeInAnimation(child: widget),
    ),
    children: items.map((item) => ListTile(title: Text(item))).toList(),
  ),
)
```

---

## 3. AnimatedList — Animate Item Add/Remove

```dart
class AnimatedListDemo extends StatefulWidget {
  @override
  State<AnimatedListDemo> createState() => _AnimatedListDemoState();
}

class _AnimatedListDemoState extends State<AnimatedListDemo> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = ['Item 0', 'Item 1', 'Item 2'];
  int _counter = 3;

  void _addItem() {
    final newItem = 'Item $_counter++';
    _counter++;
    _items.add(newItem);
    _listKey.currentState?.insertItem(
      _items.length - 1,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _removeItem(int index) {
    final removedItem = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildRemovedItem(removedItem, animation),
      duration: const Duration(milliseconds: 400),
    );
  }

  Widget _buildRemovedItem(String item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: Colors.red[100],
        child: ListTile(
          leading: const Icon(Icons.delete),
          title: Text('$item (removed)'),
        ),
      ),
    );
  }

  Widget _buildItem(String item, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          title: Text(item),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => _removeItem(index),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedList')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) =>
            _buildItem(_items[index], index, animation),
      ),
    );
  }
}
```

---

## 4. Scroll-Triggered Animations (ScrollController + AnimationController)

```dart
class ScrollAnimatedCard extends StatefulWidget {
  final String title;
  const ScrollAnimatedCard({super.key, required this.title});

  @override
  State<ScrollAnimatedCard> createState() => _ScrollAnimatedCardState();
}

class _ScrollAnimatedCardState extends State<ScrollAnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(widget.title, style: const TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}

// Usage with ScrollController
class ScrollTriggeredPage extends StatefulWidget {
  @override
  State<ScrollTriggeredPage> createState() => _ScrollTriggeredPageState();
}

class _ScrollTriggeredPageState extends State<ScrollTriggeredPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll > 0) {
        setState(() {
          _scrollProgress = (_scrollController.offset / maxScroll).clamp(0.0, 1.0);
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scroll Animations'),
        // Parallax effect on AppBar based on scroll
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: _scrollProgress),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 20,
        itemBuilder: (context, index) => ScrollAnimatedCard(
          title: 'Card $index',
        ),
      ),
    );
  }
}
```

---

## 5. Parallax Scroll Effect

```dart
class ParallaxPage extends StatelessWidget {
  const ParallaxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Parallax Header
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Parallax'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://picsum.photos/800/400',
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text('Item ${index + 1}'),
              ),
              childCount: 30,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Manual Parallax with ScrollController

```dart
class ParallaxItem extends StatefulWidget {
  final double speed; // pixels per scroll pixel
  final Widget child;
  const ParallaxItem({super.key, this.speed = 0.5, required this.child});

  @override
  State<ParallaxItem> createState() => _ParallaxItemState();
}

class _ParallaxItemState extends State<ParallaxItem> {
  double _offset = 0;

  void updateOffset(double scrollOffset) {
    setState(() {
      _offset = scrollOffset * widget.speed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, _offset),
      child: widget.child,
    );
  }
}

// Usage
class ParallaxList extends StatefulWidget {
  @override
  State<ParallaxList> createState() => _ParallaxListState();
}

class _ParallaxListState extends State<ParallaxList> {
  final ScrollController _scrollController = ScrollController();
  final List<ParallaxItem> _items = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: 10,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            // Each item gets different parallax speed
            final speed = 0.1 + (index % 3) * 0.15;
            return Transform.translate(
              offset: Offset(0, _scrollController.offset * speed),
              child: Card(
                margin: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 120,
                  child: Center(child: Text('Parallax Item $index')),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
```

---

## 6. Pull-to-Refresh with Custom Animation

```dart
class CustomRefreshDemo extends StatefulWidget {
  @override
  State<CustomRefreshDemo> createState() => _CustomRefreshDemoState();
}

class _CustomRefreshDemoState extends State<CustomRefreshDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  List<String> _items = List.generate(20, (i) => 'Item $i');

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _spinController.repeat();
    await Future.delayed(const Duration(seconds: 2));
    _spinController.stop();
    setState(() {
      _items = List.generate(20, (i) => 'Refreshed ${DateTime.now().millisecondsSinceEpoch % 1000}/$i');
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      backgroundColor: Colors.white,
      color: Colors.blue,
      strokeWidth: 3.0,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) => ListTile(
          leading: RotationTransition(
            turns: _spinController,
            child: const Icon(Icons.refresh),
          ),
          title: Text(_items[index]),
        ),
      ),
    );
  }
}
```

---

## 7. DraggableScrollableSheet (Bottom Sheet Animation)

```dart
void showCustomBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Sheet Content', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 30,
                    itemBuilder: (context, index) => ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text('Sheet Item ${index + 1}'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
```

### Full Page Bottom Sheet with AnimatedContainer

```dart
class AnimatedBottomSheet extends StatefulWidget {
  @override
  State<AnimatedBottomSheet> createState() => _AnimatedBottomSheetState();
}

class _AnimatedBottomSheetState extends State<AnimatedBottomSheet> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(child: Text('Main Content')),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            bottom: _expanded ? 0 : -280,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Expanded(
                      child: Center(child: Text('Draggable Content')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 8. Tab Bar Indicator Animation

### Custom Animated Indicator

```dart
class AnimatedTabBarPage extends StatelessWidget {
  const AnimatedTabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Animated Tab Bar'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'Missions', icon: Icon(Icons.rocket_launch)),
              Tab(text: 'Profile', icon: Icon(Icons.person)),
              Tab(text: 'Settings', icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Missions Tab')),
            Center(child: Text('Profile Tab')),
            Center(child: Text('Settings Tab')),
          ],
        ),
      ),
    );
  }
}
```

### Custom Animated Underline Indicator

```dart
class CustomTabIndicator extends StatefulWidget {
  const CustomTabIndicator({super.key});

  @override
  State<CustomTabIndicator> createState() => _CustomTabIndicatorState();
}

class _CustomTabIndicatorState extends State<CustomTabIndicator>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final tabs = ['Tab 1', 'Tab 2', 'Tab 3'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedIndex = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom animated tab row
        Row(
          children: List.generate(tabs.length, (index) {
            final isActive = _selectedIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => _tabController.animateTo(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isActive ? Colors.blue : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Text(
                    tabs[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isActive ? Colors.blue : Colors.grey,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: tabs.map((t) => Center(child: Text(t))).toList(),
          ),
        ),
      ],
    );
  }
}
```

### Gradient/Animated Tab Indicator (using BoxDecoration)

```dart
class GradientTabBar extends StatelessWidget {
  const GradientTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade400],
              ),
            ),
            child: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'One'),
                Tab(text: 'Two'),
                Tab(text: 'Three'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                Center(child: Text('Page 1')),
                Center(child: Text('Page 2')),
                Center(child: Text('Page 3')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 9. Hero Animation (Bonus — smooth page transitions)

```dart
class HeroAnimationDemo extends StatelessWidget {
  final List<String> items = ['Item 1', 'Item 2', 'Item 3'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(title: items[index])),
        ),
        child: Hero(
          tag: 'hero-$index',
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(items[index], style: const TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  const DetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final index = title.replaceAll('Item ', '');
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Hero(
          tag: 'hero-$index',
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(title, style: const TextStyle(fontSize: 32)),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 10. CrossFade / AnimatedSwitcher for View Transitions

```dart
class LoadingToContentTransition extends StatefulWidget {
  @override
  State<LoadingToContentTransition> createState() => _LoadingToContentTransitionState();
}

class _LoadingToContentTransitionState extends State<LoadingToContentTransition> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () => setState(() => _loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: _loading
          ? const SizedBox(
              key: ValueKey('loading'),
              width: double.infinity,
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            )
          : const SizedBox(
              key: ValueKey('content'),
              width: double.infinity,
              height: 200,
              child: Center(child: Text('Content Loaded!')),
            ),
    );
  }
}
```

---

## Package Summary

| Pattern | Package/SDK | Key Widget |
|---|---|---|
| Skeleton loading | `shimmer` 3.0.0 | `Shimmer.fromColors()` |
| Staggered list animations | `flutter_staggered_animations` 1.1.1 | `AnimationConfiguration.staggeredList()` |
| Animated list add/remove | Flutter SDK | `AnimatedList` |
| Scroll-triggered | Flutter SDK | `ScrollController` + `AnimationController` |
| Parallax | Flutter SDK | `CustomScrollView` + `SliverAppBar` |
| Pull-to-refresh | Flutter SDK | `RefreshIndicator` |
| Bottom sheet | Flutter SDK | `DraggableScrollableSheet` |
| Tab indicator | Flutter SDK | `TabBar` + `AnimatedContainer` |
| Page transitions | Flutter SDK | `Hero` |
| View transitions | Flutter SDK | `AnimatedSwitcher` |
