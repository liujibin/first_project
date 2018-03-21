import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "demo app",
      home: new RandomWords()
    );

  }

}



class RandomWords extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords>{

  final _suggestions = <WordPair>[];
  final _fontSize = new TextStyle(fontSize: 16.0);
  final _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Welcome to flutter"),
          actions: <Widget>[new IconButton(icon: new Icon(Icons.list), onPressed: _pushNavi)],
        ),
        body:  _buildSuggestions()
    );
  }

  Widget _buildSuggestions(){
    _suggestions.addAll(generateWordPairs().take(20));
    return new ListView.builder(
        itemBuilder: (context,i){
          if(i.isOdd){return new Divider();}//如果i是奇数，就添加分割线，如果是偶数，才添加带数据的row
          final index = i ~/ 2;//效果和整除差不多，i为0、1、2、3、4、5...，算到的index为0、0、1、1、2、2...
          //index的计算，主要是因为插入了分割线以后，迭代器迭代的次数是原来的双倍，一半是渲染分割线，一半是渲染带数据的row
          if(index < _suggestions.length){
            return _buildRow(_suggestions[index]);
          }
        }
    );
  }

  Widget _buildRow(WordPair pair){
    final aleardySaved = _saved.contains(pair);//判断是否包含当前单词，判断是否被赞
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _fontSize,
      ),
      trailing: new Icon(
        aleardySaved ? Icons.favorite : Icons.favorite_border,
        color: aleardySaved ? Colors.red:null,
      ),
      onTap: () => _favourite(pair),
    );
  }

  void _favourite(WordPair pair){
    setState((){
      if(_saved.contains(pair)){
        _saved.remove(pair);
      }else{
        _saved.add(pair);
      }
    });
  }

  void _pushNavi(){
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder:(context){
              final tils = _saved.map((pair){
                return new ListTile(
                  title: new Text(
                    pair.asPascalCase,
                    style: _fontSize,
                  ),
                );
              });
              final divids = ListTile.divideTiles(context:context,tiles: tils).toList();
              return new Scaffold(
                appBar: new AppBar(
                  title: new Text("Welcome to new page"),
                ),
                body: new ListView(children: divids,)
              );
            })
    );
  }

}