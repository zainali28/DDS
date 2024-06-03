// sine lookup value module using two symmetries
// appears like a 2048x16bit LUT even if it uses a 512x16bit internally
// 3 clock latency
module sine_lookup(input clk, input [10:0] addr, output reg [16:0] value);

wire [15:0] sine_1sym;  // sine with 1 symmetry
blockram512x16bit_2clklatency my_quarter_sine_LUT(     // the LUT contains only one quarter of the sine wave
    .rdclock(clk),
    .rdaddress(addr[9] ? ~addr[8:0] : addr[8:0]),   // first symmetry
    .q(sine_1sym)
);

// now for the second symmetry, we need to use addr[10]
// but since our blockram has 2 clock latencies on reads
// we need a two-clock delayed version of addr[10]
reg addr10_delay1; always @(posedge clk) addr10_delay1 <= addr[10];
reg addr10_delay2; always @(posedge clk) addr10_delay2 <= addr10_delay1;

wire [16:0] sine_2sym = addr10_delay2 ? {1'b0,-sine_1sym} : {1'b1,sine_1sym};  // second symmetry

// add a third latency to the module output for best performance
always @(posedge clk) value <= sine_2sym;
endmodule


module blockram512x16bit_2clklatency(
    input wire rdclock,
    input wire [8:0] rdaddress,
    output wire [15:0] q
);

    // Register the read address
    reg [8:0] rdaddress_reg;

    // Register the BRAM output
    reg [15:0] q_reg;
	 
	 reg [15:0] ram [0:511];
	 
	 initial begin
		ram[0] = 16'h0000;
		ram[1] = 16'h0064;
		ram[2] = 16'h00C9;
		ram[3] = 16'h012D;
		ram[4] = 16'h0192;
		ram[5] = 16'h01F6;
		ram[6] = 16'h025B;
		ram[7] = 16'h02C0;
		ram[8] = 16'h0324;
		ram[9] = 16'h0389;
		ram[10] = 16'h03ED;
		ram[11] = 16'h0452;
		ram[12] = 16'h04B6;
		ram[13] = 16'h051B;
		ram[14] = 16'h057F;
		ram[15] = 16'h05E4;
		ram[16] = 16'h0648;
		ram[17] = 16'h06AD;
		ram[18] = 16'h0711;
		ram[19] = 16'h0775;
		ram[20] = 16'h07DA;
		ram[21] = 16'h083E;
		ram[22] = 16'h08A3;
		ram[23] = 16'h0907;
		ram[24] = 16'h096B;
		ram[25] = 16'h09D0;
		ram[26] = 16'h0A34;
		ram[27] = 16'h0A98;
		ram[28] = 16'h0AFC;
		ram[29] = 16'h0B60;
		ram[30] = 16'h0BC5;
		ram[31] = 16'h0C29;
		ram[32] = 16'h0C8D;
		ram[33] = 16'h0CF1;
		ram[34] = 16'h0D55;
		ram[35] = 16'h0DB9;
		ram[36] = 16'h0E1D;
		ram[37] = 16'h0E81;
		ram[38] = 16'h0EE5;
		ram[39] = 16'h0F49;
		ram[40] = 16'h0FAD;
		ram[41] = 16'h1010;
		ram[42] = 16'h1074;
		ram[43] = 16'h10D8;
		ram[44] = 16'h113C;
		ram[45] = 16'h119F;
		ram[46] = 16'h1203;
		ram[47] = 16'h1266;
		ram[48] = 16'h12CA;
		ram[49] = 16'h132D;
		ram[50] = 16'h1391;
		ram[51] = 16'h13F4;
		ram[52] = 16'h1457;
		ram[53] = 16'h14BB;
		ram[54] = 16'h151E;
		ram[55] = 16'h1581;
		ram[56] = 16'h15E4;
		ram[57] = 16'h1647;
		ram[58] = 16'h16AA;
		ram[59] = 16'h170D;
		ram[60] = 16'h1770;
		ram[61] = 16'h17D3;
		ram[62] = 16'h1836;
		ram[63] = 16'h1899;
		ram[64] = 16'h18FB;
		ram[65] = 16'h195E;
		ram[66] = 16'h19C0;
		ram[67] = 16'h1A23;
		ram[68] = 16'h1A85;
		ram[69] = 16'h1AE8;
		ram[70] = 16'h1B4A;
		ram[71] = 16'h1BAC;
		ram[72] = 16'h1C0E;
		ram[73] = 16'h1C71;
		ram[74] = 16'h1CD3;
		ram[75] = 16'h1D35;
		ram[76] = 16'h1D96;
		ram[77] = 16'h1DF8;
		ram[78] = 16'h1E5A;
		ram[79] = 16'h1EBC;
		ram[80] = 16'h1F1D;
		ram[81] = 16'h1F7F;
		ram[82] = 16'h1FE0;
		ram[83] = 16'h2042;
		ram[84] = 16'h20A3;
		ram[85] = 16'h2104;
		ram[86] = 16'h2165;
		ram[87] = 16'h21C6;
		ram[88] = 16'h2227;
		ram[89] = 16'h2288;
		ram[90] = 16'h22E9;
		ram[91] = 16'h234A;
		ram[92] = 16'h23AA;
		ram[93] = 16'h240B;
		ram[94] = 16'h246B;
		ram[95] = 16'h24CC;
		ram[96] = 16'h252C;
		ram[97] = 16'h258C;
		ram[98] = 16'h25EC;
		ram[99] = 16'h264C;
		ram[100] = 16'h26AC;
		ram[101] = 16'h270C;
		ram[102] = 16'h276C;
		ram[103] = 16'h27CC;
		ram[104] = 16'h282B;
		ram[105] = 16'h288B;
		ram[106] = 16'h28EA;
		ram[107] = 16'h2949;
		ram[108] = 16'h29A8;
		ram[109] = 16'h2A07;
		ram[110] = 16'h2A66;
		ram[111] = 16'h2AC5;
		ram[112] = 16'h2B24;
		ram[113] = 16'h2B83;
		ram[114] = 16'h2BE1;
		ram[115] = 16'h2C3F;
		ram[116] = 16'h2C9E;
		ram[117] = 16'h2CFC;
		ram[118] = 16'h2D5A;
		ram[119] = 16'h2DB8;
		ram[120] = 16'h2E16;
		ram[121] = 16'h2E74;
		ram[122] = 16'h2ED1;
		ram[123] = 16'h2F2F;
		ram[124] = 16'h2F8C;
		ram[125] = 16'h2FEA;
		ram[126] = 16'h3047;
		ram[127] = 16'h30A4;
		ram[128] = 16'h3101;
		ram[129] = 16'h315E;
		ram[130] = 16'h31BB;
		ram[131] = 16'h3217;
		ram[132] = 16'h3274;
		ram[133] = 16'h32D0;
		ram[134] = 16'h332C;
		ram[135] = 16'h3389;
		ram[136] = 16'h33E5;
		ram[137] = 16'h3440;
		ram[138] = 16'h349C;
		ram[139] = 16'h34F8;
		ram[140] = 16'h3553;
		ram[141] = 16'h35AF;
		ram[142] = 16'h360A;
		ram[143] = 16'h3665;
		ram[144] = 16'h36C0;
		ram[145] = 16'h371B;
		ram[146] = 16'h3776;
		ram[147] = 16'h37D0;
		ram[148] = 16'h382B;
		ram[149] = 16'h3885;
		ram[150] = 16'h38DF;
		ram[151] = 16'h3939;
		ram[152] = 16'h3993;
		ram[153] = 16'h39ED;
		ram[154] = 16'h3A46;
		ram[155] = 16'h3AA0;
		ram[156] = 16'h3AF9;
		ram[157] = 16'h3B52;
		ram[158] = 16'h3BAB;
		ram[159] = 16'h3C04;
		ram[160] = 16'h3C5D;
		ram[161] = 16'h3CB6;
		ram[162] = 16'h3D0E;
		ram[163] = 16'h3D67;
		ram[164] = 16'h3DBF;
		ram[165] = 16'h3E17;
		ram[166] = 16'h3E6F;
		ram[167] = 16'h3EC6;
		ram[168] = 16'h3F1E;
		ram[169] = 16'h3F75;
		ram[170] = 16'h3FCD;
		ram[171] = 16'h4024;
		ram[172] = 16'h407B;
		ram[173] = 16'h40D2;
		ram[174] = 16'h4128;
		ram[175] = 16'h417F;
		ram[176] = 16'h41D5;
		ram[177] = 16'h422B;
		ram[178] = 16'h4281;
		ram[179] = 16'h42D7;
		ram[180] = 16'h432D;
		ram[181] = 16'h4382;
		ram[182] = 16'h43D8;
		ram[183] = 16'h442D;
		ram[184] = 16'h4482;
		ram[185] = 16'h44D7;
		ram[186] = 16'h452C;
		ram[187] = 16'h4580;
		ram[188] = 16'h45D4;
		ram[189] = 16'h4629;
		ram[190] = 16'h467D;
		ram[191] = 16'h46D1;
		ram[192] = 16'h4724;
		ram[193] = 16'h4778;
		ram[194] = 16'h47CB;
		ram[195] = 16'h481E;
		ram[196] = 16'h4871;
		ram[197] = 16'h48C4;
		ram[198] = 16'h4917;
		ram[199] = 16'h4969;
		ram[200] = 16'h49BC;
		ram[201] = 16'h4A0E;
		ram[202] = 16'h4A60;
		ram[203] = 16'h4AB1;
		ram[204] = 16'h4B03;
		ram[205] = 16'h4B54;
		ram[206] = 16'h4BA6;
		ram[207] = 16'h4BF7;
		ram[208] = 16'h4C48;
		ram[209] = 16'h4C98;
		ram[210] = 16'h4CE9;
		ram[211] = 16'h4D39;
		ram[212] = 16'h4D89;
		ram[213] = 16'h4DD9;
		ram[214] = 16'h4E29;
		ram[215] = 16'h4E78;
		ram[216] = 16'h4EC8;
		ram[217] = 16'h4F17;
		ram[218] = 16'h4F66;
		ram[219] = 16'h4FB5;
		ram[220] = 16'h5003;
		ram[221] = 16'h5052;
		ram[222] = 16'h50A0;
		ram[223] = 16'h50EE;
		ram[224] = 16'h513C;
		ram[225] = 16'h5189;
		ram[226] = 16'h51D7;
		ram[227] = 16'h5224;
		ram[228] = 16'h5271;
		ram[229] = 16'h52BE;
		ram[230] = 16'h530B;
		ram[231] = 16'h5357;
		ram[232] = 16'h53A3;
		ram[233] = 16'h53EF;
		ram[234] = 16'h543B;
		ram[235] = 16'h5487;
		ram[236] = 16'h54D2;
		ram[237] = 16'h551D;
		ram[238] = 16'h5568;
		ram[239] = 16'h55B3;
		ram[240] = 16'h55FE;
		ram[241] = 16'h5648;
		ram[242] = 16'h5692;
		ram[243] = 16'h56DC;
		ram[244] = 16'h5726;
		ram[245] = 16'h5770;
		ram[246] = 16'h57B9;
		ram[247] = 16'h5802;
		ram[248] = 16'h584B;
		ram[249] = 16'h5894;
		ram[250] = 16'h58DC;
		ram[251] = 16'h5925;
		ram[252] = 16'h596D;
		ram[253] = 16'h59B5;
		ram[254] = 16'h59FC;
		ram[255] = 16'h5A44;
		ram[256] = 16'h5A8B;
		ram[257] = 16'h5AD2;
		ram[258] = 16'h5B19;
		ram[259] = 16'h5B5F;
		ram[260] = 16'h5BA5;
		ram[261] = 16'h5BEC;
		ram[262] = 16'h5C31;
		ram[263] = 16'h5C77;
		ram[264] = 16'h5CBD;
		ram[265] = 16'h5D02;
		ram[266] = 16'h5D47;
		ram[267] = 16'h5D8C;
		ram[268] = 16'h5DD0;
		ram[269] = 16'h5E14;
		ram[270] = 16'h5E58;
		ram[271] = 16'h5E9C;
		ram[272] = 16'h5EE0;
		ram[273] = 16'h5F23;
		ram[274] = 16'h5F67;
		ram[275] = 16'h5FA9;
		ram[276] = 16'h5FEC;
		ram[277] = 16'h602F;
		ram[278] = 16'h6071;
		ram[279] = 16'h60B3;
		ram[280] = 16'h60F5;
		ram[281] = 16'h6136;
		ram[282] = 16'h6178;
		ram[283] = 16'h61B9;
		ram[284] = 16'h61F9;
		ram[285] = 16'h623A;
		ram[286] = 16'h627A;
		ram[287] = 16'h62BB;
		ram[288] = 16'h62FA;
		ram[289] = 16'h633A;
		ram[290] = 16'h637A;
		ram[291] = 16'h63B9;
		ram[292] = 16'h63F8;
		ram[293] = 16'h6436;
		ram[294] = 16'h6475;
		ram[295] = 16'h64B3;
		ram[296] = 16'h64F1;
		ram[297] = 16'h652F;
		ram[298] = 16'h656C;
		ram[299] = 16'h65A9;
		ram[300] = 16'h65E6;
		ram[301] = 16'h6623;
		ram[302] = 16'h6660;
		ram[303] = 16'h669C;
		ram[304] = 16'h66D8;
		ram[305] = 16'h6714;
		ram[306] = 16'h674F;
		ram[307] = 16'h678A;
		ram[308] = 16'h67C5;
		ram[309] = 16'h6800;
		ram[310] = 16'h683B;
		ram[311] = 16'h6875;
		ram[312] = 16'h68AF;
		ram[313] = 16'h68E9;
		ram[314] = 16'h6922;
		ram[315] = 16'h695B;
		ram[316] = 16'h6994;
		ram[317] = 16'h69CD;
		ram[318] = 16'h6A06;
		ram[319] = 16'h6A3E;
		ram[320] = 16'h6A76;
		ram[321] = 16'h6AAE;
		ram[322] = 16'h6AE5;
		ram[323] = 16'h6B1C;
		ram[324] = 16'h6B53;
		ram[325] = 16'h6B8A;
		ram[326] = 16'h6BC0;
		ram[327] = 16'h6BF6;
		ram[328] = 16'h6C2C;
		ram[329] = 16'h6C62;
		ram[330] = 16'h6C97;
		ram[331] = 16'h6CCC;
		ram[332] = 16'h6D01;
		ram[333] = 16'h6D36;
		ram[334] = 16'h6D6A;
		ram[335] = 16'h6D9E;
		ram[336] = 16'h6DD2;
		ram[337] = 16'h6E06;
		ram[338] = 16'h6E39;
		ram[339] = 16'h6E6C;
		ram[340] = 16'h6E9F;
		ram[341] = 16'h6ED1;
		ram[342] = 16'h6F03;
		ram[343] = 16'h6F35;
		ram[344] = 16'h6F67;
		ram[345] = 16'h6F98;
		ram[346] = 16'h6FC9;
		ram[347] = 16'h6FFA;
		ram[348] = 16'h702B;
		ram[349] = 16'h705B;
		ram[350] = 16'h708B;
		ram[351] = 16'h70BB;
		ram[352] = 16'h70EA;
		ram[353] = 16'h711A;
		ram[354] = 16'h7149;
		ram[355] = 16'h7177;
		ram[356] = 16'h71A6;
		ram[357] = 16'h71D4;
		ram[358] = 16'h7202;
		ram[359] = 16'h722F;
		ram[360] = 16'h725D;
		ram[361] = 16'h728A;
		ram[362] = 16'h72B6;
		ram[363] = 16'h72E3;
		ram[364] = 16'h730F;
		ram[365] = 16'h733B;
		ram[366] = 16'h7367;
		ram[367] = 16'h7392;
		ram[368] = 16'h73BD;
		ram[369] = 16'h73E8;
		ram[370] = 16'h7412;
		ram[371] = 16'h743D;
		ram[372] = 16'h7467;
		ram[373] = 16'h7490;
		ram[374] = 16'h74BA;
		ram[375] = 16'h74E3;
		ram[376] = 16'h750C;
		ram[377] = 16'h7534;
		ram[378] = 16'h755D;
		ram[379] = 16'h7585;
		ram[380] = 16'h75AC;
		ram[381] = 16'h75D4;
		ram[382] = 16'h75FB;
		ram[383] = 16'h7622;
		ram[384] = 16'h7648;
		ram[385] = 16'h766F;
		ram[386] = 16'h7695;
		ram[387] = 16'h76BA;
		ram[388] = 16'h76E0;
		ram[389] = 16'h7705;
		ram[390] = 16'h772A;
		ram[391] = 16'h774E;
		ram[392] = 16'h7773;
		ram[393] = 16'h7797;
		ram[394] = 16'h77BA;
		ram[395] = 16'h77DE;
		ram[396] = 16'h7801;
		ram[397] = 16'h7824;
		ram[398] = 16'h7846;
		ram[399] = 16'h7869;
		ram[400] = 16'h788B;
		ram[401] = 16'h78AC;
		ram[402] = 16'h78CE;
		ram[403] = 16'h78EF;
		ram[404] = 16'h7910;
		ram[405] = 16'h7930;
		ram[406] = 16'h7950;
		ram[407] = 16'h7970;
		ram[408] = 16'h7990;
		ram[409] = 16'h79AF;
		ram[410] = 16'h79CE;
		ram[411] = 16'h79ED;
		ram[412] = 16'h7A0C;
		ram[413] = 16'h7A2A;
		ram[414] = 16'h7A48;
		ram[415] = 16'h7A65;
		ram[416] = 16'h7A82;
		ram[417] = 16'h7A9F;
		ram[418] = 16'h7ABC;
		ram[419] = 16'h7AD9;
		ram[420] = 16'h7AF5;
		ram[421] = 16'h7B10;
		ram[422] = 16'h7B2C;
		ram[423] = 16'h7B47;
		ram[424] = 16'h7B62;
		ram[425] = 16'h7B7D;
		ram[426] = 16'h7B97;
		ram[427] = 16'h7BB1;
		ram[428] = 16'h7BCB;
		ram[429] = 16'h7BE4;
		ram[430] = 16'h7BFD;
		ram[431] = 16'h7C16;
		ram[432] = 16'h7C2F;
		ram[433] = 16'h7C47;
		ram[434] = 16'h7C5F;
		ram[435] = 16'h7C76;
		ram[436] = 16'h7C8E;
		ram[437] = 16'h7CA5;
		ram[438] = 16'h7CBB;
		ram[439] = 16'h7CD2;
		ram[440] = 16'h7CE8;
		ram[441] = 16'h7CFE;
		ram[442] = 16'h7D13;
		ram[443] = 16'h7D29;
		ram[444] = 16'h7D3E;
		ram[445] = 16'h7D52;
		ram[446] = 16'h7D66;
		ram[447] = 16'h7D7A;
		ram[448] = 16'h7D8E;
		ram[449] = 16'h7DA2;
		ram[450] = 16'h7DB5;
		ram[451] = 16'h7DC7;
		ram[452] = 16'h7DDA;
		ram[453] = 16'h7DEC;
		ram[454] = 16'h7DFE;
		ram[455] = 16'h7E10;
		ram[456] = 16'h7E21;
		ram[457] = 16'h7E32;
		ram[458] = 16'h7E43;
		ram[459] = 16'h7E53;
		ram[460] = 16'h7E63;
		ram[461] = 16'h7E73;
		ram[462] = 16'h7E82;
		ram[463] = 16'h7E91;
		ram[464] = 16'h7EA0;
		ram[465] = 16'h7EAF;
		ram[466] = 16'h7EBD;
		ram[467] = 16'h7ECB;
		ram[468] = 16'h7ED8;
		ram[469] = 16'h7EE6;
		ram[470] = 16'h7EF3;
		ram[471] = 16'h7F00;
		ram[472] = 16'h7F0C;
		ram[473] = 16'h7F18;
		ram[474] = 16'h7F24;
		ram[475] = 16'h7F2F;
		ram[476] = 16'h7F3A;
		ram[477] = 16'h7F45;
		ram[478] = 16'h7F50;
		ram[479] = 16'h7F5A;
		ram[480] = 16'h7F64;
		ram[481] = 16'h7F6E;
		ram[482] = 16'h7F77;
		ram[483] = 16'h7F80;
		ram[484] = 16'h7F89;
		ram[485] = 16'h7F91;
		ram[486] = 16'h7F99;
		ram[487] = 16'h7FA1;
		ram[488] = 16'h7FA8;
		ram[489] = 16'h7FB0;
		ram[490] = 16'h7FB7;
		ram[491] = 16'h7FBD;
		ram[492] = 16'h7FC3;
		ram[493] = 16'h7FC9;
		ram[494] = 16'h7FCF;
		ram[495] = 16'h7FD4;
		ram[496] = 16'h7FD9;
		ram[497] = 16'h7FDE;
		ram[498] = 16'h7FE2;
		ram[499] = 16'h7FE6;
		ram[500] = 16'h7FEA;
		ram[501] = 16'h7FEE;
		ram[502] = 16'h7FF1;
		ram[503] = 16'h7FF4;
		ram[504] = 16'h7FF6;
		ram[505] = 16'h7FF8;
		ram[506] = 16'h7FFA;
		ram[507] = 16'h7FFC;
		ram[508] = 16'h7FFD;
		ram[509] = 16'h7FFE;
		ram[510] = 16'h7FFE;
		ram[511] = 16'h7FFE; 
	 end
	 
	 always @(posedge rdclock) begin
        // On the first clock cycle, store the read address in rdaddress_reg
        rdaddress_reg <= rdaddress;

        // On the second clock cycle, fetch the BRAM data and store it in q_reg
        q_reg <= ram[rdaddress_reg];
    end

    // Connect the registered output q_reg to the output port q
    assign q = q_reg;
endmodule
