module apb_protocol(

  input pclk,
  input presetn, 
  input [3:0] addr_in,
  input [7:0] data_in,
  input newd, 
  input wr,
  output [7:0] data_out 

);
  
  wire psel,penable,pwrite,pready; 
   wire [7:0] prdata,pwdata;
   wire [3:0] paddr;

  apb_master  master(

  
   .pclk(pclk),
   .presetn(presetn), 
   .addr_in(addr_in),
   .data_in(data_in),
   .newd(newd), 
   .wr(wr),
   .prdata(prdata), 
   .pready(pready),  


    .psel(psel),
    .penable(penable),
    .paddr(paddr),
    .pwdata(pwdata),
    .pwrite(pwrite),
    .dataout(data_out)
  
);


 apb_slave slave(
   .pclk(pclk),
   .presetn(presetn),
   .addr_in(addr_in),
   .data_in(data_in),
   .psel(psel),
   .penable(penable),
   .pwrite(pwrite),
  
    .pready(pready),
    .pdata(prdata)

); 

endmodule


