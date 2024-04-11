import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/application.dart';
import '../../../core/style/assets.dart';
import '../../../core/style/style.dart';
import '../../routes/app_router.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(application.translate('allSongs').toUpperCase()),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              SvgAssets.search,
              colorFilter:
                  const ColorFilter.mode(Style.secondary, BlendMode.srcIn),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          final isSelected = index == 4;
          return ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Song $index',
                style: Style.mainFont.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Text('Artist $index', style: Style.mainFont.bodySmall),
            trailing: Text('3:00', style: Style.mainFont.bodySmall),
            leading: CircleAvatar(
              backgroundColor: isSelected ? Style.primary : Style.secondary,
              radius: 17,
              child: SvgPicture.asset(
                isSelected ? SvgAssets.pause : SvgAssets.play,
                colorFilter: ColorFilter.mode(
                  isSelected ? Style.secondary : Style.primary,
                  BlendMode.srcIn,
                ),
                height: 12,
              ),
            ),
            selectedTileColor: Style.secondary.withOpacity(0.1),
            selected: isSelected,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
            onTap: () {
              application.appRouter.push(const PlayerRoute());
            },
          );
        },
      ),
    );
  }
}
