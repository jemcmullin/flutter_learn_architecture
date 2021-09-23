import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learn_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: BlocProvider<NumberTriviaBloc>(
        create: (context) => getIt<NumberTriviaBloc>(),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            //Text Display
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Placeholder(),
            ),
            const SizedBox(
              height: 20,
            ),
            //User Input
            Column(
              children: [
                //InputBox
                Placeholder(
                  fallbackHeight: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Button for concrete
                    Placeholder(
                      fallbackHeight: 50,
                      fallbackWidth: 150,
                    ),
                    //Button for random
                    Placeholder(
                      fallbackHeight: 50,
                      fallbackWidth: 150,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
