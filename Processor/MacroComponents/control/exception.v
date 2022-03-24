module exception(val, excpt_in, instr);
    input excpt_in;
    input [31:0] instr;
    output [31:0] val;

    // get the opcode
    wire o4, o3, o2, o1, o0;
    assign o4 = instr[31];
    assign o3 = instr[30];
    assign o2 = instr[29];
    assign o1 = instr[28];
    assign o0 = instr[27];

    wire a4, a3, a2, a1, a0;
    assign a4 = instr[6];
    assign a3 = instr[5];
    assign a2 = instr[4];
    assign a1 = instr[3];
    assign a0 = instr[2];

    // determine what the instruction is
    wire rtype, add, addi, sub, mul, div;
    assign addi  = (~o4 & ~o3 &  o2 & ~o1 &  o0); // o00101 addi
    assign rtype = (~o4 & ~o3 & ~o2 & ~o1 & ~o0); // o00000 rtype

    assign add = rtype & (~a4 & ~a3 & ~a2 & ~a1 & ~a0); // a00000 add  (xxx00 simplified)
    assign sub = rtype & (~a4 & ~a3 & ~a2 & ~a1 &  a0); // a00001 sub (xxx01)
    assign mul = rtype & (~a4 & ~a3 &  a2 &  a1 & ~a0); // a00110 mul  (xxx10)
    assign div = rtype & (~a4 & ~a3 &  a2 &  a1 &  a0); // a00111 div  (xxx11)

    // tristates with the correct exception
    tristate32 tri_add (val, 32'b001, add);
    tristate32 tri_addi(val, 32'b010, addi);
    tristate32 tri_sub (val, 32'b011, sub);
    tristate32 tri_mul (val, 32'b100, mul);
    tristate32 tri_div (val, 32'b101, div);

endmodule