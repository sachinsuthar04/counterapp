import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:counterapp/config/config.dart';
import 'package:counterapp/modules/bloc/counter/counter_bloc.dart';
import 'package:counterapp/modules/bloc/success/success_bloc.dart';
import 'package:counterapp/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final CountDownController _controller = CountDownController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(child: Text(widget.title)),
        elevation: 1.0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Listeners
            MultiBlocListener(
              listeners: [
                BlocListener<CounterBloc, CounterState>(
                  listener: (context, state) {
                    if (state is CounterInitial) {
                      if (state.match) {
                        BlocProvider.of<SuccessBloc>(context)
                            .add(SuccessCallEvent());
                        CustomSnackbar.pushSnackbar(context, "Congratulations");
                      } else {
                        BlocProvider.of<SuccessBloc>(context)
                            .add(FailAttemptCallEvent());
                      }
                    }
                  },
                ),
                BlocListener<SuccessBloc, SuccessState>(
                  listenWhen: (previous, current) {
                    if (previous is SuccessInitial &&
                        current is SuccessInitial) {
                      return (previous.successCounter != 0 ||
                          previous.penalty > 0);
                    } else {
                      return true;
                    }
                  },
                  listener: (context, state) {
                    if (state is SuccessInitial && state.successCounter == 0) {
                      CustomSnackbar.pushSnackbar(context, "Game is now reset");
                    }
                    if (state is SuccessInitial && state.penalty > 0) {
                      CustomSnackbar.pushSnackbar(context,
                          "Sorry timeout and one attempt is considered as penalty with total attempts.. \n Your penalty is : ${state.penalty}");
                    }
                  },
                ),
              ],
              child: const SizedBox.shrink(),
            ),

            const SizedBox(
              height: 10,
            ),
            //current second & random number
            Flexible(
              child: Row(
                children: [
                  // generator
                  Flexible(
                    child: Container(
                      height: 80,
                      margin: const EdgeInsets.all(8.0).copyWith(left: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.blueAccent),
                        color: Colors.blueAccent.withOpacity(.2),
                      ),
                      child: Center(
                        child: BlocBuilder<CounterBloc, CounterState>(
                          builder: (context, state) {
                            if (state is CounterInitial && state.time != null) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Current Second",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    state.time!.second.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  // spacing
                  const SizedBox(width: 8.0),

                  // generated number
                  Flexible(
                    child: Container(
                      height: 80,
                      margin: const EdgeInsets.all(8.0).copyWith(left: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.black),
                        color: Colors.purple.withOpacity(.2),
                      ),
                      child: Center(
                        child: BlocBuilder<CounterBloc, CounterState>(
                          builder: (context, state) {
                            if (state is CounterInitial &&
                                state.randomNumber != null) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Random Number",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    state.randomNumber!.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            // Message Banner
            Flexible(
              child: BlocBuilder<SuccessBloc, SuccessState>(
                builder: (context, state) {
                  if (state is SuccessInitial) {
                    return Container(
                      height: 150,
                      margin: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: state.successCounter == 0
                            ? Colors.amber
                            : Colors.green,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (state.successCounter > 0 &&
                                        state.successCounter <
                                            Config.winningScore)
                                    ? "Success :) \n${_getMessage(state.successCounter, state.attempts)}"
                                    : "Sorry Try Again !\n ${_getMessage(state.successCounter, state.attempts)}",
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              BlocBuilder<CounterBloc, CounterState>(
                                builder: (context, state) {
                                  if (state is CounterInitial) {
                                    if (state.match) {
                                      return Text(
                                        "+1 Score",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      );
                                    } else {
                                      return Text(
                                        "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      );
                                    }
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            CircularCountDownTimer(
              duration: 5,
              initialDuration: 0,
              controller: _controller,
              width: 100,
              height: 100,
              ringColor: Colors.grey[300]!,
              ringGradient: null,
              fillColor: Colors.tealAccent[100]!,
              fillGradient: null,
              backgroundColor: Colors.tealAccent[500],
              backgroundGradient: null,
              strokeWidth: 10.0,
              strokeCap: StrokeCap.round,
              textStyle: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
              textFormat: CountdownTextFormat.MM_SS,
              isReverse: true,
              isReverseAnimation: true,
              isTimerTextShown: true,
              autoStart: false,
              onStart: () {
                debugPrint('Countdown Started');
              },
              onComplete: () {
                BlocProvider.of<SuccessBloc>(context).add(PenaltyCallEvent());
                debugPrint('Countdown Ended');
              },
              onChange: (String timeStamp) {
                debugPrint('Countdown Changed $timeStamp');
              },
              timeFormatterFunction: (defaultFormatterFunction, duration) {
                if (duration.inSeconds == 0) {
                  return "0:00";
                } else {
                  return Function.apply(defaultFormatterFunction, [duration]);
                }
              },
            ),
            const SizedBox(
              height: 50,
            ),
            Flexible(
              child: BlocBuilder<SuccessBloc, SuccessState>(
                builder: (context, state) {
                  if (state is SuccessInitial) {
                    return GestureDetector(
                      onTap: () {
                        if (state.successCounter >= Config.winningScore) {
                          // ask to reset
                          CustomSnackbar.pushSnackbar(
                            context,
                            'You already won the game.\nPlease reset it to continue',
                            error: true,
                          );
                        } else {
                          _controller.start();
                          // generate random number
                          BlocProvider.of<CounterBloc>(context)
                              .add(GenerateRandomNumber());
                        }
                      },
                      child: Container(
                        width: 130,
                        height: 50,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: state.successCounter >= Config.winningScore
                              ? Colors.grey
                              : Colors.blueAccent,
                        ),
                        child: Center(
                          child: Text(
                            "Click",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<SuccessBloc, SuccessState>(
        builder: (context, state) {
          if (state is SuccessInitial &&
              state.successCounter >= Config.winningScore) {
            return FloatingActionButton(
              onPressed: () {
                BlocProvider.of<SuccessBloc>(context).add(ResetCallEvent());
              },
              child: const Icon(Icons.restore),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  String _getMessage(int successCounter, int attempts) {
    if (successCounter == 0) {
      return "Attempts : $attempts";
    } else if (successCounter < Config.winningScore) {
      return 'Score :  $successCounter';
    } else {
      return 'Congratulations!\nYou won the game!';
    }
  }
}
