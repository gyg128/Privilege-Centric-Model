MACHINE Priv_Config_SelMon
SETS
    TAG = {normal, gate, privileged};
    MEM_TYPE = {priv_data, priv_code, normal_code, pt, iopt, iommu_control, vector, n2p_gate, p2n_gate, normal_stack, priv_stack};
    MEM_PRIV = {read, write, execute};
    REG = {pc, sp, ttbr, vbar, mdcr, mdscr, dbgwvr, dbgwcr, esr, sctlr, daifclr};
    CONTROL_BIT = {tde, kde, mde, dbg_enable, ec, wxn, pstate_d};
    REG_PRIV = {get, set};
    INSTRUCTION = {set_ttbr, set_vbar, set_mdcr, set_mdscr, set_dbgwvr, set_dbgwcr, set_esr, set_sctlr, set_daifclr}
CONSTANTS gate_type, code_type, data_type, addr_reg, bit_reg, reg_bit, inst_priv, mem_priv_diff
PROPERTIES 
    (gate_type <: MEM_TYPE) &
    (gate_type = {n2p_gate, p2n_gate}) &
    (code_type <: MEM_TYPE) &
    (code_type = {priv_code, normal_code} \/ gate_type) &
    (data_type <: MEM_TYPE) &
    (data_type = MEM_TYPE - code_type) &
    (addr_reg <: REG) &
    (addr_reg = {pc, sp, ttbr, vbar, dbgwvr}) &
    (bit_reg <: REG) &
    (bit_reg = {mdcr, mdscr, dbgwcr, esr, sctlr, daifclr}) &
    (reg_bit <: bit_reg * CONTROL_BIT) &
    (reg_bit = {(mdcr, tde), (mdscr, kde), (mdscr, mde), (dbgwcr, dbg_enable), (esr, ec), (sctlr, wxn), (daifclr, pstate_d)}) &
    (inst_priv <: INSTRUCTION * (REG * REG_PRIV)) &
    (inst_priv = {set_ttbr |-> (ttbr, set), set_vbar |-> (vbar, set), set_mdcr |-> (mdcr, set), set_mdscr |-> (mdscr, set), 
        set_dbgwvr |-> (dbgwvr, set), set_dbgwcr |-> (dbgwcr, set), set_esr |-> (esr, set), set_sctlr |-> (sctlr, set), set_daifclr |-> (daifclr, set)}) &
    (mem_priv_diff <: MEM_TYPE * MEM_PRIV) &
    (mem_priv_diff = {(priv_data,read), (priv_data, write), (priv_code,read), (priv_code, write), (priv_code, execute), (pt, read), (pt, write), 
        (iopt, read), (iopt, write), (iommu_control, read), (iommu_control, write), (vector, write), (priv_stack, read), (priv_stack, write)})
END//MACHINE