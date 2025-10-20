import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_3/infoCard.dart';

void main() {
  runApp(BlocProvider(create: (_) => DictionaryCubit(), child: my_App()));
}

class my_App extends StatefulWidget {
  my_App();

  @override
  State<my_App> createState() => _my_AppState();
}

class _my_AppState extends State<my_App> {
  //هنا عرفنا الاوبجيكت حق الكونترولير
  final TextEditingController textController = TextEditingController();

  //الاسترنق اللي بنص الشاشه
  String textt = "One language, thousands of meanings... start exploring now!";

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DictionaryCubit>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 31, 3, 58),
        appBar: AppBar(
          centerTitle: true,
          //هذي عندها التيكست سبان وداخل التيكست سبان اقدر احد شليدرين منها واخزن فيها اكثر من تيكست
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 252, 251, 248),
              ),
              children: [
                TextSpan(
                  text: "Hash Plas",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 124, 43, 255),
                    shadows: [
                      Shadow(
                        color: Color.fromARGB(255, 54, 150, 246),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                TextSpan(text: "  "),
                TextSpan(
                  text: "Dictionary",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    shadows: [
                      Shadow(
                        color: const Color.fromARGB(255, 77, 186, 254),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(width: 10),
            Icon(
              Icons.favorite_border_rounded,
              color: const Color.fromARGB(255, 123, 70, 247),
            ),
          ],
          backgroundColor: const Color.fromARGB(255, 37, 4, 68),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            //عشان نسوي الفيلد اللي بنبحث منه
            child: Column(
              children: [
                SizedBox(height: 12),
                TextField(
                  style: TextStyle(
                    color: const Color.fromARGB(255, 204, 168, 239),
                  ),
                  //اللي بيتغير الفنكشن اللي من نوع سترنق
                  onChanged: (String value) async {
                    await cubit.getWord(value);
                  },
                  //يتحكم بالنص لما اكتب نص يطلعلي تحت يعني يتحكم بالتيكست فيلد ونوعها object
                  controller: textController,
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(255, 106, 47, 146),
                    //تلميح
                    hintText: "Palese Enter Anything..",
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 144, 134, 147),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                
                //infoCard(),
                // Container
                SizedBox(height: 100),

                //النص اللي بنص الصفحه
                BlocBuilder<DictionaryCubit, BaseState>(
                  builder: (_, state) {
                    if (state is loudingState) {
                      return CircularProgressIndicator();
                    } else if (state is intialState) {
                      return Text(
                        'One language, thousands of meanings... start exploring now!',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 223, 175, 251),
                        ),
                      );
                    }
                    if (state is SucssesState) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            infoCard(title: "Word", value: state.word),
                            SizedBox(height: 10),
                            infoCard(title: "Meaning", value: state.meaning),
                            SizedBox(height: 10),

                            infoCard(title: "example", value: state.example),
                          ],
                        ),
                      );
                    } else if (state is FaulireState) {
                      return Text(
                        state.errorMassage,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 196, 7, 7),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Search a word to get started.",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 167, 123, 242),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//بنسوي كلاسات للحالات جلب البيانات والحاله الرئيسيه هي انها تكون انيشيال ابتدائيه
class BaseState {}

class SucssesState extends BaseState {
  final String word;
  final String meaning;
  final String example;
  SucssesState(this.word, this.meaning, this.example);
}

class intialState extends BaseState {}

class loudingState extends BaseState {}

class FaulireState extends BaseState {
  final String errorMassage;
  FaulireState(this.errorMassage);
}

//بسوي الكيوبت عشان يحدث الحاله باستخدام السيت ستيت
class DictionaryCubit extends Cubit<BaseState> {
  DictionaryCubit() : super(intialState());

  //حملنا البكج هذا وسوينا منه نسخه عشان نستعمله في التراي والكاتش
  Future<void> getWord(String word) async {
    if (word.trim().isEmpty) {
      emit(FaulireState('رجاءً أدخل كلمة قبل البحث.'));
      return;
    }

    emit(loudingState());
    //ذحين بنتخدم الاوبجيكت بالAPI بطريقة قيت
    Dio _dio = Dio();

    //dioهي اللي بتكلم ال API
    //استحدم الاويت ولازم معاها اليسنك لان بقوله انتظر البيانات اللي بتجي بالمستقبل لان ممكن تتاخر معايا
    try {
      final response = await _dio.get(
        "https://api.dictionaryapi.dev/api/v2/entries/en/$word",
      );
      final data = response.data[0];
      final meaning =
          data["meanings"]?[0]?["definitions"]?[0]?["definition"] ??
          "No meaning found";
      final example =
          data["meanings"]?[0]?["definitions"]?[0]?["example"] ??
          "No example available.";
      emit(SucssesState(word, meaning, example));
    } catch (e) {
      emit(
        FaulireState(
          'عذرًا، لم نتمكن من تحميل المعلومات حاليًا. تأكد من اتصالك بالإنترنت أو حاول مجددًا لاحقًا.',
        ),
      );
    }

    //معلومه عن الفاينل انها تستدل النوع البيانات بدون ما اكتب نوع للوكال فاريبال
    //ممكن وانا بحمل البيانات يطلع لي غلط فا رح استعمل التراي والكاتش على المتغير الفاينل
  }
}
