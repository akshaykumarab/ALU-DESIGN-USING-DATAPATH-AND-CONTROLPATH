module pipeline_test;
  
  wire [15:0] Zout;
  reg [3:0]rs1,rs2,rd,func;
  reg [7:0]addr;
  reg clk1,clk2;
  integer k;
    
    
  pipeline_ALU PIPE (Zout,rs1,rs2,rd,func,addr,clk1,clk2);
    
    initial 
      begin 
        clk1=0; clk2=0;  // Generating Two Phase Clock
        repeat(20)
          begin 
            #5 clk1=1; #5 clk1=0;
            #5 clk2=1; #5 clk2=0;
          end
      end
    
    initial 
      for(k=0; k<16; k++)
        PIPE.Reg_Bank[k] =k;   // Initialize Registers
    
    initial 
      begin 
         #5 rs1=3; rs2=5; rd=10; func=0; addr=125;   //ADD
         #20 rs1=3; rs2=8; rd=12; func=2; addr=126;   //MUL
         #20 rs1=10; rs2=5; rd=14; func=1; addr=128;   //SUB
         #20 rs1=7; rs2=3; rd=13; func=11; addr=127;   //SLA
         #20 rs1=10; rs2=5; rd=15; func=1; addr=129;   //SUB
         #20 rs1=12; rs2=13; rd=16; func=0; addr=130;   //ADD
     
        #60 for(k=125 ; k<131 ;k++)
          $display ("Mem[%3d] =%3d" ,k,PIPE.mem[k]);
      end
    initial 
      begin 
        $dumpfile("pipe.vcd");
        $dumpvars(0,pipeline_test);
        $monitor("Time: %3d, F= %3d" , $time,Zout);
          #300 $finish;
      end
endmodule               
                    
                  