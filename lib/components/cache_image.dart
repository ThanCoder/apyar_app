import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final VoidCallback? onTap;
  final BoxFit? fit;
  const CacheImage({super.key, required this.url, this.onTap, this.fit});

  static String getCachePath(String url) => PathUtil.getCachePath(
    name: '${url.getName().replaceAll('/', '-').replaceAll(':', '-')}.png',
  );

  @override
  Widget build(BuildContext context) {
    return TCacheImage(url: url, fit: fit ?? BoxFit.contain);
    // return CachedNetworkImage(
    //   imageUrl: url,
    //   fit: fit,
    //   errorWidget: (context, url, error) =>
    //       Center(child: Text('Error: `$url`')),
    //   progressIndicatorBuilder: (context, url, progress) => Center(
    //     child: SizedBox(
    //       width: 70,
    //       height: 70,
    //       child: CircularProgressIndicator(value: progress.progress),
    //     ),
    //   ),
    // );
  }
}

// class _CacheImageState extends State<CacheImage> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onSecondaryTap: _deleteCache,
//       onLongPress: _deleteCache,
//       onTap: widget.onTap,
//       child: _getWidget(),
//     );
//   }

//   Widget _getWidget() {
//     if (CacheImageSettingListTile.isUseCacheImage) {
//       final cacheFile = File(
//         TWidgets.instance.getCachePath?.call(widget.url) ?? '',
//       );
//       if (cacheFile.existsSync()) {
//         return TImageFile(path: cacheFile.path, errorBuilder: _errorBuilder);
//       }
//       return FutureBuilder(
//         future: TWidgets.instance.onDownloadImage?.call(
//           widget.url,
//           cacheFile.path,
//         ),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return TLoader.random();
//           }
//           return TImageFile(path: cacheFile.path, errorBuilder: _errorBuilder);
//         },
//       );
//     }
//     return TImage(source: widget.url);
//   }

//   void _deleteCache() {
//     final file = File(CacheImage.getCachePath(widget.url));
//     if (!file.existsSync()) return;

//     showTConfirmDialog(
//       context,
//       contentText: 'Image Cache ကိုဖျက်ချင်တာ သေချာပြီလား?',
//       submitText: 'Delete Cache',
//       onSubmit: () async {
//         await file.delete();
//         await ThanPkg.appUtil.clearImageCache();
//         if (!mounted) return;
//         setState(() {});
//       },
//     );
//   }

//   Widget _errorBuilder(
//     BuildContext context,
//     Object error,
//     StackTrace? stackTrace,
//   ) {
//     return TImage(source: widget.url);
//   }
// }
