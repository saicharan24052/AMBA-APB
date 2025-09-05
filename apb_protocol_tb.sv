`timescale 1ns/1ps
module apb_protocol_tb;

  logic pclk;
  logic presetn; 
  logic [3:0] addr_in;
  logic [7:0] data_in;
  logic newd; 
  logic wr;
  logic [7:0] data_out; 
 
 
 apb_protocol dut(pclk,presetn,addr_in,data_in,newd,wr,data_out);
 
 
 
 initial begin
    pclk = 0;
    wr = 0;
    forever #0.5 pclk = ~pclk;

 end 
 
 
 initial begin
   presetn = 1'b0;
   #1;
   presetn = 1'b1; 
   wr = 1;
   newd = 1; 
    #5;
    
    addr_in = 4'b0001;
    data_in = 8'b10101010;
    
    #5;
    
    addr_in = 4'b0011;
    data_in = 8'b1111010; 
 

    #5;
    
    addr_in = 4'b0111;
    data_in = 8'b1111011;
    
     #5;
     
     wr = 0;
     
     addr_in = 4'b0111;
     
     
     #5;
      addr_in = 4'b0011;
      
      
       #5;
    
    addr_in = 4'b0001;
 
 end
 
 
 initial begin
 
    $monitor($time,"wr = %d, nedw = %d, addr = %b, data_in = %b, data_out = %b",wr,newd,addr_in,data_in,data_out);
 
 
 end
 
 
 endmodule