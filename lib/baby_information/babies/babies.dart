import 'package:baby_diary/_gen/assets.gen.dart';
import 'package:baby_diary/baby_information/babies/baby_row.dart';
import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:baby_diary/baby_information/bloc/baby_bloc.dart';
import 'package:baby_diary/baby_information/bloc/baby_event.dart';
import 'package:baby_diary/baby_information/bloc/baby_state.dart';
import 'package:baby_diary/common/base/base_app_bar.dart';
import 'package:baby_diary/common/base/base_statefull_widget.dart';
import 'package:baby_diary/common/constants/app_colors.dart';
import 'package:baby_diary/routes/route_name.dart';
import 'package:baby_diary/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Babies extends StatelessWidget {
  const Babies({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BabyBloc()..add(const LoadAllBabyEvent()),
      child: const _BabiesView(),
    );
  }
}

class _BabiesView extends BaseStatefulWidget {
  const _BabiesView();
  @override
  State<_BabiesView> createState() => _BabiesViewState();
}

class _BabiesViewState extends State<_BabiesView> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  BaseAppBar _buildAppBar(BuildContext context) {
    return BaseAppBar(
      title: '',
      hasBack: true,
      actions: [
        IconButton(
          icon: Assets.icons.add.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(AppColors.mainColor, BlendMode.srcIn)
          ),
          onPressed: () => context.goTo(RoutesName.babyDetail),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder(builder: (context, state) {
      List<BabyModel> babies = state is LoadedBabiesState ? state.babies : [];

      return CustomScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverList.builder(
              itemCount: babies.length,
              itemBuilder: (BuildContext context, int index) {
                BabyModel baby = babies[index];
                return InkWell(
                  onTap: () {
                    /// Go to baby detail
                  },
                  child: Slidable(
                    key: const ValueKey(0),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          flex: 2,
                          onPressed: (BuildContext context) {
                            context.read<BabyBloc>().add(DeleteBabyEvent(baby));
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        )
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      child: BabyRow(
                          AppColors.secondaryTextColor,
                          Colors.transparent,
                          baby:  baby
                      ),
                    ),
                  ),
                );
              }
          ),
        ],
      );
    });
  }
}
