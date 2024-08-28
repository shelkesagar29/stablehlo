// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<4x2x3x5xui32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[0, 4]> : tensor<2xi64>
    %0:2 = call @inputs() : () -> (tensor<4x2x3x5xui32>, tensor<4x3xui32>)
    %1 = call @expected() : () -> tensor<4x2x3x5xui32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1, 3], scatter_dims_to_operand_dims = [1, 3]>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<ui32>, %arg1: tensor<ui32>):
      %3 = stablehlo.maximum %arg0, %arg1 : tensor<ui32>
      stablehlo.return %3 : tensor<ui32>
    }) : (tensor<4x2x3x5xui32>, tensor<2xi64>, tensor<4x3xui32>) -> tensor<4x2x3x5xui32>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<4x2x3x5xui32>, tensor<4x2x3x5xui32>) -> ()
    return %2 : tensor<4x2x3x5xui32>
  }
  func.func private @inputs() -> (tensor<4x2x3x5xui32> {mhlo.layout_mode = "default"}, tensor<4x3xui32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x000000000200000001000000010000000200000003000000020000000400000001000000060000000100000004000000010000000000000003000000000000000100000005000000020000000100000002000000030000000300000007000000010000000300000005000000030000000000000000000000040000000000000006000000000000000400000001000000040000000100000000000000010000000000000003000000010000000000000001000000020000000100000002000000020000000000000001000000030000000200000001000000020000000200000000000000010000000000000004000000000000000300000001000000000000000200000006000000010000000100000002000000020000000000000004000000000000000000000001000000000000000200000000000000080000000100000001000000020000000400000002000000020000000300000000000000060000000100000000000000000000000200000002000000000000000000000001000000030000000200000001000000000000000100000002000000070000000000000000000000010000000300000001000000000000000300000000000000000000000000000001000000000000000200000000000000010000000000000001000000"> : tensor<4x2x3x5xui32>
    %c_0 = stablehlo.constant dense<[[3, 4, 1], [0, 0, 1], [1, 2, 4], [1, 1, 0]]> : tensor<4x3xui32>
    return %c, %c_0 : tensor<4x2x3x5xui32>, tensor<4x3xui32>
  }
  func.func private @expected() -> (tensor<4x2x3x5xui32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x000000000200000001000000010000000300000003000000020000000400000001000000060000000100000004000000010000000000000003000000000000000100000005000000020000000100000002000000030000000300000007000000010000000300000005000000030000000000000000000000040000000000000006000000000000000400000001000000040000000100000000000000010000000000000003000000010000000000000001000000020000000100000002000000020000000000000001000000030000000200000001000000020000000200000000000000010000000000000004000000000000000300000001000000000000000200000006000000010000000100000002000000020000000000000004000000000000000000000004000000000000000200000000000000080000000100000001000000020000000400000002000000020000000300000000000000060000000100000000000000000000000200000002000000000000000100000001000000030000000200000001000000010000000100000002000000070000000000000000000000010000000300000001000000000000000300000000000000000000000000000001000000000000000200000000000000010000000000000001000000"> : tensor<4x2x3x5xui32>
    return %c : tensor<4x2x3x5xui32>
  }
}