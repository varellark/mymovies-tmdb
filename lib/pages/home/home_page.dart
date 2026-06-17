import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/movie_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/movie_grid.dart';
import '../../widgets/movie_card.dart';
import '../search/search_page.dart';
import '../favorite/favorite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _HomeContent(),
    SearchPage(embedded: true),
    FavoritePage(embedded: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search_rounded),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Consumer<FavoriteProvider>(
              builder: (_, fav, __) => Badge(
                isLabelVisible: fav.isNotEmpty,
                label: Text('${fav.count}'),
                child: const Icon(Icons.favorite_border_rounded),
              ),
            ),
            activeIcon: Consumer<FavoriteProvider>(
              builder: (_, fav, __) => Badge(
                isLabelVisible: fav.isNotEmpty,
                label: Text('${fav.count}'),
                child: const Icon(Icons.favorite_rounded),
              ),
            ),
            label: 'Favorit',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollCtrl = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    _scrollCtrl.addListener(_onScroll);
  }

  void _loadData() {
    final provider = context.read<MovieProvider>();
    if (provider.nowPlaying.isEmpty) provider.fetchNowPlaying();
    if (provider.popular.isEmpty) provider.fetchPopular();
    if (provider.upcoming.isEmpty) provider.fetchUpcoming();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      context.read<MovieProvider>().fetchPopular();
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'My',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: 'Movies',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, _) {
          if (provider.error != null) {
            return _ErrorWidget(
              error: provider.error!,
              onRetry: () {
                provider.clearError();
                _loadData();
              },
            );
          }

          return RefreshIndicator(
            color: AppTheme.primaryColor,
            onRefresh: () async {
              await Future.wait([
                provider.fetchNowPlaying(refresh: true),
                provider.fetchPopular(refresh: true),
                provider.fetchUpcoming(),
              ]);
            },
            child: CustomScrollView(
              controller: _scrollCtrl,
              slivers: [
                const _SectionHeader(
                  title: 'Sedang Tayang',
                  subtitle: 'Update terbaru bioskop',
                ),
                SliverToBoxAdapter(
                  child: MovieHorizontalList(
                    movies: provider.nowPlaying,
                    isLoading: provider.isLoadingNowPlaying,
                    height: 250,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                const _SectionHeader(
                  title: 'Segera Tayang',
                  subtitle: 'Coming soon ke bioskopmu',
                ),
                SliverToBoxAdapter(
                  child: MovieHorizontalList(
                    movies: provider.upcoming,
                    isLoading: provider.isLoadingUpcoming,
                    height: 210,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                const _SectionHeader(
                  title: 'Populer',
                  subtitle: 'Movie terpopuler saat ini',
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: SliverGrid(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.52,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        if (index == provider.popular.length) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryColor,
                              strokeWidth: 2,
                            ),
                          );
                        }
                        final movie = provider.popular[index];
                        return MovieCard(
                          movie: movie,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.detail,
                            arguments: movie,
                          ),
                        );
                      },
                      childCount: provider.popular.length +
                          (provider.isLoadingPopular &&
                              provider.popular.isNotEmpty
                              ? 1
                              : 0),
                    ),
                  ),
                ),

                if (provider.isLoadingPopular && provider.popular.isEmpty)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeader({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded,
                color: AppTheme.textMuted, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat data',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
