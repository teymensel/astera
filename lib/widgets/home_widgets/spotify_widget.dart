import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/spotify_provider.dart';
import '../../utils/app_theme.dart';

class SpotifyWidget extends StatelessWidget {
  const SpotifyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SpotifyProvider>(
      builder: (context, spotifyProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.music_note,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Spotify',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: spotifyProvider.isConnected
                            ? AppTheme.successColor
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        spotifyProvider.isConnected ? 'Bağlı' : 'Bağlı Değil',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                if (!spotifyProvider.isConnected) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.music_off,
                          size: 40,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Spotify\'a bağlanın',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Müzik dinlemek ve paylaşmak için',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            spotifyProvider.connectToSpotify();
                          },
                          child: const Text('Bağlan'),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Şu an çalan şarkı
                  if (spotifyProvider.isPlaying && spotifyProvider.currentTrackName != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Şu An Çalan',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            spotifyProvider.currentTrackName!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            spotifyProvider.currentArtist ?? 'Bilinmeyen Sanatçı',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  spotifyProvider.togglePlayPause();
                                },
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.skip_next,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  spotifyProvider.skipNext();
                                },
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  spotifyProvider.isShuffling
                                      ? Icons.shuffle
                                      : Icons.shuffle,
                                  color: spotifyProvider.isShuffling
                                      ? Colors.white
                                      : Colors.white70,
                                ),
                                onPressed: () {
                                  spotifyProvider.toggleShuffle();
                                },
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  spotifyProvider.isRepeating
                                      ? Icons.repeat
                                      : Icons.repeat,
                                  color: spotifyProvider.isRepeating
                                      ? Colors.white
                                      : Colors.white70,
                                ),
                                onPressed: () {
                                  spotifyProvider.toggleRepeat();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Son çalınanlar
                  if (spotifyProvider.recentTracks.isNotEmpty) ...[
                    const Text(
                      'Son Çalınanlar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: spotifyProvider.recentTracks.take(5).length,
                        itemBuilder: (context, index) {
                          final track = spotifyProvider.recentTracks[index];
                          return Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: track['imageUrl'] != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            track['imageUrl'],
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(Icons.music_note),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  track['name'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
