import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'call_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final FocusNode _messageFocusNode = FocusNode();
  
  final List<Map<String, dynamic>> _messages = [
    {"text": "Hi There excited for the ride", "isMe": true},
    {"text": "Welcome to a wonderful experience", "isMe": false},
    {"text": "Thanks For Letting Me In", "isMe": true},
  ];

  @override
  void initState() {
    super.initState();
    _messageFocusNode.addListener(() {
      if (_messageFocusNode.hasFocus) {
        _sheetController.animateTo(
          0.7 ,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          "text": _messageController.text.trim(),
          "isMe": true,
        });
      });
      _messageController.clear();
      
      // Auto-scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _sheetController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Map Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/map.png",
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.6),
            ),
          ),
          _buildMapOverlay(),
          // Top Action Buttons
           SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'RIDEN',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.audiowide(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600.withOpacity(0.82),
                      height: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Top Row: Greeting
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_back,
                                      color: Colors.black, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.25),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white24, width: 1),
                            ),
                            child: const Icon(Icons.notifications_none_outlined,
                                color: Colors.white, size: 20),
                          ),
                          Positioned(
                            right: 2,
                            top: 2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Sheet (Draggable to 80% on focus)
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.65,
            minChildSize: 0.4,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF030408),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage("assets/images/profile.png"), 
                            backgroundColor: Colors.white24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              "Sergio Fernandez", 
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                               Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen()));
                            },
                            child: const Icon(Icons.phone, color: Colors.blue, size: 24),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.white12),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController, // Use the sheet's controller for internal scrolling
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageBubble(
                            _messages[index]["text"], 
                            isMe: _messages[index]["isMe"]
                          );
                        },
                      ),
                    ),
                    _buildMessageInput(context),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapOverlay() {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
             top: 250,
             left: 100,
             child: CustomPaint(
                size: const Size(200, 100),
                painter: RoutePainterChat(),
             ),
          ),
          Positioned(
            top: 240,
            left: 90,
            child: Transform.rotate(
              angle: -0.2, // rotate right
              child: Image.asset("assets/images/car.png", width: 40, height: 20, fit: BoxFit.contain, color: Colors.white),
            ),
          ),
          Positioned(
             top: 200,
             left: 60,
             child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
               decoration: BoxDecoration(
                 color: Colors.white.withOpacity(0.9),
                 borderRadius: BorderRadius.circular(8),
               ),
               child: Text(
                 "5 min away", 
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
                 style: GoogleFonts.poppins(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
               ),
             ),
          ),
          Positioned(
            top: 330,
            left: 280,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, {required bool isMe}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF16325B) : const Color(0xFF10192A),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 20, right: 20, top: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.emoji_emotions_outlined, color: Colors.blue, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _messageController,
                focusNode: _messageFocusNode,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Type your message",
                  hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: const Icon(Icons.send_rounded, color: Colors.blue, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class RoutePainterChat extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    Path path = Path();
    path.moveTo(0, 0); 
    path.lineTo(size.width * 0.9, size.height * 0.3);
    path.lineTo(size.width * 0.9, size.height * 0.8);
    path.lineTo(size.width - 15, size.height);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
