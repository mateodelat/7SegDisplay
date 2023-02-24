module calculadoraBasys3

(
  clk,
  rst,
  serialRX,
  start,
  seg,
  dispTrans,
  ledover
);



input clk;
input rst;
input serialRX;
input start;



output [7:0] seg;
output [3:0] dispTrans;
output ledover;

wire [4:0]wdisp0;
wire [4:0]wdisp1;
wire [4:0]wdisp2;
wire [4:0]wdisp3;

wire[7:0] wdata;

wire wdone;



//Modulo para calcular
calculadora CALC(
  .clk(clk),
  .rst(rst),
  .data(wdata),
  .start(start),
  .done(wdone),
  .ledover(ledover),
  .disp0(wdisp0),
  .disp1(wdisp1),
  .disp2(wdisp2),
  .disp3(wdisp3)
);


//Modulo para mostar datos en pantalla
sweep4disp7segBasys3
#(
  .NBITS_COMPARE (26),
  .COMPARE (100_000)
) DISPLAYS
(
  .clk (clk),
  .rst (rst),
  .disp0 (wdisp0),//C
  .disp1 (wdisp1),//L
  .disp2 (wdisp2),//A
  .disp3 (wdisp3),//C
  .seg (seg),
  .dispTrans (dispTrans)
);


//Modulo para pedir los datos
uartRX
#(
  .CLKCOUNTER (10_417),//a 9200
  .NBITS_COUNTER(14)// 14 bits
  ) uart
(
  .clk(clk),
  .rst(!rst),
  .serialRX(serialRX),
  .dataRX(wdata),
  .done(wdone)
);
endmodule
