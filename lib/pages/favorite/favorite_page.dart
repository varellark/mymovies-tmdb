import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/movie_card.dart';

class FavoritePage extends StatefulWidget {
  final bool embedded;

  const FavoritePage({super.key, this.embedded = false});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Saya'),
        automaticallyImplyLeading: !widget.embedded,
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, fav, _) {
              if (fav.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: 'Hapus semua favorit',
                onPressed: () => _confirmClearAll(context, fav),
              );
            },
          ),
        ],
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favProvider, _) {
          if (favProvider.isEmpty) {
            return const _EmptyFavorite();
          }

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.favorite_rounded,
                        color: AppTheme.primaryColor, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${favProvider.count} film tersimpan',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: favProvider.favorites.length,
                  itemBuilder: (context, index) {
                    final movie = favProvider.favorites[index];
                    return Dismissible(
                      key: Key('fav_${movie.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline_rounded,
                                color: AppTheme.primaryColor),
                            SizedBox(height: 4),
                            Text(
                              'Hapus',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (_) {
                        favProvider.removeFavorite(movie.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${movie.title} dihapus dari favorit'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.all(12),
                            action: SnackBarAction(
                              label: 'BATAL',
                              onPressed: () => favProvider.addFavorite(movie),
                            ),
                          ),
                        );
                      },
                      child: MovieListTile(
                        movie: movie,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.detail,
                          arguments: movie,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmClearAll(BuildContext context, FavoriteProvider fav) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus Semua Favorit?',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Semua film di daftar favorit akan dihapus. Aksi ini tidak bisa dibatalkan.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              fav.clearAll();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );
  }
}

class _EmptyFavorite extends StatelessWidget {
  const _EmptyFavorite();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              color: AppTheme.surfaceColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              color: AppTheme.primaryColor.withValues(alpha: 0.5),
              size: 52,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum ada film favorit',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap ikon ❤️ di film mana saja\nuntuk menambahkannya ke sini',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(
                context, AppRoutes.home),
            icon: const Icon(Icons.explore_outlined),
            label: const Text('Jelajahi Film'),
          ),
        ],
      ),
    );
  }
}
