module calculadora

(//Reset activo en bajo
  clk,
  rst,
  data,
  start,
  done,
  ledover,
  disp0,
  disp1,
  disp2,
  disp3
);


  localparam IDLE = 3'b000;
  localparam num1 = 3'b001;
  localparam num2 = 3'b010;
  localparam op = 3'b011;
  localparam result = 3'b100;
  localparam showr = 3'b101;


  input clk;
  input rst;
  input [7:0]data;
  input start;
  input done;
  output reg ledover;
  output reg [4:0]disp0;
  output reg [4:0]disp1;
  output reg [4:0]disp2;
  output reg [4:0]disp3;

  reg [2:0] rState;
  reg [15:0]rresult;
  reg [7:0]opcode;
  reg [7:0]dataA;
  reg [7:0]dataB;


  always @ (posedge clk or negedge rst or posedge start) begin
    if (rst) begin
      rState <= IDLE;
    end
    else begin
      case (rState)
        IDLE: begin
          if (start) begin
            rState <= num1;
          end
          else begin
            rState <= IDLE;
          end
        end

        num1: begin
          if (done) begin
            rState <= num2;
            dataA <= data-48;
          end
          else begin
            rState <= num1;
          end
        end

        num2: begin
          if (done) begin
            rState <= op;
            dataB <= data-48;
          end
          else begin
            rState <= num2;
          end
        end

        op: begin
          if (done) begin
            rState <= result;
            opcode <= data-48;
          end
          else begin
            rState <= op;
          end
        end

        result: begin
          rState <= showr;
        end

        showr: begin
          rState <= showr;
        end

        default: begin
          rState <= IDLE;
        end
      endcase
    end
  end

  always @ (*) begin
    case (rState)
      IDLE: begin
        disp0 <= 12;//C
        disp1 <= 13;//L
        disp2 <= 10;//A
        disp3 <= 12;//C
      end

      num1: begin
        disp0 <= 1;//1
        disp1 <= 16;//Apagado
        disp2 <= 14;//u
        disp3 <= 11;//n
      end

      num2: begin
        disp0 <= 2;//1
        disp1 <= 16;//Apagado
        disp2 <= 14;//u
        disp3 <= 11;//n
      end

      op: begin
        disp0 <= 16;//apagado
        disp1 <= 15;//p
        disp2 <= 0;//o
        disp3 <= 16;//apagado
      end

      result: begin
        case (opcode)
          1 : rresult <= dataA+dataB;//+
          2 : rresult <= dataA-dataB;//-
          3 : rresult <= dataA*dataB;//*
          4 : rresult <= dataA/dataB;// /
          default : rresult <= 1425;//Default
        endcase
      end

      showr: begin
        if(rresult > 9999)begin
          ledover <= 1'b1;
        end
        else begin
          ledover <= 1'b0;
        end

        // //0030
        disp3 = rresult/1000; // 0
        disp2 = (rresult-(disp3*1000))/100; // (0030-0)/100 = 0
        disp1 = (rresult-((disp3*1000)+(disp2*100)))/10; // (0030 - (0+0))/10 = 3
        disp0 = rresult%10; // 0

      end
    endcase
  end

endmodule
