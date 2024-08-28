// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xf32>
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.abs %0 : tensor<20x20xf32>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xf32>, tensor<20x20xf32>) -> ()
    return %2 : tensor<20x20xf32>
  }
  func.func private @inputs() -> (tensor<20x20xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xBE807B3EDACEEDC0762491BF09202A40A41FA83FECB5873FDEDFDC3F784D9D4033CCC3C08EFE37BFF6DCBB3F14DC5A40A3236DC0C5AF03400EF121C087079F40D1C391BEB8B7A6C08D37E14074A108BF1D75A9BE6A1F6DBF7A65E9BF621B963E4F02FA3FEB36A04089F793401052C3BECE662BC0DC94663F8C4D094020059FBF3DD408C00F08004140E8B33F4646ED3D1814F93FA26BE8BD73FCB63F0661D8BFB4F605C0B75DC9BFAE4D1C3F061860C04778ADBCA99425BFFC053540105882BF2E9583406B46B9C0509099C089AD9940568F28C02B79ECBEC1D8443FB892573FEAFF86BF0B4A993F5E828AC053FA173F112C713F9CFD5340E8F5FFBD635220C0FD5F8EBECBD5E9BFB5371EBFEB1324C0E05B6D3FDB415240B9CC0E40BE6684BF28C5A9BF85EA19BF9A1413C00E3A384022C80B3FB134C1BEA61458408879B7BF22F1BE40653C0ABD72FD753FA5A6E5BE8136ACBF41AC19C0948CB3BF9ADC70C0FCB7D9C0B6F8C2BD2A5D20BF9841BE3DCDAD03C0531F48C0503C9A3F43BA2FC06CA517C012EF8FBCBCD833C072B82CBE3F949B40A75511419C711BBF1FF002402055F9BFFC465F40474B0BC09127B83F671313C0D10CA840A20FD03FAC48D23F8B91A1BFAC82D4405439BCBFD385A53F26FAE2BFD619104080DE1FC0ECD6B83FBD6A5C4047A47840C1F73FC02026AE40D5F79A404D6A64403B1043C018F39440361BDEBE39DAB0409A249BBEE0C97540C092EAC01BB04440591DB5C03D9634BDCFE413BEEE9E8EBF0E85EE3F8FC2083E18A81BC00C98F7BF4278B13ED885A93F8C742C40BFB6A9BFB26D37C060542D4056A08CC09E34003F36442940C2D5293E0C441F402B9CC3C0DD6DFDBFC3BFD13D04550CC0D75E5EBE6C731B400AA6073E8ED1BCBFE0DD7AC039625C3F55E390BFBC9BF33FC1C8DE3EF6DA213F1CE8734046C177C036E965BE43F215403B13C53F837B793F61B09DC06D55CDC0DEC36DC03B36FABF7A5BEA3ECE17133E9D72BDC0F026EE3FE6DF963E061324408FCE1E4075CC84C066F79F3FD5C6604068ED61BE2C32EA3F70495A3FED9095BEEC1863C0383C9CBE9D6C873F0D93414042824CC078EC1FC0B73019C08A794A3F3A0F0DC05A51A3BFB4E1AEBF91C613C01C770DC048D23F4050EC843E224014408EA3563F17A688406B5B7140647CB6C00EE5EC40B64C9F3F32A95BC0473781BFE974DDBEEC69A140050E3B406CA99ABF1EA51F40AB7F8B3DC1F2FCBFFB5E833F740E954089E5244015710D40BE3033C05E041EC098073FC049FFE43D7F871540B86A05C0DC2155C05CBD7CBF50398C3FFD6D97C02397823F7EA708409EB805C015B876C03C549FBF3AF1B1408FC130C091841040C5E8EDBEC22739BEE833B0C0A2B2A9C0FED5FFBFB93A3540180B193FDDD211BF7F87B9BEB95123C0390C8B3F0FC86F40591292C03306A2BF6956EC3F33DD59C02C831DC0585807401AFA0EBF5ACD6ABF2F8581BD0B2E0E3F94F060405EC6A34058B01DC031A11DC0AC78863EBC2C9E3F5E8A24405093FF3D0107823F557A0BBF67F492BF78BC82C058881CBF3B683E40A3E7F5C0ACEA62C00E47C3BFBE8D1A41A0E834BF7A4C87BF9D2F49BF14AEE4BF46FCC4BFF83F374040B6F4C09F697A4024F3BB40E9A08FC0B909103F7EFF1C40C758FABE08CD3640142377BF078C99C097548B40225112C068D2D9BFE1DAA240282C0E408F10D53FDD10CD3F00848540B31DD1BEAB4558C045CC79BF766DE23FE14BF03EC7AC78BF2A76623FE651C7BC2AC361C017E27E408030004057C6C340473D7A4013E19E3D57F113C0D09A1B407C9F7740708B3D3F228E42BFF6BDB740E900F9BF5DED123F2C5330BFBDD28BC08EEBD03F21A9EC403BAA74BF8549423EEF3F343F0A31243F53CA79403A334BC0D1B20DC08C4B20C0E01DB6BF7ABE6BC0A8F32E403A3BE7BE82078DC03E684D3FC6C62F3E476783409450854061D342BF7649D0BFD38F053F4E3E31BE248AC8BF9336C13FF689A940A288BA3E57F170401B1FACBE6C790DC069F763C014E012C051C08F40C8F418C0868E114056F12740B3F905407AD254BF008B99C00DF4F03DD69182401A920040E5BF663FB0E2A840C6DB82C0564107C0DE8B1F4046B14DC0414287BFB27316C06BB991C08A76D0C08618823F6B9F08C0C6CD1B40A3A73AC0B4A687BEBA77CD3D69644940D4B7A040CAD4DE3F4448E33F2737CEBF62124D40EC012EC0B031ABBF451928C00E7CA6BD"> : tensor<20x20xf32>
    return %cst : tensor<20x20xf32>
  }
  func.func private @expected() -> (tensor<20x20xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xBE807B3EDACEED407624913F09202A40A41FA83FECB5873FDEDFDC3F784D9D4033CCC3408EFE373FF6DCBB3F14DC5A40A3236D40C5AF03400EF1214087079F40D1C3913EB8B7A6408D37E14074A1083F1D75A93E6A1F6D3F7A65E93F621B963E4F02FA3FEB36A04089F793401052C33ECE662B40DC94663F8C4D094020059F3F3DD408400F08004140E8B33F4646ED3D1814F93FA26BE83D73FCB63F0661D83FB4F60540B75DC93FAE4D1C3F061860404778AD3CA994253FFC0535401058823F2E9583406B46B9405090994089AD9940568F28402B79EC3EC1D8443FB892573FEAFF863F0B4A993F5E828A4053FA173F112C713F9CFD5340E8F5FF3D63522040FD5F8E3ECBD5E93FB5371E3FEB132440E05B6D3FDB415240B9CC0E40BE66843F28C5A93F85EA193F9A1413400E3A384022C80B3FB134C13EA61458408879B73F22F1BE40653C0A3D72FD753FA5A6E53E8136AC3F41AC1940948CB33F9ADC7040FCB7D940B6F8C23D2A5D203F9841BE3DCDAD0340531F4840503C9A3F43BA2F406CA5174012EF8F3CBCD8334072B82C3E3F949B40A75511419C711B3F1FF002402055F93FFC465F40474B0B409127B83F67131340D10CA840A20FD03FAC48D23F8B91A13FAC82D4405439BC3FD385A53F26FAE23FD619104080DE1F40ECD6B83FBD6A5C4047A47840C1F73F402026AE40D5F79A404D6A64403B10434018F39440361BDE3E39DAB0409A249B3EE0C97540C092EA401BB04440591DB5403D96343DCFE4133EEE9E8E3F0E85EE3F8FC2083E18A81B400C98F73F4278B13ED885A93F8C742C40BFB6A93FB26D374060542D4056A08C409E34003F36442940C2D5293E0C441F402B9CC340DD6DFD3FC3BFD13D04550C40D75E5E3E6C731B400AA6073E8ED1BC3FE0DD7A4039625C3F55E3903FBC9BF33FC1C8DE3EF6DA213F1CE8734046C1774036E9653E43F215403B13C53F837B793F61B09D406D55CD40DEC36D403B36FA3F7A5BEA3ECE17133E9D72BD40F026EE3FE6DF963E061324408FCE1E4075CC844066F79F3FD5C6604068ED613E2C32EA3F70495A3FED90953EEC186340383C9C3E9D6C873F0D93414042824C4078EC1F40B73019408A794A3F3A0F0D405A51A33FB4E1AE3F91C613401C770D4048D23F4050EC843E224014408EA3563F17A688406B5B7140647CB6400EE5EC40B64C9F3F32A95B404737813FE974DD3EEC69A140050E3B406CA99A3F1EA51F40AB7F8B3DC1F2FC3FFB5E833F740E954089E5244015710D40BE3033405E041E4098073F4049FFE43D7F871540B86A0540DC2155405CBD7C3F50398C3FFD6D97402397823F7EA708409EB8054015B876403C549F3F3AF1B1408FC1304091841040C5E8ED3EC227393EE833B040A2B2A940FED5FF3FB93A3540180B193FDDD2113F7F87B93EB9512340390C8B3F0FC86F40591292403306A23F6956EC3F33DD59402C831D40585807401AFA0E3F5ACD6A3F2F85813D0B2E0E3F94F060405EC6A34058B01D4031A11D40AC78863EBC2C9E3F5E8A24405093FF3D0107823F557A0B3F67F4923F78BC824058881C3F3B683E40A3E7F540ACEA62400E47C33FBE8D1A41A0E8343F7A4C873F9D2F493F14AEE43F46FCC43FF83F374040B6F4409F697A4024F3BB40E9A08F40B909103F7EFF1C40C758FA3E08CD36401423773F078C994097548B402251124068D2D93FE1DAA240282C0E408F10D53FDD10CD3F00848540B31DD13EAB45584045CC793F766DE23FE14BF03EC7AC783F2A76623FE651C73C2AC3614017E27E408030004057C6C340473D7A4013E19E3D57F11340D09A1B407C9F7740708B3D3F228E423FF6BDB740E900F93F5DED123F2C53303FBDD28B408EEBD03F21A9EC403BAA743F8549423EEF3F343F0A31243F53CA79403A334B40D1B20D408C4B2040E01DB63F7ABE6B40A8F32E403A3BE73E82078D403E684D3FC6C62F3E476783409450854061D3423F7649D03FD38F053F4E3E313E248AC83F9336C13FF689A940A288BA3E57F170401B1FAC3E6C790D4069F7634014E0124051C08F40C8F41840868E114056F12740B3F905407AD2543F008B99400DF4F03DD69182401A920040E5BF663FB0E2A840C6DB824056410740DE8B1F4046B14D404142873FB27316406BB991408A76D0408618823F6B9F0840C6CD1B40A3A73A40B4A6873EBA77CD3D69644940D4B7A040CAD4DE3F4448E33F2737CE3F62124D40EC012E40B031AB3F451928400E7CA63D"> : tensor<20x20xf32>
    return %cst : tensor<20x20xf32>
  }
}