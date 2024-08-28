// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<5x6x7xui16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi64>
    %0:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<5x2x2xui16>)
    %1 = call @expected() : () -> tensor<5x6x7xui16>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %3 = stablehlo.add %arg0, %arg1 : tensor<ui16>
      stablehlo.return %3 : tensor<ui16>
    }) : (tensor<5x6x7xui16>, tensor<2x2x2xi64>, tensor<5x2x2xui16>) -> tensor<5x6x7xui16>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> ()
    return %2 : tensor<5x6x7xui16>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16> {mhlo.layout_mode = "default"}, tensor<5x2x2xui16> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x000003000100020001000400020002000600060001000200010001000100000001000200020002000200010000000200010000000100020001000000050006000000060001000000010000000300030002000400030000000300040002000000060000000500030007000500030004000400040001000000000000000100010000000000010000000600010000000100010000000300000000000200010000000200020004000000040002000100000004000500000002000500000001000100000001000000010000000200030002000100000003000300020001000300000002000100010002000000050003000300010001000100000001000100000002000400040002000100010002000900040004000400010007000000030005000300000002000100030001000200020001000200030002000300020005000200010000000100050005000500040000000100000002000100040000000300000003000000020001000000000001000100020004000200010002000400010001000000000000000200050000000000030001000100030004000000000001000100000003000000"> : tensor<5x6x7xui16>
    %c_0 = stablehlo.constant dense<[[[0, 0], [1, 4]], [[5, 1], [0, 4]], [[0, 0], [0, 0]], [[2, 1], [2, 0]], [[2, 0], [1, 1]]]> : tensor<5x2x2xui16>
    return %c, %c_0 : tensor<5x6x7xui16>, tensor<5x2x2xui16>
  }
  func.func private @expected() -> (tensor<5x6x7xui16> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x0000030001000200010004000200020006000A0001000200010001000100000001000200020002000200010000000200010000000100020002000000050006000000060001000000010000000300030002000400030005000300040002000000060000000500070007000500030004000400040001000100000000000100010000000000010000000600010000000100010000000300000000000200010000000200020004000000040002000100000004000500000002000500000001000100000001000000010000000200030002000100000003000300020001000300000002000100010002000000050003000300010001000100000001000100000004000400040002000100010002000900040004000400010007000000030005000400000002000100030001000200020001000200030004000300020005000200010000000100050005000500040000000100000004000100040000000300000003000000030001000000000001000100020004000200010002000400010001000000000000000200050001000000030001000100030004000000000001000100000003000000"> : tensor<5x6x7xui16>
    return %c : tensor<5x6x7xui16>
  }
}