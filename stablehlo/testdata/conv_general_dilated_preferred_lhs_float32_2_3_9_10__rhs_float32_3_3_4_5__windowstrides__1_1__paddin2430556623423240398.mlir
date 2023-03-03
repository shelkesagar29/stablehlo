// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>)
    %1 = call @expected() : () -> tensor<2x3x6x6xf32>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) -> tensor<2x3x6x6xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x6x6xf32>, tensor<2x3x6x6xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) {
    %0 = stablehlo.constant dense<"0xE483A23E2F1E4A3F235378C056550340493AD8BF4017A0BFB974AFBE0528273FF70C9EBF742F9840F4A6733D1BFEB440393120C0E35FCC3EBA7CE2BF9F4202408D3405BFF01F093FAECB3CC05AB8EABEE5C446C09D87DCBFD4CDDD3FEC3D27BF397454C0CCF78D402F8271C0A5977BBF03A8C140A41C0E3F160D343E3054E7BEBF8029C0A87BCF3FCA3A4FC0050C3C400DD20D403AE732C021631DC06D4C8FC0FD245940EB5C8EBDBD1B4EBF88C28CC0568E1AC0AAA889409741FDBF1941A33F9BFE95C018AECAC0258088BF90EA8AC01BFC55BF8DFF96401C38953F55E145C0DFA7793F07265FC0608BCC3FF4E852C041B082C066BB163EAE704C3ED9D2F6BE735861C0F4706AC07E4E0BC067760840087A86C09DFE0EC0BB3F7E3FA6BCC5BEF02741C023B99EC0B70E0540636E0541B8C342C05FE34C403B1507C156BA663F33D8F0BDC361443EBDEF11C036E01040767EE04007F546404678CDBF063455BC91A887BE52DFBCBF7B720FBFAE83AC3E37A96340FFE0A4BF86B90A4091A137BF1EC3193FAE600EC0A3E044C05DC121BEF62CE5BFBA7654C09210313FDF23D3C07196FABF45D718C08B677BC074D545C04CE6E1404A135AC0435C25BFEF138DBEAAACF840D1428840426EF3BED053B0BF5FC3CD40EC2600C05D7C62C0C0890DBF1130E63FB428853F7FAFA3404985CCBF9BE229BE70B395BD5D7BD5C03F29953F56B72F404113A9BF9B2802BFC1C1CFBFBFE8ADBF1C5BF43F3438DBC090B2993F8CD81EC0B519AC40B9F249BE51DBEABF387483C01E9104409DA7083FF9B4DA406FCEA1BE6BC9AB3FFC27E6C0395E35C0205788C0FD595E402C50593F34A20BC092E83C402788BA3F937E4FBE1DD9E0BDBB881E3F622DA3C05D3BDC40CFD698BF7D8DA1401CE95740E0FD1940164E84C0B372A63F355B1E3FAEB34C401877C23FFD0F0340ADA9D63F2350AA40BA05A3BF07D02B4078C2A940BF9886BE9744B2C0624BDBBFC31382BF8933CABEB821EFBF64C67B3E9D6D26C0D82ED0BFEC8E0140632CA83EE22C534085131A3FE0DDE2BF04568ABFCD0186C031753740B1BC7B3FB055533F824904C0CDE9B1C0F37A1D40A896C0BFE68EC9BF6494A8BF3346E33FF67019402CEF65BF58D371408D9642C0310E1740FCC11EC02BC8EA3F9C4A794000154FBF0FC55540EE4984BE7B27A2C0ED387CBFEF41463EBD9DE33E629A23C034235CC00DA8F03FB48FCD3F724CABBFF17F21C0E167973B68E93CC010349AC0768E0EBFDF1EE93F833DB740A4B39DC03CF623C01C1D114024A699C020FF78BF040DFC40ED869FBF40CA963E0937EA3EFCBB8DBEA410F5BF374F2EC0A67482C030FE863FBF67FCC0F7E180BFF5DF57C0F6732B4017D54F40FAE94B40B72DB43FD1E59AC0674064C01FE465C01C9121BC00B7863F141D653F649416C03A0A7840A06496C05F0169BFA4C476BFBB73563E7B3C2F40D8205AC0E618C5BF6C43E5BF40D55BBFB5CBA7C0220DC13E0ED683BF9602CF40B2FBC740EE4D373F82DDA33E9670EAC0353283C09AC537C04CFED1BF56184D403EFC87BF1BB6A2C0D62CD9BB90B55040B7B4B5BF143135C0A0BF11C0125B73C0AC1F29C0F48BF53D69299D40DC4244402E8533C0FA8FF6BFCCA90841972477404F2FC6BF255E2D405AD68B40C04049C0AB682140BBCD9E3D6360AD3EBB9AC2C09E1D523F714F6BC08F5D8F3F13A25E409941FDBF0D3E8140D3056D3E8D3725C0BF3D96C0533323BFA3DC01413A597F40A689493F2A318D3F91203640104B8F3FFF4E2CBFC53FF23F516D8040F21B9E4089C84BC0BE34D0C0EA874B406C68384001722940FFE73EBFD889E3C0B9445E40610BB33E5CD78ABE1B897440641913BF80CBDB3F8AD3974070D667C02222C03F3E1002C09D9CA8C022C6B2406E93D63F417739C0E17C44405256B4BEC0B588C0038CBB3E5B7B2BC0CB618ABF4B42C9BF013024C08C13B9BDCCE8DE3FE9A8FFBF2F0D55406B00CA40BFE3123F21A281BF5DB570BFB52CC3403234FF3FD43BC53E7919763FA103D5BF0E9B71C06562A6BF745F34401DF3693F3296403F337F34C0AEC333BF28C202C002F567C0CEC61E40FA4B934017F25A3E924950BE1940B9BF065375C0CF5F543F08E090C056038AC09CDA5FBFE743814023BF963E8CFC00C0C8623440BBF4123FD4E7F1BED3BCDFBF4B43704091F687C075AF08BFA466A9C0671B76BE65B493401A3EDE3F2C9737C06D7FDC3FD6EAED3D8EFC52BF3D5BA73F26B2E13FEBD7774065229140678D1EC0B1C0F63E2D95A84055B5F93F6E9EA0409C660140F38BC33FE48AA040FBB6383F3ABB313F1A960AC0E55DBCBEC9AE41C03F2E7DBF5558BBBF5C292ABF9C878E40A45C7240B6F9F33F125AA1BF42A19E3FDFDA3EBF10E91F4067BD4F40ACEADE3FB62F10C0891B23C030037CC0157D02C07FC2F2BF324C2D3E3AF80B3F3072733FC30510C04C26F23DDB7262C0D9C68CBF2B330240B31A1D40D25E503DABA2F83F6768F73F41D9D13FA3EA85C027CEFEBF4CC1D1BFA7D08BC0822F54C094CD324016015A40B36F8F3EC60887C0256F6B3EE706B63FD99E1CC0C2FBEEBF76DD7E3E1007F53CDAC7CDC002B98AC02727ED3F7C202540C4204840ADCB52C0E10A913EC90469BF63402740E3E5C83C01822B40B19D4140FEFE1A40AE99C23FE9E440C0D0B981C0841CBF3FD8F942C0411599C0B5DB0B3FB3BD82BFDA827640AF2A974027126BBFCE1290C069611EC0EB50733F76B3DD3FC6216FBFD915FEBB1F6740BF876A3AC0C868AABEFE0CF3BF255FFDBF87134BC0E37363406D2A7BBFABC4AA3F9F7B15BF0AE8DABF2588F3BF357579C0B26B1C40E7E87B4045311540E32994BFDA2A86BF427B453F920EE93F35C622C04CEE78C0238ACA3FD194C8BF7EB496C07904003F6DA05B409A84A93F68B31E403AAF2ABF328B0AC0EEF15D4024BC3BC089E2CC3FF9A9854070F70640FDB249C0D6F7E53E07682F40EC3F2A400491C0BFE3D2FABFB6F4A5C0434CA0C0398695BF3AA0644066EF06BEEAA00FC1"> : tensor<2x3x9x10xf32>
    %1 = stablehlo.constant dense<"0xEBE9243FE1AF46BDFD630C41ECEE5A3FA3420A4002D33240EE0EA540BB8B16C017F8D7C095FBC6C011A3EF3DC95A06BFBE67C83F8D8E65406CB232BEA33CBFBF41E43AC0CAFC904083BE973F5FD203C0A88D5DBF70FAB4BF9C96063E4BD67DC047AB4E40220BCA3F77EB11401349A8BFCA24383F7DCBCDBFB521C1BF6A0F64409C4BC5BFAF10B93F73598FC0BD8F60C05AEC85C0F71A3B402095A0BF1A10FDBEE5B65C3FDF5313C072648EC0B60081BF2818EEBFFA7470C0E76E03400E471B40856B01C0AB003C40B2D7C6BF494EA53F603930C0E99D664072C9BF406AC480C005A5A2BF58B007BF50B4933FE9000340433538400606CABE7EA3953FB6CFAB3F6E642E40F4131040051091C0616493C0AC104340BFD8C63F3BC94FBE9B41EBBF615306C0D6370640D7A25ABF8B3FDA3F2F68BFBF60BA83BFE6D481C0A5CDC2C0D8CF1FBFA6E10B401A29FF3B8F9D4B402E238C3F3BD0D540C90E113FB4354C40587328C044FB17BEEE6E6F40D5559A40509C8DBF6D853A40049F4D3FA6B69EC000DF2D3F2233AEBE97B6D23F50B327404A3B123E3D25D7BF5C9B914023F03D408559563F11C2E63F67DBEE3FD1E21B4086BCBABF4C6911BFDDA1B9BF6B366CC0491BBDBD3B04CB4092E125C0DE7974C0AF6F8DBF6C2A2440FE862940DC368A3FCFB1C33E11CB0440400A0F4064DA62C037169E401E3B79C0F9484740D47D19C0DA36763F67D3F13FCCBCD3BE50ACFD3F5C310ABFB4368C3FC75648C0421FA7BF11E0FB3F638FB640429E8E3F86713EBF8CE95FC015DC1FBF199153C0230E403F03A73140F4231E3FD1BBCABF4CF8C040565F083EB9D65B405661DB4045DD24C0C95957C08C3E81C0AABD24C01E3EAA3F943A1EBE2F3CE3BF1FE5063FBCA6D0BFEADE744023D5A8C06CC4BDC0B65F313FC5E06DC04402A7C0A1B337C018EA11C0210926C0407BECBF9FB060402DFBAEC0D712BA3F83C58040E61B4ABE768DE5BF2CD37F4031674A4065D2CA3EC78401C0"> : tensor<3x3x4x5xf32>
    return %0, %1 : tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>
  }
  func.func private @expected() -> tensor<2x3x6x6xf32> {
    %0 = stablehlo.constant dense<"0xC0ECE8BF791C9041860008C35722284294A91CC1DAA1124388CA4041E34E0A427EA22442FA921643CC7926C192A2FCC1F4E012410436E541E4C370C18B6BE7C280BD32C287691142BDFAF542864717424A4FF6C1963B8BC156C0B342C625AAC23225C1C20C8E3241C16E17425D1F2843CE610AC3876E8AC2070817C311051A43EBA034426D2B5CC265B6E4C0B23CA8422C5652C136116742BDFB40C238CD8FC054532AC2C4B743415F903141C0CF58417F1DAD4269E33DC22ACA5542B13EAE42D07D5042FF0940C206CF9E4278063941957FE6C21CC175C29C4F2341147BB3429BA59741A37DD4C1050285C249F4B9C079730AC26D5860C2B8B68F411DA2D142AE8B15425E7CBAC130AE7BC0D704EDC256C9ED41D06FA1C27F676542464B5DC161AA78C2BDD915C3C34D8742C43E21C262DCE3414F1C30C114B390429AA119C2FA755C42B5C7214258C10243D4B5CF411956DDC047369D4258EED04158D571C1FA0421C2C02AC8C22EB116C354C528C021CD87C276B205432CF5B44254E867421C70094268949441C0DF58C140737542491B9EC206D59BC28F9E09C2773541C2E268DF4291CAEFC228210AC177486BC2E0272CC16DCF93419A5D3642566C08C3447666C22C1218C2A88BD841A700C0C1F2B30FC3C63580C207E2864257B140C2ABDB67C225A20FC20AE020C11CB04E42B2243FC27AA7EA4270711FC27A229CC01C5BA54258AA05C100415F425C9C49C2EAF3E7416AEB3641FA2EF5C177AECE4215F0FA42B9F099C1C5BDCEC203D7C0C159209C42115BBC42889910C2333797C2188408C200EFEB400B528D41F43E85C220BD8CC14C046CC053C008C310A3C141F077C4C045BE3CC289E08A41B36E42C1C22AAFC2C0B1FE403FB2934180C3E442A0AB164038EB994151A386C216215D42E41A634256024E413E202EC15A8B45C23DD6DC42DE3B2843521051411C556FC1B8F93441C53B1B434BC86EC1DD6BD3C26A87C1C2F4041E410ED8E2412F26B0C21BA808C274D246C187A1F84270392F3F8D44CFC185EC59C2CFAD114279C275414CBF40C3EDDF10C21C5AE9C191E6EE41281F43C1FFB137C2C09295415C5048429444C1C2CCCD2C421A58494219591441CA528D423AF7CD422D2E1242ADDD72411D9B03C12AE4C34256E0BD41608FBAC2BC3FC2412E7FFA4172998742FAE351C20081404296AA8C415EB9E8C1FB9A0A42"> : tensor<2x3x6x6xf32>
    return %0 : tensor<2x3x6x6xf32>
  }
}
