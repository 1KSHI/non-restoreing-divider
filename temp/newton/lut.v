module lut(
    input wire [15:0] N,
    output reg [21:0] initial_approx
);

always @(*)begin
    if     (N<= 16'd2     ) begin initial_approx = 22'b01_00000000000000000000; end
    else if(N<= 16'd4     ) begin initial_approx = 22'b00_10000000000000000000; end
    else if(N<= 16'd8     ) begin initial_approx = 22'b00_01000000000000000000; end
    else if(N<= 16'd16    ) begin initial_approx = 22'b00_00100000000000000000; end
    else if(N<= 16'd32    ) begin initial_approx = 22'b00_00010000000000000000; end
    else if(N<= 16'd64    ) begin initial_approx = 22'b00_00001000000000000000; end
    else if(N<= 16'd128   ) begin initial_approx = 22'b00_00000100000000000000; end
    else if(N<= 16'd256   ) begin initial_approx = 22'b00_00000010000000000000; end
    else if(N<= 16'd512   ) begin initial_approx = 22'b00_00000001000000000000; end
    else if(N<= 16'd1024  ) begin initial_approx = 22'b00_00000000100000000000; end
    else if(N<= 16'd2048  ) begin initial_approx = 22'b00_00000000010000000000; end
    else if(N<= 16'd4096  ) begin initial_approx = 22'b00_00000000001000000000; end
    else                    begin initial_approx = 22'b00_00000000000100000000; end
end



endmodule
