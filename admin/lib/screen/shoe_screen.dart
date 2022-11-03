import 'dart:io';

import 'package:admin/bloc/shoe/shoe_bloc.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_validator/form_validator.dart';
import 'package:formz/formz.dart';

class ShoeScreen extends StatefulWidget{
  const ShoeScreen({super.key});

  @override
  State<ShoeScreen> createState() => _ShoeScreenState();
}

class _ShoeScreenState extends State<ShoeScreen> {
  final _formKey = GlobalKey<FormState>();
  late SingleValueDropDownController _brand;
  late TextEditingController _title;
  late TextEditingController _description;
  late TextEditingController _price;
  List<int> sizes = <int>[];
  List<String> colors = <String>[];

  List<String> brandList = [
    "Adidas",
    "Nike",
    "Puma",
    "New Balance",
    "Reebok",
    "Jordan",
  ];

  List<int> sizesList = [
    38,
    39,
    40,
    41,
    42,
  ];

  List<String> colorList = [
    "0xFF00FFFF",
    "0xFF000000",
    "0xFF0000FF",
    "0xFFff00ff",
    "0xFF808080",
    "0xFF008000",
    "0xFFff0000",
    "0xFFffff00",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _brand = SingleValueDropDownController();
    _title = TextEditingController();
    _description = TextEditingController(text: "viverra vitae congue eu consequat ac felis donec et odio pellente");
    _price = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _brand.dispose();
    _title.dispose();
    _description.dispose();
    _price.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _shoeView(context),
    );
  }

  Widget _shoeView(BuildContext context){
    return BlocListener<ShoeBloc, ShoeState>(
      listener: (context, state){
        if(state.status.isSubmissionFailure){
          EasyLoading.dismiss();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message ?? "Error"))
            );
        }
        if(state.status.isSubmissionSuccess){
          EasyLoading.dismiss();
          Navigator.pop(context);
        }
        if(state.status.isSubmissionInProgress){
          EasyLoading.show(status: "Adding...",);
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _formShoe(context),
                _addButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formShoe(BuildContext context){
    return Expanded(
      child: ListView(
        children: [
          _brandForm(),
          const SizedBox(height: 10,),
          _imageForm(context),
          const SizedBox(height: 10,),
          _titleForm(),
          const SizedBox(height: 10,),
          _descriptionForm(),
          const SizedBox(height: 10,),
          _priceForm(),
          const SizedBox(height: 10,),
          _sizeForm(context),
          const SizedBox(height: 10,),
          _colorForm(context),
        ],
      ),
    );
  }

  Widget _brandForm(){
    return DropDownTextField(
      controller: _brand,
      validator: ValidationBuilder().build(),
      textFieldDecoration: const InputDecoration(
        labelText: "Brand"
      ),
      dropDownList: _brandDropDown(),
      dropDownItemCount: 2,
    );
  }

  List<DropDownValueModel> _brandDropDown() {
    List<DropDownValueModel> brands = [];

    for (var brand in brandList) {
      brands.add(
          DropDownValueModel(
            name: brand,
            value: brand,
          )
      );
    }

    return brands;
  }

  Widget _imageForm(BuildContext context){
    return BlocBuilder<ShoeBloc, ShoeState>(
      builder: (context, state){
        return Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black)
          ),
          child: GestureDetector(
            onTap: (){
              BlocProvider.of<ShoeBloc>(context).add(ShoeImage());
            },
            child: _isHaveImage(state),
          ),
        );
      },
    );
  }

  Widget _isHaveImage(ShoeState state){
    if(state.image == null){
      return const Center(
        child: Icon(Icons.upload),
      );
    }else{
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: FileImage(File(state.image!)),
              fit: BoxFit.cover
            )
        ),
      );
    }
  }

  Widget _titleForm(){
    return TextFormField(
      controller: _title,
      decoration: const InputDecoration(
        labelText: "Title"
      ),
      keyboardType: TextInputType.name,
      validator: ValidationBuilder().build(),
    );
  }

  Widget _descriptionForm(){
    return TextFormField(
      controller: _description,
      decoration: const InputDecoration(
          labelText: "Description"
      ),
      keyboardType: TextInputType.multiline,
      maxLines: 4,
      validator: ValidationBuilder().build(),
    );
  }

  Widget _priceForm(){
    return TextFormField(
      controller: _price,
      decoration: const InputDecoration(
          labelText: "Price"
      ),
      keyboardType: TextInputType.number,
      validator: ValidationBuilder().build(),
    );
  }

  Widget _sizeForm(BuildContext context){
    return Wrap(
      children: _buildChipSize(context),
    );
  }

  List<Widget> _buildChipSize(BuildContext context) {
    List<Widget> choices = [];

    for (var size in sizesList) {
      choices.add(
          ChoiceChip(
            label: Text(size.toString()),
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: sizes.contains(size) ? Colors.white : Colors.black),
            selected: sizes.contains(size),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            labelPadding: const EdgeInsets.symmetric(vertical: 10),
            selectedColor: Colors.blue,
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.black),
            onSelected: (selected) {
              if(selected){
                setState(() {
                  sizes.add(size);
                });
              }else{
                setState(() {
                  sizes.remove(size);
                });
              }
            },
          )
      );
    }

    return choices;
  }

  Widget _colorForm(BuildContext context){
    return Wrap(
      children: _buildChipColor(context),
    );
  }

  List<Widget> _buildChipColor(BuildContext context){
    List<Widget> widget = [];

    for (var color in colorList) {
      widget.add(
          Container(
            margin: EdgeInsets.only(left: colorList.indexOf(color) == 0 ? 0 : 8),
            child: InkWell(
              onTap: (){
                if(colors.contains(color)){
                  setState(() {
                    colors.remove(color);
                  });
                }else{
                  setState(() {
                    colors.add(color);
                  });
                }
              },
              borderRadius: BorderRadius.circular(200),
              child: CircleAvatar(
                  backgroundColor: Color(int.parse(color)),
                  child: colors.contains(color)
                      ? _selectedShoeColor()
                      : const SizedBox()
              ),
            ),
          )
      );
    }

    return widget;
  }

  Widget _selectedShoeColor(){
    return const Center(
      child: Icon(Icons.check, color: Colors.white,),
    );
  }

  Widget _addButton(BuildContext context){
    return BlocBuilder<ShoeBloc, ShoeState>(
      builder: (context, state){
        return SizedBox(
          width: double.infinity,
          height: 35,
          child: ElevatedButton(
            onPressed: (){
              if(_formKey.currentState!.validate()){
                BlocProvider.of<ShoeBloc>(context).add(ShoeAdded(_brand.dropDownValue!.name, state.image!, _title.text, _description.text, int.parse(_price.text), sizes, colors));
              }
            },
            child: const Text("Add"),
          ),
        );
      },
    );
  }
}