`timescale 1ns / 1ps
/**
 * 
 * Test bench for the processor wrapper.
 * Written by ECE 350 course staff.
 *
 **/

module ProcWrapper_tb #(parameter FILE = "nop");

	// FileData
	localparam DIR = "Processor/Test Files/";
	localparam MEM_DIR = "Memory Files/";
	localparam OUT_DIR = "Output Files/";
	localparam VERIF_DIR = "Verification Files/";
	localparam DEFAULT_CYCLES = 255;

	// Inputs to the processor
	reg clock = 0, reset = 0;

	// I/O for the processor
	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2, rs3;
	wire[31:0] instAddr, instData, 
		rData, regA, regB, regC,
		memAddr, memDataIn;
	wire memDataOut;
	wire[7:0] buttons;

	// Wires for Test Harness
	wire[4:0] rs1_test, rs1_in;
	reg testMode = 0; 
	reg[7:0] num_cycles = DEFAULT_CYCLES;
	reg[15*8:0] exp_text;
	reg null;

	// Connect the reg to test to the for loop
	assign rs1_test = reg_to_test;

	// Hijack the RS1 value for testing
	assign rs1_in = testMode ? rs1_test : rs1;

	// Expected Value from File
	reg signed [31:0] exp_result;

	// Where to store file error codes
	integer expFile, diffFile, actFile, expScan; 

	// Do Verification
	reg verify = 1;

	// Metadata
	integer errors = 0,
			cycles = 0,
			reg_to_test = 0;

	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2),	.ctrl_readRegC(rs3), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB), .data_readRegC(regC),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem({31'b0, memDataOut}),
		
		// Controller
		.controller(buttons)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({DIR, MEM_DIR, FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1_in), .ctrl_readRegB(rs2), .ctrl_readRegC(rs3), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB), .data_readRegC(regC));
						
	// Processor Memory (RAM)
	RAM #(
		.DATA_WIDTH(1),	
		.ADDRESS_WIDTH(16), 
		.DEPTH(19200),           
		.MEMFILE("Graphics/MemFiles/bkg_stripes.mem")) 
	ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[15:0]), 
		.dataIn(memDataIn[0]), 
		.dataOut(memDataOut));

	// for testing purposes, assign the buttons to a constant
	assign buttons = 8'b00100110; // B, Left, and Down

	// Create the clock
	always
		#10 clock = ~clock; 

	//////////////////
	// Test Harness //
	//////////////////

	initial begin
		// Check if the parameter exists
		if(FILE == 0) begin
			$display("Please specify the test");
			$finish;
		end

		$display({"Loading ", FILE, ".mem\n"});

		// Read the expected file
		expFile = $fopen({DIR, VERIF_DIR, FILE, "_exp.txt"}, "r");

			// Check for any errors in opening the file
		if(!expFile) begin
			$display("Couldn't read the expected file.",
				"\nMake sure there is a %0s_exp.txt file in the \"%0s\" directory.", FILE, {DIR ,VERIF_DIR});
			$display("Continuing for %0d cycles without checking for correctness,\n", DEFAULT_CYCLES);
			verify = 0;
		end

		// Output file name
		$dumpfile({DIR, OUT_DIR, FILE, ".vcd"});
		// Module to capture and what level, 0 means all wires
		$dumpvars(0, ProcWrapper_tb);

		$display();

		// Create the files to store the output
		actFile = $fopen({DIR, OUT_DIR, FILE, "_actual.txt"},   "w");

		if (verify) begin
			diffFile = $fopen({DIR, OUT_DIR, FILE, "_diff.txt"},  "w");

			// Get the number of cycles from the file
			expScan = $fscanf(expFile, "num cycles:%d", 
				num_cycles);

			// Check that the number of cycles was read
			if(expScan != 1) begin
				$display("Error reading the %0s file.", {FILE, "_exp.txt"});
				$display("Make sure that file starts with \n\tnum cycles:NUM_CYCLES");;
				$display("Where NUM_CYCLES is a positive integer\n");
			end
		end

		// Clear the Processor at the beginning
		reset = 1;
		#1
		reset = 0;

		// Run for the number of cycles specified 
		for (cycles = 0; cycles < num_cycles; cycles = cycles + 1) begin
			
			// Every rising edge, write to the actual file
			@(posedge clock);
			if (rwe && rd != 0) begin
				$fdisplay(actFile, "Cycle %3d: Wrote %0d into register %0d", cycles, rData, rd);
			end
		end

		$fdisplay(actFile, "============== Testing Mode ==============");

		if (verify)
			$display("\t================== Checking Registers ==================");

		// Activate the test harness
		testMode = 1;

		// Check the values in the regfile
		for (reg_to_test = 0; reg_to_test < 32; reg_to_test = reg_to_test + 1) begin
			
			if (verify) begin
				// Obtain the register value
				expScan =  $fscanf(expFile, "%s", exp_text);
				expScan = $sscanf(exp_text, "r%d=%d", null, exp_result);

				// Check for errors when reading
				if (expScan != 2) begin
					$display("Error reading value for register %0d.", reg_to_test);
					$display("Please make sure the value is in the format");
					$display("\tr%0d=EXPECTED_VALUE", reg_to_test);

					// Close the Files
					$fclose(expFile);
					$fclose(actFile);
					$fclose(diffFile);

					#100;
					$finish;
				end
			end 
			
			// Allow the regfile output value to stabilize
			#1;

			// Write the register value to the actual file
			$fdisplay(actFile, "Reg %2d: %11d", rs1_test, regA);
			
			// Compare the Values 
			if (verify) begin
				if (exp_result !== regA) begin
					$fdisplay(diffFile, "Reg: %2d Expected: %11d Actual: %11d",
						rs1_test, $signed(exp_result), $signed(regA));
					$display("\tFAILED Reg: %2d Expected: %11d Actual: %11d",
						rs1_test, $signed(exp_result), $signed(regA));
					errors = errors + 1;
				end else begin
					$display("\tPASSED Reg: %2d", rs1_test);
				end
			end
		end

		// Close the Files
		$fclose(expFile);
		$fclose(actFile);

		if (verify)
			$fclose(diffFile);

		// Display the tests and errors
		if (verify)
			$display("\nFinished %0d cycle%c with %0d error%c", cycles, "s"*(cycles != 1), errors, "s"*(errors != 1));
		else 
			$display("Finished %0d cycle%c", cycles, "s"*(cycles != 1));

		#100;
		$finish;
	end
endmodule
