MACHINE Error6_cr0_Config
SETS
    TAG = {normal, gate, privileged};
    MEM_TYPE = {priv_data, priv_code, normal_code, pt, iopt, iommu_control, idt, n2p_gate, p2n_gate, normal_stack, priv_stack};
    MEM_PRIV = {read, write, execute};
    REG = {cr3, pc, sp, cr0, idtr};
    CONTROL_BIT = {wp};
    REG_PRIV = {get, set};
    INSTRUCTION = {mov_to_cr0, mov_to_cr3, lidt}
CONSTANTS gate_type, code_type, data_type, addr_reg, bit_reg, reg_bit, inst_priv, mem_priv_diff
PROPERTIES 
    (gate_type <: MEM_TYPE) &
    (gate_type = {n2p_gate, p2n_gate}) &
    (code_type <: MEM_TYPE) &
    (code_type = {priv_code, normal_code} \/ gate_type) &
    (data_type <: MEM_TYPE) &
    (data_type = MEM_TYPE - code_type) &
    (addr_reg <: REG) &
    (addr_reg = {cr3, pc, sp, idtr}) &
    (bit_reg <: REG) &
    (bit_reg = {cr0}) &
    (reg_bit <: bit_reg * CONTROL_BIT) &
    (reg_bit = {(cr0, wp)}) &
    (inst_priv <: INSTRUCTION * (REG * REG_PRIV)) &
    //(inst_priv = {mov_to_cr0 |-> (cr0, set), mov_to_cr3 |-> (cr3, set), lidt |-> (idtr, set)}) &
    //reg design error
    (inst_priv = {mov_to_cr3 |-> (cr3, set), lidt |-> (idtr, set)}) &
    (mem_priv_diff <: MEM_TYPE * MEM_PRIV) &
    (mem_priv_diff = {(priv_data, write), (priv_code, execute), (pt, write), (iopt, write), (iommu_control, write), (idt, write), (priv_stack, write)})
    //mem design error
    //(mem_priv_diff = {(priv_data, write), (priv_code, execute), (pt, write), (iopt, write), (iommu_control, write), (idt, write)})
END//MACHINE