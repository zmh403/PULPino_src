// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

  logic [31:0]     data_mem[];  // this variable holds the whole memory content
  logic [31:0]     instr_mem[]; // this variable holds the whole memory content
  event            event_mem_load;

  task mem_preload;
    integer      addr;
    integer      mem_addr;
    integer      bidx;
    integer      instr_size;
    integer      instr_width;
    integer      data_size;
    integer      data_width;
    logic [31:0] data;
    string       l2_imem_file;
    string       l2_dmem_file;
    begin
      $display("Preloading memory");

	// 32678, 32
      instr_size   = tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.RAM_SIZE;
      instr_width = tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.DATA_WIDTH;
//	$display("INSTR_SIZE:%d", instr_size);
//	$display("INSTR_WIDTH:%d", instr_width);


	// 32678, 32
      data_size   = tb.top_i.core_region_i.data_mem.RAM_SIZE;
      data_width = tb.top_i.core_region_i.data_mem.DATA_WIDTH;
//	$display("DATA_SIZE:%d", data_size);
//	$display("DATA_WIDTH:%d", data_width);

	// [31:0] mem [8192]
      instr_mem = new [instr_size/4];
      data_mem  = new [data_size/4];
//	$display("INSTR_MEM:%0d", $bits(instr_mem));
//	$display("DATA_MEM:%0d", $bits(data_mem));

      if(!$value$plusargs("l2_imem=%s", l2_imem_file))
         l2_imem_file = "slm_files/l2_stim.slm";

      $display("Preloading instruction memory from %0s", l2_imem_file);
      $readmemh(l2_imem_file, instr_mem);

      if(!$value$plusargs("l2_dmem=%s", l2_dmem_file))
         l2_dmem_file = "slm_files/tcdm_bank0.slm";

      $display("Preloading data memory from %0s", l2_dmem_file);
      $readmemh(l2_dmem_file, data_mem);

      // preload data memory
      for(addr = 0; addr < data_size/4; addr = addr) begin

        for(bidx = 0; bidx < data_width/8; bidx++) begin
          mem_addr = addr / (data_width/32);
          data = data_mem[addr];

          if (bidx%4 == 0)
            tb.top_i.core_region_i.data_mem.sp_ram_i.mem[mem_addr][bidx] = data[ 7: 0];
          else if (bidx%4 == 1)
            tb.top_i.core_region_i.data_mem.sp_ram_i.mem[mem_addr][bidx] = data[15: 8];
          else if (bidx%4 == 2)
            tb.top_i.core_region_i.data_mem.sp_ram_i.mem[mem_addr][bidx] = data[23:16];
          else if (bidx%4 == 3)
            tb.top_i.core_region_i.data_mem.sp_ram_i.mem[mem_addr][bidx] = data[31:24];

          if (bidx%4 == 0)
		  $display("ADDR: %h DATA[7:0]: %d", mem_addr, data[7:0]);
          else if (bidx%4 == 1)
		  $display("DATA[15:8]: %d",data[15:8]);
          else if (bidx%4 == 2)
		  $display("DATA[23:16]: %h",data[23:16]);
          else if (bidx%4 == 3)
		  $display("DATA[31:24]: %h",data[31:24]);

          if (bidx%4 == 3) addr++;
        end
      end

      // preload instruction memory
      for(addr = 0; addr < instr_size/4; addr = addr) begin

        for(bidx = 0; bidx < instr_width/8; bidx++) begin
          mem_addr = addr / (instr_width/32);
          data = instr_mem[addr];

          if (bidx%4 == 0)
            tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[mem_addr][bidx] = data[ 7: 0];
          else if (bidx%4 == 1)
            tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[mem_addr][bidx] = data[15: 8];
          else if (bidx%4 == 2)
            tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[mem_addr][bidx] = data[23:16];
          else if (bidx%4 == 3)
            tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.sp_ram_i.mem[mem_addr][bidx] = data[31:24];

          if (bidx%4 == 0)
		  $display("ADDR: %h I_DATA[7:0]: %d", mem_addr, data[7:0]);
          else if (bidx%4 == 1)
		  $display("I_DATA[15:8]: %h",data[15:8]);
          else if (bidx%4 == 2)
		  $display("I_DATA[23:16]: %h",data[23:16]);
          else if (bidx%4 == 3)
		  $display("I_DATA[31:24]: %h",data[31:24]);

          if (bidx%4 == 3) addr++;
        end
      end
    end
  endtask
