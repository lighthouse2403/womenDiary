import 'package:baby_diary/knowledge/bloc/knowledge_bloc.dart';
import 'package:baby_diary/knowledge/bloc/knowledge_state.dart';
import 'package:baby_diary/knowledge/components/heart_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baby_diary/common/base/base_statefull_widget.dart';
import 'package:baby_diary/routes/route_name.dart';
import 'package:baby_diary/routes/routes.dart';

class Knowledge extends BaseStatefulWidget {
  const Knowledge({super.key});

  @override
  State<Knowledge> createState() => _KnowledgeState();
}

class _KnowledgeState extends BaseStatefulState<Knowledge> {
  KnowledgeBloc knowledgeBloc = KnowledgeBloc();

  @override
  Widget? buildBody() {
    return BlocProvider(
        create: (context) => knowledgeBloc,
        child: BlocListener<KnowledgeBloc, KnowledgeState> (
            listener: (context, state) {
              if (state is LoadingKnowledgeSuccessfullyState) {
                setState(() {
                });
              }
            },
            child: InkWell(
              onTap: () {
                context.navigateTo(RoutesName.knowledgeDetail).then((value) {
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/pregnancy_backgroound_3.jpg'),
                      fit: BoxFit.cover
                  ),
                ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: SafeArea(
                        child: Container(
                            height: 260.0,
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                HeartIndicator(),
                                const SizedBox(width: 20),
                              ],
                            )
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 20,
                      ),
                    )
                  ],
                ),
              ),
            )
        )
    );
  }
}
