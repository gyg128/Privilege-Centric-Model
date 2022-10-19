MACHINE Priv_Config_SKEEv7
SETS
    TAG = {normal, gate, privileged};
    MEM_TYPE = {priv_data, priv_code, normal_code, pt, iopt, iommu_control, idt, n2p_gate, p2n_gate, normal_stack, priv_stack};
    MEM_PRIV = {read, write, execute};
    REG = {pc, sp, ttbcr, ttbr, vbar, contextidr};
    CONTROL_BIT = {nn, cid};
    REG_PRIV = {get, set};
    INSTRUCTION = {set_ttbcr, set_ttbr, set_vbar, set_contextidr}
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
    (bit_reg = {ttbcr, contextidr}) &
    (reg_bit <: bit_reg * CONTROL_BIT) &
    (reg_bit = {(ttbcr, nn), (contextidr, cid)}) &
    (inst_priv <: INSTRUCTION * (REG * REG_PRIV)) &
    (inst_priv = {set_ttbcr |-> (ttbcr, set), set_ttbr |-> (ttbr, set), set_vbar |-> (vbar, set), set_contextidr |-> (contextidr, set)}) &
    (mem_priv_diff <: MEM_TYPE * MEM_PRIV) &
    (mem_priv_diff = {(priv_data,read), (priv_data, write), (priv_code,read), (priv_code, execute), (pt, read), (pt, write), 
        (iopt, read), (iopt, write), (iommu_control, read), (iommu_control, write), (idt, write), (priv_stack, read), (priv_stack, write)})
END//MACHINE