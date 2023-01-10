import 'dart:typed_data';

import 'package:ab_smartly/internal/hashing/hashing.dart';
import 'package:ab_smartly/internal/variant_assigner.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test('chooseVariant', ()
  {
    expect(VariantAssigner.chooseVariant([0.0, 1.0], 0.0), equals(1));
    expect(VariantAssigner.chooseVariant([0.0, 1.0], 0.5), equals(1));
    expect(VariantAssigner.chooseVariant([0.0, 1.0], 1.0), equals(1));

    expect(VariantAssigner.chooseVariant([1.0, 0.0], 0.0), equals(0));
    expect(VariantAssigner.chooseVariant([1.0, 0.0], 0.5), equals(0));
    expect(VariantAssigner.chooseVariant([1.0, 0.0], 1.0), equals(1));

    expect(VariantAssigner.chooseVariant([0.5, 0.5], 0.0), equals(0));
    expect(VariantAssigner.chooseVariant([0.5, 0.5], 0.25), equals(0));
    expect(VariantAssigner.chooseVariant([0.5, 0.5], 0.49999999), equals(0));
    expect(VariantAssigner.chooseVariant([0.5, 0.5], 0.5), equals(1));
    expect(VariantAssigner.chooseVariant([0.5, 0.5], 0.50000001), equals(1));
    expect(VariantAssigner.chooseVariant([0.5, 0.5], 0.75), equals(1));
    expect(VariantAssigner.chooseVariant([0.5, 0.5], 1.0), equals(1));

    expect(
        VariantAssigner.chooseVariant([0.333, 0.333, 0.334], 0.0), equals(0));
    expect(
        VariantAssigner.chooseVariant([0.333, 0.333, 0.334], 0.25), equals(0));
    expect(VariantAssigner.chooseVariant([0.333, 0.333, 0.334], 0.33299999),
        equals(0));
    expect(
        VariantAssigner.chooseVariant([0.333, 0.333, 0.334], 0.333), equals(1));
    expect(VariantAssigner.chooseVariant([0.333, 0.333, 0.334], 0.33300001),
        equals(1));
    expect(
        VariantAssigner.chooseVariant([0.333, 0.333, 0.334], 0.5), equals(1));
    expect(VariantAssigner.chooseVariant([0.333, 0.333, 0.334], 0.66599999),
        equals(1));
    expect(
        VariantAssigner.chooseVariant([0.333, 0.333, 0.334], 0.666), equals(2));

    expect(
        VariantAssigner.chooseVariant([0.333, 0.333, 0.334], 0.66600001), equals(2));
    expect(
        VariantAssigner.chooseVariant([0.333, 0.333, 0.334], 0.75), equals(2));
    expect(
        VariantAssigner.chooseVariant([0.333, 0.333, 0.334], 1.0), equals(2));
    expect(
        VariantAssigner.chooseVariant([0.0, 1.0], 0.0), equals(1));
    expect(
        VariantAssigner.chooseVariant([0.0, 1.0], 1.0), equals(1));
  });



  test('testAssignmentsMatch', (){

    Map<dynamic, dynamic> data = {
      123456789 : [1, 0, 1, 1, 1, 0, 0, 2, 1, 2, 2, 2, 0, 0],
      "bleh@absmartly.com" : [0, 1, 0, 0, 0, 0, 1, 0, 2, 0, 0, 0, 1, 1],
      "e791e240fcd3df7d238cfc285f475e8152fcc0ec" : [1, 0, 1, 1, 0, 0, 0, 2, 0, 2, 1, 0, 0, 1],
    };

    data.forEach((key, value) {

      var unitUID = key;
      var expectedVariants = value;
      final List<List<double>> splits = [
        [0.5, 0.5],
        [0.5, 0.5],
        [0.5, 0.5],
        [0.5, 0.5],
        [0.5, 0.5],
        [0.5, 0.5],
        [0.5, 0.5],
        [0.33, 0.33, 0.34],
        [0.33, 0.33, 0.34],
        [0.33, 0.33, 0.34],
        [0.33, 0.33, 0.34],
        [0.33, 0.33, 0.34],
        [0.33, 0.33, 0.34],
        [0.33, 0.33, 0.3],
      ];

      final List<List<int>> seeds = [
        [0x00000000, 0x00000000],
        [0x00000000, 0x00000001],
        [0x8015406f, 0x7ef49b98],
        [0x3b2e7d90, 0xca87df4d],
        [0x52c1f657, 0xd248bb2e],
        [0x865a84d0, 0xaa22d41a],
        [0x27d1dc86, 0x845461b9],
        [0x00000000, 0x00000000],
        [0x00000000, 0x00000001],
        [0x8015406f, 0x7ef49b98],
        [0x3b2e7d90, 0xca87df4d],
        [0x52c1f657, 0xd248bb2e],
        [0x865a84d0, 0xaa22d41a],
        [0x27d1dc86, 0x845461b9]];

      final List<int> unitHash = Hashing.hashUnit(unitUID.toString());
      final VariantAssigner assigner = VariantAssigner(Uint8List.fromList(unitHash));
      for (int i = 0; i < seeds.length; ++i) {
        final List<int> frags = seeds[i];
        final List<double> split = splits[i];
        final int variant = assigner.assign(split, frags[0], frags[1]);
        assert(expectedVariants[i] == variant);
      }
    });
  });
}

