module multiplier_testbench();
reg [7:0] input1,input2;
wire [15:0] answer;

ebm uut(.a(input1),
        .b(input2),
		.ma(answer));


initial begin
  $dumpfile("testing.vcd");
  $dumpvars(0);
end

initial begin
      $monitor($time,"input1=%b,input2=%b,answer=%d\n",
                      input1 ,  input2   ,answer);
	  #10;

	  input1 = 8'b00011111;
	  input2 = 8'b00000000;
	  #100;

	  input1 = 8'd5;
	  input2 = 8'd7;
	  #100;

	  input1 = 8'd176;
	  input2 = 8'd138;
	  #100;
end

endmodule