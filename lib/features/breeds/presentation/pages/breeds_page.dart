import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/view_state.dart';
import '../../domain/entities/image_breed.dart';
import '../providers/breeds_provider.dart';
import '../widgets/filter_breeds.dart';
import '../widgets/item_image_breed.dart';
import '../widgets/title_cat_breeds.dart';

class BreedsPage extends StatefulWidget {
  const BreedsPage({super.key});

  @override
  State<BreedsPage> createState() => _BreedsPageState();
}

class _BreedsPageState extends State<BreedsPage> {
  List<ImageBreed> _listImageBreed = [];
  int page = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(() {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent) {
          _nextDataPage();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BreedsProvider>(context);
    _listImageBreed = provider.listImageBreed;
    return ModalProgressHUD(
      inAsyncCall: provider.state is Loading,
      child: Scaffold(
        appBar: AppBar(
          title: const TitleCatBreeds(),
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Expanded(
                  child: _listImages(_listImageBreed, provider),
                )
              ],
            ),
            const FilterBreeds(),
          ],
        ),
      ),
    );
  }

  Widget _listImages(List<ImageBreed> images, BreedsProvider provider) {
    if (provider.state is Loaded && images.isEmpty) {
      return const Center(child: Text('Breeds not found'));
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return ItemImageBreed(images: images[index]);
      },
    );
  }

  Future<void> _nextDataPage() async {
    final provider = context.read<BreedsProvider>();
    if (provider.state is Loading) return;
    page = page + 1;

    final res = await provider.getListImagesBreeds(page: page);
    if (res == 0) return;
    _scrollController.animateTo(
      _scrollController.offset + 10.0,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    );
  }
}
