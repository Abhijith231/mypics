import 'package:flutter/material.dart';
import 'package:mypics/providers/user.dart';
import 'package:provider/provider.dart';

import '../providers/photoprovider.dart';

class ShowImages extends StatefulWidget {
  @override
  _ShowImagesState createState() => _ShowImagesState();
}

class _ShowImagesState extends State<ShowImages> {
  Future<void> _refreshPhotos(BuildContext context) async {
    await Provider.of<PhotoProvider>(context, listen: false)
        .fetchAndSetPhotos();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<PhotoProvider>(context, listen: false).fetchAndSetPhotos();

    return Container(
      child: FutureBuilder(
        future: _refreshPhotos(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshPhotos(context),
                    child: Consumer<PhotoProvider>(
                      builder: (ctx, photodata, _) => Container(
                        child: ListView.builder(
                          itemCount: photodata.photos.length,
                          itemBuilder: (_, i) => Card(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Image.network(
                                    photodata.photos[i].imageUrl,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    photodata.photos[i].like
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                  ),
                                  onPressed: () => photodata.toggleLikePhoto(
                                      photodata.photos[i].name),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
