import 'package:flutter/material.dart';
import 'package:ta_chegando/styles/text.dart';

class OnibusPage extends StatelessWidget {
  const OnibusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Pesquisar ônibus:",
                  style: TituloBranco(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 16),
                child: TextField(
                  cursorColor: Theme.of(context).backgroundColor,
                  cursorRadius: const Radius.circular(20),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                    hintText: "Ex: Vila Mariana ou 917H",
                    hintStyle: TextStyle(fontSize: 16),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) => print(value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
