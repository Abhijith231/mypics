import 'package:flutter/material.dart';
import 'package:mypics/constants.dart';
import 'package:mypics/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

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
                        child: photodata.photos.length == 0
                            ? Center(
                                child: Text('No Photos'),
                              )
                            : ListView.builder(
                                itemCount: photodata.photos.length,
                                itemBuilder: (_, i) => Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color2.withAlpha(16),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: SizedBox(
                                          height: 300,
                                          child: BlurHash(
                                            hash: photodata.photos[i].blurhash,
                                            image: photodata.photos[i].imageUrl,
                                            imageFit: BoxFit.contain,
                                            duration: Duration(seconds: 3),
                                            curve: Curves.easeOut,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: IconButton(
                                          icon: Icon(
                                            photodata.photos[i].like
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              photodata.toggleLikePhoto(
                                                  photodata.photos[i].name),
                                        ),
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
