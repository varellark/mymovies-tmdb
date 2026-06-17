import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/movie.dart';
import '../../providers/movie_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../utils/helper.dart';

class DetailPage extends StatefulWidget {
  final Movie movie;

  const DetailPage({super.key, required this.movie});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchMovieDetail(widget.movie.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieProvider>(
        builder: (context, provider, _) {
          final movie = provider.selectedMovie ?? widget.movie;
          final isLoading = provider.isLoadingDetail;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                stretch: true,
                backgroundColor: AppTheme.backgroundColor,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Consumer<FavoriteProvider>(
                    builder: (context, fav, _) {
                      final isFav = fav.isFavorite(movie.id);
                      return Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFav
                                ? AppTheme.primaryColor
                                : Colors.white,
                          ),
                          onPressed: () {
                            fav.toggleFavorite(movie);
                            Helper.showSnackBar(
                              context,
                              isFav
                                  ? 'Dihapus dari favorit'
                                  : 'Ditambahkan ke favorit ❤️',
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _BackdropImage(movie: movie),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 90,
                              height: 135,
                              child: movie.posterPath != null
                                  ? Image.network(
                                movie.fullPosterUrl,
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                color: AppTheme.surfaceColor,
                                child: const Icon(Icons.movie_outlined,
                                    color: AppTheme.textMuted),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                                ),
                                if (movie.tagline != null &&
                                    movie.tagline!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    '"${movie.tagline}"',
                                    style: const TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                _InfoChips(movie: movie, isLoading: isLoading),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: AppTheme.dividerColor, height: 1),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _RatingRow(movie: movie),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: AppTheme.dividerColor, height: 1),
                    const SizedBox(height: 20),

                    if (movie.genres != null && movie.genres!.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _GenreRow(genres: movie.genres!),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: AppTheme.dividerColor, height: 1),
                      const SizedBox(height: 20),
                    ],

                    if (movie.overview != null && movie.overview!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _OverviewSection(overview: movie.overview!),
                      ),

                    const SizedBox(height: 20),
                    const Divider(color: AppTheme.dividerColor, height: 1),
                    const SizedBox(height: 20),

                    if (!isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _DetailInfoGrid(movie: movie),
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BackdropImage extends StatelessWidget {
  final Movie movie;
  const _BackdropImage({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        movie.backdropPath != null
            ? Image.network(
          movie.fullBackdropUrl,
          fit: BoxFit.cover,
        )
            : Container(color: AppTheme.surfaceColor),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppTheme.backgroundColor.withValues(alpha: 0.8),
                AppTheme.backgroundColor,
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoChips extends StatelessWidget {
  final Movie movie;
  final bool isLoading;
  const _InfoChips({required this.movie, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        _Chip(
          icon: Icons.calendar_today_outlined,
          label: movie.year,
        ),
        if (!isLoading && movie.runtime != null)
          _Chip(
            icon: Icons.access_time_outlined,
            label: movie.runtimeFormatted,
          ),
        if (movie.originalLanguage != null)
          _Chip(
            icon: Icons.language_outlined,
            label: movie.originalLanguage!.toUpperCase(),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.textMuted, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final Movie movie;
  const _RatingRow({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RatingStat(
          value: movie.formattedRating,
          label: 'Rating',
          icon: Icons.star_rounded,
          color: Helper.ratingColor(movie.voteAverage),
        ),
        const SizedBox(width: 32),
        _RatingStat(
          value: Helper.formatNumber(movie.voteCount),
          label: 'Votes',
          icon: Icons.how_to_vote_outlined,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(width: 32),
        _RatingStat(
          value: movie.popularity.toStringAsFixed(0),
          label: 'Popularitas',
          icon: Icons.trending_up_rounded,
          color: AppTheme.secondaryColor,
        ),
      ],
    );
  }
}

class _RatingStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _RatingStat(
      {required this.value,
        required this.label,
        required this.icon,
        required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
        ),
      ],
    );
  }
}

class _GenreRow extends StatelessWidget {
  final List<Genre> genres;
  const _GenreRow({required this.genres});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Genre',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: genres
              .map(
                (g) => Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                g.name,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}

class _OverviewSection extends StatefulWidget {
  final String overview;
  const _OverviewSection({required this.overview});

  @override
  State<_OverviewSection> createState() => _OverviewSectionState();
}

class _OverviewSectionState extends State<_OverviewSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sinopsis',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedCrossFade(
          firstChild: Text(
            widget.overview,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          secondChild: Text(
            widget.overview,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          crossFadeState:
          _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        if (widget.overview.length > 200)
          TextButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
            ),
            child: Text(_expanded ? 'Sembunyikan' : 'Selengkapnya'),
          ),
      ],
    );
  }
}

class _DetailInfoGrid extends StatelessWidget {
  final Movie movie;
  const _DetailInfoGrid({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        _InfoRow(label: 'Judul Asli', value: movie.originalTitle ?? '-'),
        _InfoRow(label: 'Tanggal Rilis', value: Helper.formatDate(movie.releaseDate)),
        _InfoRow(label: 'Status', value: movie.status ?? '-'),
        if (movie.budget != null && movie.budget! > 0)
          _InfoRow(label: 'Budget', value: Helper.formatCurrency(movie.budget)),
        if (movie.revenue != null && movie.revenue! > 0)
          _InfoRow(label: 'Pendapatan', value: Helper.formatCurrency(movie.revenue)),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
