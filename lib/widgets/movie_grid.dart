import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_theme.dart';
import 'movie_card.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final String? emptyMessage;
  final ScrollController? scrollController;

  const MovieGrid({
    super.key,
    required this.movies,
    this.isLoading = false,
    this.hasMore = false,
    this.onLoadMore,
    this.emptyMessage,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && movies.isEmpty) {
      return const _GridShimmer();
    }

    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.movie_filter_outlined,
                color: AppTheme.textMuted, size: 64),
            const SizedBox(height: 16),
            Text(
              emptyMessage ?? 'Tidak ada movie ditemukan',
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.52,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == movies.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onLoadMore?.call();
          });
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
                strokeWidth: 2,
              ),
            ),
          );
        }

        final movie = movies[index];
        return MovieCard(
          movie: movie,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.detail,
            arguments: movie,
          ),
        );
      },
    );
  }
}

class MovieHorizontalList extends StatelessWidget {
  final List<Movie> movies;
  final bool isLoading;
  final double height;

  const MovieHorizontalList({
    super.key,
    required this.movies,
    this.isLoading = false,
    this.height = 240,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, __) => _ShimmerCard(height: height),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return SizedBox(
            width: height * 0.65,
            child: MovieCard(
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
    );
  }
}

class _GridShimmer extends StatelessWidget {
  const _GridShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.52,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const _ShimmerCard(),
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  final double? height;
  const _ShimmerCard({this.height});

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor.withValues(alpha: _anim.value + 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: AppTheme.cardColor.withValues(alpha: _anim.value + 0.2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    height: 12,
                    width: double.infinity,
                    color: AppTheme.dividerColor.withValues(alpha: _anim.value + 0.2),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: 60,
                    color: AppTheme.dividerColor.withValues(alpha: _anim.value),
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
