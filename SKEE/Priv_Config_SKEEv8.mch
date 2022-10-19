MACHINE Priv_Config_SKEEv8
SETS
    TAG = {normal, gate, privileged};
    MEM_TYPE = {priv_data, priv_code, normal_code, pt, iopt, iommu_control, idt, n2p_gate, p2n_gate, normal_stack, priv_stack};
    MEM_PRIV = {read, write, execute};
    REG = {pc, sp, tcr, ttbr1, vbar};
    CONTROL_BIT = {a1};
    REG_PRIV = {get, set};
    INSTRUCTION = {set_tcr, set_ttbr1, set_vbar}
CONSTANTS gate_type, code_type, data_type, addr_reg, bit_reg, reg_bit, inst_priv, mem_priv_diff
PROPERTIES 
    (gate_type <: MEM_TYPE) &
    (gate_type = {n2p_gate, p2n_gate}) &
    (code_type <: MEM_TYPE) &
    (code_type = {priv_code, normal_code} \/ gate_type) &
    (data_type <: MEM_TYPE) &
    (data_type = MEM_TYPE - code_type) &
    (addr_reg <: REG) &
    (addr_reg = {pc, sp, ttbr1, vbar}) &
    (bit_reg <: REG) &
    (bit_reg = {tcr}) &
    (reg_bit <: bit_reg * CONTROL_BIT) &
    (reg_bit = {(tcr, a1)}) &
    (inst_priv <: INSTRUCTION * (REG * REG_PRIV)) &
    (inst_priv = {set_tcr |-> (tcr, set), set_ttbr1 |-> (ttbr1, set), set_vbar |-> (vbar, set)}) &
    (mem_priv_diff <: MEM_TYPE * MEM_PRIV) &
    (mem_priv_diff = {(priv_data,read), (priv_data, write), (priv_code,read), (priv_code, execute), (pt, read), (pt, write), 
        (iopt, read), (iopt, write), (iommu_control, read), (iommu_control, write), (idt, write), (priv_stack, read), (priv_stack, write)})
END//MACHINE