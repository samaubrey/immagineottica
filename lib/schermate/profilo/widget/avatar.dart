import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../util/costanti.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });

  final String? imageUrl;
  final void Function(String) onUpload;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ElevatedButton(
              onPressed: _isLoading ? null : _upload,
              //child: const Text('Carica immagine \npersonale',),
              child: Icon(Icons.add,size: 30,),
            style: ElevatedButton.styleFrom(shape: CircleBorder())
          ),
          SizedBox(width: 45,)
        ],),
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
          Container(
            width: 150,
            height: 150,
            color: Colors.grey,
            child: const Center(
              child: Text('Nessuna immagine'),
            ),
          )
        else
          CircleAvatar(radius: 90,
          backgroundImage: NetworkImage(widget.imageUrl!),),
      ],
    );
  }

  Future<void> _upload() async {
    final _picker = ImagePicker();
    final imageFile = await _picker.pickImage( source: ImageSource.gallery,
  maxWidth: 300, maxHeight: 300 );
    if (imageFile == null) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      await supabase.storage.from('avatars').uploadBinary(filePath, bytes,
    fileOptions: FileOptions(contentType: imageFile.mimeType));
      final imageUrlResponse = await supabase.storage.from('avatars')
    .createSignedUrl(filePath, 60*60*24*365*10);
      widget.onUpload(imageUrlResponse);
    }
    on StorageException catch (error){
      if(mounted){
        context.showErrorSnackBar(message: 'Si è verificato un errore'
            'imprevisto.\nDettagli: ${error.message}');
      }
    }

    setState(() => _isLoading = false);
  }
}
