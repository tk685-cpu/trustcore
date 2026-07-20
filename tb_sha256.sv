// tb_sha256.sv  —  SystemVerilog testbench for sha256.v
//
// Compile:  iverilog -g2012 -o sim_sha tb_sha256.sv sha256.v
// Run all:  vvp sim_sha
// Run one:  vvp sim_sha +test-case=1   (1=known vectors, 2=corner cases, 3=random, 4=chained stress)
// Seed:     vvp sim_sha +test-case=3 +seed=1234
//
// Test 4 note: NIST's official SHA-256 Monte Carlo Test chains hashes by
// concatenating the last THREE digests (96 bytes) as the next input. Our
// hardware's message port is only 256 bits (32 bytes) wide and only supports
// a single 512-bit block, so the official 96-byte-input MCT can't run on this
// design. Test 4 instead chains ONE digest at a time (SHA256 of the previous
// digest, repeated), which fits the hardware and keeps the same core idea:
// run many chained operations and check against known-correct checkpoints,
// which stresses far more bit patterns than a handful of hand-picked vectors.

`timescale 1ns/1ps

module tb_sha256;

    parameter CLK_HALF = 20;   // 25 MHz clock

    // DUT signals
    logic         clk, rst_n;
    logic         start, busy, done;
    logic [255:0] message;
    logic [7:0]   msg_len;
    logic [255:0] digest;

    sha256 dut (
        .clk(clk), .rst_n(rst_n),
        .start(start), .busy(busy), .done(done),
        .message(message), .msg_len(msg_len), .digest(digest)
    );

    initial clk = 1'b0;
    always #CLK_HALF clk = ~clk;

    int test_case = 0;    // 0 = run all
    int seed      = 42;
    int pass_cnt  = 0;
    int fail_cnt  = 0;
    bit verbose   = 0;    // set when a specific test case is picked with +test-case=N

    // KAT sweep: message = sequential bytes 0x00,0x01,0x02... at each length.
    // Digests computed independently with Python's hashlib (verified correct).
    // Capped at 32 bytes — that's the widest message this hardware can accept.
    //
    // NOTE: Icarus Verilog doesn't support unpacked-array localparams with
    // '{...} initializers, so these are plain arrays filled in an initial
    // block below instead of true localparams. They're never written to
    // again after that, so they behave the same as constants in practice.
    localparam int N_KAT = 14;
    logic [255:0] KAT_MSG    [0:N_KAT-1];
    logic [7:0]   KAT_LEN    [0:N_KAT-1];
    logic [255:0] KAT_DIGEST [0:N_KAT-1];

    // Test 4 (chained stress test): seed + 100 checkpoint digests, computed
    // independently in Python by chaining SHA256(prev_digest) 1000 times
    // (one checkpoint every 10th chain step).
    localparam logic [255:0] MCT_SEED =
        256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
    localparam int N_CKPT = 100;
    logic [255:0] MCT_CKPT [0:N_CKPT-1];

    initial begin
        KAT_MSG[0]  = 256'h0000000000000000000000000000000000000000000000000000000000000000;
        KAT_MSG[1]  = 256'h0000000000000000000000000000000000000000000000000000000000000000;
        KAT_MSG[2]  = 256'h0001000000000000000000000000000000000000000000000000000000000000;
        KAT_MSG[3]  = 256'h0001020000000000000000000000000000000000000000000000000000000000;
        KAT_MSG[4]  = 256'h0001020300000000000000000000000000000000000000000000000000000000;
        KAT_MSG[5]  = 256'h0001020304000000000000000000000000000000000000000000000000000000;
        KAT_MSG[6]  = 256'h0001020304050600000000000000000000000000000000000000000000000000;
        KAT_MSG[7]  = 256'h0001020304050607000000000000000000000000000000000000000000000000;
        KAT_MSG[8]  = 256'h000102030405060708090a0b0c0d0e0000000000000000000000000000000000;
        KAT_MSG[9]  = 256'h000102030405060708090a0b0c0d0e0f00000000000000000000000000000000;
        KAT_MSG[10] = 256'h000102030405060708090a0b0c0d0e0f10111213141516000000000000000000;
        KAT_MSG[11] = 256'h000102030405060708090a0b0c0d0e0f10111213141516170000000000000000;
        KAT_MSG[12] = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e00;
        KAT_MSG[13] = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

        KAT_LEN[0]=0;  KAT_LEN[1]=1;  KAT_LEN[2]=2;  KAT_LEN[3]=3;
        KAT_LEN[4]=4;  KAT_LEN[5]=5;  KAT_LEN[6]=7;  KAT_LEN[7]=8;
        KAT_LEN[8]=15; KAT_LEN[9]=16; KAT_LEN[10]=23; KAT_LEN[11]=24;
        KAT_LEN[12]=31; KAT_LEN[13]=32;

        KAT_DIGEST[0]  = 256'he3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855;
        KAT_DIGEST[1]  = 256'h6e340b9cffb37a989ca544e6bb780a2c78901d3fb33738768511a30617afa01d;
        KAT_DIGEST[2]  = 256'hb413f47d13ee2fe6c845b2ee141af81de858df4ec549a58b7970bb96645bc8d2;
        KAT_DIGEST[3]  = 256'hae4b3280e56e2faf83f414a6e3dabe9d5fbe18976544c05fed121accb85b53fc;
        KAT_DIGEST[4]  = 256'h054edec1d0211f624fed0cbca9d4f9400b0e491c43742af2c5b0abebf0c990d8;
        KAT_DIGEST[5]  = 256'h08bb5e5d6eaac1049ede0893d30ed022b1a4d9b5b48db414871f51c9cb35283d;
        KAT_DIGEST[6]  = 256'h57355ac3303c148f11aef7cb179456b9232cde33a818dfda2c2fcb9325749a6b;
        KAT_DIGEST[7]  = 256'h8a851ff82ee7048ad09ec3847f1ddf44944104d2cbd17ef4e3db22c6785a0d45;
        KAT_DIGEST[8]  = 256'h7071fc3188fde7e7e500d4768f1784bede1a22e991648dcab9dc3219acff1d4c;
        KAT_DIGEST[9]  = 256'hbe45cb2605bf36bebde684841a28f0fd43c69850a3dce5fedba69928ee3a8991;
        KAT_DIGEST[10] = 256'hf6a954a68555187d88cd9a026940d15ab2a7e24c7517d21ceeb028e93c96f318;
        KAT_DIGEST[11] = 256'h1d64add2a6388367c9bc2d1f1b384b069a6ef382cdaaa89771dd103e28613a25;
        KAT_DIGEST[12] = 256'h4f23c2ca8c5c962e50cd31e221bfb6d0adca19111dca8e0c62598ff146dd19c4;
        KAT_DIGEST[13] = 256'h630dcd2966c4336691125448bbb25b4ff412a49c732db2c8abc1b8581bd710dd;

        MCT_CKPT[0] = 256'h31b484ecc2ffb8164a93010dd98a05b1c6b2cbd488b09074e2e9dd6010406217;
        MCT_CKPT[1] = 256'h8674aac1916ae9f06750e378d90bd725697e150601492e44df3a3fcce7f16656;
        MCT_CKPT[2] = 256'h050299e31bc62fccc31c5aabacd59b24a9153b7e6b2d9f943455c1f0304172d7;
        MCT_CKPT[3] = 256'h51faff1ae04abc7781b682dfd4feb612b3a21912c0451955908d407c74bd2fb3;
        MCT_CKPT[4] = 256'h5218964d5602931131eb017235b3e2681e1e9ae5bda74972e87db0534edd84c3;
        MCT_CKPT[5] = 256'h3656df483b362fe5b181063322fa5e7f4d7fdc4d9f5f03bcefcfb360d4555546;
        MCT_CKPT[6] = 256'h2ac27759efcdf3a1275155deeed2351e02424a053b0ad0d23d1fa9993c52918b;
        MCT_CKPT[7] = 256'hf8e0ddab49c70aad661d48bf155fb0e01ae48e7cef694057f782c54d7e7ca354;
        MCT_CKPT[8] = 256'h599f481bcc6872b0620885e187a560f710f19dd1c04eb82cde7c3f29e62e9a4f;
        MCT_CKPT[9] = 256'h24ad951a749c12e153e6a18ab1da52a4f0c279a16edcc608462c9826ff88768a;
        MCT_CKPT[10] = 256'h6f79b253be92f396f4c4dade5d89b77e5879cf87ead4e0229511f4c30a3970e9;
        MCT_CKPT[11] = 256'hf4fb42adcf6da884e2ba953115abddd55a54ba6170a4ff51940a72a986b8d1b6;
        MCT_CKPT[12] = 256'hcf18e51af5a9202ffcab1376221320e7feef8511dc2d49e5ec6dcbbb3fc8de83;
        MCT_CKPT[13] = 256'heaa00f70f404d069f87edaa809b1f4922e3e0daae193c663bafef7268aef093a;
        MCT_CKPT[14] = 256'h806ca0316705f205256fe6f5ec62ef13f55bb0ddb291f2a93392d3edf75cedbd;
        MCT_CKPT[15] = 256'hb310053309be4642b54e2a098424b35390039c12e07d532bec384b2b629181a9;
        MCT_CKPT[16] = 256'h38eb6259d41424a5ba0b44d815b570469e31dd9f0e7016c72e3c40f6487c59b3;
        MCT_CKPT[17] = 256'h69270fbf19371e5dabfa7198560954d9b23364c50461d4f65910f34220bb46c4;
        MCT_CKPT[18] = 256'h35dac6dba3acb01d104281c424eb1236aec14e2be17841583fc4981e12a9da97;
        MCT_CKPT[19] = 256'h8be4c9385883f91b3457d59fadec5441d456b97f72b0281b1a31f88b3d3543ba;
        MCT_CKPT[20] = 256'he400cedfaa5d44fb7b6ec7a451a41393ca6daa4faf4b822f72abac74d624845f;
        MCT_CKPT[21] = 256'hce9b3796d5d5e44ea92099c3ecaea52055fc4f8e60551a2c7f9712b061844766;
        MCT_CKPT[22] = 256'h51b0156e5cdc1dff02f04da003ca9259e0d5a3ca67fc2c2113dfed76bf9aa020;
        MCT_CKPT[23] = 256'hce9c6ddc17caf4b053e91935b582ae6fd0c429ecf7e42cb92106447d5c337d05;
        MCT_CKPT[24] = 256'haa66bc0d42a5c8a97e66f599f1e9628d0acebc7ea8afd5596db538044112d42e;
        MCT_CKPT[25] = 256'h68b3af218235a0b454b27f8edc28ccea94f704263e5bf09add2569591a053ebb;
        MCT_CKPT[26] = 256'h3a31c3ce5af493c0a3ea2862556a380640f5679fc4aae73984fbb3e0daaebaaa;
        MCT_CKPT[27] = 256'hf444bf63a638be32de6d886beebf7d3afc13213aa4080f93679c7b09bf1f63a1;
        MCT_CKPT[28] = 256'h645189f39a8f072c4e8ad72a49ea46e90e5eab15c1763c7d97b1f5cba86f83da;
        MCT_CKPT[29] = 256'h0b31d9d5d497c8b4064a0d63b045bc3329873043b9fe79dbf9bc1cb9e55c8f7f;
        MCT_CKPT[30] = 256'ha37b6767a0e2f0ae24e82403273f3ef62e40eb7ad1bede3d54fa99dffdcdbc14;
        MCT_CKPT[31] = 256'h9127bd39bd0b9eb49b4aa1af4809ef398ed43552543d6759ca502d5d083162e2;
        MCT_CKPT[32] = 256'hbbbe8dfc74ed8dcc17868f3afa7ff729d0a8d161f8d152dcac14c83508c3a50e;
        MCT_CKPT[33] = 256'h1f11633cf2704cf1ab6c17a33a8fea563c8c21863b9efadf97e05eb977dac746;
        MCT_CKPT[34] = 256'h2282248a02b666c43ce66705cc6db823bbaf906a098bc302cff2767e9f913726;
        MCT_CKPT[35] = 256'h1e3d494a80dd231020a781ab0fa430e6af6734b69f6940fe3f80a2126b79c516;
        MCT_CKPT[36] = 256'hf4501fa3c525319e50fcba8bdd92d005109b7bffe2e024efad21585912cd617b;
        MCT_CKPT[37] = 256'h470b826bb4b78bf0dab222d78b93c5a4e27b24590ba05985ca1583034952b4ee;
        MCT_CKPT[38] = 256'h24db465ef3f20305bcf3025a386e8fd2694574f1821278e7d388c48afcc08ace;
        MCT_CKPT[39] = 256'he72917fc660e187024631879a4bd48473df2a75868dfccaa5f37ae13046bc252;
        MCT_CKPT[40] = 256'hb47a069d6bd68f1bb436067dcf70e1f1214d2adc63de0793c888b85837b5f492;
        MCT_CKPT[41] = 256'haa57c9690063e769975bba735a38080a238c493914a65c0207b00e9a56708764;
        MCT_CKPT[42] = 256'h112ff64b3a8943022a9c43d9e507b4d9b5f5af72c08efecd0688cb1d46b55023;
        MCT_CKPT[43] = 256'h89972ad72ad0ffc03eae3f55f894a6c553deb4ed7b9c3978a44169867fdd3a86;
        MCT_CKPT[44] = 256'h1fab608752a4df2da94a4d12c0b178aa9e0347971c5c01c910e915b6d5a83cbb;
        MCT_CKPT[45] = 256'h8c03861b26bd5f30c9529d0269ce42a3a962f735f0bbb834f6e75c8a15d4e58e;
        MCT_CKPT[46] = 256'ha09db80de618d208a669d3f959e6c79637669e04dbdf3cd0b80f91efadd0b7b6;
        MCT_CKPT[47] = 256'haf7a2f53133dcc7bcfa09e864530b3d336208d702ead3aa324581c8ae5c9ac5d;
        MCT_CKPT[48] = 256'hc352842b8c90c8a5112d9468c5a04656eed54a212c0cd4b222dfb953a481b831;
        MCT_CKPT[49] = 256'h58e2e71739a9811237e3c945114f9a6c5674a1fcd2199473ecf95fcd3eb851aa;
        MCT_CKPT[50] = 256'h51702e28f594c110e002d9d8048ad910a26b5cde711e977f4d2a67086530d5ee;
        MCT_CKPT[51] = 256'h658b4058c4804119fc2d6ad0f4cfa432513dcf20101652d91beb482d62b3e211;
        MCT_CKPT[52] = 256'hdfb2ef11987ebb91809d6b18e4afd4252c9807f2bb2fd6a6a76038568170ba8b;
        MCT_CKPT[53] = 256'h5a7314fb818a2d647e186bd307dab09e2170ed98ae53d8e3ea110ded020596e6;
        MCT_CKPT[54] = 256'h1ae075222b9920b121976028feb21cb3d65f2c76a9044570fe3b2921a9a21e90;
        MCT_CKPT[55] = 256'hbf977368ee5ae093b1d9e5e2755870129ee89f82103058fd2dd410711b847c91;
        MCT_CKPT[56] = 256'h76101ef1b34d69ed878b33cc67a80ec7e1504a725d4a0a586b2d9a191c7ed983;
        MCT_CKPT[57] = 256'h4b68c08717cf62c6c9f96f76c1b0c9a39d13e91c07311faf86399dbb1be72ba4;
        MCT_CKPT[58] = 256'hc637523aea83b81948732bdf0c5f332843b58df5e8b1444eff0693221f4135bb;
        MCT_CKPT[59] = 256'h33aedfee2f0b9b360ec492c2cee63b00290986dc4c9c38683916ec33e75aad43;
        MCT_CKPT[60] = 256'h8189c9a9b5b6fc7bb0dd53ec82dd92c583126d1fec2a42d4b60fc991104d373e;
        MCT_CKPT[61] = 256'h6e2e099d3274cfda27cab777d7198ab126105a319e3e72bf6bd007637979622c;
        MCT_CKPT[62] = 256'hb11d0fba14a5d878d009b54afaf1f0abfe902db3c6f1f815e89eda2284aff527;
        MCT_CKPT[63] = 256'hd62c1337636e78089f489e186b63b4c0a2b04d3414362df2d265106a78a14a46;
        MCT_CKPT[64] = 256'h85a03115b3e990720a0a51029c14c6db876453e5c206812e9d9bcee9559fe914;
        MCT_CKPT[65] = 256'hd19e67b96079195f66d4270fb62d0d39376ee379ad7ac52f4899f41f45ed5bb6;
        MCT_CKPT[66] = 256'h7ebc6a4443bab02ccab8148f0103b40516bc89aff61026cfdb62e1c8274bcfe6;
        MCT_CKPT[67] = 256'had89569d1ef0e6a0da2d4664b59effb38efa76eba9f0acb172955ed00e5384e1;
        MCT_CKPT[68] = 256'h59907d6bbbc9af1d7ce37baf7970c75b4bf8695e7a0840af5f3e89337fe73dd9;
        MCT_CKPT[69] = 256'h3fe48ba83dc53bbb3341501b924379f4fab76ea650f33c752dcc9da5a5a9dec4;
        MCT_CKPT[70] = 256'h5c81f8771acfb8dac797f0c52f7b4908b90b7a4f594163e37928136fd570a5c3;
        MCT_CKPT[71] = 256'h6c4a03b1050cf2c93d59f3057a0c8801bddd0615042e145898bef9f82a8dd06d;
        MCT_CKPT[72] = 256'h2dab964988c1bab586f6ce470911cf51f1e97aae9ba6b354e3f68c215754da99;
        MCT_CKPT[73] = 256'ha359b5a90cc4b5ea1a08ce10e4480031efacad60e66c06a884368d31757fd558;
        MCT_CKPT[74] = 256'h56c7c02f0b52fdd6eaff83885e5eef946317e4bcb9df01e6f1edf0adc2ae9b41;
        MCT_CKPT[75] = 256'h2a25d71cf33ca208d6c399d70ce134554129ad2b76636c6dca2a1d0eb55a51a0;
        MCT_CKPT[76] = 256'h1dc73ec06521f0ed266628b8ab37625ebe1ae6584b24ae338836b3d1eca3dd3a;
        MCT_CKPT[77] = 256'h129d623faed2f456603a3b5cc9bd83df05002c6d0abc5e369e0c9eaf328b28bc;
        MCT_CKPT[78] = 256'h2978fb84b724936720fda2e416fa728ca8627fd1ee47da6d8b13823032b5f91e;
        MCT_CKPT[79] = 256'h8ce3e76072090abad687de9bcbc8ccbd5eacec01a91b1fb8653760adccb2c1f7;
        MCT_CKPT[80] = 256'h43264c1dbbafee81e9840b4700c9288e5449de03b16abdee08bb0c8b1de97bbb;
        MCT_CKPT[81] = 256'h2c80a2faa7f49e1a503d98cbfbd13f75587aeb36439f53b875761b5c23fcbde3;
        MCT_CKPT[82] = 256'h943d8c1d8414d64d643a33ce79d23f5563e2af1be50a033c34fb1ef61f102d6f;
        MCT_CKPT[83] = 256'h0536aa8c18de31a5e753a6d3415a82badd4f1bb7a5e10c4a2637380d1a9cc9ec;
        MCT_CKPT[84] = 256'h1ddefefea7f4bb5164b4fb1efb3d0f1c5a57e897c0ad7deca4e3493ed25b82da;
        MCT_CKPT[85] = 256'h7a63c2c415dcf8e277a2b3de1a0409dcadece8f8148682fcc9a418b14fdb4b93;
        MCT_CKPT[86] = 256'h73e641df4cc4dc23509cceca31679bc58d746980264e80212331b9de1ede1e26;
        MCT_CKPT[87] = 256'hf8d308620d49541899ccc1189d17dcae8c5e3ccc2519530bb18f276093e0e1b4;
        MCT_CKPT[88] = 256'h7fac77cd2734cde6526cc286dad664dd6b215107717ce5c095b2f5a460c34ba8;
        MCT_CKPT[89] = 256'h772d3f200266f04b5759b71b6d2ca1296add3a07a23cbd9089bcddf0411880f1;
        MCT_CKPT[90] = 256'hf52ff700a31535677662e794a4d99268aec8e923df614a6eb03e73060dfde851;
        MCT_CKPT[91] = 256'h412e0b1f4dcd00af19146bd0ec222808d8a30bf4df7877a880fd41634282e395;
        MCT_CKPT[92] = 256'h44064af3751c76f2c8c87e953bce7f5c7e574aa918b4a9f62e0bfc6036252ce1;
        MCT_CKPT[93] = 256'hce6f74c649291c8082df8646fbe871ce2d8ec38b90ff42fd0692f9da4d9f8cd2;
        MCT_CKPT[94] = 256'h2c37ddc6b2d9899a459878f46916d9c0a65628b1d43419971d28eb81f7d29e38;
        MCT_CKPT[95] = 256'h724e6b5bbe8b1af69225bf405c99d9366944a4607af2127ce20e3263f2ce9d47;
        MCT_CKPT[96] = 256'he10843c4730bf7ec6ca7e0f7b5ebde3ef3a114b9e29e863dd8e226345189c479;
        MCT_CKPT[97] = 256'hfae322f2e497d50c1876639be5e09dbacc320e7609d49aafbb93f98aedaed8ff;
        MCT_CKPT[98] = 256'h7d62c34a059992dd220b1cefbd33b4563c0a1bd12ae9c293d840315909d19921;
        MCT_CKPT[99] = 256'ha88d34c746d53d3355d3bf5839640933260f455208ee4d46e21f0ae1acfe565b;
    end

    // Load a message, pulse start, wait for done
    task automatic run_hash(input logic [255:0] msg, input logic [7:0] len);
        int cycles = 0;
        message = msg;
        msg_len = len;
        @(posedge clk);
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;
        while (!done && cycles < 300) begin
            @(posedge clk);
            cycles++;
        end
        if (cycles >= 300) $display("  TIMEOUT waiting for done");
    endtask

    // Named check — only prints a line when verbose is on
    task automatic check(input logic cond, input string label);
        if (cond) begin
            if (verbose) $display("  %s: PASS", label);
            pass_cnt++;
        end else begin
            if (verbose) $display("  %s: FAIL", label);
            fail_cnt++;
        end
    endtask

    // Same as check(), but shows got/expected on failure (for digest comparisons)
    task automatic check_digest(input logic [255:0] expected, input string label);
        if (digest === expected) begin
            if (verbose) $display("  %s: PASS", label);
            pass_cnt++;
        end else begin
            if (verbose) $display("  %s: FAIL (got 0x%h, expected 0x%h)", label, digest, expected);
            fail_cnt++;
        end
    endtask

    // Test 1: Known FIPS 180-4 vectors + a KAT sweep across every reachable length
    task automatic test_case_1();
        int k;

        run_hash(256'd0, 8'd0);   // SHA256("")
        check_digest(256'he3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855, "1.1");
        check(!busy, "1.2");

        run_hash({8'h61, 248'd0}, 8'd1);   // SHA256("a")
        check_digest(256'hca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb, "1.3");

        run_hash({8'h61, 8'h62, 8'h63, 232'd0}, 8'd3);   // SHA256("abc")
        check_digest(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad, "1.4");

        // 1.5-1.18: sweep every reachable message length (0-32 bytes)
        for (k = 0; k < N_KAT; k++) begin
            run_hash(KAT_MSG[k], KAT_LEN[k]);
            check_digest(KAT_DIGEST[k], $sformatf("1.%0d", 5 + k));
        end
    endtask

    // Test 2: Corner cases
    task automatic test_case_2();
        logic [255:0] digest_a, digest_b;

        run_hash({8'h00, 248'd0}, 8'd1);
        check(digest !== 256'd0, "2.1");

        run_hash(256'd0, 8'd32);
        digest_a = digest;
        check(digest_a !== 256'd0, "2.2");

        run_hash(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 8'd32);
        digest_b = digest;
        check(digest_a !== digest_b, "2.3");

        run_hash({8'hAB, 248'd0}, 8'd1);
        digest_a = digest;
        run_hash({8'hAB, 8'h00, 8'h00, 8'h00, 224'd0}, 8'd4);
        digest_b = digest;
        check(digest_a !== digest_b, "2.4");

        run_hash({64'hDEADBEEFCAFEBABE, 192'd0}, 8'd8);
        check(digest !== 256'd0, "2.5");

        run_hash(256'd0, 8'd0);
        digest_a = digest;
        run_hash(256'd0, 8'd32);
        digest_b = digest;
        check(digest_a !== digest_b, "2.6");
    endtask

    // Test 3: Random inputs (aggregated — 50 runs per sub-test)
    task automatic test_case_3();
        logic [255:0] msg_a, msg_b, digest_a, digest_b;
        logic [7:0]   len_a;
        int           i, flip_bit, fails;

        // 3.1 Determinism: same input twice -> same digest
        fails = 0;
        for (i = 0; i < 50; i++) begin
            msg_a = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed),
                     $urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            len_a = ($urandom(seed) % 32) + 1;

            run_hash(msg_a, len_a);
            digest_a = digest;
            run_hash(msg_a, len_a);
            digest_b = digest;

            if (digest_a !== digest_b) fails++;
        end
        check(fails == 0, "3.1");

        // 3.2 Sensitivity: flip one bit -> digest must change
        fails = 0;
        for (i = 0; i < 50; i++) begin
            msg_a = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed),
                     $urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            len_a = ($urandom(seed) % 32) + 1;
            flip_bit = $urandom(seed) % (len_a * 8);
            msg_b = msg_a;
            msg_b[255 - flip_bit] = ~msg_a[255 - flip_bit];

            run_hash(msg_a, len_a);
            digest_a = digest;
            run_hash(msg_b, len_a);
            digest_b = digest;

            if (digest_a === digest_b) fails++;
        end
        check(fails == 0, "3.2");

        // 3.3 Non-zero output
        fails = 0;
        for (i = 0; i < 50; i++) begin
            msg_a = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed),
                     $urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            len_a = ($urandom(seed) % 32) + 1;
            run_hash(msg_a, len_a);
            if (digest === 256'd0) fails++;
        end
        check(fails == 0, "3.3");
    endtask

    // Test 4: chained stress test (adapted single-digest Monte Carlo test — see
    // header note for why this differs from the official 3-digest NIST version)
    task automatic test_case_4();
        logic [255:0] d;
        int c;

        run_hash(MCT_SEED, 8'd32);
        d = digest;

        for (c = 1; c <= 1000; c++) begin
            run_hash(d, 8'd32);
            d = digest;
            // digest still holds this cycle's result here, so check_digest() works directly
            if (c % 10 == 0)
                check_digest(MCT_CKPT[(c/10)-1], $sformatf("4.%0d", c/10));
        end
    endtask

    // Runs one test case, prints how many of its checks passed
    task automatic run_test(input int num);
        int pass_before = pass_cnt;
        int fail_before = fail_cnt;
        int total;
        case (num)
            1: test_case_1();
            2: test_case_2();
            3: test_case_3();
            4: test_case_4();
        endcase
        total = (pass_cnt + fail_cnt) - (pass_before + fail_before);
        $display("Test %0d: %0d/%0d passed", num, pass_cnt - pass_before, total);
    endtask

    // Top-level stimulus
    initial begin
        void'($value$plusargs("test-case=%d", test_case));
        void'($value$plusargs("seed=%d", seed));
        verbose = (test_case != 0);   // show per-check detail only when a test is picked

        // Only record a waveform when zoomed into one test — a full run with
        // 50 random iterations can generate a huge trace and blow up memory
        if (verbose) begin
            $dumpfile("tb_sha256.vcd");
            $dumpvars(0, tb_sha256);
        end

        rst_n = 1'b0;
        start = 1'b0;
        message = 256'd0;
        msg_len = 8'd0;
        repeat(4) @(posedge clk);
        rst_n = 1'b1;
        repeat(2) @(posedge clk);

        case (test_case)
            1: run_test(1);
            2: run_test(2);
            3: run_test(3);
            4: run_test(4);
            default: begin
                run_test(1);
                run_test(2);
                run_test(3);
                run_test(4);
            end
        endcase

        $display("SUMMARY: %0d passed, %0d failed", pass_cnt, fail_cnt);
        $finish;
    end

endmodule
