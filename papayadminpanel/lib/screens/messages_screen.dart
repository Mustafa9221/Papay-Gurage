import 'package:flutter/material.dart';
import 'package:papayadminpanel/MongoDb/messagesHelper.dart';


class MessagesScreen extends StatefulWidget{
  final trackingId;
  const MessagesScreen({super.key,required this.trackingId});
  
  @override   
  State<MessagesScreen> createState() => _MessagesScreenState();
}
class _MessagesScreenState extends State<MessagesScreen> {
  final _message = TextEditingController();
  final messageHelper = Messageshelper();
  List<dynamic> _messages = []; // Store messages here
  bool _loading = true;
  String? _error;
  final _scrollController = ScrollController();

  Future fetchMessages() async {
    final response = await messageHelper.fetchMessages(trackingId: widget.trackingId);
    if (response[0]) {
      setState(() {
        _messages = response[1];
        _loading = false;
        _error = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
      scrolltoBottom();
    });
    } else {
      setState(() {
        _error = "Something went wrong";
        _loading = false;
      });
    }
  }

  scrolltoBottom(){
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    super.initState();
    fetchMessages(); // Call once
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chat"),
        backgroundColor: const Color(0xFF191A23),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : _messages.isEmpty
                        ? Center(child: Text('No messages found'))
                        : ListView.builder(
                          controller: _scrollController,
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final msg = _messages[index];
                              return Container(
                                alignment: msg["author"] == "admin"
                                    ? Alignment.topLeft
                                    : Alignment.topRight,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: msg["author"] == "admin"
                                        ? Colors.black
                                        : Colors.green,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        msg["message"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: msg["author"] == "admin"
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        setTimeStamp(msg["timestamp"]),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          color: msg["author"] == "admin"
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(child: MessagesField()),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final message = _message.text;
                      _message.clear();
                      final response = await messageHelper.sendMessage(
                        message: message,
                        trackingId: widget.trackingId,
                      );
                      if (response[0]) {
                        setState(() {
                          _messages.add(response[1]); 
                          WidgetsBinding.instance.addPostFrameCallback((_) {
      scrolltoBottom();
    });
                        });
                      }
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget MessagesField() {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: _message,
        decoration: InputDecoration(
          hintText: "Type...",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  String setTimeStamp(String data) {
    final list = data.split(":");
    return list[1] + ":" + list[2].split("Z")[0];
  }
}
