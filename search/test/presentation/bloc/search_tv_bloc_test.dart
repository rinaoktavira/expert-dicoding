import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv_entities.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tv.dart';
import 'package:search/presentation/bloc/tv/search_tv_bloc.dart';

import 'search_tv_bloc_test_mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late SearchTvBloc searchtvBloc;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTv();
    searchtvBloc = SearchTvBloc(mockSearchTv);
  });

  final tTvModel = Tv(
    backdropPath: '/mUkuc2wyV9dHLG0D0Loaw5pO2s8.jpg',
    genreIds: const [10765, 10759, 18],
    id: 1399,
    originalName: 'Game of Thrones',
    overview:
        "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
    popularity: 29.780826,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2011-04-17',
    name: 'Game of Thrones',
    voteAverage: 7.91,
    voteCount: 1172,
  );
  final tTvList = <Tv>[tTvModel];
  const tQuery = 'game';

  blocTest<SearchTvBloc, SearchTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      return searchtvBloc;
    },
    act: (bloc) => bloc.add(const TvOnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvLoading(),
      SearchTvHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockSearchTv.execute(tQuery));
    },
  );

  blocTest<SearchTvBloc, SearchTvState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchtvBloc;
    },
    act: (bloc) => bloc.add(const TvOnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvLoading(),
      const SearchTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTv.execute(tQuery));
    },
  );

  test('initial state should be empty', () {
    expect(searchtvBloc.state, SearchTvEmpty());
  });
}
