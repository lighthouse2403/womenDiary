import 'package:women_diary/chat/component/new_thread.dart';
import 'package:women_diary/chat/component/thread_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/chat/bloc/chat_bloc.dart';
import 'package:women_diary/chat/bloc/chat_event.dart';
import 'package:women_diary/chat/bloc/chat_state.dart';
import 'package:women_diary/common/admob_handle.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/base/base_statefull_widget.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/common/firebase/firebase_chat.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

class Chat extends BaseStatefulWidget {
  const Chat({super.key});
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends BaseStatefulState<Chat> {
  final ScrollController _controller = ScrollController();
  final double _endReachedThreshold = 30;
  bool _loading = false;
  ChatBloc chatBloc = ChatBloc();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    chatBloc.add(const LoadThreads());
  }

  void _onScroll() {
    if (!_controller.hasClients || _loading) return;

    final shouldReload = _controller.position.extentAfter < _endReachedThreshold;
    bool isNotFull = chatBloc.threads.length >= FirebaseChat.instance.threadLimit;
    if (shouldReload && !_loading && isNotFull) {
      _loading = true;
      chatBloc.add(const LoadThreads());
    }
  }

  @override
  PreferredSizeWidget? buildAppBar() {
    return BaseAppBar(
      backgroundColor: AppColors.pinkTextColor,
      title: '💞 Giao lưu',
    );
  }

  @override
  Widget? buildBody() {
    return BlocProvider(
      create: (context) => chatBloc,
      child: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is LoadingState) {
            loadingView.show(context);
          } else if (state is LoadingSuccessfulState) {
            setState(() => _loading = false);
            loadingView.hide();
          }
        },
        child: Stack(
          children: [
            CustomScrollView(
              controller: _controller,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: _refresh,
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final thread = chatBloc.threads[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            AdsHelper.showAds(dismiss: () {
                              context.navigateTo(
                                RoutesName.chatDetail,
                                arguments: thread,
                              ).then((value) => chatBloc.add(const LoadThreads()));
                            });
                          },
                          child: ThreadRow(thread: thread),
                        );
                      },
                      childCount: chatBloc.threads.length,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: FirebaseChat.instance.threadLimit > chatBloc.threads.length
                        ? const SizedBox()
                        : const Center(
                      child: CupertinoActivityIndicator(
                        radius: 14,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: AppColors.pinkTextColor,
                onPressed: () {
                  context.navigateTo(RoutesName.newChat)
                      .then((res) => chatBloc.add(const LoadThreads()));
                },
                child: const Icon(Icons.add_comment, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    FirebaseChat.instance.threadLimit = 0;
    chatBloc.add(const LoadThreads());
  }
}
