module apb_slave (
  input pclk,
  input presetn,
  input [3:0] addr_in,
  input [7:0] data_in,
  input psel,
  input penable,
  input pwrite,
  
  output reg pready,
  output reg [7:0] pdata

);  
  localparam [1:0] idle = 0, write = 1, read =2;
  reg [7:0] mem [0:15];
  reg [1:0] state, next_state;   
   // next state logic block   
  always @(posedge pclk) begin
     if(presetn ==0)              //presetn = 0 reset, presetn= 1 start
      state <= idle;   
      else
      state <= next_state;
  end
 // 
 always @(*) begin
     case(state)
     	
        idle:
       		begin
               pready = 0;
               pdata = 8'b0;
               if(pwrite && psel)
               		next_state = write; 
               else if (~pwrite && psel)
               		next_state = read;
               	else
               		next_state = idle;	
        	end
    
        write:
       		begin       
               if(psel && pwrite) begin
               pready = 1;
               mem[addr_in] = data_in; 
               next_state = write;
               end 
               else
                next_state = idle;               
        	end     
    
    
        read:
       		begin
       	
       		  
       		 if(psel) begin // PSEL, is asserted, which means that PADDR, PWRITE and PWDATA must be valid.
			pready = 1;        		 
			pdata =  mem[addr_in]; 
       		 next_state = read;
       		end
              else begin
               next_state = idle;      
        	    end
              end
    default : next_state = idle;
    endcase
 end

endmodule