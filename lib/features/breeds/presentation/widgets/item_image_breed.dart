import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/image_breed.dart';
import '../pages/detail_breed_page.dart';

class ItemImageBreed extends StatelessWidget {
  final ImageBreed images;
  const ItemImageBreed({super.key, required this.images});

  @override
  Widget build(BuildContext context) => RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();

          context.push('/reedDetail',
              extra: DetailBreedPageParams(imageBreed: images));
        },
        child: Stack(
          children: [
            Hero(
              tag: images.id,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    maxHeightDiskCache: 400,
                    width: double.infinity,
                    key: PageStorageKey(images.id),
                    imageUrl: images.url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                        height: 200,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: 25,
              child: _buildTextContainer(images.breed.first.name),
            ),
            Positioned(
              bottom: 15,
              left: 25,
              child:
                  _buildTextContainer(images.breed.first.origin ?? 'No origin'),
            ),
            Positioned(
              bottom: 15,
              right: 25,
              child: _buildTextContainer(
                  'Intelligence: ${images.breed.first.intelligence}'),
            ),
          ],
        ),
      ),
    );

  Widget _buildTextContainer(String text) => Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
}
