import 'package:core/presentation/bloc/tv_bloc/popular_tv/popular_tv_bloc.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const POPULAR_TV = '/popular-tv';

  const PopularTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<PopularTvSeriesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<PopularTvSeriesBloc>().add(OnPopularTvCalled()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TvSeries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvSeriesBloc, PopularTvState>(
          builder: (context, state) {
            if (state is PopularTvLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTvHasData) {
              final tvSeries = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = tvSeries[index];
                  return TvCard(tv);
                },
                itemCount: tvSeries.length,
              );
            } else {
              return Center(
                key: const Key('error_msg'),
                child: Text((state as PopularTvError).message),
              );
            }
          },
        ),
      ),
    );
  }
}
