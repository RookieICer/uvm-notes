
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_policy extends uvm_mem_mam_policy;

constraint start_addr_c {
    start_offset[11:0] == 'h0;
};

endclass

module mem_mam_test_top;

initial begin
    uvm_mem_mam_cfg     m_cfg;
    uvm_mem_mam         m_mam;
    my_policy           m_policy;
    uvm_mem_region      region0;
    uvm_mem_region      region1;
    uvm_mem_region      region2;
    uvm_status_e        m_status;

    m_cfg = new();
    m_cfg.randomize() with {
        start_offset    == 'h1000;
        n_bytes         == 1;
        end_offset      <= 'hFFFF_FFFF;
    };
    m_mam = new("m_mam", m_cfg);
    m_policy = new();

    region0 = m_mam.reserve_region('h4432, 'h1000, "region0");
    region1 = m_mam.reserve_region('h4432, 'h1000, "region1");
    region2 = m_mam.request_region('h1000, m_policy);

    if (region0) begin
        `uvm_info("dbg", $sformatf("region0 is not null"), UVM_LOW)
    end else begin
        `uvm_info("dbg", $sformatf("region0 is null"), UVM_LOW)
    end

    if (region1) begin
        `uvm_info("dbg", $sformatf("region1 is not null"), UVM_LOW)
    end else begin
        `uvm_info("dbg", $sformatf("region1 is null"), UVM_LOW)
    end

    if (region2) begin
        `uvm_info("dbg", $sformatf("region2 is not null"), UVM_LOW)
    end else begin
        `uvm_info("dbg", $sformatf("region2 is null"), UVM_LOW)
    end
    
    region2.write(m_status, 4, 'hF);

    region2.release_region();
    m_mam.release_region(region1);
    m_mam.release_all_regions();
end

endmodule
