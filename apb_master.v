module apb_master(

  
  input pclk,
  input presetn, 
  input [3:0] addr_in,
  input [7:0] data_in,
  input newd, 
  input wr,
  input [7:0] prdata, 
  input pready,  

     

  output reg psel,
  output reg penable,
  output reg [3:0] paddr,
  output reg [7:0] pwdata,
  output reg pwrite,
  output  [7:0] dataout
  
);

 localparam [1:0] idle = 0, setup = 1, enable = 2;
 reg [1:0] state, next_state;  
                             
/////present state logic sequential
                             
 always @(posedge pclk) begin
 
    if(presetn ==0)
        state <= idle;
    else 
    	state <= next_state;
 end
 
//////combinational logic

always @(*) begin
   
   case (state) 
   idle:
  	 begin
          if(newd)
          next_state = setup;
          else
          next_state = idle;
   	end    
       
   setup:
  	 begin
     	next_state = enable;
   	 end 
   
   
   enable:
   	begin     
		if(newd) begin	
		   if(pready)	   
		   next_state = setup;	   
		   else	   
		   next_state = enable;	
		end  	
		else  begin	   
		   next_state = idle;	
		end
	end	
   	  default : next_state = idle;
   	endcase
   	     
 end
 
 
 /////////////////address decoding
 
always @(posedge pclk) begin
  
    if(presetn == 0)   
       psel <= 0;  
     else if (next_state == setup || next_state == enable) 	
        psel <= 1; 
      else
      psel <= 0;

end
 
 
 ///////////////output state logic
 
 always @(posedge pclk) begin  
 
		if(presetn == 1'b0)
          begin
          penable <= 1'b0;
          paddr   <= 4'h0;
          pwdata  <= 8'h00;
          pwrite  <= 1'b0;
          end
          
          else if (next_state == idle)
            begin
          penable <= 1'b0;
          paddr   <= 4'h0;
          pwdata  <= 8'h00;
          pwrite  <= 1'b0;
          end
          
          else if (next_state == setup)
          begin
          penable <= 1'b0;
          paddr   <= addr_in;
          pwrite  <= wr; 
          
          if(wr) 
            pwdata  <= data_in;      
          end
          
          else if(next_state == enable)
           begin
          penable <= 1'b1;
          end

 end 
 
      
 assign dataout = (psel && (pwrite == 0) && pready)? prdata : 8'b00000000;
 
 
 

 endmodule












 