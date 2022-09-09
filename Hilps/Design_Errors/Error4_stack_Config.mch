MACHINE Error4_stack_Config
SETS
    TAG = {normal, gate, privileged};
    MEM_TYPE = {priv_data, priv_code, normal_code, pt, iopt, iommu_control, idt, n2p_gate, p2n_gate, normal_stack, priv_stack};
    MEM_PRIV = {read, write, execute};
    REG = {pc, sp, tcr, ttbr, vbar, sctlr};
    CONTROL_BIT = {sz};
    REG_PRIV = {get, set};
    INSTRUCTION = {set_tcr, set_ttbr, set_vbar, set_sctlr}
CONSTANTS gate_type, code_type, data_type, addr_reg, bit_reg, reg_bit, inst_priv, mem_priv_diff
PROPERTIES 
    (gate_type <: MEM_TYPE) &
    (gate_type = {n2p_gate, p2n_gate}) &
    (code_type <: MEM_TYPE) &
    (code_type = {priv_code, normal_code} \/ gate_type) &
    (data_type <: MEM_TYPE) &
    (data_type = MEM_TYPE - code_type) &
    (addr_reg <: REG) &
    (addr_reg = {pc, sp, ttbr, vbar}) &
    (bit_reg <: REG) &
    (bit_reg = {tcr, sctlr}) &
    (reg_bit <: bit_reg * CONTROL_BIT) &
    (reg_bit = {(tcr, sz)}) &
    (inst_priv <: INSTRUCTION * (REG * REG_PRIV)) &
    (inst_priv = {set_tcr |-> (tcr, set), set_ttbr |-> (ttbr, set), set_vbar |-> (vbar, set), set_sctlr |-> (sctlr, set)}) &
    //reg design error
    //(inst_priv = {set_tcr |-> (tcr, set), set_ttbr |-> (ttbr, set), set_vbar |-> (vbar, set), set_sctlr |-> (sctlr, set)}) &
    (mem_priv_diff <: MEM_TYPE * MEM_PRIV) &
    //(mem_priv_diff = {(priv_data,read), (priv_data, write), (priv_code,read), (priv_code, execute), (pt, read), (pt, write), 
    //    (iopt, read), (iopt, write), (iommu_control, read), (iommu_control, write), (idt, read), (idt, write), (priv_stack, read), (priv_stack, write)})
    //mem design error
    (mem_priv_diff = {(priv_data,read), (priv_data, write), (priv_code,read), (priv_code, execute), (pt, read), (pt, write), 
        (iopt, read), (iopt, write), (iommu_control, read), (iommu_control, write), (idt, read), (idt, write)})
END//MACHINE